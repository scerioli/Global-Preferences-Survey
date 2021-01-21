CreateAlternativeModels <- function(data) {
  # This function takes the complete dataset at individual level for all the
  # countries, select the interesting columns and fit the linear model for the
  # different preferences on it.
  # It returns a list of models containing the preferences in the first level,
  # and the countries in the second level.
  
  # Use gender as a factor and not as numeric
  data[, gender := as.factor(gender)]
  # Select the interesting columns
  colsVar <- c("country", names(data)[5:13])
  # Select the data to fit
  dataToFit <- data %>% select(all_of(colsVar))
  
  # Create a model for each preference
  preferences <- names(dataToFit)[2:7]
  
  models <- lapply(preferences, function(x) {
    form <- paste0(x, " ~ gender")
    model <- EstimateModel(dat = dataToFit, formula = form, var = "country")
  })
  
  names(models) <- preferences
  
  return(models)
}
