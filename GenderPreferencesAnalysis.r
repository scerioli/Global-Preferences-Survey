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
dataComplete[, gender := as.factor(gender)]
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
setnames(dataCoeff, old = "gender1", new = "gender")
## --------------------------------------------------------------------------- #

## --------------------------------- PLOT ------------------------------------ #
relevantCoefficients  <- data.table()

# Loop over the model and extract the coefficients associated to each 
# preference and each country
for (i in 1:length(models)) {
  dt_tmp <- ExtractMostRelevantCoefficient(models[[i]])
  dt_tmp[, preference := names(models)[[i]]]
  relevantCoefficients <- rbind(dt_tmp, relevantCoefficients)
}

# Note that NA here represents those countries where no coefficient was
# significantly different from 0
ggplot(relevantCoefficients) +
  geom_histogram(aes(x = name, fill = name), stat = "count") +
  facet_wrap(~ preference)

relevantCoefficients %>%
  group_by(preference) %>%
  mutate(preference = as.factor(preference), 
         country = reorder_within(country, mainCoef, preference)) %>%
  ggplot() +
  geom_hline(yintercept = 0) +
  geom_point(aes(x = country, y = mainCoef, color = name)) +
  scale_color_brewer(palette = "Set1")  +
  facet_wrap(~ preference, scales = "free") +
  scale_x_reordered() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 


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

# Plot the gender coefficient only over preference for all the countries
PlotSummary(data = dataCoeff, 
            var1 = "logAvgGDPpc", var2 = "gender", var3 = "preference",
            labs = c("Log GDP p/c", 
                     "Gender Coefficient"))
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
            var1 = "logAvgGDPpc", var2 = "avgGenderDiffNorm", fill = "region",
            labs = c("Log GDP p/c", 
                     "Average Gender Differences"))
## --------------------------------------------------------------------------- #

## --------------------- 3.3 PCA on the Gender Index ------------------------- #
genderIndex <- GenderIndex(data_all)

summaryIndex[genderIndex, GenderIndex := i.GenderIndex, on = "country"]
summaryGenderIndex <- summaryIndex[complete.cases(summaryIndex)]
## --------------------------------------------------------------------------- #

## --------------------------------- PLOT ------------------------------------ #
PlotSummary(data = summaryGenderIndex, 
            var1 = "GenderIndex", var2 = "avgGenderDiff", fill = "region",
            labs = c("Gender Equality Index", 
                     "Average Gender Differences"))
#------------------------------------------------------------------------------#


# ================================ #
#### 4. VARIABLES CONDITIONING  ####
# ================================ #

## ---------- Gender Equality Index Residualized using Log GDP --------------- #
regressionGDPx <- lm(GenderIndex ~ logAvgGDPpc, data = summaryGenderIndex)
regressionGDPy <- lm(avgGenderDiffNorm ~ logAvgGDPpc, data = summaryGenderIndex)

# Use residuals and predictions (x being GenderIndex, y the avgGenderDiffNorm)
summaryGenderIndex$predictedGDPx <- predict(regressionGDPx)
summaryGenderIndex$residualsGDPx <- residuals(regressionGDPx)

summaryGenderIndex$predictedGDPy <- predict(regressionGDPy)
summaryGenderIndex$residualsGDPy <- residuals(regressionGDPy)
#------------------------------------------------------------------------------#

# Just to have a nice plot for residuals :)
ggplot(summaryGenderIndex, aes(x = logAvgGDPpc, y = avgGenderDiffNorm)) +
  geom_smooth(method = "lm", se = FALSE, color = "lightgrey") + 
  geom_segment(aes(xend = logAvgGDPpc, yend = predictedGDPy), alpha = .2) + 
  geom_point(aes(color = abs(residualsGDPy))) + # Color mapped to abs(residuals)
  scale_color_continuous(low = "black", high = "red") +  # Colors to use here
  guides(color = FALSE) +
  geom_point(aes(y = predictedGDPy), shape = 1) +
  theme_bw() 

## --------------------------------- PLOT ------------------------------------ #
PlotSummary(data = summaryGenderIndex, var1 = "residualsGDPx", var2 = "residualsGDPy",
            labs = c("Gender Equality Index (residualized using Log GDP p/c)", 
                     "Average Gender Differences (residualized using Log GDP p/c)"))
#------------------------------------------------------------------------------#

