AddResiduals_new <- function(dt, robust = FALSE) {
  # This function adds to the summary of the data the residuals from the
  # regression performed on various variables of interest.
  # It returns the summary of the data including these residuals.
  # If the argument robust is set to TRUE, the residuals are calculated using a
  # robust linear regression, otherwise a simple OLS is performed. 
  
  # -------- Gender differences residualise using Log GDP -------- #
  # This is common to all the residuals
  dt_Diff <- Residualise(dt, 
                         var1 = "logAvgGDPpcStd",
                         var2 = "avgGenderDiffStd", 
                         robust = robust)
  # Rename the variable
  dt_Diff[, residualsavgGenderDiffStd_GDP := residualsavgGenderDiffStd]
  dt_Diff$residualsavgGenderDiffStd <- NULL
  
  # -------- Gender Equality Index ---------- #
  # Log GDP Residualised using Gender Equality Index
  dt_GEIx <- Residualise(dt, 
                         var1 = "GenderIndexStd",
                         var2 = "logAvgGDPpcStd", 
                         robust = robust)
  # Rename the variable
  dt_GEIx[, residualslogAvgGDPpcStd_GEI := residualslogAvgGDPpcStd]
  dt_GEIx$residualslogAvgGDPpcStd <- NULL
  
  dt_GEIy <- Residualise(dt, 
                         var1 = "GenderIndexStd",
                         var2 = "avgGenderDiffStd", 
                         robust = robust)
  # Rename the variable
  dt_GEIy[, residualsavgGenderDiffStd_GEI := residualsavgGenderDiffStd]
  dt_GEIy$residualsavgGenderDiffStd <- NULL
  
  # Gender Equality Index Residualised using Log GDP
  dt_GEI <- Residualise(dt, 
                        var1 = "logAvgGDPpcStd",
                        var2 = "GenderIndexStd", 
                        robust = robust)
  # residualsGenderIndexStd
  
  # -------- WEF Global Gender Gap ---------- #
  # Log GDP Residualised using WEF Score
  dt_WEFx <- Residualise(dt, 
                         var1 = "ScoreWEFStd",
                         var2 = "logAvgGDPpcStd", 
                         robust = robust)
  # Rename the variable
  dt_WEFx[, residualslogAvgGDPpcStd_WEF := residualslogAvgGDPpcStd]
  dt_WEFx$residualslogAvgGDPpcStd <- NULL
  
  dt_WEFy <- Residualise(dt, 
                         var1 = "ScoreWEFStd",
                         var2 = "avgGenderDiffStd", 
                         robust = robust)
  # Rename the variable
  dt_WEFy[, residualsavgGenderDiffStd_WEF := residualsavgGenderDiffStd]
  dt_WEFy$residualsavgGenderDiffStd <- NULL
  
  # WEF Global Gender Gap Index Residualised using Log GDP
  dt_WEF <- Residualise(dt, 
                        var1 = "logAvgGDPpcStd",
                        var2 = "ScoreWEFStd", 
                        robust = robust)
  # residualsScoreWEFStd 
  
  # -------- UNDP GI Index ---------- #
  # Log GDP Residualised using UN value
  dt_UNx <- Residualise(dt, 
                        var1 = "ValueUNStd",
                        var2 = "logAvgGDPpcStd", 
                        robust = robust)
  # Rename the variable
  dt_UNx[, residualslogAvgGDPpcStd_UN := residualslogAvgGDPpcStd]
  dt_UNx$residualslogAvgGDPpcStd <- NULL
  
  dt_UNy <- Residualise(dt, 
                        var1 = "ValueUNStd",
                        var2 = "avgGenderDiffStd", 
                        robust = robust)
  # Rename the variable
  dt_UNy[, residualsavgGenderDiffStd_UN := residualsavgGenderDiffStd]
  dt_UNy$residualsavgGenderDiffStd <- NULL
  
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
  
  # -------- Gender Development Index ---------- #
  # Log GDP Residualised using Gender Equality Index
  dt_GDIx <- Residualise(dt, 
                         var1 = "GDIStd",
                         var2 = "logAvgGDPpcStd", 
                         robust = robust)
  # Rename the variable
  dt_GDIx[, residualslogAvgGDPpcStd_GDI := residualslogAvgGDPpcStd]
  dt_GDIx$residualslogAvgGDPpcStd <- NULL
  
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
  dts <- list(dt_Diff, dt_GEIx, dt_GEIy, dt_GEI, dt_WEFx, dt_WEFy, dt_WEF,
              dt_GDIx, dt_GDIy, dt_GDI, dt_UNx, dt_UNy, dt_UN, 
              dt_ratioLabor, dt_Date)
  # Loop over the data table list to merge into a single data table
  for (data_table in dts) {
    # Select the interesting columns to keep
    data_table <- data_table %>% select(c(starts_with("residuals"), "country"))
    # Merge the two data tables
    dt <- merge(dt, data_table, by = "country", all = TRUE)
  }
  
  return(dt)
}
