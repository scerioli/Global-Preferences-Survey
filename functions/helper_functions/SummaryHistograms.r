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

  # Assign mean of the bin for GDP
  data[GDPquant == 1, meanGender := mean(gender, na.rm = T), by = "preference"]
  data[GDPquant == 2, meanGender := mean(gender, na.rm = T), by = "preference"]
  data[GDPquant == 3, meanGender := mean(gender, na.rm = T), by = "preference"]
  data[GDPquant == 4, meanGender := mean(gender, na.rm = T), by = "preference"]
  # Assign mean of the bin for GEI
  data[GEIquant == 1, meanGenderGEI := mean(gender, na.rm = T), by = "preference"]
  data[GEIquant == 2, meanGenderGEI := mean(gender, na.rm = T), by = "preference"]
  data[GEIquant == 3, meanGenderGEI := mean(gender, na.rm = T), by = "preference"]
  data[GEIquant == 4, meanGenderGEI := mean(gender, na.rm = T), by = "preference"]

  data <- unique(data[, c(-1, -2, -4, -5)])

  data[preference == "negrecip", meanGender := -1 * meanGender]
  data[preference == "risktaking", meanGender := -1 * meanGender]
  data[preference == "patience", meanGender := -1 * meanGender]

  data[preference == "negrecip", meanGenderGEI := -1 * meanGenderGEI]
  data[preference == "risktaking", meanGenderGEI := -1 * meanGenderGEI]
  data[preference == "patience", meanGenderGEI := -1 * meanGenderGEI]

  return(data)
}
