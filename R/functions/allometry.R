allometry <- function(data, xreg, yreg, graph=FALSE){
  x <- data[,xreg]
  y <- data[,yreg]

  # 1. Estimates the starting values by linear regressions on log for nls()
  REG <- lm(log(y) ~ log(x))

  # 2. Use nls() to estimate a and b parameters
  NLSREG <- nls(y ~ a*x^b, start = list(a = exp(as.numeric(coef(REG)[1])),
                                       b = as.numeric(coef(REG)[2])), 
               control = nls.control(maxiter = 1000))
  
  # 3. Print the results
  if(graph){
    plot(x, y, xlim = c(0,max(x)), 
         ylim = c(0,max(y)), 
         xlab = deparse(substitute(xreg)),
         ylab = deparse(substitute(yreg)))
    
    curve(as.numeric(coef(NLSREG)[1])*x^as.numeric(coef(NLSREG)[2]), 
          from=0, 
          to=max(x), 
          xlab="x", 
          ylab="y",
          add=T, 
          col="red")
  }
  
  return(data.frame(a = as.numeric(coef(NLSREG)[1]), b = as.numeric(coef(NLSREG)[2]), RSS = NLSREG$m$deviance()))
  
}
