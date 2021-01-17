CreateCompleteSummaryIndex <- function(dt_summary, dt_data) {
  # This function creates the data table containing all the information needed
  # to create the plots in the article (that is why the name is summary index).
  #
  # ARGS:
  # - dt_summary [data.table]  This data table has two columns: one for the
  #                            isocode of the country, and one for PC1 of the
  #                            gender differences on the preferences
  # - dt_data    [data.table]  The complete data table. This will be used to
  #                            merge all the useful information on a country
  #                            level to the data_summary
  #
  # RETURNS:
  # - dt_summary including all the gender index single indicators, the PC1 of
  #              the PCA on these gender index, and the normalized predictors
  #

  dt_summary[dt_data$data, `:=` (isocode = i.isocode,
                                 logAvgGDPpc = log(i.avgGDPpc)), on = "country"]
  dt_summary[dt_data$timeWomenSuff, Date := i.Date, on = "country"]
  dt_summary[dt_data$WEF, ScoreWEF := i.Score, on = "country"]
  dt_summary[dt_data$ratioLabor, avgRatioLabor := i.avgRatioLabor, on = "country"]
  dt_summary[dt_data$UNindex, ValueUN := i.Value, on = "country"]
  dt_summary <- merge(dt_summary, dt_data$world_area, by = "country")
  dt_summary[, avgGenderDiffNorm := (avgGenderDiff - min(avgGenderDiff)) /
                                      (max(avgGenderDiff) - min(avgGenderDiff))]

  # Perform the principal component analysis imputing missing values
  pcaColumns <- imputePCA(dt_summary[, c(5:8)], method = "EM", ncp = 1)
  pca <- prcomp(pcaColumns$completeObs, scale. = T)

  dt_summary[, GenderIndex := pca$x[, 1]]

  # Standardize the predictors
  dt_summary$logAvgGDPpcNorm   <- normalize(dt_summary$logAvgGDPpc)
  dt_summary$GenderIndexNorm   <- normalize(dt_summary$GenderIndex)
  dt_summary$ScoreWEFNorm      <- normalize(dt_summary$ScoreWEF)
  dt_summary$ValueUNNorm       <- normalize(dt_summary$ValueUN)
  dt_summary$DateNorm          <- normalize(dt_summary$Date)
  dt_summary$avgRatioLaborNorm <- normalize(dt_summary$avgRatioLabor)

  return(dt_summary)
}

