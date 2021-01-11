AddResiduals <- function(dt) {

  ## ---------- Log GDP Residualized using Gender Equality Index ------------- #
  regressionGEIx <- lm(logAvgGDPpcNorm ~ GenderIndexNorm, data = dt)
  regressionGEIy <- lm(avgGenderDiffNorm ~ GenderIndexNorm, data = dt)
  # Use residuals
  dt$residualsGEIx <- residuals(regressionGEIx)
  dt$residualsGEIy <- residuals(regressionGEIy)

  ## ---------- Gender Equality Index Residualized using Log GDP ------------- #
  regressionGDPx <- lm(GenderIndexNorm ~ logAvgGDPpcNorm, data = dt)
  regressionGDPy <- lm(avgGenderDiffNorm ~ logAvgGDPpcNorm, data = dt)
  # Use residuals
  dt$residualsGDPx <- residuals(regressionGDPx)
  dt$residualsGDPy <- residuals(regressionGDPy)

  ## ------- WEF Global Gender Gap Index Residualized using Log GDP ---------- #
  regressionWEFx <- lm(ScoreWEFNorm ~ logAvgGDPpcNorm, data = dt)
  # Use residuals
  dt$residualsWEFx <- residuals(regressionWEFx)

  ## --------- UN Gender Equality Index Residualized using Log GDP ----------- #
  regressionUNx <- lm(-ValueUNNorm ~ logAvgGDPpcNorm, data = dt)
  # Use residuals
  dt$residualsUNx <- residuals(regressionUNx)

  ## ----------- Ratio Female to Male Residualized using Log GDP ------------- #
  regressionRatiox <- lm(avgRatioLaborNorm ~ logAvgGDPpcNorm, data = dt)
  # Use residuals
  dt$residualsRatiox <- residuals(regressionRatiox)

  ## -------- Time since Women's Suffrage Residualized using Log GDP --------- #
  regressionDatex <- lm(-DateNorm ~ logAvgGDPpcNorm, data = dt)
  # Use residuals
  dt$residualsDatex <- residuals(regressionDatex)


  return(dt)
}
