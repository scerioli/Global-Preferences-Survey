SummaryHistograms <- function(dt, summ) {
  # This function creates the data that will be plot as histograms

  data <- dt[, .(logAvgGDPpc, gender, preference, country)]
  data[summ, genderIndex := i.GenderIndex, on = "country"]

  # Summary for the GDP
  data[logAvgGDPpc <= quantile(logAvgGDPpc, 0.25, na.rm = TRUE),
       GDPquant := 1]
  data[is.na(GDPquant) & logAvgGDPpc <= quantile(logAvgGDPpc, 0.50, na.rm = TRUE),
       GDPquant := 2]
  data[is.na(GDPquant) & logAvgGDPpc <= quantile(logAvgGDPpc, 0.75, na.rm = TRUE),
       GDPquant := 3]
  data[is.na(GDPquant),
       GDPquant := 4]
  # Summary for the Gender equality index
  data[genderIndex <= quantile(genderIndex, 0.25, na.rm = TRUE),
       GEIquant := 1]
  data[is.na(GEIquant) & genderIndex <= quantile(genderIndex, 0.50, na.rm = TRUE),
       GEIquant := 2]
  data[is.na(GEIquant) & genderIndex <= quantile(genderIndex, 0.75, na.rm = TRUE),
       GEIquant := 3]
  data[is.na(GEIquant),
       GEIquant := 4]

  # Assign mean of the bin for GDP and GEI
  for (i in 1:length(data$GEIquant)) {
    data[GDPquant == i, meanGenderGDP := mean(gender, na.rm = T), by = "preference"]
    data[GEIquant == i, meanGenderGEI := mean(gender, na.rm = T), by = "preference"]
  }

  data <- unique(data[, c(-1, -2, -4, -5)])

  data[preference %in% c("negrecip", "risktaking", "patience"), 
       `:=` (meanGenderGDP = -1 * meanGenderGDP,
             meanGenderGEI = -1 * meanGenderGEI)]


  return(data)
}
