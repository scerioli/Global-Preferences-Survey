AddResiduals_new <- function(dt, robust = FALSE) {
  # This function adds to the summary of the data the residuals from the
  # regression performed on various variables of interest.
  # It returns the summary of the data including these residuals.
  # If the argument robust is set to TRUE, the residuals are calculated using a
  # robust linear regression, otherwise a simple OLS is performed. 
  
  # Log GDP Residualised using Gender Equality Index
  dt_GEIx <- Residualise(dt, 
                         var1 = "GenderIndexStd",
                         var2 = "logAvgGDPpcStd", 
                         robust = robust)
  dt_GEIy <- Residualise(dt, 
                         var1 = "GenderIndexStd",
                         var2 = "avgGenderDiffStd", 
                         robust = robust)
  # Rename the variable
  dt_GEIy[, residualsavgGenderDiffStd_GEI := residualsavgGenderDiffStd]
  dt_GEIy$residualsavgGenderDiffStd <- NULL
  
  # Gender Equality Index Residualised using Log GDP
  dt_GDPx <- Residualise(dt, 
                         var1 = "logAvgGDPpcStd",
                         var2 = "GenderIndexStd", 
                         robust = robust)
  dt_GDPy <- Residualise(dt, 
                         var1 = "logAvgGDPpcStd",
                         var2 = "avgGenderDiffStd", 
                         robust = robust)
  # Rename the variable
  dt_GDPy[, residualsavgGenderDiffStd_GDP := residualsavgGenderDiffStd]
  dt_GDPy$residualsavgGenderDiffStd <- NULL
  
  # WEF Global Gender Gap Index Residualised using Log GDP
  dt_WEF <- Residualise(dt, 
                        var1 = "logAvgGDPpcStd",
                        var2 = "ScoreWEFStd", 
                        robust = robust)
  
  # UN Gender Equality Index Residualised using Log GDP
  dt_UN <- Residualise(dt, 
                       var1 = "logAvgGDPpcStd",
                       var2 = "ValueUNStd", 
                       robust = robust)
  dt_UN[, residualsValueUNStd := -1 * residualsValueUNStd]
  
  # Ratio Female to Male Residualised using Log GDP
  dt_ratioLabor <- Residualise(dt, 
                               var1 = "logAvgGDPpcStd",
                               var2 = "avgRatioLaborStd",
                               robust = robust)
  
  # Time since Women's Suffrage Residualised using Log GDP
  dt_Date <- Residualise(dt, 
                         var1 = "logAvgGDPpcStd",
                         var2 = "DateStd", 
                         robust = robust)
  dt_Date[, residualsDateStd := -1 * residualsDateStd]
  
  
  # Log GDP Residualised using Gender Equality Index
  dt_GDIx <- Residualise(dt, 
                         var1 = "GDIStd",
                         var2 = "logAvgGDPpcStd", 
                         robust = robust)
  dt_GDIy <- Residualise(dt, 
                         var1 = "GDIStd",
                         var2 = "avgGenderDiffStd", 
                         robust = robust)
  # Rename the variable
  dt_GDIy[, residualsavgGenderDiffStd_GDI := residualsavgGenderDiffStd]
  dt_GDIy$residualsavgGenderDiffStd <- NULL
  
  # GDI Residualised using Log GDP
  dt_GDI <- Residualise(dt, 
                        var1 = "logAvgGDPpcStd",
                        var2 = "GDIStd", 
                        robust = robust)
  
  
  # Group the data tables into a single list
  dts <- list(dt_GEIx, dt_GEIy, dt_GDPx, dt_GDPy, dt_GDIx, dt_GDIy,
              dt_WEF, dt_UN, dt_ratioLabor, dt_Date, dt_GDI)
  # Loop over the data table list to merge into a single data table
  for (data_table in dts) {
    # Select the interesting columns to keep
    data_table <- data_table %>% select(c(starts_with("residuals"), "country"))
    # Merge the two data tables
    dt <- merge(dt, data_table, by = "country")
  }
  
  return(dt)
}
