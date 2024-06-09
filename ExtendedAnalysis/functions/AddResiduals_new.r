AddResiduals_new <- function(dt, robust = FALSE) {
  # This function adds to the summary of the data the residuals from the
  # regression performed on various variables of interest.
  # It returns the summary of the data including these residuals.
  # If the argument robust is set to TRUE, the residuals are calculated using a
  # robust linear regression, otherwise a simple OLS is performed. 
  
  dt_all <- AddResiduals(dt, robust = robust)
  
  # -------- Ratio Female to Male Labor Force Participation ---------- #
  # Log GDP Residualised using F/M LFP
  dt_LFPx <- Residualise(dt, 
                         var1 = "avgRatioLaborStd",
                         var2 = "logAvgGDPpcStd", 
                         robust = robust)
  # Rename the variable
  dt_LFPx[, residualslogAvgGDPpcStd_LFP := residualslogAvgGDPpcStd]
  dt_LFPx$residualslogAvgGDPpcStd <- NULL
  
  dt_LFPy <- Residualise(dt, 
                         var1 = "avgRatioLaborStd",
                         var2 = "avgGenderDiffStd", 
                         robust = robust)
  # Rename the variable
  dt_LFPy[, residualsavgGenderDiffStd_LFP := residualsavgGenderDiffStd]
  dt_LFPy$residualsavgGenderDiffStd <- NULL
  
  # -------- Time Since Women Suffrage ---------- #
  # Log GDP Residualised using TSWS
  dt_TSWSx <- Residualise(dt, 
                          var1 = "DateStd",
                          var2 = "logAvgGDPpcStd", 
                          robust = robust)
  # Rename the variable
  dt_TSWSx[, residualslogAvgGDPpcStd_TSWS := residualslogAvgGDPpcStd]
  dt_TSWSx$residualslogAvgGDPpcStd <- NULL
  
  dt_TSWSy <- Residualise(dt, 
                          var1 = "DateStd",
                          var2 = "avgGenderDiffStd", 
                          robust = robust)
  # Rename the variable
  dt_TSWSy[, residualsavgGenderDiffStd_TSWS := residualsavgGenderDiffStd]
  dt_TSWSy$residualsavgGenderDiffStd <- NULL
  
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
  dts <- list(dt_all, dt_LFPx, dt_LFPy, dt_TSWSx, dt_TSWSy,
              dt_GDIx, dt_GDIy, dt_GDI)
  # Loop over the data table list to merge into a single data table
  for (data_table in dts) {
    # Select the interesting columns to keep
    data_table <- data_table %>% select(c(starts_with("residuals"), "country"))
    # Merge the two data tables
    dt <- merge(dt, data_table, by = "country", all = TRUE)
  }
  
  return(dt)
}
