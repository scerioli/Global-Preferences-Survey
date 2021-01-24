#####################  ANALYSIS OF GLOBAL PREFERENCES  #########################

# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("/Users/sara/Desktop/Projects/Global_Preferences_Survey/")

# Source helper functions
source("functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "functions/")
SourceFunctions(path = "functions/helper_functions/")

# Load libraries
LoadRequiredLibraries()

# Load the data
data_all <- LoadData()


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

data_all <- PrepareData(data_all)

# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]


# ========================== #
#### 2. CREATE THE MODELS ####
# ========================== #

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

# PCA on the preferences
summaryIndex <- AvgGenderDiffPreferencesPCA(dataCoeff)

# Prepare summary index
summaryIndex <- CreateCompleteSummaryIndex(summaryIndex, data_all)


# ================================ #
#### 4. VARIABLES CONDITIONING  ####
# ================================ #

summaryIndex <- AddResiduals(summaryIndex)


# ================== #
#### 5. PLOTTING  ####
# ================== #

# Prepare summary histograms
dataSummary <- SummaryHistograms(dataCoeff, summaryIndex)


# =============================== #
#### 6. SUPPLEMENTARY MATERIAL ####
# =============================== #
colsToKeep_coeff <- c("gender", "preference", "country", "isocode", "logAvgGDPpc")

colsToKeep_summary <- c("GenderIndex", "GenderIndexNorm", "ScoreWEFNorm", "ValueUNNorm", 
                        "DateNorm", "avgRatioLaborNorm", "residualslogAvgGDPpcNorm",
                        "residualsavgGenderDiffNorm_GEI", "country")
dataCoeff_summary <- merge(dataCoeff[, ..colsToKeep_coeff], 
                           summaryIndex[, ..colsToKeep_summary],
                           by = "country")

dataCoeff_summary[preference == "risktaking", gender := -1 * gender]
dataCoeff_summary[preference == "negrecip", gender := -1 * gender]
dataCoeff_summary[preference == "patience", gender := -1 * gender]

dataCoeff_summary <- AddResidualsSinglePreference(dataCoeff_summary)

# -------------- #

## Alternative model
modelsAlternative <- CreateAlternativeModels(dataComplete)
dataCoeffAlternative <- SummaryCoeffPerPreferencePerCountry(modelsAlternative)

# Adjust data for plotting
dataCoeffAlternative[data_all$data, `:=` (isocode     = i.isocode,
                                          logAvgGDPpc = log(i.avgGDPpc)),
                     on = "country"]
setnames(dataCoeffAlternative, old = "gender1", new = "gender")
dataCoeffAlternative[preference == "risktaking", gender := -1 * gender]
dataCoeffAlternative[preference == "negrecip", gender := -1 * gender]
dataCoeffAlternative[preference == "patience", gender := -1 * gender]



# ================================ #
#### 7. MODEL EVALUATION  ####
# ================================ #

# Add the data from the article
dt_article <- fread("files/Data_Extract_From_World_Development_Indicators/dataFromArticle2.csv")

# Create a data table for a quick comparison
dt_compare <- dt_article[summaryIndex, .(avgDiffArticle = AverageGenderDifference,
                                         avgDiffOurs = i.avgGenderDiffNorm,
                                         isocode = i.isocode), on = "isocode"]
dt_compare <- dt_compare[complete.cases(dt_compare)]

# Plot the results
PlotSummary(data = dt_compare, var1 = "avgDiffArticle", var2 = "avgDiffOurs",
            labs = c("Average Gender Differences from the Article",
                     "Average Gender Differences from our Model"),
            display = TRUE
)

# Compare with the Bayesian Supersedes the t-Test method
# Plots can be reproduced using the plotAll function
comparison <- BESTmcmc(dt_article$AverageGenderDifference,
                       summaryIndex$avgGenderDiffNorm)


# ========================== #
#### WRITE DATA SUMMARIES ####
# ========================== #

## ---------------------- Write csv data summaries -------------------------- ##
fwrite(dataSummary,
       file = "files/outcome/main_data_for_histograms.csv")
fwrite(summaryIndex,
       file = "files/outcome/main_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
fwrite(dataCoeff_summary,
       file = "files/outcome/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")
fwrite(dataCoeffAlternative,
       file = "files/outcome/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficients_alternativeModel.csv")
#------------------------------------------------------------------------------#
