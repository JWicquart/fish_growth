#' A function to extract growth parameters for fishes from back-calculation data
#'
#' @author Nina M. D. Schiettekatte
#' @param length Numerical vector with length (CAUTION: must be in cm)
#' @param age    Numerical vector with age
#' @param id     Character vector with fish id
#' @param linf_m Prior for linf
#' @param lmax   maximum size. Based on this value, maximum growth rate kmax will be computed.
#' @param plot   option to plot model fit (TRUE or FALSE)
#' @param ...     Additional arguments, see ?rstan::sampling()
#' @details      Returns a list with three elements.
#' First element is a dataframe with estimates for linf, k and t0, sl and gp.
#' There is a hierarchical structure for linf and k, so that there is a unique estimate for these parameters per individual (linf_j, k_j).
#' linf and k are the population level estimates of linf and k. kmax is the standardised growth parameter, depending on lmax
#' (kmax = exp(sl * log(lmax) + gp), see Morais and Bellwood (2018) for details)
#' Second element is a dataframe with model fits for the average regression across individuals (ypred_m, ypred_sd, ypred_lq, ypred_uq),
#' and the fitted regression er individual (urep_m, yrep_sd, yrep_lq, yrep_uq)
#' The third element is the entire stanfit object.
#'
#' @keywords      fish, growth, Von Bertalanfy
#' @import ggplot2
#' @import dplyr
#' @import rstan
#' @export growthreg
#'
#' @examples
#'
#' em <- dplyr::filter(fishgrowbot::coral_reef_fishes_data, species == "Epinephelus merra", location == "Moorea")
#' bc <- fishgrowbot::bcalc(data = em)$lengths
#' fishgrowbot::growthreg(length = bc$l_m/10, age = bc$age,
#' id = bc$id, lmax = 32, linf_m = 30, iter = 2000, chains = 1)
#'



growthreg <- function(length, age, id, lmax = 20, linf_m, plot = TRUE, ...){
  
  requireNamespace("ggplot2")
  requireNamespace("rstan")
  
  
  data <- list(
    N = length(length),
    N_1 = length(unique(id)),
    y = length,
    x = age,
    J = as.integer(as.factor(as.character(id))),
    linf_prior = linf_m,
    lmax = lmax,
    X = rep(1, length(length))
  )
  
  fit <- rstan::sampling(vonbert_stan, data = data, ...)
  
  summary <-  as.data.frame(rstan::summary(fit)$summary)
  
  result <- summary[c("k", "linf", "t0", "kmax"),1:8]
  
  ee <- rstan::extract(fit)
  y_m <- ee$y_m
  y_rep <- ee$y_rep
  pred <- data.frame(
    age = age,
    ypred_m = apply(y_m,2,mean),
    ypred_lq = apply(y_m,2,quantile, 0.025),
    ypred_uq = apply(y_m,2,quantile, 0.975),
    yrep_m = apply(y_rep,2,mean),
    yrep_lq = apply(y_rep,2,quantile, 0.025),
    yrep_uq = apply(y_rep,2,quantile, 0.975)
  )
  
  if(plot){
    p <-
      ggplot() +
      geom_point(aes(x = age, y = length)) +
      geom_ribbon(aes(x = age, ymin = ypred_lq, ymax = ypred_uq), alpha = 0.4, data = pred) +
      geom_line(aes(x = age, y = ypred_m), data = pred) +
      theme_bw()
    
    print(p)
  }
  return(list(summary = result, fitted = pred, stanfit = fit))
  
}