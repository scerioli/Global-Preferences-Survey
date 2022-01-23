AddResidualsSinglePreference <- function(dt, robust = FALSE) {
  # This function adds to the summary of the data the residuals from the
  # regression performed on various variables of interest.
  # It returns the summary of the data including these residuals.
  # If the argument robust is set to TRUE, the residuals are calculated using a
  # robust linear regression, otherwise a simple OLS is performed. 
  
  dt_tmp <- c()
  
  # Single preference average gender difference residualised 
  for (pref in unique(dt$preference)) {
    # using the Gender Equality Index
    dt_tmpGEI <- Residualise(dt[preference == pref], 
                             var1 = "GenderIndex",
                             var2 = "gender",
                             robust = robust)
    new_nameGEI <- paste0("residualsgenderGEI_", pref)
    dt_tmpGEI[, ((new_nameGEI)) := residualsgender]
    dt_tmpGEI <- rev(dt_tmpGEI)[, 1]
    
    # using the logGDP
    dt_tmpGDP <- Residualise(dt[preference == pref], 
                             var1 = "logAvgGDPpc",
                             var2 = "gender",
                             robust = robust)
    
    new_nameGDP <- paste0("residualsgenderGDP_", pref)
    dt_tmpGDP[, ((new_nameGDP)) := residualsgender]
    dt_tmpGDP <- rev(dt_tmpGDP)[, 1]
    
    # LogGDP residualised using the Gender Equality Index
    dt_logGDP_GEI <- Residualise(dt[preference == pref], 
                                 var1 = "GenderIndex",
                                 var2 = "logAvgGDPpc",
                                 robust = robust)
    new_nameGEI <- paste0("residualslogAvgGDPpc_", pref)
    dt_logGDP_GEI[, ((new_nameGEI)) := residualslogAvgGDPpc]
    dt_logGDP_GEI <- rev(dt_logGDP_GEI)[, 1]
    
    # Gender Equality Index residualised using logGDP
    dt_GEI_logGDP <- Residualise(dt[preference == pref], 
                                 var1 = "logAvgGDPpc",
                                 var2 = "GenderIndex",
                                 robust = robust)
    new_nameGDP <- paste0("residualsGenderIndex_", pref)
    dt_GEI_logGDP[, ((new_nameGDP)) := residualsGenderIndex]
    dt_GEI_logGDP <- rev(dt_GEI_logGDP)[, 1]
    
    dt_tmp <- cbind(dt_tmp, dt_tmpGEI, dt_tmpGDP, dt_logGDP_GEI, dt_GEI_logGDP)
    
    rm(dt_logGDP_GEI)
    rm(dt_GEI_logGDP)
  }
  
  dt_tmp$country <- unique(dt$country)
  
  dt <- merge(dt, dt_tmp, by = "country")
  
  return(dt)
}
