ExtractCoefficientsStanModel <- function(model_list_SMS) {
  # This function takes as an input an S4 type object (a stan model) and 
  # extracts the relevant coefficients for the analysis, saving them into a 
  # data.table format.
  
  dt_models_posrecip <- c()
  i <- 1
  
  for (C in unique(dataComplete$country)) {

    # Save the coefficients, the country and the preference in a data table
    dt_models_posrecip_tmp <- data.table(country = C,
                                         namesCoeff = names(models_list_SMS[[i]]@coef),
                                         coefficients = models_list_SMS[[i]]@coef,
                                         sd = precis(models_list_SMS[[i]], depth = 2)[[2]],
                                         preference = "posrecip")
    
    dt_models_posrecip <- rbind(dt_models_posrecip, dt_models_posrecip_tmp)
    i <- i + 1
  }
  
  return(dt_models_posrecip)
}