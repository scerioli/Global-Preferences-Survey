Standardize <- function(data, columns, level = NULL, newName = FALSE) {
  # This function takes the six economic preferences and standardizes them at
  # the level specified (for instance, country level or global level).
  # 
  # ARGS:
  #   - data [data.table]  input data containing the six economic preferences
  #   - columns [integer]  the vector of integers indicating the index of the 
  #                        columns of data to standardize
  #   - level [character]  the level at which to calculate the standardization.
  #                        Default is NULL and it means global level
  #   - newName [logical]  is the argument for specifying if the variable to
  #                        standardize must have a new name or be assigned to 
  #                        the same column
  
  columns <- names(data[, ..columns])
  
  if (!is.null(level)) {
    for (column in columns) {
      if (newName) {
        data[, paste0(((column)), "Std") := standardize(eval(as.name(column))), 
             by = level]
      }
      else {
        data[, ((column)) := standardize(eval(as.name(column))), by = level]
      }
    }
  } else {
    for (column in columns) {
      if (newName) {
        data[, paste0(((column)), "Std") := standardize(eval(as.name(column)))]
      }
      else {
        data[, ((column)) := standardize(eval(as.name(column)))]
      }
    }
  }
 
  return(data)
}  