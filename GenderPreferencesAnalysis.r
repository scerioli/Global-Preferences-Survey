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

# Select the directory
path_GPS_dir   <- "files/GPS_Dataset/GPS_dataset_individual_level/"
path_Index_dir <- "files/Data_Extract_From_World_Development_Indicators/"
path_GEI_dir   <- "files/Gender_Equality_Index_Data/"

# Load the data
data          <- read_dta(paste0(path_GPS_dir, "individual_new.dta")) 
indicators    <- read_csv(file = paste0(path_Index_dir, "Data.csv"), na = "..")
timeWomenSuff <- fread(file = paste0(path_GEI_dir, "Womens_suffrage_date_mod.csv"), 
                       na.strings = "-") %>% setDT(.)
WEF           <- fread(paste0(path_GEI_dir, "WEF_Global_Gender_Gap_Index.txt"),
                       sep = "\t")
ratioLabor    <- fread(file = paste0(path_GEI_dir, "RatioLaborMF.csv"), skip = 4)
UNindex       <- fread(file = paste0(path_GEI_dir, "UN_Gender_Inequality_Index_mod.csv"),
                       na = "..")


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

## ----------------------------- 1.1 GDP data ------------------------------- ##
# Select specific columns of indicators
indicators <- indicators %>% select(c(names(indicators)[1], 
                                      names(indicators)[5:14]))

# New names for the columns indicating the GDP
newColsNames <- sapply(strsplit(split = "\\ \\[YR", x = names(indicators)[-1]), 
                       `[`, 1)
setnames(indicators, old = names(indicators)[-1], new = newColsNames)

# Set the data to data table
setDT(data)
setDT(indicators)

# Only the first 217 names are actual country names
indicators <- indicators[1:217]
# Clean the names of the countries
indicators <- CleanCountryNames(data, indicators)

# Calculate the average GDP p/c
avgGDP <- rowMeans(indicators[, -1])
indicators[, avgGDPpc := avgGDP]

# Merge information of the indicators into the dataset
data <- data %>% merge(indicators, by.x = "country", by.y = "Country Name") %>%
  select(country, isocode, region, language, patience, risktaking, posrecip, 
         negrecip, altruism, trust, subj_math_skills, gender, age, avgGDPpc)
# ---------------------------------------------------------------------------- #

## ---------------- 1.2 Time since women's complete suffrage ---------------- ##
# Merge time since women's suffrage into the main dataset
setnames(timeWomenSuff, old = "Country", new = "country")
# ---------------------------------------------------------------------------- #

## ----------------------- 1.3 WEF Gender Gap Index ------------------------- ##
setnames(WEF, old = "Economy", new = "country")
# ---------------------------------------------------------------------------- #

## ------------------------- 1.4 Ratio Labor M/F ---------------------------- ##
# Select specific columns of indicators
ratioLabor <- ratioLabor %>% select(c(names(ratioLabor)[1:2],
                                      names(ratioLabor)[48:57]))
setnames(ratioLabor, old = names(ratioLabor), new = as.character(ratioLabor[1]))
ratioLabor <- ratioLabor[-1]

# Clean the names
ratioLabor <- CleanCountryNames(data, ratioLabor)
setnames(ratioLabor, old = "Country Name", new = "country")

# Calculate average
avgRatioLabor <- rowMeans(ratioLabor[, c(-1,-2)])
ratioLabor[, avgRatioLabor := avgRatioLabor]
ratioLabor <- ratioLabor[, c(1, 13)]
# ---------------------------------------------------------------------------- #

## ------------------ 1.5 UN Gender Inequality Index ------------------------ ##
setnames(UNindex, old = "Country", new = "country")
# ---------------------------------------------------------------------------- #


# Create a complete dataset (no NAs)
dataComplete <- data[complete.cases(data)]


# ========================= #
#### 2. CREATE THE MODEL ####
# ========================= #

## ------------- 2.1 Model on country level of the preferences --------------- #
dataComplete[, age_2 := age^2]
# dataComplete[gender == 2, gender := 0]
colsVar <- c("country", names(dataComplete)[5:13], "age_2")

# Select the data to fit
dataToFit <- dataComplete %>% select(all_of(colsVar))

# Create the models of each variable for each country
model_patience <- dlply(dataToFit, "country", function(dt) 
  lm(patience ~ gender + age + age_2 + subj_math_skills, dt))
model_risktaking <- dlply(dataToFit, "country", function(dt) 
  lm(risktaking ~ gender + age + age_2 + subj_math_skills, dt))
model_posrecip <- dlply(dataToFit, "country", function(dt) 
  lm(posrecip ~ gender + age + age_2 + subj_math_skills, dt))
model_negrecip <- dlply(dataToFit, "country", function(dt) 
  lm(negrecip ~ gender + age + age_2 + subj_math_skills, dt))
model_altruism <- dlply(dataToFit, "country", function(dt) 
  lm(altruism ~ gender + age + age_2 + subj_math_skills, dt))
model_trust <- dlply(dataToFit, "country", function(dt) 
  lm(trust ~ gender + age + age_2 + subj_math_skills, dt))

