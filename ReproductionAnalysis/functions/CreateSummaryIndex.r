CreateSummaryIndex <- function(dt_summary, dt_data, rescale = TRUE) {
  # This function creates the data table containing all the information needed
  # to create the plots in the article (that is why the name is summary index).
  #
  # ARGS:
  # - dt_summary [data.table]  The data table to fill with extra information
  # - dt_data    [data.table]  The complete data table. This will be used to
  #                            merge all the useful information on a country
  #                            level to the data_summary
  # - rescale    [logical]     TRUE if the average gender differences should be 
  #                            rescaled; Default TRUE
  #
  # RETURNS:
  # - dt_summary
  #

  dt_summary[dt_data$data, `:=` (isocode = i.isocode,
                                 logAvgGDPpc = log(i.avgGDPpc)), on = "country"]
  dt_summary[dt_data$timeWomenSuff, Date := i.Date, on = "country"]
  dt_summary[dt_data$WEF, ScoreWEF := i.Score, on = "country"]
  dt_summary[dt_data$ratioLabor, avgRatioLabor := i.avgRatioLabor, on = "country"]
  dt_summary[dt_data$UNindex, ValueUN := i.Value, on = "country"]
  dt_summary <- merge(dt_summary, dt_data$world_area, by = "country")
  
  if (rescale) {
    dt_summary[, avgGenderDiffRescaled := Rescale(avgGenderDiff)]
  }

  return(dt_summary)
}

