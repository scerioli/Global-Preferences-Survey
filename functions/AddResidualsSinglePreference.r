AddResidualsSinglePreference <- function(dt) {
  # This function adds to the summary of the data the residuals from the
  # regression performed on various variables of interest.
  # It returns the summary of the data including these residuals.
  
  # Single preference average gender difference residualised using the 
  # Gender Equality Index
  for (pref in unique(dt$preference)) {
    dt_tmp <- Residualise(dt[preference == pref], 
                          var1 = "GenderIndexNorm",
                          var2 = "gender")
    
    new_name <- paste0("residualsgender_", pref)
    dt_tmp[, ((new_name)) := residualsgender]
    dt_tmp <- rev(dt_tmp)[, 1]
    
    dt <- cbind(dt, dt_tmp)
  }
  
  
  return(dt)
}
