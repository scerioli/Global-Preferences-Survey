Standardize <- function(data, level) {
  # This function takes the six economic preferences and standardizes them at
  # the level specified (for instance, country level or global level).
  # 
  # ARGS:
  #   - data [data.table]  input data containing the six economic preferences
  #   - level [character]  the level at which to calculate the standardization
  
  data[, altruism := standardize(altruism), by = level]
  data[, posrecip := standardize(posrecip), by = level]
  data[, negrecip := standardize(negrecip), by = level]
  data[, patience := standardize(patience), by = level]
  data[, risktaking := standardize(risktaking), by = level]
  data[, trust := standardize(trust), by = level]
  
}  