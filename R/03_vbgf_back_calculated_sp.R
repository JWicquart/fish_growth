# 1. Source functions ----

source("R/functions/growthreg.R")

# 2. Required packages ----

library(tidyverse)
library(rfishbase)
library(rstan)
library(parallel)
library(bayesplot)

# 3. Source models ----

vonbert_stan <- stan_model("stan/vonbert.stan")

# 4. Load data ----

bc <- read.csv("data/02_back-calculated-size-at-age_morat-et-al.csv") %>%
  drop_na(Li_sploc_m) %>%
  group_by(ID) %>%
  filter(Agecpt > 2) %>% # filter with maxage > 2
  ungroup() %>%
  dplyr::group_by(Species) %>%
  dplyr::mutate(n = length(unique(ID))) %>%
  filter(n >= 5) %>% # filter with at least 5 individuals
  ungroup() %>% 
  #filter(Species %in% c("Acanthurus triostegus", "Acanthurus achilles")) %>% 
  as.data.frame()

# 5. Extract all unique combinations per species and location ----

opts <- rfishbase::species(unique(bc$Species), fields = c("Species", "Length")) %>% # Get maximum lengths (Lmax) from fishbase
  group_by(Species) %>% 
  dplyr::summarise(lmax = mean(Length, na.rm = TRUE)) %>%
  ungroup() %>% 
  as.data.frame() %>% 
  mutate(lmax = ifelse(Species == "Chlorurus spilurus", 27, lmax)) %>% # Manually add value for missing species
  right_join(., unique(select(bc, Species))) %>% # Join with unique combinations
  as.data.frame()


# 6. Run models ----

ncores <- detectCores()

if (ncores < 5 | Sys.info()[1] == "Windows"){
  growthmodels <- lapply(1:nrow(opts), function(x){
    
    sp <- opts[x,"Species"]
    lmax <- opts[x,"lmax"]
    
    data <- bc %>% dplyr::filter(Species == sp) 
    
    linf_prior <- 0.8 * max(data$Lcpt)/10
    
    fit <- growthreg(length = data$Li_sp_m/10,  # Function requires cm
                     age = data$Agei,
                     id = as.character(data$ID),
                     lmax = lmax, 
                     linf_m = linf_prior,
                     control = list(adapt_delta = 0.99, max_treedepth = 12),
                     cores = 4, iter = 2000, warmup = 1000,
                     plot = FALSE)
    
    return(fit)
    
  })
} else{
  
  growthmodels <- mclapply(1:nrow(opts), function(x){
    
    sp <- opts[x,"Species"]
    lmax <- opts[x,"lmax"]
    
    data <- bc %>% dplyr::filter(Species == sp) 
    
    linf_prior <- 0.8 * max(data$Lcpt)/10
    
    fit <- growthreg(length = data$Li_sp_m/10,  # Function requires cm
                     age = data$Agei,
                     id = as.character(data$ID),
                     lmax = lmax, 
                     linf_m = linf_prior,
                     control = list(adapt_delta = 0.99, max_treedepth = 12),
                     cores = 1, iter = 2000, warmup = 1000,
                     plot = FALSE)
    
    return(fit)
    
  }, mc.cores = round(0.8 * ncores))
}

#### diagnostics #####
check_rhat <- function(fit) {
  fit_summary <- summary(fit, probs = c(0.5))$summary
  N <- dim(fit_summary)[[1]]
  
  no_warning <- TRUE
  for (n in 1:N) {
    rhat <- fit_summary[,6][n]
    if (rhat > 1.1 || is.infinite(rhat) || is.nan(rhat)) {
      print(sprintf('Rhat for parameter %s is %s!',
                    rownames(fit_summary)[n], rhat))
      no_warning <- FALSE
    }
  }
  if (no_warning){
    print('Rhat looks reasonable for all parameters')
    return(TRUE)
  }
    
  else{
    print('  Rhat above 1.1 indicates that the chains very likely have not mixed')
    return(FALSE)
  }
}

rcheck <- lapply(growthmodels, function(x){check_rhat(x[[3]])}) %>% unlist

length(rcheck[rcheck == FALSE])
which(rcheck == FALSE)


###### posterior predictive checks

for (x in 1:nrow(opts)){
  print(x)
  sp <- opts[x,"Species"]
  data <- bc %>% dplyr::filter(Species == sp) 
  
  yrep <- extract(growthmodels[[x]][[3]], "y_rep")[[1]][sample(4000, 50),]
  print(pp_check(data$Li_sp_m/10, yrep, fun = ppc_dens_overlay))
  Sys.sleep(3)
}

###### rerun some 
opts2 <- opts[which(rcheck == FALSE),]

i_rerun <- which(rcheck == FALSE)