## ---------- Log GDP Residualized using Gender Equality Index --------------- #
regressionGEIx <- lm(logAvgGDPpc ~ GenderIndex, data = summaryGenderIndex)
regressionGEIy <- lm(avgGenderDiffNorm ~ GenderIndex, data = summaryGenderIndex)

# Use residuals and predictions
summaryGenderIndex$predictedGEIx <- predict(regressionGEIx)
summaryGenderIndex$residualsGEIx <- residuals(regressionGEIx)

summaryGenderIndex$predictedGEIy <- predict(regressionGEIy)
summaryGenderIndex$residualsGEIy <- residuals(regressionGEIy)
#------------------------------------------------------------------------------#

## --------------------------------- PLOT ------------------------------------ #
PlotSummary(data = summaryGenderIndex, var1 = "residualsGEIx", var2 = "residualsGEIy",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)", 
                     "Average Gender Differences (residualized using Gender Equality Index)"))
#------------------------------------------------------------------------------#

## ---------------- Multivariate model for GDP and GEI ----------------------- #
# Need to specify that I want to use map from rethinking and not from purr
map <- rethinking::map
# standardize predictor
summaryGenderIndex$logAvgGDPpcNorm <- (summaryGenderIndex$logAvgGDPpc - mean(summaryGenderIndex$logAvgGDPpc))/
  sd(summaryGenderIndex$logAvgGDPpc)

# standardize predictor
summaryGenderIndex$GenderIndexNorm <- (summaryGenderIndex$GenderIndex - mean(summaryGenderIndex$GenderIndex))/
  sd(summaryGenderIndex$GenderIndex)

# Fit the model
modelMulti <- map(alist(avgGenderDiffNorm ~ dnorm(mu , sigma),
                        mu <- a + bGDP * logAvgGDPpcNorm + bGEI * GenderIndexNorm,
                        a ~ dnorm(10 , 10),
                        bGDP ~ dnorm(0 , 1),
                        bGEI ~ dnorm(0 , 1),
                        sigma ~ dunif(0 , 10)), 
                  data = summaryGenderIndex )

# Plot the results of the model
plot(precis(modelMulti))
# Comment:
# Since the coefficient of GEI is closer to 0 than the coefficient of GDP, 
# this may tell us that there is small additional values in knowing the GEI 
# once we know the GDP
# TODO: Can we use this with the PCA on data about age on a country?

# Predictor residual plots
predictorResidual <- map(alist(GenderIndexNorm ~ dnorm(mu, sigma),
                               mu <- a + b * logAvgGDPpcNorm,
                               a ~ dnorm(0 , 10),
                               b ~ dnorm(0 , 1),
                               sigma ~ dunif(0, 10)),
                         data = summaryGenderIndex)

# Compute expected value for controlling the logGDP
muResGDP <- coef(predictorResidual)['a'] + 
  coef(predictorResidual)['b'] * summaryGenderIndex$logAvgGDPpcNorm
# Compute residual for each country
m_residGDP <- summaryGenderIndex$GenderIndexNorm - muResGDP

# Compute expected value for controlling the GEI
muResGEI <- coef(predictorResidual)['a'] + 
  coef(predictorResidual)['b'] * summaryGenderIndex$GenderIndexNorm
# Compute residual for each country
m_residGEI <- summaryGenderIndex$logAvgGDPpcNorm - muResGEI

summaryGenderIndex[, `:=` (residualGDP = m_residGDP,
                           residualGEI = m_residGEI)]

# Plot
PlotSummary(data = summaryGenderIndex, var1 = "residualGEI", var2 = "avgGenderDiffNorm",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)", 
                     "Average Gender Differences"))
PlotSummary(data = summaryGenderIndex, var1 = "residualGDP", var2 = "avgGenderDiffNorm",
            labs = c("Gender Equality Index (residualized using Log GDP p/c)", 
                     "Average Gender Differences"))




# ============================= #
#### 5. CORRELATION WITH AGE ####
# ============================= #

## ------------------------- 5.1 Prepare the data ---------------------------- #
dt_age <- fread("files/World_Ages/average_ages.csv")

outOfList <- setdiff(summaryIndex$country, dt_age$country)
dt_age[country %like% "Bosnia and Herzegovina", country := outOfList[1]]
dt_age[country %like% "Czech", country := outOfList[2]]

summaryGenderIndex <- merge(summaryGenderIndex, dt_age, by = "country") 

