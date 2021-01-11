CreateCompleteSummaryIndex <- function(dt_pca, data) {
  # This function creates the data table containing all the information needed
  # to create the plots in the article (that is why the name is summary index)

  dt_pca[data_all$data, `:=` (isocode = i.isocode,
                              logAvgGDPpc = log(i.avgGDPpc)), on = "country"]
  dt_pca[data_all$timeWomenSuff, Date := i.Date, on = "country"]
  dt_pca[data_all$WEF, ScoreWEF := i.Score, on = "country"]
  dt_pca[data_all$ratioLabor, avgRatioLabor := i.avgRatioLabor, on = "country"]
  dt_pca[data_all$UNindex, ValueUN := i.Value, on = "country"]
  dt_pca <- merge(dt_pca, data_all$world_area, by = "country")
  dt_pca[, avgGenderDiffNorm := (avgGenderDiff - min(avgGenderDiff)) /
                                  (max(avgGenderDiff) - min(avgGenderDiff))]

  # Perform the principal component analysis
  dt_pca <- dt_pca[complete.cases(dt_pca)]
  pca <- prcomp(dt_pca[, c(5:8)], scale. = T)

  dt_pca[, GenderIndex := pca$x[, 1]]

  # Standardize the predictors
  dt_pca$logAvgGDPpcNorm <- normalize(dt_pca$logAvgGDPpc)
  dt_pca$GenderIndexNorm <- normalize(dt_pca$GenderIndex)
  dt_pca$ScoreWEFNorm <- normalize(dt_pca$ScoreWEF)
  dt_pca$ValueUNNorm <- normalize(dt_pca$ValueUN)
  dt_pca$DateNorm <- normalize(dt_pca$Date)
  dt_pca$avgRatioLaborNorm <- normalize(dt_pca$avgRatioLabor)

  return(dt_pca)
}
