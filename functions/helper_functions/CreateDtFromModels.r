CreateDtFromModels <- function(model) {
  # A model is passed to this function and a data table is extracted, taking the
  # coefficients of the models and creating the columns of the data table from
  # it, for each country.
  
  # Extract the coefficient names
  colNames <- names(coef(model[[1]]))
  dt       <- data.table()
  
  # For each country
  for(country in 1:length(model)) { 
    tmp <- data.table(country  = names(model)[country])
    for (coefficient in 1:length(colNames)) {
      tmp[, (colNames[[coefficient]]) := coef(model[[country]])[[coefficient]]]
    }
    dt <- rbind(dt, tmp)
  }
  
  return(dt)
}