# 1. Required packages ----

library(tidyverse)
library(readxl)
library(brms)
library(rfishbase)
library(rstan)
library(parallel)

# 2. Load data ----

data_complete <- read.csv("data/02_back-calculated-size-at-age_morat-et-al.csv") %>%
  select(Family, Genus, Species, ID, Agecpt, Lcpt, Location, Observer) %>% 
  unique() %>%
  dplyr::group_by(Species) %>%
  dplyr::mutate(n = length(unique(ID))) %>%
  filter(n >= 10) %>% # filter with at least 10 replicates
  ungroup() %>% 
  dplyr::mutate(Lcpt = Lcpt/10) # Convert to cm

# 4. Extract all unique combinations per species  ----

opts <- unique(select(data_complete, Species)) %>%
  as.data.frame()

# 3. Use parameters from literature to get the priors ----

# 3.1 Load file and misc modifications --

vbgf_literature <- read_excel("data/00_von-bertalanffy-literature.xlsx", sheet = 1) %>% 
  dplyr::mutate(Linf = ifelse(Size_unit == "cm", Linf, Linf),
                Size_max = ifelse(Size_unit == "cm", Size_max, Size_max)) %>% # Convert all length values to mm
  select(-Family, -Genus) # Remove Family and Genus to add those level through fishbase

# 3.2 Check validity of species names --

vbgf_literature %>% 
  select(Species) %>% 
  unique() %>% 
  left_join(., load_taxa()) %>% 
  filter(is.na(Genus))

# 3.3 Apply the corrections --

vbgf_literature <- vbgf_literature %>% 
  dplyr::mutate(Species = str_replace_all(Species, c("Acanthurus chirugus" = "Acanthurus chirurgus",
                                                     "Chlorurus microrbinos" = "Chlorurus microrhinos",
                                                     "Scarus psitticus" = "Scarus psittacus",
                                                     "Cetoscarus bicolour" = "Cetoscarus bicolor"))) %>% 
  dplyr::mutate(Species = as.factor(Species)) %>% 
  dplyr::select(Species, Linf, K) %>% 
  dplyr::group_by(Species) %>% 
  dplyr::summarise(Linf = mean(Linf, na.rm = TRUE),
                   K = mean(K, na.rm = TRUE)) %>% 
  ungroup() %>% 
  rename(k = K) %>%
  right_join(opts)
  

# 5. Make a function to fit model by species ----

vbgf_bayesian <- function(data, dataprior, ...){
  
  species_i <- data %>% 
    select(Species) %>% 
    unique() %>% 
    as.character()
  
  prior_k <- ifelse(is.na(as.numeric(dataprior[which(dataprior$Species == species_i), "k"])), 
                    0.5,
                    as.numeric(dataprior[which(dataprior$Species == species_i), "k"]))
  
  prior_linf <- ifelse(is.na(as.numeric(dataprior[which(dataprior$Species == species_i),"Linf"])),
                       10,
                       as.numeric(dataprior[which(dataprior$Species == species_i),"Linf"]))
  
  priors <- c(
    prior_string(paste0("normal(", prior_linf, ",", 0.1 * prior_linf, ")"), lb = 0, nlpar = "linf"),
    prior_string(paste0("normal(", prior_k, ",", 0.5 * prior_k, ")"), lb = 0,  nlpar = "k"),
    prior(normal(0, 0.5), lb = -0.5, ub = 0.5, nlpar = "t0"))
  
  
  fit <- brm(bf(Lcpt ~ linf * (1 - exp(-k * (Agecpt - t0))), k ~ 1, linf ~ 1, t0 ~ 1, nl = TRUE),
             data = data, 
             family = gaussian(),
             prior = priors,
             control = list(adapt_delta = 0.95), ...)
  
  fit
  
}

# 6. Run models ----

ncores <- detectCores()

if (ncores < 5 | Sys.info()[1] == "Windows") {
  growthmodels <-
    lapply(1:nrow(opts), function(x){
      
      sp <- as.character(opts[x,"Species"])
      
      data_prior <- vbgf_literature %>% 
        filter(Species == sp)
      
      data_raw <- data_complete %>% 
        filter(Species == sp)
      
      vbgf_bayesian(data_raw, data_prior)
      
    })
} else {
  growthmodels <-
    parallel::mclapply(1:nrow(opts), function(x){
      
      sp <- as.character(opts[x,"Species"])
      
      data_prior <- vbgf_literature %>% 
        filter(Species == sp)
      
      data_raw <- data_complete %>% 
        filter(Species == sp)
      
      vbgf_bayesian(data_raw, data_prior)
    }, mc.cores = 0.2 * ncores)
}

# 7. Extract parameters ----

lapply(1:nrow(opts), function(x){
  
  summary <- posterior_summary(growthmodels[[x]], fixed = TRUE) %>% 
    as.data.frame() %>% 
    dplyr::mutate(Parameter = row.names(.), .before = 1) %>% 
    filter(Parameter %in% c("b_k_Intercept", "b_linf_Intercept", "b_t0_Intercept")) %>% 
    mutate(Parameter = str_replace_all(Parameter, c("b_k_Intercept" = "K",
                                                    "b_linf_Intercept" = "Linf",
                                                    "b_t0_Intercept" = "t0"))) %>% 
    mutate(Species = as.character(opts[x,"Species"]), .before = 1)
  
  return(summary)
}) %>% 
  plyr::ldply() %>% 
  write.csv(., "data/03_raw_vbgf_predictions_sp.csv", row.names = FALSE)

# 8. Extract fitted values ----

lapply(1:nrow(opts), function(x){
  op <- opts[x,]
  fitted <- data.frame(Species = op) %>% 
    cbind(Agei = seq(from = 0,
                     to = data_complete %>% 
                       filter(Species == as.character(op)) %>% 
                       dplyr::summarise(max(Agecpt)) %>% 
                       as.numeric(), 
                     by = 0.1),
          fitted(growthmodels[[x]], newdata = data.frame(Agecpt = seq(from = 0, 
                                                                      to = data_complete %>% 
                                                                        filter(Species == as.character(op)) %>% 
                                                                        dplyr::summarise(max(Agecpt)) %>% 
                                                                        as.numeric(), 
                                                                      by = 0.1))))
  return(fitted)
}) %>% 
  plyr::ldply() %>% 
  write.csv(., "data/03_raw_vbgf_fitted_sp.csv", row.names = FALSE)
