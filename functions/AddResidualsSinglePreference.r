AddResidualsSinglePreference <- function(dt) {
  # This function adds to the summary of the data the residuals from the
  # regression performed on various variables of interest.
  # It returns the summary of the data including these residuals.
  
  # Single preference average gender difference residualised 
  for (pref in unique(dt$preference)) {
    # using the Gender Equality Index
    dt_tmpGEI <- Residualise(dt[preference == pref], 
                             var1 = "GenderIndexStd",
                             var2 = "gender")
    
    new_nameGEI <- paste0("residualsgenderGEI_", pref)
    dt_tmpGEI[, ((new_nameGEI)) := residualsgender]
    dt_tmpGEI <- rev(dt_tmpGEI)[, 1]
    
    # using the logGDP
    dt_tmpGDP <- Residualise(dt[preference == pref], 
                             var1 = "logAvgGDPpc",
                             var2 = "gender")
    
    new_nameGDP <- paste0("residualsgenderGDP_", pref)
    dt_tmpGDP[, ((new_nameGDP)) := residualsgender]
    dt_tmpGDP <- rev(dt_tmpGDP)[, 1]
    
    dt <- cbind(dt, dt_tmpGEI, dt_tmpGDP)
  }
  
  # LogGDP residualised using the Gender Equality Index
  dt <- Residualise(dt, 
                    var1 = "GenderIndexStd",
                    var2 = "logAvgGDPpc")
  
  # Gender Equality Index residualised using logGDP
  dt <- Residualise(dt, 
                    var1 = "logAvgGDPpc",
                    var2 = "GenderIndexStd")
  
  return(dt)
}
