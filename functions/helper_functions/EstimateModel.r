EstimateModel <- function(dat, formula, var = NULL) {
  # This function has the purpose to extract the important parameters from the
  # model(s). If var is given, it means that there is the need to make the
  # model run on the same variable grouped by different rows.
  # 
  # ARGS
  # - dat      [data table] is the data we are giving to the model
  # - formula  [character]  the formula binding the variables in the model
  # - var      [character]  is the column name of the variable we want to put
  #                         in the model to group by
  #                      
  # RETURN
  # - mod      [list]       a list containing the model parameters
  
  
  if (!is.null(var)) {
    mod <- dlply(dat, var, function(dt) 
      lm(eval(as.formula(formula)), data = dt))
    
  } else {
    mod <- lm(eval(as.formula(formula)), data = dat)
  }
  
  return(mod)
}