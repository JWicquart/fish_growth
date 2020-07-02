# 1. Source functions ----

source("R/functions/bcalc_bayes.R")
source("R/functions/growthreg.R")

# 2. Recquired packages ----

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

bcalc_stan <- stan_model("stan/stan_bcalc.stan")
vonbert_stan <- stan_model("stan/vonbert.stan")



# load data
bc <- read.csv("data/size_at_age_coral_reef_fishes_data.csv")

# run models

# filter with maxage > 1
bc <- group_by(bc, ID) %>% 
  mutate(agemax = max(Agei)) %>% 
  filter(agemax > 1)  %>%
  ungroup() %>%
# filter with at least 3 replicates
  group_by(Species, Location) %>% 
  mutate(nrep = length(unique(ID))) %>% 
  filter(nrep>2) %>%
  ungroup()

# all unique combinations per species and location
opts <- unique(select(bc, Location, Species))

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
    
    loc = opts[x,"Location"]
    sp = opts[x,"Species"]
    lmax = opts[x,"lmax"]
    
    data <- bc %>% dplyr::filter(Location == loc, Species == sp)
    fit <- growthreg(length = data$Li_sploc_m/10, 
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
    op$kmax <- growthmodels[[x]]$summary["kmax", "mean"]
    op$kmax_sd <- growthmodels[[x]]$summary["kmax", "sd"]
    op$k <- growthmodels[[x]]$summary["k", "mean"]
    op$k_sd <- growthmodels[[x]]$summary["k", "sd"]  
    op$linf <- growthmodels[[x]]$summary["linf", "mean"]
    op$linf_sd <- growthmodels[[x]]$summary["linf", "sd"]
    op$t0 <- growthmodels[[x]]$summary["t0", "mean"]
    op$t0_sd <- growthmodels[[x]]$summary["t0", "sd"]
    return(op)
  }) %>% plyr::ldply()


write.csv(growth_extract, "results_regressions_vbgc.csv", row.names = FALSE)


# extract fitted values
growth_pred <-
  lapply(1:nrow(opts), function(x){
    op <- opts[x,]
    fitted <- cbind(op, growthmodels[[x]]$fitted)
    return(fitted)
  }) %>% plyr::ldply()

write.csv(growth_pred, "results_regressions_fitted.csv", row.names = FALSE)