models <- list(model_p = model_patience, model_r = model_risktaking, 
               model_pr = model_posrecip, model_nr = model_negrecip, 
               model_a = model_altruism, model_t = model_trust)
## --------------------------------------------------------------------------- #

## -- 2.2 Model globally the dependency of the preferences from gender only -- #
namesModel <- names(dataToFit)[2:7]
dataCoeff  <- data.table(country = character(),
                         intercept = double(),
                         genderCoef = double(),
                         ageCoef = double(),
                         age2Coef = double(),
                         smsCoef = double(),
                         preference = character())

# Loop over the model and extract the coefficients associated to each preference
# and each country
for (i in 1:length(models)) {
  dt_tmp <- CreateDtFromModels(models[[i]])
  dt_tmp[, preference := namesModel[i]]
  dataCoeff <- rbind(dt_tmp, dataCoeff)
}
# Add data for plotting
dataCoeff[data, `:=` (isocode = i.isocode,
                      logAvgGDPpc = log(i.avgGDPpc)), 
          on = "country"]

# Create the annotation for the summary of the model
labels <- dataCoeff %>%
  do(ExtractModelSummary(., var1 = "logAvgGDPpc", var2 = "genderCoef", var3 = "preference")) %>% 
  setDT(.)

# Plot the results vs GDP
ggplot(dataCoeff, aes(x = logAvgGDPpc, y = genderCoef)) +
  geom_point(shape = 21, fill = "white", size = 3) +
  geom_smooth(method = "lm", color = "red") +
  geom_text(aes(label = isocode), color = "gray20", size = 3, check_overlap = F, hjust = -0.5) +
  facet_wrap(vars(preference), ncol = 3) +
  geom_text(x = 7, y = 0.42, data = labels, aes(label = correlation), hjust = 0) +
  geom_text(x = 7, y = 0.38, data = labels, aes(label = pvalue), hjust = 0) 
## --------------------------------------------------------------------------- #

## ---------- 2.3 Principal component analysis on the preferences ------------ #
dt_pca <- data.table()

for (C in unique(dataCoeff$country)) {
  # Create a transposed data table on country level
  dt_tmp <- as.data.table(t(dataCoeff[country == C, .(genderCoef)]))
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
pca <- prcomp(dt_pca_pos[, 2:7], scale. = F)
## --------------------------------------------------------------------------- #

# Add data for plotting
summaryIndex <- data.table(avgGenderDiff = pca$x[, 1],
                           country = unique(dataCoeff$country),
                           isocode = unique(dataCoeff$isocode),
                           logAvgGDPpc = unique(dataCoeff$logAvgGDPpc)
)

summaryIndex[, avgGenderDiffNorm := (avgGenderDiff - min(avgGenderDiff)) /
               (max(avgGenderDiff) - min(avgGenderDiff))]

# Create annotation for the correlation and p-value
labels_idx <- summaryIndex %>% do(ExtractModelSummary(., var1 = "logAvgGDPpc", var2 = "avgGenderDiff"))
setDT(labels_idx)

# Plot the results
ggplot(data = summaryIndex, aes(x = logAvgGDPpc, y = avgGenderDiffNorm)) +
  geom_point(shape = 21, fill = "white", size = 3) +
  geom_smooth(method = "lm", color = "red") +
  geom_text(aes(label = isocode), color = "gray20", size = 3, check_overlap = F, hjust = -0.5) +
  geom_text(x = 7, y = 1, data = labels_idx, aes(label = correlation), hjust = 0) +
  geom_text(x = 7, y = .95, data = labels_idx, aes(label = pvalue), hjust = 0) +
  xlab("Log GDP p/c") + ylab("Average Gender Difference (Index)") +
  theme_bw()


## --------- 2.4 Principal component analysis on the Gender Index ------------ #
summaryGenderIndex <- data.table(country = unique(dataCoeff$country),
                                 isocode = unique(dataCoeff$isocode))

summaryGenderIndex <- merge(summaryGenderIndex, timeWomenSuff, by = "country") 
summaryGenderIndex <- merge(summaryGenderIndex, WEF, by = "country")
summaryGenderIndex <- merge(summaryGenderIndex, ratioLabor, by = "country")
summaryGenderIndex <- summaryGenderIndex[, -4]
summaryGenderIndex <- merge(summaryGenderIndex, UNindex, by = "country")

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

# Create annotation for the correlation and p-value
labels_gender_idx <- genderIndexComplete %>% 
  do(ExtractModelSummary(., var1 = "GenderIndex", var2 = "avgGenderDiff"))
setDT(labels_gender_idx)

# Plot the results
ggplot(data = genderIndexComplete, aes(x = GenderIndex, y = avgGenderDiffNorm)) +
  geom_point(shape = 21, fill = "white", size = 3) +
  geom_smooth(method = "lm", color = "red") +
  geom_text(aes(label = isocode), color = "gray20", size = 3, check_overlap = F, hjust = -0.5) +
  geom_text(x = -2.5, y = 1, data = labels_gender_idx, aes(label = correlation), hjust = 0) +
  geom_text(x = -2.5, y = .95, data = labels_gender_idx, aes(label = pvalue), hjust = 0) +
  xlab("Gender Equality (Index)") + ylab("Average Gender Difference (Index)") +
  theme_bw()

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

