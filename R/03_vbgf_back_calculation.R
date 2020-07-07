# 1. Source functions ----

source("R/functions/bcalc_bayes.R")
source("R/functions/growthreg.R")

# 2. Required packages ----

library(tidyverse)
library(plyr)
library(rfishbase)
library(rstan)
library(parallel)
library(purrr)

# 3. Source models ----

bcalc_stan <- stan_model("stan/stan_bcalc.stan")
vonbert_stan <- stan_model("stan/vonbert.stan")

# 4. Load data ----

bc <- read.csv("data/back-calculated-size-at-age_morat-et-al.csv") %>%
  drop_na(Li_sploc_m) %>%
  group_by(ID) %>%
  filter(Agecpt > 2) %>% # filter with maxage > 2
  ungroup() %>%
  dplyr::group_by(Species, Location) %>%
  dplyr::mutate(nrep = length(unique(ID))) %>%
  filter(nrep > 4) %>% # filter with at least 3 replicates
  ungroup()

# 5. Extract all unique combinations per species and location ----

opts <- unique(select(bc, Location, Species))

# 6. Get maximum lengths (Lmax) from fishbase ----

maxl <- rfishbase::species(opts$Species, fields = c("Species", "Length")) %>%
  group_by(Species) %>% dplyr::summarise(Lmax = mean(Length, na.rm = TRUE)) %>%
  as.data.frame()
colnames(maxl) <- c("Species", "lmax")

opts <- left_join(opts, maxl) %>%
  as.data.frame()

opts[opts$Species == "Chlorurus spilurus", "lmax"] <- 27

# 7. Run models ----

growthmodels <- lapply(1:nrow(opts), function(x){
    
    loc <- opts[x,"Location"]
    sp <- opts[x,"Species"]
    lmax <- opts[x,"lmax"]
    
    data <- bc %>% dplyr::filter(Location == loc, Species == sp)
    
    fit <- growthreg(length = data$Li_sp_m/10,  #function requires cm
                     age = data$Agei,
                     id = as.character(data$ID),
                     lmax = lmax, linf_m = 0.8 * lmax,
                     control = list(adapt_delta = 0.999, max_treedepth = 15),
                     cores = 4, iter = 4000, warmup = 2000,
                     plot = FALSE)
    
    return(fit)
    
})

# 8. Extract parameters ----

lapply(1:nrow(opts), function(x){
    op <- opts[x,]
    op$k <- growthmodels[[x]]$summary["k", "mean"]
    op$k_sd <- growthmodels[[x]]$summary["k", "sd"]  
    op$linf <- growthmodels[[x]]$summary["linf", "mean"]
    op$linf_sd <- growthmodels[[x]]$summary["linf", "sd"]
    op$t0 <- growthmodels[[x]]$summary["t0", "mean"]
    op$t0_sd <- growthmodels[[x]]$summary["t0", "sd"]
    return(op)
}) %>% 
  plyr::ldply() %>% 
  write.csv(., "data/results_regressions_vbgc.csv", row.names = FALSE)

# 9. Extract fitted values ----

lapply(1:nrow(opts), function(x){
    op <- opts[x,]
    fitted <- op %>% cbind(growthmodels[[x]]$fitted)
    return(fitted)
}) %>% 
  plyr::ldply() %>% 
  write.csv(., "data/results_regressions_prediction.csv", row.names = FALSE)
