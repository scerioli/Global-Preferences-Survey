CompareMissingNAsWithImputingNAs <- function(dt_summary) {

  # Remove all the rows related to the Gender Index
  dt_summary <- summaryIndex[, 1:12]

  # Perform PCA imputing missing values
  pcaColumns <- imputePCA(dt_summary[, c(5:8)], method = "EM", ncp = 1)
  pcaImputed <- prcomp(pcaColumns$completeObs, scale. = T)

  # Perform PCA removing missing values
  dt_pca <- dt_summary[complete.cases(dt_summary)]
  pcaMissing <- prcomp(dt_pca[, 5:8], scale. = T)

  # Compare with BEST the two distributions generated from the imputing and from
  # the excluding the missing values
  comparePCA <- BESTmcmc(pcaImpute$x[, 1], pcaMissing$x[, 1])

  plotAll(comparePCA)
}
