AssignName <- function(var1, var2 = NULL, var3 = NULL, var4 = NULL, value) {
  # This function creates a new variable with the wished name associated.
  
  # Create the new variable
  if (!is.null(var2)) {
    newName <- assign(paste0(var1, "_", var2), value)
  } else if (!is.null(var3)) {
    newName <- assign(paste0(var1, "_", var2, "_", var3), value)
  } else if (!is.null(var4)) {
    newName <- assign(paste0(var1, "_", var2,  "_", var3, "_", var4), value)
  } else {
    newName <- assign(var1, value)
  }
  
  return(newName)
}