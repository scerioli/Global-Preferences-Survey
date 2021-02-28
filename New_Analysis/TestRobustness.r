#####################  ANALYSIS OF ROBUSTNESS  #########################

# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("~/Desktop/Projects/Global-Preferences-Survey/")

# Source helper functions
source("functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "functions/")
SourceFunctions(path = "functions/helper_functions/")

# Load libraries
LoadRequiredLibraries()
library(caret)

# Load the data
dataSummary       <- fread("files/output/main_data_for_histograms.csv")
summaryIndex      <- fread("files/output/main_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
dataCoeff_summary <- fread("files/output/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")
dataCoeffGlobal   <- fread("files/output/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficientsGlobal.csv")
dataCoeffAlternative <- fread("files/output/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficients_alternativeModel.csv")
# Select the directory
# path_dir     <- "files/input/"
# path_GPS_dir <- paste0(path_dir, "GPS_Dataset/GPS_dataset_individual_level/")
#
# # Load the data
# world_area <- fread(file = paste0(path_dir, "world_area.txt"), sep = ",")


# ========================== #
#### 1. CROSS VALIDATION ####
# ========================= #

#### 1.1 Random Countries ####

# Set the seed for reproducible sampling
set.seed(123)

# Create test and training dataset
randomSample <- createDataPartition(y = summaryIndex$avgGenderDiffRescaled,
                                    p = 0.9, list = FALSE)

# Generate the training dataset
trainingData <- summaryIndex[randomSample]
# Generate the test dataset
testData <- summaryIndex[-randomSample]

# Building the model
modelRandom <- lm(avgGenderDiffRescaled ~ GenderIndexRescaled, data = trainingData)

# Make the predictions
predictionsRandom <- predict(modelRandom, testData)

# Model performance metrics
performanceRandom <- data.table(R2   = R2(predictionsRandom, testData$avgGenderDiffRescaled),
                                RMSE = RMSE(predictionsRandom, testData$avgGenderDiffRescaled),
                                MAE  = MAE(predictionsRandom, testData$avgGenderDiffRescaled))


#### 1.2 Selected Countries ####
performance <- c()

for (area in unique(summaryIndex$region)) {
  regionName <- gsub(" ", "", area)
  # Select test dataset
  assign(paste0("test", regionName), summaryIndex[region == area])
  # Create training dataset
  assign(paste0("exclude", regionName), summaryIndex[region != area])

  # Building the model
  assign(paste0("model",  regionName),
         lm(avgGenderDiffRescaled ~ GenderIndexRescaled,
            data = eval(as.name(paste0("exclude", regionName)))))

  # Make the predictions
  assign(paste0("predictions", regionName),
         predict(eval(as.name(paste0("model", regionName))),
                 eval(as.name(paste0("test", regionName)))))

  # Model performance metrics
  assign(paste0("performance", regionName),
         data.table(R2   = R2(eval(as.name(paste0("predictions", regionName))),
                              eval(as.name(paste0("test", regionName)))$avgGenderDiffRescaled),
                    RMSE = RMSE(eval(as.name(paste0("predictions", regionName))),
                                eval(as.name(paste0("test", regionName)))$avgGenderDiffRescaled),
                    MAE  = MAE(eval(as.name(paste0("predictions", regionName))),
                               eval(as.name(paste0("test", regionName)))$avgGenderDiffRescaled),
                    NCountries = nrow(summaryIndex[region == area]),
                    region = area))
  performance <- rbind(eval(as.name(paste0("performance", regionName))),
                       performance)

}

PlotSummary(data = summaryIndex[region != "Middle East and North Africa"],
            var1 = "GenderIndexRescaled",
            var2 = "avgGenderDiffRescaled",
            labs = c("Log GDP p/c",
                     "Average Gender Differences (Index)"),
            display = TRUE,
            fill = "region"
           # save = "plots/main_Fig1B.png"
)

modelAll <- lm(avgGenderDiffRescaled ~ GenderIndexRescaled, data = summaryIndex)



relevantCoefficients  <- data.table()

# Loop over the model and extract the coefficients associated to each
# preference and each country
for (i in 1:length(models)) {
  dt_tmp <- ExtractMostRelevantCoefficient(models[[i]])
  dt_tmp[, preference := names(models)[[i]]]

  relevantCoefficients <- rbind(dt_tmp, relevantCoefficients)
}

relevantCoefficients <- merge(relevantCoefficients,
                              summaryIndex[, .(logAvgGDPpc = unique(logAvgGDPpc),
                                               country = unique(country))],
                              by = "country")

# Note that NA here represents those countries where no coefficient was
# significantly different from 0
ggplot(relevantCoefficients) +
  geom_histogram(aes(x = name, fill = name), stat = "count") +
  facet_wrap(~ preference)

# Plot the main coefficients ordered by logGDPpc
relevantCoefficients %>%
  group_by(preference) %>%
  mutate(preference = as.factor(preference),
         country = reorder_within(country, logAvgGDPpc, preference)) %>%
  ggplot() +
  geom_hline(yintercept = 0) +
  geom_point(aes(x = country, y = mainCoef, color = name)) +
  scale_color_brewer(palette = "Set1")  +
  facet_wrap(~ preference, scales = "free") +
  scale_x_reordered() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


# Plot the main coefficients ordered by logGDPpc
dataCoeff_summary %>%
  group_by(preference) %>%
  mutate(preference = as.factor(preference),
         country = reorder_within(country, logAvgGDPpc, preference)) %>%
  ggplot() +
  geom_hline(yintercept = 0) +
  geom_point(aes(x = country, y = gender)) +
  scale_color_brewer(palette = "Set1")  +
  facet_wrap(~ preference, scales = "free") +
  scale_x_reordered() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


