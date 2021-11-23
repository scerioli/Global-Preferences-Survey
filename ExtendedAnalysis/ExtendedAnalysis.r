###########################  EXTENDED ANALYSIS  ################################

# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("/Users/sara/Desktop/Projects/Global-Preferences-Survey/ReproductionAnalysis/")

# Source helper functions
source("functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "functions/")
SourceFunctions(path = "functions/helper_functions/")

# Load libraries
LoadRequiredLibraries()

# Load the data
# dataSummary <- fread("files/output/main_data_for_histograms.csv")
# summaryIndex <- fread("files/output/main_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
# dataCoeff_summary <- fread("files/output/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")
# dataCoeffGlobal <- fread("files/output/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficientsGlobal.csv")
# dataCoeffAlternative <- fread("files/output/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficients_alternativeModel.csv")

# Load the data
data_all <- LoadData()
