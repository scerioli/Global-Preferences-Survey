#####################  ANALYSIS OF GLOBAL PREFERENCES  #########################

# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("/Users/sara/Desktop/Projects/Global_Preferences_Survey/")

# Source helper functions
source("functions/SourceFunctions.r")
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

## ------------- 2.1 Model on country level of the preferences --------------- #
dataComplete[, age_2 := age^2]
dataComplete[gender == 2, gender := 0]
colsVar <- c("country", names(dataComplete)[5:13], "age_2")

# Select the data to fit
dataToFit <- dataComplete %>% select(all_of(colsVar))

# Create a model for each preference
preferences <- names(dataToFit)[2:7]

models <- lapply(preferences, function(x) {
  form <- paste0(x, " ~ gender + age + age_2 + subj_math_skills")
  model <- EstimateModel(dat = dataToFit, formula = form, var = "country")
})

names(models) <- preferences
## --------------------------------------------------------------------------- #

## ------------- 2.2 Summarise the preferences for each country -------------- #
dataCoeff <- SummaryCoeffPerPreferencePerCountry(models)

# Add data for plotting
dataCoeff[data_all$data, `:=` (isocode     = i.isocode,
                               logAvgGDPpc = log(i.avgGDPpc)), 
          on = "country"]
## --------------------------------------------------------------------------- #

## --------------------------------- PLOT ------------------------------------ #
PlotSummary(data = dataCoeff, 
            var1 = "logAvgGDPpc", var2 = "gender", var3 = "preference")

# Plot coefficient by country by preference
dataCoeff %>% 
  merge(data_all$world_area, by = "country") %>%
  group_by(preference) %>%
  mutate(preference = as.factor(preference), 
         country = reorder_within(country, subj_math_skills, preference)) %>%
  ggplot(aes(x = country, y = subj_math_skills, fill = region)) +
  geom_point(shape = 21, size = 3) +
  xlab("Country") + ylab("Coefficient on math skills") +
  theme_bw() +
  geom_hline(yintercept = 0) +
  scale_fill_brewer(palette = "Set1")  +
  facet_wrap(~ preference, ncol = 2, scales = "free") +
  scale_x_reordered() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
## --------------------------------------------------------------------------- #


# ===================================== #
#### 3. PRINCIPAL COMPONENT ANALYSIS ####
# ===================================== #

## ----------------------- 3.1 PCA on the preferences ------------------------ #
pca <- PreferencesPCA(dataCoeff)
## --------------------------------------------------------------------------- #

## ------------------------- 3.2 Prepare summary data ------------------------ #
summaryIndex <- data.table(avgGenderDiff = pca$x[, 1],
                           country = unique(dataCoeff$country),
                           isocode = unique(dataCoeff$isocode),
                           logAvgGDPpc = unique(dataCoeff$logAvgGDPpc))

summaryIndex <- merge(summaryIndex, data_all$world_area, by = "country") 
summaryIndex[, avgGenderDiffNorm := (avgGenderDiff - min(avgGenderDiff)) /
               (max(avgGenderDiff) - min(avgGenderDiff))]
## --------------------------------------------------------------------------- #

## --------------------------------- PLOT ------------------------------------ #
PlotSummary(data = summaryIndex, 
            var1 = "logAvgGDPpc", var2 = "avgGenderDiffNorm", fill = "region")
## --------------------------------------------------------------------------- #

## --------------------- 3.3 PCA on the Gender Index ------------------------- #
# NOTE: After adding this, the previous plot changes, not understood why yet
genderIndex <- GenderIndex(data_all)

summaryIndex[genderIndex, GenderIndex := i.GenderIndex, on = "country"]
summaryIndex <- summaryIndex[complete.cases(summaryIndex)]
## --------------------------------------------------------------------------- #

## --------------------------------- PLOT ------------------------------------ #
PlotSummary(data = summaryIndex, 
            var1 = "GenderIndex", var2 = "avgGenderDiff", fill = "region")
#------------------------------------------------------------------------------#


# ============================= #
#### 4. CORRELATION WITH AGE ####
# ============================= #

## ------------------------- 4.1 Prepare the data ---------------------------- #
dt_age <- fread("files/World_Ages/average_ages.csv")

outOfList <- setdiff(summaryIndex$country, dt_age$country)
dt_age[country %like% "Bosnia and Herzegovina", country := outOfList[1]]
dt_age[country %like% "Czech", country := outOfList[2]]

summaryIndex <- merge(summaryIndex, dt_age, by = "country") 

data_all$data[, averageAge := mean(age, na.rm = T), by = "country"]
summaryIndex[data_all$data, averageAgeGPS := i.averageAge, on = "country"]
#------------------------------------------------------------------------------#

## --------------------------------- PLOT ------------------------------------ #
PlotSummary(data = summaryIndex,
            var1 = "logAvgGDPpc", var2 = "avgGenderDiff", fill = "region")

PlotSummary(data = summaryIndex,
            var1 = "averageAge", var2 = "avgGenderDiff", fill = "region")

PlotSummary(data = summaryIndex,
            var1 = "averageAgeGPS", var2 = "avgGenderDiff", fill = "region")
#------------------------------------------------------------------------------#


# ============================== #
#### WRITE THE DATA SUMMARIES ####
# ============================== #

## ---------------------- Write csv data summaries -------------------------- ##
fwrite(summaryIndex, 
       file = "files/outcome/summaryDifferencesGDP.csv")
fwrite(genderIndex, 
       file = "files/outcome/summaryDifferencesGenderEqualityIndex.csv")
#------------------------------------------------------------------------------#


# Ideas for the next step:
# - Create PCA for the different age indicators (average age, median age, life expectancy...)
# - Divide the ages in 3 generations and plot the average gender differences vs
#   the logGDP


# Create a division between age
# TODO: Create a division between generations rather than by age
# https://en.wikipedia.org/wiki/Generation

data_age <- data %>% group_by(gender) %>% 
  summarise(young = quantile(age, 0.25, na.rm = TRUE),
            middle_age = quantile(age, 0.50, na.rm = TRUE),
            old = quantile(age, 0.75, na.rm = TRUE))

data[age <= quantile(age, 0.25, na.rm = TRUE), age_quant := "young"]
data[is.na(age_quant) & age <= quantile(age, 0.50, na.rm = TRUE), age_quant := "middle_age"]
data[is.na(age_quant), age_quant := "old"]



