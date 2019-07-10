backcalc <- function(data, id = "id", agei = "agei", radi = "radi", agecap = "agecap", radcap = "radcap", lencap = "lencap", l0p = "l0p"){
  
  # ---- NOTE ----
  #
  # This function was written from the box 1, page 190 of the following book:
  #
  # Vigliola L., Meekan M.G. (2009) The Back-Calculation of Fish Growth From Otoliths. 
  # In: Green B.S., Mapstone B.D., Carlos G., Begg G.A. (eds) Tropical Fish Otoliths: Information for Assessment, Management and Ecology. 
  # Reviews: Methods and Technologies in Fish Biology and Fisheries, vol 11. Springer, Dordrecht
  #
  # Numbering of the following comments correspond to the different steps of this article
  
  require(minpack.lm)
  
  # 2. Calculation of R0p (otolith radius at hatching) ----
  
  data$r0p <- mean(data[data[[agei]]==0,]$radi, na.rm = TRUE)
  
  data_unique <- data[!duplicated(data[[id]]), ] # Create new data with one row by individual
  
  # 4. Estimate 'b', 'c' and 'd' parameters (needed to calculate 'a' parameter at step 5) ----
  
  # 4.1 Define the models --
  
  model_iso <- lencap ~ l0p - d*r0p + d*radcap # Isometric model to estimate 'd' parameter

  model_allo <- formula(lencap ~ l0p - b*r0p^c + b*radcap^c) # Allometric model to estimate 'b' and 'c' parameters
  
  # 4.2 Estimate 'd' parameter (using model_iso) --
  
  model_iso_fit <- nls(model_iso, data = data_unique, start = c(d = 1))
  
  d <- as.numeric(coef(model_iso_fit))
  
  # 4.3 Estimate 'b' and 'c' parameters (using model_allo) --
  
  # 4.3.1 Get the starting values -
  
  lnew <- data_unique$lencap - data_unique$l0p
  
  res_mod_log <- lm(log(lnew)~log(data_unique$radcap))
  
  b_estim_1 <- as.numeric(exp(res_mod_log$coefficients[1]))
  
  c_estim_1 <- as.numeric(res_mod_log$coefficients[2])                
  
  nls_allo_step1 <- nls(formula(lencap ~ l0p + b * radcap^c), data = data_unique, start = list(b = b_estim_1, c = c_estim_1)) 
  
  b_estim_2 <- as.numeric(coef(nls_allo_step1)[1])
  
  c_estim_2 <- as.numeric(coef(nls_allo_step1)[2])
  
  # 4.3.2 Estimate 'b' and 'c' parameters -
  
  nls_allo_step2 <- nlsLM(model_allo, data = data_unique,  start = list(b = b_estim_2, c = c_estim_2), control = nls.lm.control(maxiter = 1023))
  
  b <- as.numeric(coef(nls_allo_step2)[1])
  
  c <- as.numeric(coef(nls_allo_step2)[2])
  
  SEc <- coef(summary(nls_allo_step2))[2,2]
  
  dgfree <- df.residual(nls_allo_step2)
  
  # 5. Calculate 'a' parameter (test 'c' parameter against 1 to know what equation to use) ----
  
  test_value <- abs(c - 1)/SEc
  
  test_treshold <- qt(0.975, df = dgfree, ncp = 1)
  
  if(test_value > test_treshold){
    
    # If 'c' is significantly different from 1 (allometry) then use estimates of 'b' and 'c' to calculate 'a'
    a <- data_unique[1,"l0p"] - b*data_unique[1,"r0p"]^c
    
  } else {
    
    if(test_value < test_treshold){
      
      # If 'c' is NOT significantly different from 1 (isometry) then use estimate of 'd' to calculate 'a'
      a <- data_unique[1,"l0p"] - d*data_unique[1,"r0p"]
      
    }
  }
  
  # 6. Back-calculate fish size at agei ----
  
  data$li <- a + exp(log(data$l0p - a) + 
                          (((log(data$lencap - a) - log(data$l0p - a))*(log(data$radi) - log(data$r0p))) / (log(data$radcap) - log(data$r0p))))
  
  return(data)
  
}