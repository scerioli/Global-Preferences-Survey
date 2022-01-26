## ============================================================================ #
####  ANALYSIS OF GLOBAL PREFERENCES with ROBUST LINEAR REGRESSION and GDI  ####
# ============================================================================ #
# This analysis is divided into two main parts:
# 1. Additional data analysis, using the Gender Development Index instead of the
#    Gender Equality Index, as indicated in the technical notes of the United 
#    Nations Human Development Indicators (version of 2020):
#    http://hdr.undp.org/sites/default/files/hdr2020_technical_notes.pdf
# 2. Use of the robust linear regression instead of OLS, for the whole 
#    replication analysis and the new data added here.


#### 0. Load Libraries and Set Path ####
# ------------------------------------ #
# Set the path
setwd("~/Desktop/Projects/Global-Preferences-Survey/")

# Source helper functions
source("ReproductionAnalysis/functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "ReproductionAnalysis/functions/")
SourceFunctions(path = "ReproductionAnalysis/functions/helper_functions/")
SourceFunctions(path = "ExtendedAnalysis/functions/")

# Load libraries
LoadRequiredLibraries()


#### 1. Prepare the Data ####
# ------------------------- #
# Create the GDI index
GDI_index <- CreateGDIindex()

# Load the data
data_all <- LoadData()
data_all$GDI_index <- GDI_index
data_all <- PrepareData_new(data_all)

# Standardize preferences at country level
data_all$data <- Standardize(data    = data_all$data,
                             columns = c(5:10),
                             level   = "country")

# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]



# ===================== #
#### ADDITIONAL DATA ####
# ===================== #

#### 2. Create the Models ####
# -------------------------- #
# Model on country level of the preferences
models <- CreateModelsForPreferencesCountryLevel(dataComplete, robust = FALSE)

# Summarize the preferences for each country
dataCoeff <- SummaryCoeffPerPreferencePerCountry(models)

# Adjust data for plotting
dataCoeff[data_all$data, `:=` (isocode     = i.isocode,
                               logAvgGDPpc = log(i.avgGDPpc)),
          on = "country"]
setnames(dataCoeff, old = "gender1", new = "gender")


#### 3. Principal Component Analysis ####
# ------------------------------------- #
# PCA on the preferences
summaryIndex <- AvgGenderDiffPreferencesPCA(dataCoeff)

# Prepare summary index
summaryIndex <- CreateSummaryIndex_new(summaryIndex, data_all)

# Perform the principal component analysis imputing missing values
summaryIndex$GenderIndex <- GenderIndexPCA(summaryIndex[, c(5:8)])

# Standardize the predictors (mean 0 and std dev 1)
summaryIndex <- Standardize(data    = summaryIndex, 
                            columns = c(2, 4:9, 14),
                            newName = TRUE)
# Set the Gender Index on a scale between 0 and 1
summaryIndex[, GenderIndexRescaled := Rescale(GenderIndex)]

# Prepare summary histograms
dataSummary <- SummaryHistograms_new(dataCoeff, summaryIndex)


#### 4. Variables Conditioning  ####
# -------------------------------- #

#### 4.1 Variable conditioning on summarised gender differences ####
# Add residuals to the summary index
summaryIndex <- AddResiduals_new(summaryIndex, robust = FALSE)

# Invert trend for two variables
summaryIndex[, `:=` (ValueUNStd = -1 * ValueUNStd,
                     DateStd    = -1 * DateStd)]

#### 4.2 Variable conditioning on single preferences ####
colsToKeep_coeff <- c("gender", "preference", "country", "isocode", "logAvgGDPpc")
colsToKeep_summary <- c("GenderIndex", "GDI", "country")

dataCoeff_summary <- merge(dataCoeff[, ..colsToKeep_coeff], 
                           summaryIndex[, ..colsToKeep_summary],
                           by = "country")

# Invert the trend of those preferences with opposite direction of the difference
dataCoeff_summary <- InvertPreference(dataCoeff_summary)

dataCoeff_summary <- AddResidualsSinglePreference_new(dataCoeff_summary, 
                                                      robust = FALSE)

# Use the original gender coefficient (not inverted) to calculate the mean for
# each preference, and the 95% confidence interval of the standard error
dataCoeff_summary[, meanGender := mean(genderOrig), by = "preference"]
dataCoeff_summary[, stdGender := 1.96 * sqrt(sd(genderOrig)^2 / uniqueN(country)), 
                  by = "preference"]


#### 5. Write Data Summaries ####
# ----------------------------- #
# Write csv data summaries
fwrite(dataSummary,
       file = "ExtendedAnalysis/files/output/newData_data_for_histograms.csv")
fwrite(summaryIndex,
       file = "ExtendedAnalysis/files/output/newData_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
fwrite(dataCoeff_summary,
       file = "ExtendedAnalysis/files/output/newData_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")

rm(dataSummary)
rm(summaryIndex)
rm(dataCoeff_summary)
rm(models)



# ============================== #
#### ROBUST LINEAR REGRESSION ####
# ============================== #

#### 2. Create the Models ####
# -------------------------- #
# Model on country level of the preferences
models <- CreateModelsForPreferencesCountryLevel(dataComplete, robust = TRUE)

# Summarize the preferences for each country
dataCoeff <- SummaryCoeffPerPreferencePerCountry(models)

# Adjust data for plotting
dataCoeff[data_all$data, `:=` (isocode     = i.isocode,
                               logAvgGDPpc = log(i.avgGDPpc)),
          on = "country"]
setnames(dataCoeff, old = "gender1", new = "gender")


#### 3. Principal Component Analysis ####
# ------------------------------------- #
# PCA on the preferences
summaryIndex <- AvgGenderDiffPreferencesPCA(dataCoeff)

# Prepare summary index
summaryIndex <- CreateSummaryIndex_new(summaryIndex, data_all)

# Perform the principal component analysis imputing missing values
summaryIndex$GenderIndex <- GenderIndexPCA(summaryIndex[, c(5:8)])

# Standardize the predictors (mean 0 and std dev 1)
summaryIndex <- Standardize(data    = summaryIndex, 
                            columns = c(2, 4:9, 14),
                            newName = TRUE)
# Set the Gender Index on a scale between 0 and 1
summaryIndex[, GenderIndexRescaled := Rescale(GenderIndex)]

# Prepare summary histograms
dataSummary <- SummaryHistograms_new(dataCoeff, summaryIndex)


#### 4. Variables Conditioning  ####
# -------------------------------- #

#### 4.1 Variable conditioning on summarised gender differences ####
# Add residuals to the summary index
summaryIndex <- AddResiduals_new(summaryIndex, robust = TRUE)

# Invert trend for two variables
summaryIndex[, `:=` (ValueUNStd = -1 * ValueUNStd,
                     DateStd    = -1 * DateStd)]

#### 4.2 Variable conditioning on single preferences ####
colsToKeep_coeff <- c("gender", "preference", "country", "isocode", "logAvgGDPpc")
colsToKeep_summary <- c("GenderIndex", "GDI", "country")

dataCoeff_summary <- merge(dataCoeff[, ..colsToKeep_coeff], 
                           summaryIndex[, ..colsToKeep_summary],
                           by = "country")

# Invert the trend of those preferences with opposite direction of the difference
dataCoeff_summary <- InvertPreference(dataCoeff_summary)

dataCoeff_summary <- AddResidualsSinglePreference_new(dataCoeff_summary, 
                                                      robust = TRUE)

# Use the original gender coefficient (not inverted) to calculate the mean for
# each preference, and the 95% confidence interval of the standard error
dataCoeff_summary[, meanGender := mean(genderOrig), by = "preference"]
dataCoeff_summary[, stdGender := 1.96 * sqrt(sd(genderOrig)^2 / uniqueN(country)), 
                  by = "preference"]


#### 5. Write Data Summaries ####
# ----------------------------- #
# Write csv data summaries
fwrite(dataSummary,
       file = "ExtendedAnalysis/files/output/robust_data_for_histograms.csv")
fwrite(summaryIndex,
       file = "ExtendedAnalysis/files/output/robust_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
fwrite(dataCoeff_summary,
       file = "ExtendedAnalysis/files/output/robust_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")
