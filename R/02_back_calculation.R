# 1. Source functions ----

source("functions/bcalc_freq.R")
source("functions/bcalc_bayes.R")
source("functions/growthreg.R")

# 2. Required packages ----

library(plyr)
library(tidyverse)
library(rstan)

# 3. Source models ----

bcalc_stan <- stan_model("./../stan/stan_bcalc.stan")

# 4. Import data ----

data_complete <- read.csv("./../data/coral_reef_fishes_data.csv")

# 5. Back-calculation for each species ----

options <- unique(select(data_complete, species))

bc_results <- 
  lapply(1:nrow(options), purrr::possibly(function(x){
    print(x)
    print(options[x,])
    data <- dplyr::filter(data_complete, species == options[x, "species"], agecap > 1)
    result <- bcalc_bayes(data)
    return(result)
  }, otherwise = NA))

bc_results1 <- bc_results[!is.na(bc_results)] %>% 
  lapply(function(x){x$lengths}) %>% 
  plyr::ldply() %>% 
  dplyr::select(-l_q1, -l_q3) %>% 
  rename("agei" = "age", 
         "Li_sp_m" = "l_m",
         "Li_sp_sd" = "l_sd")

# 6. Bayesian Back-calculation for each species and each location ----

options <- unique(select(data_complete, location, species))

bc_results <- 
  lapply(1:nrow(options), purrr::possibly(function(x){
    print(x)
    print(options[x,])
    data <- dplyr::filter(data_complete, 
                          location == options[x, "location"], 
                          species == options[x, "species"], agecap > 1)
    result <- bcalc_bayes(data)
    return(result)
  }, otherwise = NA))

bc_results2 <- bc_results[!is.na(bc_results)] %>% 
  lapply(function(x){x$lengths}) %>% 
  plyr::ldply() %>% 
  dplyr::select(-l_q1, -l_q3) %>% 
  rename("agei" = "age", 
         "Li_sploc_m" = "l_m",
         "Li_sploc_sd" = "l_sd")

# 7. Add R0p and merge data ----

data_complete <- data_complete %>% 
  dplyr::group_by(id) %>% 
  summarize(R0p = radi[which(agei == 0)]) %>% 
  ungroup(.) %>% 
  left_join(data_complete, .) %>% 
  left_join(., bc_results1) %>% 
  left_join(., bc_results2)

# 8. Rename variables following the standards of growth models ----

data_complete <- data_complete %>% 
  rename("Family" = "family",
         "Genus" = "genus",
         "Species" = "species",
         "ID" = "id",
         "Agei" = "agei",
         "Ri" = "radi",
         "Agecpt" = "agecap",
         "Rcpt" = "radcap",
         "Lcpt" = "lencap",
         "L0p" = "l0p",
         "Weight" = "weight",
         "Location" = "location",
         "Observer" = "observer") %>% 
  select(Family, Genus, Species, ID, Agei, Ri, Agecpt, Rcpt, Lcpt, L0p, R0p, 
         Li_sp_m, Li_sp_sd, Li_sploc_m, Li_sploc_sd, Weight, Location, Observer) # Re-order variables

# 9. Export data ----

write.csv(data_complete, 
          "./../data/back-calculated-size-at-age_morat-et-al_2020-04-20.csv", 
          row.names = FALSE)
