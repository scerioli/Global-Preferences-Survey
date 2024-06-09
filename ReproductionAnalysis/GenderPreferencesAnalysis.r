# ============================================================================ #
#####################  ANALYSIS OF GLOBAL PREFERENCES  #########################
# ============================================================================ #


# ==================================== #
#### 0. LOAD LIBRARIES AND SET PATH ####
# ==================================== #
# Set the path
setwd("Global-Preferences-Survey/")

# Source helper functions
source("ReproductionAnalysis/functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "ReproductionAnalysis/functions/")
SourceFunctions(path = "ReproductionAnalysis/functions/helper_functions/")

# Load libraries
LoadRequiredLibraries()


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #
# Load the data
data_all <- LoadData()
data_all <- PrepareData(data_all)

# Standardize preferences at country level
data_all$data <- Standardize(data    = data_all$data, 
                             columns = c(5:10), 
                             level   = "country")
# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]


# =========================================================== #
#### 2. CREATE THE MODELS FOR PREFERENCES AT COUNTRY LEVEL ####
# =========================================================== #
# Model on country level of the preferences
models <- CreateModelsForPreferencesCountryLevel(dataComplete)
# Summarize the preferences for each country
dataCoeff <- SummaryCoeffPerPreferencePerCountry(models)
# Adjust data for plotting
dataCoeff[data_all$data, `:=` (isocode     = i.isocode,
                               logAvgGDPpc = log(i.avgGDPpc)),
          on = "country"]
setnames(dataCoeff, old = "gender1", new = "gender")


# ===================================== #
#### 3. PRINCIPAL COMPONENT ANALYSIS ####
# ===================================== #

#### 3.1 Create the Aggregated Gender Index ####
# -------------------------------------------- #
summaryIndex <- AvgGenderDiffPreferencesPCA(dataCoeff)
# Add the individual indexes for economic development and gender equality to 
# the summaryIndex variable
summaryIndex <- CreateSummaryIndex(summaryIndex, data_all)

#### 3.2 Create the Gender Equality Index ####
# ------------------------------------------ #
summaryIndex$GenderIndex <- GenderIndexPCA(summaryIndex[, c(5:8)])

#### 3.3 Standardize and rescale for histograms ####
# ------------------------------------------------ #
# Standardize the predictors (mean 0 and std dev 1)
summaryIndex <- Standardize(data    = summaryIndex, 
                            columns = c(2, 4:8, 13),
                            newName = TRUE)
# Set the Gender Index on a scale between 0 and 1
summaryIndex[, GenderIndexRescaled := Rescale(GenderIndex)]
# Prepare summary histograms
dataSummary <- SummaryHistograms(dataCoeff, summaryIndex)


# ============================== #
#### 4. CONDITIONAL ANALYSIS  ####
# ============================== #
# Conditional analysis using residuals
summaryIndex <- AddResiduals(summaryIndex)
# Invert trend for two variables
summaryIndex[, `:=` (ValueUNStd = -1 * ValueUNStd,
                     DateStd    = -1 * DateStd)]


# =============================== #
#### 5. SUPPLEMENTARY MATERIAL ####
# =============================== #

#### 5.1 Variable conditioning on separate economic measures ####
# ------------------------------------------------------------- #
colsToKeep_coeff <- c("gender", "preference", "country", "isocode", "logAvgGDPpc")
colsToKeep_summary <- c("GenderIndexRescaled", "country")

dataCoeff_summary <- merge(dataCoeff[, ..colsToKeep_coeff], 
                           summaryIndex[, ..colsToKeep_summary],
                           by = "country")
# Invert the trend of those preferences with opposite direction of the difference
dataCoeff_summary <- InvertPreference(dataCoeff_summary)
# Conditional analysis on single preferences using residuals
dataCoeff_summary <- AddResidualsSinglePreference(dataCoeff_summary)
# Use the original gender coefficient (not inverted) to calculate the mean for
# each preference, and the 95% confidence interval of the standard error
dataCoeff_summary[, meanGender := mean(genderOrig), by = "preference"]
dataCoeff_summary[, stdGender := 1.96 * sqrt(sd(genderOrig)^2 / uniqueN(country)), 
                  by = "preference"]

#### 5.2 Alternative models ####
# ---------------------------- #
modelsAlternative <- CreateAlternativeModels(dataComplete)
dataCoeffAlternative <- SummaryCoeffPerPreferencePerCountry(modelsAlternative)

# Adjust data for plotting
dataCoeffAlternative[data_all$data, `:=` (isocode     = i.isocode,
                                          logAvgGDPpc = log(i.avgGDPpc)),
                     on = "country"]
setnames(dataCoeffAlternative, old = "gender1", new = "gender")

# Invert the trend of those preferences with opposite direction of the difference
dataCoeffAlternative <- InvertPreference(dataCoeffAlternative)

#### 5.3 Gender differences standardize at global level ####
# -------------------------------------------------------- #
dataStdGlobal <- Standardize(data = data_all$data, 
                             columns = c(5:10))

# Use only the complete dataset
dataCompleteGlobal <- dataStdGlobal[complete.cases(dataStdGlobal)]

# Model on country level of the preferences
modelsGlobal <- CreateModelsForPreferencesCountryLevel(dataCompleteGlobal)

# Summarize the preferences for each country
dataCoeffGlobal <- SummaryCoeffPerPreferencePerCountry(modelsGlobal)

# Adjust data for plotting
dataCoeffGlobal[data_all$data, `:=` (isocode     = i.isocode,
                                     logAvgGDPpc = log(i.avgGDPpc)),
                on = "country"]
setnames(dataCoeffGlobal, old = "gender1", new = "gender")

# Invert the trend of those preferences with opposite direction of the difference
dataCoeffGlobal <- InvertPreference(dataCoeffGlobal)


#### 6. WRITE DATA SUMMARIES ####
# ----------------------------- #
# Write csv data summaries
fwrite(dataSummary,
       file = "ReproductionAnalysis/files/output/main_data_for_histograms.csv")
fwrite(summaryIndex,
       file = "ReproductionAnalysis/files/output/main_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
fwrite(dataCoeff_summary,
       file = "ReproductionAnalysis/files/output/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")
fwrite(dataCoeffGlobal[, c(1, 3, 7, 8, 9)],
       file = "ReproductionAnalysis/files/output/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficientsGlobal.csv")
fwrite(dataCoeffAlternative[, -2],
       file = "ReproductionAnalysis/files/output/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficients_alternativeModel.csv")

