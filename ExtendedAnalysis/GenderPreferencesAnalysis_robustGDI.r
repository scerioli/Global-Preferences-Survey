## ============================================================================ #
####  ANALYSIS OF GLOBAL PREFERENCES with ROBUST LINEAR REGRESSION and GDI  ####
# ============================================================================ #
# Analysing the data using a robust linear regression instead of simple OLS, and
# adding a different index for the Gender Inequality, that is the Gender 
# Development Index as indicated in the technical notes of the United Nations
# Human Development Indicators (version of 2020):
# http://hdr.undp.org/sites/default/files/hdr2020_technical_notes.pdf


# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("~/Desktop/Projects/Global-Preferences-Survey/")

# Source helper functions
source("ReproductionAnalysis/functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "ReproductionAnalysis/functions/")
SourceFunctions(path = "ReproductionAnalysis/functions/helper_functions/")
SourceFunctions(path = "ExtendedAnalysis/functions/")

# Load libraries
LoadRequiredLibraries_new()

# Create the GDI index
GDI_index <- CreateGDIindex()

# Load the data
data_all <- LoadData()
data_all$GDI_index <- GDI_index


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

data_all <- PrepareData_new(data_all)

# Standardize preferences at country level
data_all$data <- Standardize(data    = data_all$data,
                             columns = c(5:10),
                             level   = "country")

# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]


# ========================== #
#### 2. CREATE THE MODELS ####
# ========================== #

# Model on country level of the preferences
models <- CreateModelsForPreferencesCountryLevel_robust(dataComplete)

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

# PCA on the preferences
summaryIndex <- AvgGenderDiffPreferencesPCA(dataCoeff)

# Prepare summary index
summaryIndex <- CreateSummaryIndex_new(summaryIndex, data_all)

# Perform the principal component analysis imputing missing values
summaryIndex$GenderIndex <- GenderIndexPCA(summaryIndex[, c(5:8)])

# Standardize the predictors (mean 0 and std dev 1)
summaryIndex <- Standardize(data    = summaryIndex, 
                            columns = c(4:9, 14),
                            newName = TRUE)
# Set the Gender Index on a scale between 0 and 1
summaryIndex[, GenderIndexRescaled := Rescale(GenderIndex)]

# Prepare summary histograms
dataSummary <- SummaryHistograms_new(dataCoeff, summaryIndex)


# ================================ #
#### 4. VARIABLES CONDITIONING  ####
# ================================ #

# Add residuals to the summary index
summaryIndex <- AddResiduals_new(summaryIndex)

# Invert trend for two variables
summaryIndex[, `:=` (ValueUNStd = -1 * ValueUNStd,
                     DateStd    = -1 * DateStd)]


# =============================== #
#### 5. SUPPLEMENTARY MATERIAL ####
# =============================== #

colsToKeep_coeff <- c("gender", "preference", "country", "isocode", "logAvgGDPpc")

colsToKeep_summary <- c("GenderIndex",
                        "GDI",
                        "country")
dataCoeff_summary <- merge(dataCoeff[, ..colsToKeep_coeff], 
                           summaryIndex[, ..colsToKeep_summary],
                           by = "country")

# Invert the trend of those preferences with opposite direction of the difference
dataCoeff_summary <- InvertPreference(dataCoeff_summary)

dataCoeff_summary <- AddResidualsSinglePreference_robust(dataCoeff_summary)

# Use the original gender coefficient (not inverted) to calculate the mean for
# each preference, and the 95% confidence interval of the standard error
dataCoeff_summary[, meanGender := mean(genderOrig), by = "preference"]
dataCoeff_summary[, stdGender := 1.96 * sqrt(sd(genderOrig)^2 / uniqueN(country)), 
                  by = "preference"]


# ============================= #
#### 6. WRITE DATA SUMMARIES ####
# ============================= #

# Write csv data summaries
fwrite(dataSummary,
       file = "ExtendedAnalysis/files/output/main_data_for_histograms.csv")
fwrite(summaryIndex,
       file = "ExtendedAnalysis/files/output/main_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
fwrite(dataCoeff_summary,
       file = "ExtendedAnalysis/files/output/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")