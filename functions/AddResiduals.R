AddResiduals <- function(dt) {
  # This function adds to the summary of the data the residuals from the
  # regression performed on various variables of interest.
  # It returns the summary of the data including these residuals.

  # Adjust those columns that needs to have a negative coefficient in front
  dt[, `:=` (ValueUNNorm = -1 * ValueUNNorm,
             DateNorm = -1 * DateNorm)]

  # Log GDP Residualised using Gender Equality Index
  dt_GEIx <- Residualise(dt, var1 = "GenderIndexNorm",
                             var2 = "logAvgGDPpcNorm")
  dt_GEIy <- Residualise(dt, var1 = "GenderIndexNorm",
                             var2 = "avgGenderDiffNorm")
  # Rename the variable
  dt_GEIy[, residualsavgGenderDiffNorm_GEI := residualsavgGenderDiffNorm]
  dt_GEIy$residualsavgGenderDiffNorm <- NULL

  # Gender Equality Index Residualised using Log GDP
  dt_GDPx <- Residualise(dt, var1 = "logAvgGDPpcNorm",
                             var2 = "GenderIndexNorm")
  dt_GDPy <- Residualise(dt, var1 = "logAvgGDPpcNorm",
                             var2 = "avgGenderDiffNorm")
  # Rename the variable
  dt_GDPy[, residualsavgGenderDiffNorm_GDP := residualsavgGenderDiffNorm]
  dt_GDPy$residualsavgGenderDiffNorm <- NULL

  # WEF Global Gender Gap Index Residualised using Log GDP
  dt_WEF <- Residualise(dt, var1 = "logAvgGDPpcNorm",
                            var2 = "ScoreWEFNorm")

  # UN Gender Equality Index Residualised using Log GDP
  dt_UN <- Residualise(dt, var1 = "logAvgGDPpcNorm",
                           var2 = "ValueUNNorm")

  # Ratio Female to Male Residualised using Log GDP
  dt_ratioLabor <- Residualise(dt, var1 = "logAvgGDPpcNorm",
                                   var2 = "avgRatioLaborNorm")
  # Time since Women's Suffrage Residualised using Log GDP
  dt_Date <- Residualise(dt, var1 = "logAvgGDPpcNorm",
                             var2 = "DateNorm")


  # Group the data tables into a single list
  dts <- list(dt_GEIx, dt_GEIy, dt_GDPx, dt_GDPy,
           dt_WEF, dt_UN, dt_ratioLabor, dt_Date)
  # Loop over the data table list to merge into a single data table
  for (data_table in dts) {
    dt <- SelectAndMerge(dt, data_table)
  }

  return(dt)
}
