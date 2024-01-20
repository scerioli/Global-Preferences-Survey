## =========================================================================== #
####  ANALYSIS OF GLOBAL PREFERENCES with ROBUST LINEAR REGRESSION and GDI  ####
# ============================================================================ #
# This analysis is the extended study done by using additional (using the Gender 
# Development Index), and making use of the robust linear regression instead of 
# OLS for the whole replication analysis.


# ===================================== #
#### 0. LOAD LIBRARIES AND SETH PATH ####
# ===================================== #
# Set the path
setwd("Global-Preferences-Survey/")

# Source helper functions
source("ReproductionAnalysis/functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "ReproductionAnalysis/functions/")
SourceFunctions(path = "ReproductionAnalysis/functions/helper_functions/")
SourceFunctions(path = "ExtendedAnalysis/functions/")

# Load libraries
LoadRequiredLibraries()


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

# 1.1 Add the new data set
# ---------------------- #
GDI_index <- CreateGDIindex()

# 1.2 Load the data
# --------------- #
data_all <- LoadData()
data_all$GDI_index <- GDI_index
data_all <- PrepareData_new(data_all)

# 1.3 Standardize preferences at country level
# ------------------------------------------ #
data_all$data <- Standardize(data    = data_all$data,
                             columns = c(5:10),
                             level   = "country")
# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]


# ========================== #
#### 2. CREATE THE MODELS ####
# ========================== #
# Model on country level of the preferences
models <- CreateModelsForPreferencesCountryLevel(dataComplete, robust = TRUE)
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
summaryIndex <- CreateSummaryIndex_new(summaryIndex, data_all)

#### 3.2 Create the Gender Equality Index ####
# ------------------------------------------ #
summaryIndex$GenderIndex <- GenderIndexPCA(summaryIndex[, c(5:8)])

# Standardize the predictors (mean 0 and std dev 1)
summaryIndex <- Standardize(data    = summaryIndex, 
                            columns = c(2, 4:9, 14),
                            newName = TRUE)

#### 3.3 Standardize and rescale for histograms ####
# ------------------------------------------------ #
# Set the Gender Index on a scale between 0 and 1
summaryIndex[, GenderIndexRescaled := Rescale(GenderIndex)]
# Prepare summary histograms
dataSummary <- SummaryHistograms_new(dataCoeff, summaryIndex)


# ============================= #
#### 4. CONDITIONAL ANALYSIS ####
# ============================= #

#### 4.1 Variable conditioning on aggregated gender differences ####
# ---------------------------------------------------------------- #
# Add residuals to the summary index
summaryIndex <- AddResiduals_new(summaryIndex, robust = TRUE)
# Invert trend for two variables
summaryIndex[, `:=` (ValueUNStd = -1 * ValueUNStd,
                     DateStd    = -1 * DateStd)]

#### 4.2 Variable conditioning on separate economic preferences ####
# ---------------------------------------------------------------- #
colsToKeep_coeff <- c("gender", "preference", "country", "isocode")
colsToKeep_summary <- c("logAvgGDPpcStd", "GenderIndexRescaled", "GDIStd", 
                        "ScoreWEFStd", "ValueUNStd", "country")

dataCoeff_summary <- merge(dataCoeff[, ..colsToKeep_coeff], 
                           summaryIndex[, ..colsToKeep_summary],
                           by = "country")

# Invert the trend of those preferences with opposite direction of the difference
dataCoeff_summary <- InvertPreference(dataCoeff_summary)
# Add residuals of separate economic measures to the summary index
dataCoeff_summary <- AddResidualsSinglePreference_new(dataCoeff_summary, 
                                                      robust = TRUE)
# Use the original gender coefficient (not inverted) to calculate the mean for
# each preference, and the 95% confidence interval of the standard error
dataCoeff_summary[, meanGender := mean(genderOrig), by = "preference"]
dataCoeff_summary[, stdGender := 1.96 * sqrt(sd(genderOrig)^2 / uniqueN(country)), 
                  by = "preference"]


# ============================= #
#### 5. WRITE DATA SUMMARIES ####
# ============================= #
# Write csv data summaries
fwrite(dataSummary,
       file = "ExtendedAnalysis/files/output/robust_data_for_histograms.csv")
fwrite(summaryIndex,
       file = "ExtendedAnalysis/files/output/robust_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
fwrite(dataCoeff_summary,
       file = "ExtendedAnalysis/files/output/robust_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")
