Rescale <- function(variable) {
  # This function rescales the values of a vector or a list using the minimum 
  # and the maximum of the input vector or list
  # 
  # ARGS
  #   - variable   is the vector or list to rescale
  
  variableRescaled <- (variable - min(variable)) / (max(variable) - min(variable))
  
  return(variableRescaled)
}