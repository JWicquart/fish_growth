# 1. Required packages ----

library(tidyverse)
library(plyr)
library(rfishbase)
library(brms)
library(fishflux)

data_complete <- read.csv("data/back-calculated-size-at-age_morat-et-al.csv")

# 2. Extract parameters from fishbase to get the priors ----

fishbase_priors <- growth_params(unique(data_complete$Species)) %>% 
  group_by(species) %>% 
  dplyr::summarise(k = mean(k, na.rm = TRUE),
            Linf = mean(Linf, na.rm = TRUE)) %>% 
  full_join(., rfishbase::species(unique(data_complete$Species), fields = c("Species", "Length")) %>% 
              dplyr::rename(species = Species) %>% 
              group_by(species) %>% 
              dplyr::summarise(Lmax = mean(Length, na.rm = TRUE)) %>% 
              as.data.frame()) %>% 
  mutate_all(~replace(., is.nan(.), NA))

# 3. Extract all unique combinations per species and location ----

opts <- unique(select(data_complete, Species, Location))

# 4. Make a function to fit model by species ----

vbgf_bayesian <- function(data, dataprior){
  
  species_i <- data %>% 
    select(Species) %>% 
    unique() %>% 
    as.character()
  
  prior_k <- ifelse(is.na(as.numeric(dataprior[which(dataprior$species == species_i), "k"])), 
                    0.5,
                    as.numeric(dataprior[which(dataprior$species == species_i), "k"]))
  
  prior_linf <- ifelse(is.na(as.numeric(dataprior[which(dataprior$species == species_i),"Linf"])),
                       as.numeric(dataprior[which(dataprior$species == species_i),"Lmax"]),
                       as.numeric(dataprior[which(dataprior$species == species_i),"Linf"]))
  
  priors <- c(
    prior_string(paste0("normal(", prior_linf, ", 5)"), lb = 0, nlpar = "linf"),
    prior_string(paste0("normal(", prior_k, ", 0.5)"), lb = 0,  nlpar = "k"),
    prior(normal(0, 0.5), lb = -0.5, ub = 0.5, nlpar = "t0"))
  
  
  fit <- brm(bf(Li_sp_m ~ linf * (1 - exp(-k * (Agei - t0))), k ~ 1, linf ~ 1, t0 ~ 1, nl = TRUE),
             data = data, 
             family = gaussian(),
             prior = priors,
             control = list(adapt_delta = 0.95), iter = 10000, warmup = 5000)
  
  fit
  
}

# 5. Run models ----

growthmodels <-
  lapply(1:nrow(opts), function(x){
    
    sp <- opts[x,"Species"]
    loc <- opts[x, "Location"]
    
    data_prior <- filter(fishbase_priors, species == sp)
    
    data_raw <- read.csv("data/coral_reef_fishes_data.csv") %>% 
      dplyr::rename(Family = family, Location = location, Species = species, Agei = agecap, Li_sp_m = lencap) %>% 
      select(Family, Location, Species, Agei, Li_sp_m) %>%
      filter(Species == sp, Location == loc) %>% 
      unique() %>%
      mutate(Li_sp_m = Li_sp_m/10)
    
    vbgf_bayesian(data_raw, data_prior)
    
})

# 6. Extract parameters ----

lapply(1:nrow(opts), function(x){
  
  summary <- posterior_summary(growthmodels[[x]], fixed = TRUE) %>% 
    as.data.frame() %>% 
    mutate(Parameter = row.names(.), .before = 1) %>% 
    filter(Parameter %in% c("b_k_Intercept", "b_linf_Intercept", "b_t0_Intercept")) %>% 
    mutate(Parameter = str_replace_all(Parameter, c("b_k_Intercept" = "K",
                                                    "b_linf_Intercept" = "Linf",
                                                    "b_t0_Intercept" = "t0")))
  
  return(summary)
}) %>% 
  plyr::ldply() %>% 
  write.csv(., "data/03_raw_vbgf_predictions.csv", row.names = FALSE)

# 7. Extract fitted values ----

lapply(1:nrow(opts), function(x){
  op <- opts[x,]
  fitted <- op %>% 
    cbind(Agei = seq(from = 1,
                     to = data_complete %>% 
                       filter(Location == op$Location, Species == op$Species) %>% 
                       dplyr::summarise(max(Agecpt)) %>% 
                       as.numeric(), 
                     by = 0.1),
          fitted(growthmodels[[x]], newdata = data.frame(Agei = seq(from = 1, 
                                                                    to = data_complete %>% 
                                                                      filter(Location == op$Location, Species == op$Species) %>% 
                                                                      dplyr::summarise(max(Agecpt)) %>% 
                                                                      as.numeric(), 
                                                                    by = 0.1))))
  return(fitted)
}) %>% 
  plyr::ldply() %>% 
  write.csv(., "data/03_raw_vbgf_fitted.csv", row.names = FALSE)
