# 1. Source functions ----

source("R/functions/growthreg.R")

# 2. Required packages ----

library(stringr)
library(plyr)
library(dplyr)
library(tidyr)
library(rfishbase)
library(rstan)
library(parallel)
library(dplyr)
library(purrr)

# 3. Source models ----

vonbert_stan <- stan_model("stan/vonbert.stan")



# load data
bc <- read.csv("data/back-calculated-size-at-age_morat-et-al.csv")

# run models

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

# all unique combinations per species and location
opts <- unique(select(bc, Species))

# get maxlengths
maxl <- rfishbase::species(opts$species, fields = c("Species", "Length")) %>% 
  group_by(Species) %>% summarise(Lmax = mean(Length, na.rm = TRUE)) %>% 
  as.data.frame()
colnames(maxl) <- c("Species", "lmax")

opts <- left_join(opts, maxl) %>%
  as.data.frame()
opts[opts$Species == "Chlorurus spilurus", "lmax"] <- 27

# run models
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

# extract parameters
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


write.csv(growth_extract, "results_regressions_vbgc.csv", row.names = FALSE)


# extract parameters
growth_pred <-
  lapply(1:nrow(opts), function(x){
    op <- opts[x,]
    fitted <- cbind(op, growthmodels[[x]]$fitted)
    return(fitted)
  }) %>% plyr::ldply()

write.csv(growth_pred, "results_regressions_fitted.csv", row.names = FALSE)

test <- fit$fitted
plot(test$age, test$yrep_m)
plot(test$age, test$ypred_m)






