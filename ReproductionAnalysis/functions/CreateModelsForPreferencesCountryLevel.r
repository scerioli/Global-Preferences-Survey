CreateModelsForPreferencesCountryLevel <- function(data, robust = FALSE) {
  # This function takes the complete dataset at individual level for all the
  # countries, select the interesting columns and fit the linear model for the
  # different preferences on it.
  # It returns a list of models containing the preferences in the first level,
  # and the countries in the second level.

  # Create the column age squared
  data[, age_2 := age^2]
  # Use gender as a factor and not as numeric
  data[, gender := as.factor(gender)]
  # Select the interesting columns
  colsVar <- c("country", names(data)[5:13], "age_2")
  # Select the data to fit
  dataToFit <- data %>% select(all_of(colsVar))

  # Create a model for each preference
  preferences <- names(dataToFit)[2:7]
  
  models <- lapply(preferences, function(x) {
    form <- paste0(x, " ~ gender + age + age_2 + subj_math_skills")
    model <- EstimateModel(dat = dataToFit, formula = form, var = "country",
                           robust = robust)
  })

  names(models) <- preferences

  return(models)
}
