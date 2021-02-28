#####################  ANALYSIS OF GLOBAL PREFERENCES  #########################

# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("~/Desktop/Projects/Global-Preferences-Survey/")

# Source helper functions
source("functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "functions/")
SourceFunctions(path = "functions/helper_functions/")
SourceFunctions(path = "New_Analysis/functions")

# Load libraries
LoadRequiredLibraries()
# Set map first choice to rethinking package
map <- rethinking::map

# Define logit function
logit <- function(x) {
  log(x / (1 - x))
}

# Load the data
data_all <- LoadData()


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

data_all <- PrepareData(data_all)

# Standardize preferences at country level
data_all$data <- Standardize(data    = data_all$data, 
                             columns = c(5:10), 
                             level   = "country")

# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]

preferences <- c("posrecip", "altruism", "negrecip", 
                 "patience", "trust", "risktaking")

# Round the values of each preference and make them start from 0, to make them
#  simpler to analyse
for (pref in preferences) {
  dataComplete[, paste0(pref, "_round") := floor(eval(as.name(pref)) + 
                                                   abs(min(eval(as.name(pref)))) + 1)]
}


# ====================== #
#### 2. CREATE MODELS ####
# ====================== #

#### 2.1 Basic model with only gender as coefficient ####

modelObject <- CreateModelGender(dataComplete)

# Assign the variables from the list
dt_posrecip <- modelObject$dataTable
model_posrecip <- modelObject$model

#### 2.2 Model with subj_math_skills as ordered categorical predictor together with gender ####

# CAREFUL!! It will take ~5 hours
models_list_SMS <- CreateModelGenderSMS(dataComplete)

dt_models_posrecip <- ExtractCoefficientsStanModel(models_list_SMS)


# ======================= #
#### 3. SAVE THE DATA ####
# ======================= #

fwrite(dt_posrecip, file = "tmp/model_posrecip_gender_byCountry.csv")
fwrite(precis(m_posrecip_pred, depth = 2), file = "tmp/model_posrecip_SMS_gender_all_countries.csv")
fwrite(dt_models_posrecip, file = "tmp/models_posrecip_SMS_gender_byCountry.csv")
