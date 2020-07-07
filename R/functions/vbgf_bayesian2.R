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