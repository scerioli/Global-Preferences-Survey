SummaryCoeffPerPreferencePerCountry <- function(model) {
  # This function takes as an argument a model (or more models in a list) and
  # extract from it the coefficients for each preference
  
  # Create an empty data table to be filled in the for loop
  dt  <- data.table()
  
  # Loop over the model and extract the coefficients associated to each 
  # preference and each country
  for (i in 1:length(model)) {
    dt_tmp <- CreateDtFromModels(model[[i]])
    dt_tmp[, preference := names(model)[[i]]]
    dt <- rbind(dt_tmp, dt)
  }
  
  return(dt)
}