data_all$data[, averageAge := mean(age, na.rm = T), by = "country"]
summaryGenderIndex[data_all$data, averageAgeGPS := i.averageAge, on = "country"]

ggplot(data = summaryGenderIndex) +
  geom_histogram(aes(x = averageAgeGPS - averageAge))
#------------------------------------------------------------------------------#

## --------------------------------- PLOT ------------------------------------ #
PlotSummary(data = summaryGenderIndex,
            var1 = "logAvgGDPpc", var2 = "averageAgeGPS", fill = "region")

PlotSummary(data = summaryGenderIndex,
            var1 = "GenderIndex", var2 = "averageAge", fill = "region")

PlotSummary(data = summaryGenderIndex,
            var1 = "averageAge", var2 = "avgGenderDiff", fill = "region")

PlotSummary(data = summaryGenderIndex,
            var1 = "averageAgeGPS", var2 = "avgGenderDiff", fill = "region")
#------------------------------------------------------------------------------#

# Ideas for the next step:
# - Create PCA for the different age indicators (average age, median age, life expectancy...)
# - Divide the ages in 3 generations and plot the average gender differences vs
#   the logGDP
#   Millennials: 1981 - 1996 (31 - 15 years)
#   Generation X: 1965 - 1980 (47 - 32 years)
#   Baby Boomers: 1946 - 1964 (66 - 48 years)
#   Silent Generation: 1928 - 1945 (84 - 67 years)
#   Greatest Generation: 1901 - 1927 (111 - 85 years)
#   
#   Divide instad using the division from the quadratic model they use?

dataGeneration <- dataComplete[age <= 31, generation := "millennials"]
dataGeneration[is.na(generation) & age <= 47, generation := "genX"]
dataGeneration[is.na(generation) & age <= 66, generation := "babyBoomers"]
dataGeneration[is.na(generation) & age > 66, generation := "older"]


colsVarGen <- c(colsVar, "generation")
# Select the data to fit
dataGen <- dataGeneration %>% select(all_of(colsVarGen))
generations <- unique(dataGen$generation)


modelsGen <- lapply(preferences, function(x) {
  form <- paste0(x, " ~ gender + generation + subj_math_skills")
  model <- EstimateModel(dat = dataGen, formula = form, var = "country")
})

names(modelsGen) <- preferences

relevantCoefficientsGen  <- data.table()

# Loop over the model and extract the coefficients associated to each 
# preference and each country
for (i in 1:length(modelsGen)) {
  dt_tmp <- ExtractMostRelevantCoefficient(modelsGen[[i]])
  dt_tmp[, preference := names(modelsGen)[[i]]]
  relevantCoefficientsGen <- rbind(dt_tmp, relevantCoefficientsGen)
}

# Note that NA here represents those countries where no coefficient was
# significantly different from 0
ggplot(relevantCoefficientsGen) +
  geom_histogram(aes(x = name, fill = name), stat = "count") +
  facet_wrap(~ preference) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 

relevantCoefficientsGen %>%
  group_by(preference) %>%
  mutate(preference = as.factor(preference), 
         country = reorder_within(country, mainCoef, preference)) %>%
  ggplot() +
  geom_hline(yintercept = 0) +
  geom_point(aes(x = country, y = mainCoef, color = name)) +
  scale_color_brewer(palette = "Set1")  +
  facet_wrap(~ preference, scales = "free") +
  scale_x_reordered() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 

## --------------------------------------------------------------------------- #


# ========================== #
#### WRITE DATA SUMMARIES ####
# ========================== #

## ---------------------- Write csv data summaries -------------------------- ##
fwrite(summaryIndex, 
       file = "files/outcome/summaryDifferencesGDP.csv")
fwrite(genderIndex, 
       file = "files/outcome/summaryDifferencesGenderEqualityIndex.csv")
#------------------------------------------------------------------------------#


data_age <- data %>% group_by(gender) %>% 
  summarise(young = quantile(age, 0.25, na.rm = TRUE),
            middle_age = quantile(age, 0.50, na.rm = TRUE),
            old = quantile(age, 0.75, na.rm = TRUE))

data[age <= quantile(age, 0.25, na.rm = TRUE), age_quant := "young"]
data[is.na(age_quant) & age <= quantile(age, 0.50, na.rm = TRUE), age_quant := "middle_age"]
data[is.na(age_quant), age_quant := "old"]


ggplot(data = dataGeneration) +
  geom_histogram(aes(x = generation), stat = "count")
