InvertPreference <- function(data) {
  # This function takes some input data containing all the six preferences at
  # single level (no PCA) and it multiplies the ones with an opposite trend by
  # a -1.
  
  # Define the original value of the gender to preserve the direction of the
  # change
  data[, genderOrig := gender] 
  # Invert the sign for the known preferences
  data[preference %in% c("risktaking", "negrecip", "patience"), 
       gender := -1 * genderOrig]
  
  return(data)
}