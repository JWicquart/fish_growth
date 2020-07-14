pred_vbgf <- function(data, agemaxna = 20){
  
  if(is.na(data$Age_max)){
    
    data_frame = data.frame(Agei = seq(from = 0, to = agemaxna, length.out = 1000))
    
  }else{
    
    data_frame = data.frame(Agei = seq(from = 0, to = data$Age_max, length.out = 1000))
    
  }
  
  data_frame <- data_frame %>% 
    bind_cols(data) %>% 
    mutate(Li = Linf*(1-(exp(-K*(Agei-t0)))))
  
}