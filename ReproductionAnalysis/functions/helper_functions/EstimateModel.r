EstimateModel <- function(dat, formula, var = NULL, robust = FALSE) {
  # This function extracts the important parameters from the model(s). 
  # If var is given, it means that there is the need to make the model run on 
  # the same variable grouped by different rows.
  #
  # ARGS
  # - dat     [data table] is the data we are giving to the model
  # - formula [character]  the formula binding the variables in the model
  # - var     [character]  is the column name of the variable we want to put
  #                        in the model to group by. Default is NULL
  # - robust  [boolean]    is indicating if the linear regression to be 
  #                        performed is simple (OLS) or robust. Default is FALSE
  #
  # RETURN
  # - mod     [list]       a list containing the model parameters
  
  if (robust) {
    LinearRegression <- as.function(rlm)
  } else {
    LinearRegression <- as.function(lm)
  }
  
  if (!is.null(var)) {
    mod <- dlply(dat, var, function(dt)
      LinearRegression(eval(as.formula(formula)), data = dt))
    
  } else {
    mod <- LinearRegression(eval(as.formula(formula)), data = dat)
  }
  
  
  return(mod)
}
