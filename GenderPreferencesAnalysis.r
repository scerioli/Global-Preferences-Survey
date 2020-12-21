################################################################################
#####################  ANALYSIS OF GLOBAL PREFERENCES  #########################
################################################################################
# Reference article: https://science.sciencemag.org/content/362/6412/eaas9899
# DOI: 10.1126/science.aas9899


# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("/Users/sara/Desktop/Projects/Global_Preferences_Survey/")

# Source helper functions
source("functions/SourceFunctions.r")
SourceFunctions(path = "functions/helper_functions/", trace = TRUE)

# Load libraries
LoadRequiredLibraries()

# Load the Data
data_all <- LoadData()


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

data_all <- PrepareData(data_all)

# Complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]


# ========================== #
#### 2. CREATE THE MODELS ####
# ========================== #

## ------------- 2.1 Model on country level of the preferences --------------- #
dataComplete[, age_2 := age^2]
# dataComplete[gender == 2, gender := 0]
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
# Create the annotation for the summary of the model
labels <- dataCoeff %>%
  do(ExtractModelSummary(., var1 = "logAvgGDPpc", 
                            var2 = "gender", 
                            var3 = "preference")) %>% 
  setDT(.)

# Plot the results vs GDP
ggplot(dataCoeff, aes(x = logAvgGDPpc, y = gender)) +
  geom_point(shape = 21, fill = "white", size = 3) +
  geom_smooth(method = "lm", color = "red") +
  geom_text(aes(label = isocode), color = "gray20", size = 3, 
            check_overlap = F, hjust = -0.5) +
  facet_wrap(vars(preference), ncol = 3) +
  geom_text(x = 7, y = 0.42, data = labels, aes(label = correlation), hjust = 0) +
  geom_text(x = 7, y = 0.38, data = labels, aes(label = pvalue), hjust = 0) 
## --------------------------------------------------------------------------- #


# ===================================== #
#### 3. PRINCIPAL COMPONENT ANALYSIS ####
# ===================================== #

## ----------------------- 3.1 PCA on the preferences ------------------------ #
dt_pca <- data.table()

for (C in unique(dataCoeff$country)) {
  # Create a transposed data table on country level
  dt_tmp <- as.data.table(t(dataCoeff[country == C, .(gender)]))
  # Set new names to identify the preferences
  setnames(dt_tmp, old = names(dt_tmp), new = unique(dataCoeff$preference))
  # Add the country information
  dt_tmp[, country := C]
  
  dt_pca <- rbind(dt_pca, dt_tmp)
}
# Create a data table with the correct slope as in the article (aestethics only)
dt_pca_pos <- dt_pca[, .(country, 
                         Trust                  = trust, 
                         Altruism               = altruism, 
                         `Positive Reciprocity` = posrecip, 
                         `Negative Reciprocity` = negrecip * - 1, 
                         `Risk Taking`          = risktaking * - 1, 
                         Patience               = patience * - 1)]

# Perform the principal component analysis
pca <- prcomp(dt_pca_pos[, -1], scale. = F)
## --------------------------------------------------------------------------- #

# Add data for plotting
summaryIndex <- data.table(avgGenderDiff = pca$x[, 1],
                           country = unique(dataCoeff$country),
                           isocode = unique(dataCoeff$isocode),
                           logAvgGDPpc = unique(dataCoeff$logAvgGDPpc))

summaryIndex <- merge(summaryIndex, data_all$world_area, by = "country") 

summaryIndex[, avgGenderDiffNorm := (avgGenderDiff - min(avgGenderDiff)) /
               (max(avgGenderDiff) - min(avgGenderDiff))]

# Create annotation for the correlation and p-value
labels_idx <- summaryIndex %>% 
  do(ExtractModelSummary(., var1 = "logAvgGDPpc", var2 = "avgGenderDiff")) %>%
  setDT(.)

# Plot the results
ggplot(data = summaryIndex, aes(x = logAvgGDPpc, y = avgGenderDiffNorm)) +
  geom_point(shape = 21, size = 3, aes(fill = region)) +
  geom_smooth(method = "lm", color = "red") +
  geom_text(aes(label = isocode), color = "gray20", size = 3, 
            check_overlap = F, hjust = -0.5) +
  geom_text(x = 7, y = 1, data = labels_idx, aes(label = correlation), hjust = 0) +
  geom_text(x = 7, y = .95, data = labels_idx, aes(label = pvalue), hjust = 0) +
  xlab("Log GDP p/c") + ylab("Average Gender Difference (Index)") +
  theme_bw() +
  scale_fill_brewer(palette = "Set1")