if (ncores < 5 | Sys.info()[1] == "Windows"){
  
  growthmodels_rerun <- lapply(i_rerun, function(x){
    
    sp <- opts[x,"Species"]
    lmax <- opts[x,"lmax"]
    
    data <- bc %>% dplyr::filter(Species == sp) 
    
    linf_prior <- 0.8 * max(data$Lcpt)/10
    
    fit <- growthreg(length = data$Li_sp_m/10,  # Function requires cm
                     age = data$Agei,
                     id = as.character(data$ID),
                     lmax = lmax, 
                     linf_m = linf_prior,
                     control = list(adapt_delta = 0.99, max_treedepth = 12),
                     cores = (ncores - 1), iter = 4000, warmup = 2000,
                     plot = FALSE)
    
    return(fit)
    
  })
}else{
  growthmodels_rerun <- parallel::mclapply(i_rerun, function(x){
    
    sp <- opts[x,"Species"]
    lmax <- opts[x,"lmax"]
    
    data <- bc %>% dplyr::filter(Species == sp) 
    
    linf_prior <- 0.8 * max(data$Lcpt)/10
    
    fit <- growthreg(length = data$Li_sp_m/10,  # Function requires cm
                     age = data$Agei,
                     id = as.character(data$ID),
                     lmax = lmax, 
                     linf_m = linf_prior,
                     control = list(adapt_delta = 0.99, max_treedepth = 12),
                     cores = 1, iter = 4000, warmup = 2000,
                     plot = FALSE)
    
    return(fit)
    
  }, mc.cores = round(0.8 * ncores))
  }
  
growthmodels[i_rerun] <- growthmodels_rerun

# second check
rcheck <- lapply(growthmodels, function(x){check_rhat(x[[3]])}) %>% unlist
length(rcheck[rcheck == FALSE])
which(rcheck == FALSE)



##### inspect individial species ####

### 2
x = 2
sp <- opts[x,"Species"]
lmax <- opts[x,"lmax"]

data <- bc %>% dplyr::filter(Species == sp)

rstan::plot(growthmodels[[x]][[3]], plotfun = "trace", pars = "linf_j")
# second ind. is problematic
unique(data$ID)[2]

data <- data %>% dplyr::filter(!ID == "AC_LI_MA_03_17_165")

linf_prior <- 0.8 * max(data$Lcpt)/10

ggplot(data) +
  geom_point(aes(x = Agei, y = Li_sp_m, 
                 color = ID, shape = Location))

fit <- growthreg(length = data$Li_sp_m/10,  # Function requires cm
                 age = data$Agei,
                 id = as.character(data$ID),
                 lmax = lmax, 
                 linf_m = linf_prior,
                 control = list(adapt_delta = 0.99, max_treedepth = 12),
                 cores = 4, iter = 4000, warmup = 2000,
                 plot = FALSE)

yrep <- extract(fit[[3]], "y_rep")[[1]][sample(4000, 50),]

pp_check(data$Li_sp_m/10, yrep, fun = ppc_dens_overlay)

rstan::plot(fit[[3]], plotfun = "trace", pars = "linf_j")

# replace
growthmodels[[x]] <- fit


### 6
x = 6
sp <- opts[x,"Species"]
lmax <- opts[x,"lmax"]

data <- bc %>% dplyr::filter(Species == sp) %>%
  # problem with outlier
  filter(!ID == "Ct_MA_MA_03_17_155")

linf_prior <- 0.8 * max(data$Lcpt)/10

ggplot(data) +
  geom_point(aes(x = Agei, y = Li_sp_m, color = ID))

fit <- growthreg(length = data$Li_sp_m/10,  # Function requires cm
                 age = data$Agei,
                 id = as.character(data$ID),
                 lmax = lmax, 
                 linf_m = 20,
                 control = list(adapt_delta = 0.99, max_treedepth = 12),
                 cores = 4, iter = 2000, warmup = 1000,
                 plot = FALSE)

yrep <- extract(fit[[3]], "y_rep")[[1]][sample(4000, 50),]

pp_check(data$Li_sp_m/10, yrep, fun = ppc_dens_overlay)

rstan::plot(fit[[3]], plotfun = "trace", pars = "linf_j")

# replace
growthmodels[[x]] <- fit

### 17
x = 17
sp <- opts[x,"Species"]
lmax <- opts[x,"lmax"]

data <- bc %>% dplyr::filter(Species == sp)

rstan::plot(growthmodels[[x]][[3]], plotfun = "trace", pars = "linf_j")
# 1st ind. is problematic
unique(data$ID)[1]

data <- data %>% dplyr::filter(!ID == "SA_MI_MA_03_17_128")

linf_prior <- 0.8 * max(data$Lcpt)/10

ggplot(data) +
  geom_point(aes(x = Agei, y = Li_sp_m, 
                 color = ID, shape = Location))

fit <- growthreg(length = data$Li_sp_m/10,  # Function requires cm
                 age = data$Agei,
                 id = as.character(data$ID),
                 lmax = lmax, 
                 linf_m = linf_prior,
                 control = list(adapt_delta = 0.99, max_treedepth = 12),
                 cores = 4, iter = 2000, warmup = 1000,
                 plot = FALSE)

yrep <- extract(fit[[3]], "y_rep")[[1]][sample(4000, 50),]

pp_check(data$Li_sp_m/10, yrep, fun = ppc_dens_overlay)

rstan::plot(fit[[3]], plotfun = "trace", pars = "linf_j")

