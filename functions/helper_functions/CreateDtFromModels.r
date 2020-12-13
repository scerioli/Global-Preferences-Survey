CreateDtFromModels <- function(model) {
  
  dt <- data.table()
  
  for(i in 1:length(model)) {        
    tmp <- data.table(country   = names(model)[i],
                      intercept = coef(model[[i]])[[1]],
                      genderCoef = coef(model[[i]])[[2]],
                      ageCoef  = coef(model[[i]])[[3]],
                      age2Coef = coef(model[[i]])[[4]],
                      smsCoef  = coef(model[[i]])[[5]])
    dt <- rbind(dt, tmp)
  }
  
  return(dt)
}