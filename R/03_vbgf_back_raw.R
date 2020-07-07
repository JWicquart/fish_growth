# 1. Required packages ----

library(tidyverse)
library(plyr)
library(rfishbase)
library(brms)

# 2. Extract parameters from fishbase to get the priors ----

fishbase_priors <- growth_params(unique(data_complete$Species)) %>% 
  group_by(species) %>% 
  summarise(k = mean(k, na.rm = TRUE),
            Linf = mean(Linf, na.rm = TRUE)) %>% 
  full_join(., rfishbase::species(unique(data_complete$Species), fields = c("Species", "Length")) %>% 
              rename(species = Species) %>% 
              group_by(species) %>% 
              dplyr::summarise(Lmax = mean(Length, na.rm = TRUE)) %>% 
              as.data.frame()) %>% 
  mutate_all(~replace(., is.nan(.), NA))

# 3. Make a function to fit model by species ----

vbgf_bayesian2 <- function(data, dataprior){
  
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
    prior_string(paste0("normal(", prior_linf, ", 5)"), nlpar = "linf"),
    prior_string(paste0("normal(", prior_k, ", 0.5)"), nlpar = "k"),
    prior(normal(0, 1), nlpar = "t0"))
  
  
  fit <- brm(bf(Li_sp_m ~ linf * (1 - exp(-k * (Agei - t0))), k ~ 1, linf ~ 1, t0 ~ 1, nl = TRUE),
             data = data, 
             family = gaussian(),
             prior = priors,
             control = list(adapt_delta = 0.95), iter = 10000, warmup = 5000)
  
  fit
  
}

# 4. Run models ----

growthmodels <-
  lapply(unique(data_complete$Species), function(x){
    
    data_prior <- filter(fishbase_priors, species == x)
    
    data_raw <- read.csv("./../data/coral_reef_fishes_data.csv") %>% 
      rename(Family = family, Location = location, Species = species, Agei = agecap, Li_sp_m = lencap) %>% 
      select(Family, Location, Species, Agei, Li_sp_m) %>%
      filter(Species == x) %>% 
      unique() %>%
      mutate(Li_sp_m = Li_sp_m/10)
    
    vbgf_bayesian2(data_raw, data_prior)
    
  })

# 5. Extract parameters ----

A <- lapply(1:nrow(opts), function(x){
  op <- opts[x,]
  op$k <- growthmodels[[x]]$summary["k", "mean"]
  op$k_sd <- growthmodels[[x]]$summary["k", "sd"]  
  op$linf <- growthmodels[[x]]$summary["linf", "mean"]
  op$linf_sd <- growthmodels[[x]]$summary["linf", "sd"]
  op$t0 <- growthmodels[[x]]$summary["t0", "mean"]
  op$t0_sd <- growthmodels[[x]]$summary["t0", "sd"]
  return(op)
}) %>% 
  plyr::ldply()

# 6. Extract fitted values ----

lapply(1:nrow(opts), function(x){
  op <- opts[x,]
  fitted <- op %>% cbind(growthmodels[[x]]$fitted)
  return(fitted)
}) %>% 
  plyr::ldply() %>% 
  write.csv(., "data/results_regressions_prediction.csv", row.names = FALSE)
