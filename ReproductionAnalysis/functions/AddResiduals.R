AddResiduals <- function(dt, robust = FALSE) {
  # This function adds the residuals from the regression performed on various 
  # variables of interest to the summary of the data.
  # If the argument robust is set to TRUE, the residuals are calculated using a
  # robust linear regression, otherwise a simple OLS is performed. 
  
  # 1. Log GDP Residualised using Gender Equality Index
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
  
  # 2. Gender Equality Index Residualised using Log GDP
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
  
  # 3. WEF Global Gender Gap Index Residualised using Log GDP
  dt_WEF <- Residualise(dt, 
                        var1 = "logAvgGDPpcStd",
                        var2 = "ScoreWEFStd", 
                        robust = robust)
  
  # 4. UN Gender Equality Index Residualised using Log GDP
  dt_UN <- Residualise(dt, 
                       var1 = "logAvgGDPpcStd",
                       var2 = "ValueUNStd", 
                       robust = robust)
  # Invert the direction of the index (originally an "inequality" index)
  dt_UN[, residualsValueUNStd := -1 * residualsValueUNStd]
  
  # 5. Ratio Female to Male Residualised using Log GDP
  dt_ratioLabor <- Residualise(dt, 
                               var1 = "logAvgGDPpcStd",
                               var2 = "avgRatioLaborStd",
                               robust = robust)
  
  # 6. Time since Women's Suffrage Residualised using Log GDP
  dt_Date <- Residualise(dt, 
                         var1 = "logAvgGDPpcStd",
                         var2 = "DateStd", 
                         robust = robust)
  # Invert the direction of the index (originally an "inequality" index)
  dt_Date[, residualsDateStd := -1 * residualsDateStd]
  
  
  # Group the data tables into a single list
  dts <- list(dt_GEIx, dt_GEIy, dt_GDPx, dt_GDPy,
              dt_WEF, dt_UN, dt_ratioLabor, dt_Date)
  # Loop over the data table list to merge into a single data table
  for (data_table in dts) {
    # Select the interesting columns to keep
    data_table <- data_table %>% select(c(starts_with("residuals"), "country"))
    # Merge the two data tables
    dt <- merge(dt, data_table, by = "country", all = TRUE)
  }
  
  
  return(dt)
}