# replace
growthmodels[[x]] <- fit


### 24
x = 24
sp <- opts[x,"Species"]
lmax <- opts[x,"lmax"]

data <- bc %>% dplyr::filter(Species == sp) %>%
  filter(!ID %in% c("CE_FL_MA_03_17_214", "CE_FL_MA_03_17_216"))

linf_prior <- 0.8 * max(data$Lcpt)/10

ggplot(data) +
  geom_point(aes(x = Agei, y = Li_sp_m, 
                 color = ID, shape = Location))

fit <- growthreg(length = data$Li_sp_m/10,  # Function requires cm
                 age = data$Agei,
                 id = as.character(data$ID),
                 lmax = lmax, 
                 linf_m = linf_prior,
                 control = list(adapt_delta = 0.99, max_treedepth = 12),
                 cores = 4, iter = 2000, warmup = 1000,
                 plot = FALSE)

yrep <- extract(fit[[3]], "y_rep")[[1]][sample(4000, 50),]

pp_check(data$Li_sp_m/10, yrep, fun = ppc_dens_overlay)

rstan::plot(fit[[3]], plotfun = "trace", pars = "linf_j")

# replace
growthmodels[[x]] <- fit

### 33
x = 33
sp <- opts[x,"Species"]
lmax <- opts[x,"lmax"]

rstan::plot(growthmodels[[x]][[3]], plotfun = "trace", pars = "linf_j")
# 5th individual problematic

data <- bc %>% dplyr::filter(Species == sp) 

unique(data$ID)[5]

data <- data %>%
  filter(! ID == "GAM18_A089")

linf_prior <- 0.8 * max(data$Lcpt)/10

ggplot(data) +
  geom_point(aes(x = Agei, y = Li_sp_m, 
                 color = ID, shape = Location))

fit <- growthreg(length = data$Li_sp_m/10,  # Function requires cm
                 age = data$Agei,
                 id = as.character(data$ID),
                 lmax = lmax, 
                 linf_m = linf_prior,
                 control = list(adapt_delta = 0.99, max_treedepth = 12),
                 cores = 4, iter = 2000, warmup = 1000,
                 plot = FALSE)

yrep <- extract(fit[[3]], "y_rep")[[1]][sample(4000, 50),]

pp_check(data$Li_sp_m/10, yrep, fun = ppc_dens_overlay)
rstan::plot(fit[[3]], plotfun = "trace", pars = "linf_j")


# replace
growthmodels[[x]] <- fit


### 37
x = 37
sp <- opts[x,"Species"]
lmax <- opts[x,"lmax"]

rstan::plot(growthmodels[[x]][[3]], plotfun = "trace", pars = "linf_j")
# 7 and 12

data <- bc %>% dplyr::filter(Species == sp) 

remove <- unique(data$ID)[c(2, 6, 7,12)]

data <- data %>%
  filter(! ID %in% remove)

linf_prior <- 0.9 * max(data$Lcpt)/10

ggplot(data) +
  geom_point(aes(x = Agei, y = Li_sp_m, 
                 color = ID, shape = Location))

fit <- growthreg(length = data$Li_sp_m/10,  # Function requires cm
                 age = data$Agei,
                 id = as.character(data$ID),
                 lmax = lmax, 
                 linf_m = linf_prior,
                 control = list(adapt_delta = 0.99, max_treedepth = 12),
                 cores = 4, iter = 2000, warmup = 1000,
                 plot = FALSE)

yrep <- extract(fit[[3]], "y_rep")[[1]][sample(4000, 50),]

pp_check(data$Li_sp_m/10, yrep, fun = ppc_dens_overlay)
rstan::plot(fit[[3]], plotfun = "trace", pars = "linf_j")


# replace
growthmodels[[x]] <- fit

# last check
rcheck <- lapply(growthmodels, function(x){check_rhat(x[[3]])}) %>% unlist
length(rcheck[rcheck == FALSE])
## OK!!!

# 7. Extract parameters ----

lapply(1:nrow(opts), function(x){
  
  pred <- growthmodels[[x]]$summary %>% 
    as.data.frame() %>% 
    mutate(Parameter = row.names(.)) %>% 
    filter(Parameter != "kmax") %>% 
    rename(Estimate = mean, Est.Error = sd, Q2.5 = "2.5%", Q97.5 = "97.5%") %>% 
    mutate(Species = opts[x, "Species"]) %>%
    select(Species, Parameter, Estimate, Est.Error, Q2.5, Q97.5)
  
  return(pred)
  
}) %>% 
  plyr::ldply() %>% 
  write.csv(., "data/03_back-calculated_vbgf_predictions_sp.csv", row.names = FALSE)

# 8. Extract fitted values ----

lapply(1:nrow(opts), function(x){
  
    fitted <- growthmodels[[x]]$fitted %>% 
      as.data.frame() %>% 
      mutate(Species = opts[x, "Species"]) 
      
    return(fitted)
    
}) %>% 
  plyr::ldply() %>% 
  write.csv(., "data/03_back-calculated_vbgf_fitted_sp.csv", row.names = FALSE)

