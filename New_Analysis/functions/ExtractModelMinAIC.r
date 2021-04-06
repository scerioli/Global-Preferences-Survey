ExtractModelMinAIC <- function(AIC_models) {
  # This function extracts the name of the model and its minimum AIC value for 
  # each country
  
  modelMinAIC <- c()
  
  for (single_country in 1:length(AIC_models)) { 
    tmp <- data.table(country  = names(AIC_models)[single_country])
    positionMinAIC <- which(AIC_models[[single_country]]$AIC == min(AIC_models[[single_country]]$AIC))
    if (positionMinAIC == 1) {
      tmp$minAIC <- min(AIC_models[[single_country]]$AIC)
      tmp$modelMinAIC <- "model"
    } else if (positionMinAIC == 2) {
      tmp$minAIC <- min(AIC_models[[single_country]]$AIC)
      tmp$modelMinAIC <- "model_g"
    } else if (positionMinAIC == 3) {
      tmp$minAIC <- min(AIC_models[[single_country]]$AIC)
      tmp$modelMinAIC <- "model_SMS"
    } else if (positionMinAIC == 4) {
      tmp$minAIC <- min(AIC_models[[single_country]]$AIC)
      tmp$modelMinAIC <- "model_gSMS"
    } else if (positionMinAIC == 5) {
      tmp$minAIC <- min(AIC_models[[single_country]]$AIC)
      tmp$modelMinAIC <- "model_ga"
    } else if (positionMinAIC == 6) {
      tmp$minAIC <- min(AIC_models[[single_country]]$AIC)
      tmp$modelMinAIC <- "model_gSMSa"
    } else if (positionMinAIC == 7) {
      tmp$minAIC <- min(AIC_models[[single_country]]$AIC)
      tmp$modelMinAIC <- "model_gSMSaCat"
    }
    
    modelMinAIC <- rbind(modelMinAIC, tmp)
  }
  
  return(modelMinAIC)
}