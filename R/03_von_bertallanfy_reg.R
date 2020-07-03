# 1. Source functions ----

source("R/functions/growthreg.R")

# 2. Required packages ----

library(plyr)
library(tidyverse)
library(rfishbase)
library(rstan)
library(parallel)
library(purrr)

# 3. Source models ----

vonbert_stan <- stan_model("stan/vonbert.stan")

# 4. Import data ----

bc <- read.csv("data/back-calculated-size-at-age_morat-et-al.csv")

# 5. Apply some filters ----

# filter with maxage > 1
bc <- group_by(bc, ID) %>% 
  mutate(agemax = max(Agei)) %>% 
  filter(agemax > 1)  %>%
  ungroup() %>%
# filter with at least 3 replicates
  group_by(Species) %>% 
  mutate(nrep = length(unique(ID))) %>% 
  filter(nrep>2) %>%
  ungroup()

# 6. Get all unique combinations per species and location ----
 
opts <- unique(select(bc, Species))

# 7. Get maxlengths for each species from fishbase ----

maxl <- rfishbase::species(opts$species, fields = c("Species", "Length")) %>% 
  group_by(Species) %>% summarise(Lmax = mean(Length, na.rm = TRUE)) %>% 
  as.data.frame()
colnames(maxl) <- c("Species", "lmax")

opts <- left_join(opts, maxl) %>%
  as.data.frame()
opts[opts$Species == "Chlorurus spilurus", "lmax"] <- 27

# 8. Run models ----

growthmodels <-
  lapply(1:nrow(opts), function(x){
    
    sp = opts[x,"Species"]
    lmax = opts[x,"lmax"]
    
    data <- bc %>% dplyr::filter(Species == sp)
    fit <- growthreg(length = data$Li_sp_m/10, 
                     age = data$Agei, 
                     id = as.character(data$ID), 
                     lmax = lmax, linf_m = 0.8 * lmax, 
                     control = list(adapt_delta = 0.999, max_treedepth = 15), 
                     cores = 4,
                     plot = FALSE)
    
    return(fit)
    
  })

# 9. Extract and export parameters ----

# 9.1 Extraction --

growth_extract <-
  lapply(1:nrow(opts), function(x){
    op <- opts[x,]
    op$k <- growthmodels[[x]]$summary["k", "mean"]
    op$k_sd <- growthmodels[[x]]$summary["k", "sd"]  
    op$linf <- growthmodels[[x]]$summary["linf", "mean"]
    op$linf_sd <- growthmodels[[x]]$summary["linf", "sd"]
    op$t0 <- growthmodels[[x]]$summary["t0", "mean"]
    op$t0_sd <- growthmodels[[x]]$summary["t0", "sd"]
    return(op)
  }) %>% plyr::ldply()

# 9.2 Exportation --

write.csv(growth_extract, "results_regressions_vbgc.csv", row.names = FALSE)

# 10. Extract and export predictions ----

# 10.1 Extraction --

growth_pred <-
  lapply(1:nrow(opts), function(x){
    op <- opts[x,]
    fitted <- cbind(op, growthmodels[[x]]$fitted)
    return(fitted)
  }) %>% plyr::ldply()

# 10.2 Exportation --

write.csv(growth_pred, "results_regressions_fitted.csv", row.names = FALSE)