## --------- 2.4 Principal component analysis on the Gender Index ------------ #
summaryGenderIndex <- data.table(country = unique(dataCoeff$country),
                                 isocode = unique(dataCoeff$isocode))

summaryGenderIndex <- merge(summaryGenderIndex, data_all$timeWomenSuff, by = "country") 
summaryGenderIndex <- merge(summaryGenderIndex, data_all$WEF, by = "country")
summaryGenderIndex <- merge(summaryGenderIndex, data_all$ratioLabor, by = "country")
summaryGenderIndex <- summaryGenderIndex[, -4]
summaryGenderIndex <- merge(summaryGenderIndex, data_all$UNindex, by = "country")

# Create a complete dataset (no NAs)
genderIndexComplete <- summaryGenderIndex[complete.cases(summaryGenderIndex)]
genderIndexComplete[, Value := as.numeric(Value)]

# Perform the principal component analysis
pca_gender <- prcomp(genderIndexComplete[, c(3:6)], scale. = T)
## --------------------------------------------------------------------------- #

# Add data for plotting
genderIndexComplete[, GenderIndex := pca_gender$x[, 1]]
genderIndexComplete[summaryIndex, `:=` (avgGenderDiff = i.avgGenderDiff,
                                        avgGenderDiffNorm = i.avgGenderDiffNorm),
                    on = "country"]

genderIndexComplete[summaryIndex, region := region, on = "country"] 

# Create annotation for the correlation and p-value
labels_gender_idx <- genderIndexComplete %>% 
  do(ExtractModelSummary(., var1 = "GenderIndex", var2 = "avgGenderDiff")) %>%
  setDT(.)

# Plot the results
ggplot(data = genderIndexComplete, aes(x = GenderIndex, y = avgGenderDiffNorm)) +
  geom_point(shape = 21, size = 3, aes(fill = region)) +
  geom_smooth(method = "lm", color = "red") +
  geom_text(aes(label = isocode), color = "gray20", size = 3, 
            check_overlap = F, hjust = -0.5) +
  geom_text(x = -2.5, y = 1, data = labels_gender_idx, aes(label = correlation), 
            hjust = 0) +
  geom_text(x = -2.5, y = .95, data = labels_gender_idx, aes(label = pvalue), 
            hjust = 0) +
  xlab("Gender Equality (Index)") + ylab("Average Gender Difference (Index)") +
  theme_bw() +
  scale_fill_brewer(palette = "Set1")

#------------------------------------------------------------------------------#

## -------------------- 3.0 Write csv data summaries ------------------------ ##
fwrite(summaryIndex, 
       file = "files/outcome/summaryDifferencesGDP.csv")
fwrite(genderIndexComplete, 
       file = "files/outcome/summaryDifferencesGenderEqualityIndex.csv")
#------------------------------------------------------------------------------#




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



ggplot(data[!is.na(risktaking)], aes(fill = factor(gender))) +
  geom_histogram(aes(x = risktaking), bins = 30, position = "identity", alpha = 0.5)

ggplot(data[!is.na(age) & country == "Russia"], aes(fill = factor(gender))) +
  geom_histogram(aes(x = risktaking), position = "identity", alpha = 0.7)

ggplot(data[!is.na(risktaking) & country == "Russia"], aes(fill = factor(age_quant))) +
  geom_histogram(aes(x = risktaking), position = "identity", alpha = 0.7)

ggplot(data[!is.na(negrecip) & country == "Pakistan"], aes(fill = factor(gender))) +
  geom_histogram(aes(x = negrecip), position = "identity", alpha = 0.7) #+
facet_grid(vars(age_quant)) 



# TODO: Next steps...
# Dependency on age
data_aggregated <- data[, .(meanPatience = mean(patience, na.rm = T),
                            meanRisktaking = mean(risktaking, na.rm = T),
                            meanPosrecip = mean(posrecip, na.rm = T),
                            meanNegrecip = mean(negrecip, na.rm = T),
                            meanAltruism = mean(altruism, na.rm = T),
                            meanTrust = mean(trust, na.rm = T),
                            meanMathSkills = mean(subj_math_skills, na.rm = T),
                            meanAge = mean(age, na.rm = T), 
                            avgGDPpc = unique(avgGDPpc)), 
                        by = c("country", "isocode")]

ggplot(data_aggregated, aes(x = log(avgGDPpc), y = meanAge)) +
  geom_point(shape = 21, fill = "white", size = 3) +
  geom_text(aes(label = isocode), color = "gray20", size = 3,
            check_overlap = F, hjust = -0.5)

