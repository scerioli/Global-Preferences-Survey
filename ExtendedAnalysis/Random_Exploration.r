setwd("../Desktop/Private Sara/Global-Preferences-Survey/")

source("ReproductionAnalysis/functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "ReproductionAnalysis/functions/")
SourceFunctions(path = "ReproductionAnalysis/functions/helper_functions/")
SourceFunctions(path = "ExtendedAnalysis/functions/")

# Load libraries
LoadRequiredLibraries()
library(effects)

data_all <- LoadData()

data_all$data

# Data exploration
dt <- data_all$data
dt[country == "United States", country := "USA"]
dt[country == "United Kingdom", country := "UK"]
dt[country == "Bosnia Herzegovina", country := "Bosnia and Herzegovina"]

dt_lan <- dt[, .N, by = c("language", "country")]

dt_lan[, NSpeakers := N]

world_map <- map_data("world")

maps <- map_data("world", region = unique(dt$country), subregion = unique(dt$region))
maps$country <- maps$region
maps$region <- maps$subregion

dt2 <- unique(dt[, .(avgAge = mean(age, na.rm = TRUE), 
              medianAge = median(age, na.rm = TRUE)), by = "country"])

dt3 <- left_join(maps, dt2, by = c("country"))

# Plotting the average age of the interviewed people in each country
ggplot() +
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), 
               color = "white", fill = "lightgrey") +
  geom_polygon(data = dt3, aes(x = long, y = lat, group = group, 
                                  fill = as.numeric(avgAge)), color = "white") +
  scale_fill_viridis_c(option = "C") +
  theme_void() +
  labs(fill = "Avg Age")

# Plotting the median age of the interviewed people in each country
ggplot() +
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), 
               color = "white", fill = "lightgrey") +
  geom_polygon(data = dt3, aes(x = long, y = lat, group = group, 
                               fill = as.numeric(medianAge)), color = "white") +
  scale_fill_viridis_c(option = "C") +
  theme_void() +
  labs(fill = "Median Age")

# Age doesn't play a role here because when we take the coefficient for female/male,
# we are checking the "pure effect" of being male vs female. It is of course true
# that a low representation of the ages could introduce a bias.

GDI_index <- CreateGDIindex()
# Load and prepare the data
data_all$GDI_index <- GDI_index
data_all <- PrepareData_new(data_all)
data_all$data <- Standardize(data    = data_all$data,
                             columns = c(5:10),
                             level   = "country")
dataComplete <- data_all$data[complete.cases(data_all$data)]

# Create the models
models <- CreateModelsForPreferencesCountryLevel(dataComplete, robust = FALSE)
dataCoeff <- SummaryCoeffPerPreferencePerCountry(models)
dataCoeff[data_all$data, `:=` (isocode     = i.isocode,
                               logAvgGDPpc = log(i.avgGDPpc)),
          on = "country"]
setnames(dataCoeff, old = "gender1", new = "gender")

# PCA on the preferences
summaryIndex <- AvgGenderDiffPreferencesPCA(dataCoeff)
summaryIndex <- CreateSummaryIndex_new(summaryIndex, data_all)
summaryIndex$GenderIndex <- GenderIndexPCA(summaryIndex[, c(5:8)])
summaryIndex <- Standardize(data    = summaryIndex, 
                            columns = c(2, 4:9, 14),
                            newName = TRUE)
summaryIndex[, GenderIndexRescaled := Rescale(GenderIndex)]

# Gender Inequality Index of UNDP has opposite meaning, so let's invert it
summaryIndex[, ValueUNStd := -ValueUNStd]

# What if we look at the median age in the different countries plotted with the
# log GDP vs gender differences...?
summaryIndex[dt2, medianAge := i.medianAge, on = "country"]

ggplot(summaryIndex) +
  geom_point(aes(x = logAvgGDPpcStd, y = avgGenderDiffStd, 
                 col = as.numeric(medianAge)), size = 3)

ggplot(summaryIndex) +
  geom_point(aes(x = ScoreWEFStd, y = avgGenderDiffStd, 
                 col = as.numeric(medianAge)), size = 3)

# I am wondering if we should have a further look into the data set to understand
# if we have any sample bias in terms of age. If we are controlling for the age
# but we have not enough representatives for that age group, is it fair to say
# that we have controlled for age? Can we say we see some effect only because some
# age groups were not well-represented?