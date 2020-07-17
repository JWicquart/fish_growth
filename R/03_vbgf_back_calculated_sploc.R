# 1. Source functions ----

source("R/functions/bcalc_bayes.R")
source("R/functions/growthreg.R")

# 2. Required packages ----

library(tidyverse)
library(rfishbase)
library(rstan)
library(parallel)

# 3. Source models ----

bcalc_stan <- stan_model("stan/stan_bcalc.stan")
vonbert_stan <- stan_model("stan/vonbert.stan")

# 4. Load data ----

bc <- read.csv("data/02_back-calculated-size-at-age_morat-et-al.csv") %>%
  drop_na(Li_sploc_m) %>%
  group_by(ID) %>%
  filter(Agecpt > 2) %>% # filter with maxage > 2
  ungroup() %>%
  dplyr::group_by(Species, Location) %>%
  dplyr::mutate(n = length(unique(ID))) %>%
  filter(n >= 5) %>% # filter with at least 5 replicates
  ungroup()

# 5. Extract all unique combinations per species and location ----

opts <- rfishbase::species(unique(bc$Species), fields = c("Species", "Length")) %>% # Get maximum lengths (Lmax) from fishbase
  group_by(Species) %>% 
  dplyr::summarise(lmax = mean(Length, na.rm = TRUE)) %>%
  ungroup() %>% 
  as.data.frame() %>% 
  mutate(lmax = ifelse(Species == "Chlorurus spilurus", 27, lmax)) %>% # Manually add value for missing species
  right_join(., unique(select(bc, Location, Species))) # Join with unique combinations

# 6. Run models ----

growthmodels <- lapply(1:nrow(opts), function(x){
    
    loc <- opts[x,"Location"]
    sp <- opts[x,"Species"]
    lmax <- opts[x,"lmax"]
    
    data <- bc %>% dplyr::filter(Location == loc, Species == sp)
    
    fit <- growthreg(length = data$Li_sp_m/10,  # Function requires cm
                     age = data$Agei,
                     id = as.character(data$ID),
                     lmax = lmax, 
                     linf_m = 0.8 * lmax,
                     control = list(adapt_delta = 0.999, max_treedepth = 15),
                     cores = 4, iter = 5000, warmup = 2500,
                     plot = FALSE)
    
    return(fit)
    
})

# 7. Extract parameters ----

lapply(1:nrow(opts), function(x){
  
  pred <- growthmodels[[x]]$summary %>% 
    as.data.frame() %>% 
    mutate(Parameter = row.names(.)) %>% 
    filter(Parameter != "kmax") %>% 
    rename(Estimate = mean, Est.Error = sd, Q2.5 = "2.5%", Q97.5 = "97.5%") %>% 
    bind_cols(opts[x,]) %>% 
    select(Species, Location, Parameter, Estimate, Est.Error, Q2.5, Q97.5)
  
  return(pred)
  
}) %>% 
  plyr::ldply() %>% 
  write.csv(., "data/03_back-calculated_vbgf_predictions_sploc.csv", row.names = FALSE)

# 8. Extract fitted values ----

lapply(1:nrow(opts), function(x){
  
    fitted <- growthmodels[[x]]$fitted %>% 
      as.data.frame() %>% 
      bind_cols(opts[x,], .)
    
    return(fitted)
    
}) %>% 
  plyr::ldply() %>% 
  write.csv(., "data/03_back-calculated_vbgf_fitted_sploc.csv", row.names = FALSE)
