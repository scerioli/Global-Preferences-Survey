GenderIndex <- function(data_all) {
  
  summaryGenderIndex <- data.table(country = unique(data_all$data$country),
                                   isocode = unique(data_all$data$isocode))
  
  summaryGenderIndex <- merge(summaryGenderIndex, data_all$timeWomenSuff, by = "country") 
  summaryGenderIndex <- merge(summaryGenderIndex, data_all$WEF, by = "country")
  summaryGenderIndex <- merge(summaryGenderIndex, data_all$ratioLabor, by = "country")
  summaryGenderIndex <- summaryGenderIndex[, -4]
  summaryGenderIndex <- merge(summaryGenderIndex, data_all$UNindex, by = "country")
  
  # Create a complete dataset (no NAs)
  genderIndexComplete <- summaryGenderIndex[complete.cases(summaryGenderIndex)]
  genderIndexComplete[, Value := as.numeric(Value)]
  
  # Perform the principal component analysis
  pca <- prcomp(genderIndexComplete[, c(3:6)], scale. = T)
  
  genderIndexComplete[, GenderIndex := pca$x[, 1]]
  genderIndexComplete[summaryIndex, `:=` (avgGenderDiff = i.avgGenderDiff,
                                          avgGenderDiffNorm = i.avgGenderDiffNorm),
                      on = "country"]
  
  genderIndexComplete[summaryIndex, region := region, on = "country"] 
  
  return(genderIndexComplete)
}