AddResiduals_new <- function(dt) {
  # This function adds to the summary of the data the residuals from the
  # regression performed on various variables of interest.
  # It returns the summary of the data including these residuals.
  
  # Log GDP Residualised using Gender Equality Index
  dt_GEIx <- Residualise(dt, var1 = "GenderIndexStd",
                         var2 = "logAvgGDPpc")
  dt_GEIy <- Residualise(dt, var1 = "GenderIndexStd",
                         var2 = "avgGenderDiff")
  # Rename the variable
  dt_GEIy[, residualsavgGenderDiff_GEI := residualsavgGenderDiff]
  dt_GEIy$residualsavgGenderDiff <- NULL
  
  # Gender Equality Index Residualised using Log GDP
  dt_GDPx <- Residualise(dt, var1 = "logAvgGDPpc",
                         var2 = "GenderIndexStd")
  dt_GDPy <- Residualise(dt, var1 = "logAvgGDPpc",
                         var2 = "avgGenderDiff")
  # Rename the variable
  dt_GDPy[, residualsavgGenderDiff_GDP := residualsavgGenderDiff]
  dt_GDPy$residualsavgGenderDiff <- NULL
  
  # WEF Global Gender Gap Index Residualised using Log GDP
  dt_WEF <- Residualise(dt, var1 = "logAvgGDPpc",
                        var2 = "ScoreWEFStd")
  
  # UN Gender Equality Index Residualised using Log GDP
  dt_UN <- Residualise(dt, var1 = "logAvgGDPpc",
                       var2 = "ValueUNStd")
  dt_UN[, residualsValueUNStd := -1 * residualsValueUNStd]
  
  # Ratio Female to Male Residualised using Log GDP
  dt_ratioLabor <- Residualise(dt, var1 = "logAvgGDPpc",
                               var2 = "avgRatioLaborStd")
  
  # Time since Women's Suffrage Residualised using Log GDP
  dt_Date <- Residualise(dt, var1 = "logAvgGDPpc",
                         var2 = "DateStd")
  dt_Date[, residualsDateStd := -1 * residualsDateStd]
  
  
  # Log GDP Residualised using Gender Equality Index
  dt_GDIx <- Residualise(dt, var1 = "GDIStd",
                         var2 = "logAvgGDPpc")
  dt_GDIy <- Residualise(dt, var1 = "GDIStd",
                         var2 = "avgGenderDiff")
  # Rename the variable
  dt_GDIy[, residualsavgGenderDiff_GDI := residualsavgGenderDiff]
  dt_GDIy$residualsavgGenderDiff <- NULL
  
  # GDI Residualised using Log GDP
  dt_GDI <- Residualise(dt, var1 = "logAvgGDPpc",
                            var2 = "GDIStd")
  
  
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
