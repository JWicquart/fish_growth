#' Run back-calculation in Bayesian framework
#'
#' @author Nina M. D. Schiettekatte
#' @param data dataframe containing results from otolith reading plus information on the length of hatching (l0p) of a certain species
#' data should contain:
#' \itemize{
#' \item{id:} unique fish id per individual
#' \item{radi:} measurements of otolith growth rings (in mm)
#' \item{agei:} age estimation of fish
#' \item{lencap:} length at capture (in mm)
#' \item{radcap:} radius of otolith at capture (in mm)
#' \item{l0p:} length of fish at hatching (in mm)
#' }
#' @param ... arguments to add to rstan::sampling()
#' @details  Returns a list of model fit and a dataset called lengths with the estimated lengths at age
#' \itemize{
#' \item{l_m:} mean length in mm
#' \item{l_sd:} sd of length
#' \item{l_q1:} lower 95% CI quantile
#' \item{l_q3:} upper 95% CI quantile
#' }
#'
#' Input data should include radi at age 0 measurements as well,
#' but can handle missing data (NA) for the cases where it is not possible to measure the radius at hatching
#' @import dplyr
#' @import rstan
#' @export bcalc


bcalc_bayes <- function(data, ...){
  
  if(!"radi" %in% colnames(data)){
    warning("data not in correct format")
    return(NA)
  }
  
  if(!"agei" %in% colnames(data)){
    warning("data not in correct format")
    return(NA)
  }
  if(!"radcap" %in% colnames(data)){
    warning("data not in correct format")
    return(NA)
  }
  if(!"lencap" %in% colnames(data)){
    warning("data not in correct format")
    return(NA)
  }
  if(!"id"   %in% colnames(data)){
    warning("data not in correct format")
    return(NA)
  }
  if(!"l0p"  %in% colnames(data)){
    warning("data not in correct format")
    return(NA)
  }
  
  if (length(which(!is.na(data[data$agei == 0, "radi"])))<2){
    warning("At least 2 known measurements of r0p are needed")
    return(NA)
  }else{
    
    missing = which(is.na(data[data$agei == 0, "radi"]))
    missing2 = which(is.na(data$radi))
    
    if (length(missing) == 1){
      missing <- array(missing, dim = 1)
    }
    if (length(missing2) == 1){
      missing2 <- array(missing2, dim = 1)
    }
    
    sdata <- list(
      N = nrow(data),
      Ni = length(unique(data[data$agei == 1,]$id)),
      N_mis = nrow(data[data$agei == 0 & is.na(data$radi),]),
      missing = missing,
      known = which(!is.na(data[data$agei == 0, "radi"])),
      missing2 = missing2,
      known2 = which(!is.na(data$radi)),
      id = as.integer(as.factor(as.character(data$id))),
      r = data[!is.na(data$radi),"radi"],
      rcap = (data[data$agei == 1,]$radcap),
      lcap = (data[data$agei == 1,]$lencap),
      l0p = unique(data$l0p),
      r0p = data[data$agei == 0  & !is.na(data$radi), "radi"]
    )
    
    fit <- rstan::sampling(bcalc_stan, sdata, chains = 4, ...)
    
    ll <- rstan::extract(fit, "l")[[1]]
    
    lengths <- data.frame(
      id = data$id,
      age = data$agei,
      l_m = apply(ll, 2, mean),
      l_sd = apply(ll, 2, sd),
      l_q1 = apply(ll, 2, quantile, 0.025),
      l_q3 = apply(ll, 2, quantile, 0.975)
    )
    
    # check for fit and outliers
    lcap_mu <- rstan::extract(fit, "lcap_mu")[[1]]
    lcap <- data.frame(
      id = unique(data$id),
      radcap = (data[data$agei == 1,]$radcap),
      r0 = (data[data$agei == 0,]$radi),
      lencap = (data[data$agei == 1,]$lencap),
      l_m = apply(lcap_mu, 2, median),
      l_sd = apply(lcap_mu, 2, sd),
      l_lq = apply(lcap_mu, 2, quantile, 0.025),
      l_uq = apply(lcap_mu, 2, quantile, 0.975)
    ) %>%
      mutate(outlier = lencap > l_lq & lencap < l_uq)
    
    return(list(fit = fit, lengths = lengths, lcap = lcap))
  }
}

