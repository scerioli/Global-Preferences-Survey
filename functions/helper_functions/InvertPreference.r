InvertPreference <- function(data) {
  # This function takes some input data containing all the six preferences at
  # single level (no PCA) and it multiplies the ones with an opposite trend by
  # a -1
  
  data[preference == "risktaking", gender := -1 * gender]
  data[preference == "negrecip", gender := -1 * gender]
  data[preference == "patience", gender := -1 * gender]
  
  return(data)
}