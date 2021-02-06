Residualise <- function(dt, var1, var2) {
  # This functions returns the residuals of two variables in a data table
  # saving them inside the same data table.
  # 
  # ARGS
  # - dt     [data table]  the data table where the variable to residualise are
  # - var1   [numeric]     the variable to be used for the residuals
  # - var2   [numeric]     the variable to be residualised
  # 
  # RETURN
  # - dt_complete [data table]  the complete dataset plus the new residualised
  #                             variable
  
  # Use complete dataset for the model
  dt_complete <- dt[complete.cases(dt[, eval(as.name(var2))])]
  regressionVar2 <- lm(eval(as.name(var2)) ~ eval(as.name(var1)), data = dt)
  # Add the residuals to the complete dataset
  dt_complete[, paste0("residuals", ((var2))) := residuals(regressionVar2)]

  return(dt_complete)
}
