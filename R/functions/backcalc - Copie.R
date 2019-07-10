backcalc = function(data, model = "Lea"){
  
  data$R0p <- mean(data[data$agei==0,]$radi, na.rm = TRUE)
  
  if(model == "Lea"){
    data$Li = (data$radi/data$radcap)*data$lencap
  
  } else if (model == "Campana") {
    data$R0p <- mean(data[data$agei==1,]$radi)
    data$Li = data$lencap + (data$radi - data$radcap) * ((data$lencap-data[1,"L0p"])/(data$radcap-data[,"R0p"]))
 
  } else if (model == "Fry") {
    
    # 1 - Duplication des données et extraction d'un seule ligne par individu
    
    Results = data
    data = data[!duplicated(data$fish), ]
    
    # 2 - Détermination du paramètre "a"
    
    # 2.1 - Isométrie (estimation du paramètre "d")
    
    ModelIso = lencap ~ L0p - d*R0p + d*radcap
    
    ModelIsoFit = nls(ModelIso, data = data, start = c(d = 1))
    
    d = as.numeric(coef(ModelIsoFit))
    
    # 2.2 - Allométrie (estimation des paramètres "c" et "d")
    
    ModelAllo = lencap ~ L0p - b*R0p^c + b*radcap^c
    
    # 2.2.1 - Obtention des starting values
    
    Lnew <- data$lencap - data$L0p
    
    ResModLog <- lm(log(Lnew)~log(data$radcap))
    
    b.estim.1 <- as.numeric(exp(ResModLog$coefficients[1]))
    
    c.estim.1 <- as.numeric(ResModLog$coefficients[2])                
    
    nls.allo.step1 <- nls(formula(lencap ~ L0p + b * radcap^c), data = data, start = list(b = b.estim.1, c = c.estim.1)) 
    
    b.estim.2 = as.numeric(coef(nls.allo.step1)[1])
    
    c.estim.2 = as.numeric(coef(nls.allo.step1)[2])
    
    # 2.2.2 - Modèle non linéaire
    
    library(minpack.lm)
    
    ModelAllo = formula(lencap ~ L0p - b*R0p^c + b*radcap^c)
    
    nls.allo.step2 <- nlsLM(ModelAllo, data = data,  start = list(b = b.estim.2, c = c.estim.2), control = nls.lm.control(maxiter = 1023))
    
    b = as.numeric(coef(nls.allo.step2)[1])
    
    c = as.numeric(coef(nls.allo.step2)[2])
    
    SEc = coef(summary(nls.allo.step2))[2,2]
    
    dgfree = df.residual(nls.allo.step2)
    
    # 2.3 - Test de significativité : "c" est-il significativement différent de 1 ?
    
    testc = abs(c - 1)/SEc
    
    seuil = qt(0.975, df = dgfree, ncp = 1)
    
    if(testc > seuil){
      
      shape = "allometry"
      
    } else {
      if(testc < seuil){
        
        shape = "isometry"
        
      }
    }
    
    # 2.4 - Calcul du paramètre "a"
    
    if(shape == "allometry"){
      
      a = data[1,"L0p"] - b*data[1,"R0p"]^c
      
    } else {
      if(shape == "isometry"){
        
        a = data[1,"L0p"] - d*data[1,"R0p"]
        
      }
    }
    
    # 3 - Application du modèle de Fry
    
    Results$Li <- a + exp(log(Results$L0p - a) + 
                            (((log(Results$lencap-a)-log(Results$L0p-a))*(log(Results$radi)-log(Results$R0p))) / (log(Results$radcap)-log(Results$R0p))))
    data <- Results
    
  } else {
    stop("Error: the model doesn't exist")
  }
  return(data)
}