CreateHeatMap <- function(dataset, varX, varY, varZ) {
  # Create a heat map starting from some of the columns of an initial dataset
  
  # Prepare heat map base
  nSample <- dataset[, .N, by = c(eval(as.character(varX)),
                                  eval(as.character(varZ)))]
  
  x <- unique(dataset[, eval(as.name(varX))])
  y <- min(dataset[, eval(as.name(varY))]):max(dataset[, eval(as.name(varY))])
  z <- unique(dataset[, eval(as.name(varZ))])
  dt_heatMap <- expand.grid(X = x, Y = y, Z = z)
  
  dt_heatMap <- merge(dt_heatMap, 
                      dataset[, .N, by = c(eval(as.character(varX)),
                                           eval(as.character(varY)),
                                           eval(as.character(varZ)))],
                      by.x = c("X", "Y", "Z"), 
                      by.y = c(eval(as.character(varX)),
                               eval(as.character(varY)),
                               eval(as.character(varZ)))
  )
  # Make it a data table for comfortable use
  setDT(dt_heatMap)
  # Merge with sample
  dt_heatMap <- merge(dt_heatMap, nSample, 
                      by.x = c("X", "Z"), 
                      by.y = c(eval(as.character(varX)),
                               eval(as.character(varZ)))
  )
  setnames(dt_heatMap, c("N.x", "N.y"), c("N", "total"))
  
  dt_heatMap[, fracN  := N / total, by = c("X", "Z")]
  dt_heatMap[, sigmaN := sqrt(N) / total / 2, by = c("X", "Y", "Z")]
  # Set the variables to the correct format
  dt_heatMap[, `:=` (Y     = as.factor(Y), 
                     X     = as.character(X), 
                     fracN = as.numeric(fracN),
                     sigmaN = as.numeric(sigmaN),
                     Z     = as.factor(Z))]
  dt_heatMap[, `:=` (N = NULL, total = NULL)]
  # Fill the missing data
  for(idx in unique(dt_heatMap$X)) {
    for (idy in unique(dt_heatMap$Y)) {
      for (idz in unique(dt_heatMap$Z)) {
        if (nrow(dt_heatMap[X == idx & Y == idy & Z == idz]) == 0) {
          newRow <- data.table(Y = as.numeric(idy), 
                               X = as.character(idx), 
                               fracN = as.numeric(0),
                               sigmaN = as.numeric(0),
                               Z = as.factor(idz))
          dt_heatMap <- rbind(dt_heatMap, newRow)
        }
      }
    }
  }
  
  return(dt_heatMap)
}
