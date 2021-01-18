Residualise <- function(dt, var1, var2) {
  # Use complete dataset for the model
  dt_complete <- dt[complete.cases(dt[, eval(as.name(var2))])]
  regressionVar2 <- lm(eval(as.name(var2)) ~ eval(as.name(var1)), data = dt)
  # Add the residuals to the complete dataset
  dt_complete[, paste0("residuals", ((var2))) := residuals(regressionVar2)]

  return(dt_complete)
}
