GenderIndexPCA <- function(data) {
  
  pcaColumns <- imputePCA(data, method = "EM", ncp = 1)
  pca <- prcomp(pcaColumns$completeObs, scale. = T)
  
  genderIndex <- pca$x[, 1]
  
  return(genderIndex)
}