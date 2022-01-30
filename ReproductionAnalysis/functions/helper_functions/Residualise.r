Residualise <- function(dt, var1, var2, robust = FALSE) {
  # This functions returns the residuals of two variables in a data table
  # saving them inside the same data table.
  # 
  # ARGS
  # - dt     [data table]  the data table where the variable to residualise are
  # - var1   [numeric]     the variable to be used for the residuals
  # - var2   [numeric]     the variable to be residualised
  # - robust [logical]     is the regression to be performed simple (OLS) or
  #                        robust. Default is FALSE
  # 
  # RETURN
  # - dt_complete [data table]  the complete dataset plus the new residualised
  #                             variable
  
  if (robust) {
    LinearRegression <- as.function(rlm)
  } else {
    LinearRegression <- as.function(lm)
  }
  
  # Use complete dataset for the model
  dt_complete <- dt[complete.cases(dt[, .(eval(as.name(var1)), 
                                          eval(as.name(var2)))])]
  regressionVar2 <- LinearRegression(eval(as.name(var2)) ~ eval(as.name(var1)), 
                                     data = dt_complete)
  # Add the residuals to the complete dataset
  dt_complete[, paste0("residuals", ((var2))) := residuals(regressionVar2)]
  
  return(dt_complete)
}
