################################################################################
#####################  ANALYSIS OF GLOBAL PREFERENCIES  ########################
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
path_GPS_dir <- "files/GPS_Dataset/GPS_dataset_individual_level/"
path_Index_dir <- "files/Data_Extract_From_World_Development_Indicators/"

# Load the data
data <- read_dta(paste0(path_GPS_dir, "individual_new.dta")) 
indicators <- read_csv(file = paste0(path_Index_dir, "Data.csv"), na = "..")


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

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

# Clean the names of the countries
indicators <- CleanCountryNamesGDP(data, indicators)

# Calculate the average GDP p/c
avgGDP <- rowMeans(indicators[, -1])
indicators[, avgGDPpc := avgGDP]

# Merge information of the indicators into the dataset
data <- data %>% merge(indicators, by.x = "country", by.y = "Country Name") %>%
  select(country, isocode, region, language, patience, risktaking, posrecip, 
         negrecip, altruism, trust, subj_math_skills, gender, age, avgGDPpc)

# Create a complete dataset (no NAs)
dataComplete <- data[complete.cases(data)]

# ========================= #
#### 2. CREATE THE MODEL ####
# ========================= #

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

dataCoeff[data, `:=` (isocode = i.isocode,
                      avgGDPpc = i.avgGDPpc), on = "country"]


ggplot(dataCoeff[preference == "patience"], aes(x = log(avgGDPpc), y = genderCoef)) +
  geom_point(shape = 21, fill = "white", size = 3) +
  geom_text(aes(label = isocode), color = "gray20", size = 3,
            check_overlap = F, hjust = -0.5)



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

ggplot(data[!is.na(patience) & country == "Russia"], aes(fill = factor(gender))) +
  geom_histogram(aes(x = patience), position = "identity", alpha = 0.7) +
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

