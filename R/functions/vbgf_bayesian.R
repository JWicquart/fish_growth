vbgf_bayesian <- function(data, type){
  
  fit <- brm(bf(Li_sp_m ~ linf * (1 - exp(-k * (Agei - t0))), k ~ 1, linf ~ 1, t0 ~ 1, nl = TRUE),
             data = data, 
             family = gaussian(),
             prior = c(prior(normal(10, 5), nlpar = "linf"),
                       prior(normal(0.5, 0.5), nlpar = "k"),
                       prior(normal(0, 1), nlpar = "t0")),
             control = list(adapt_delta = 0.95), iter = 10000, warmup = 5000)
  
  if(type == "parameters"){ # Parameters estimates, SE, Q2.5 and Q97.5
    
    fixef(fit) %>% 
      as.data.frame() %>% 
      mutate(Parameter = row.names(.), .before = 1)
    
  }else if (type == "values"){ # Values of parameters for each iteration
    
    fit %>%
      spread_draws(b_k_Intercept, b_linf_Intercept, b_t0_Intercept)
    
  }else if (type == "fitted"){ # Fitted values (y for each x)
    
    data %>%
      data_grid(Agei = seq_range(Agei, n = 50)) %>%
      add_fitted_draws(fit)
    
  }else{
    
    stop("type must be 'fitted' or 'parameters'")
    
  }
  
}