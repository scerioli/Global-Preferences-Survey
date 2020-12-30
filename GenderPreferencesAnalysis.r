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
            var1 = "logAvgGDPpc", var2 = "gender", var3 = "preference",
            labs = c("Log GDP p/c", 
                     "Gender Coefficient"))

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
            var1 = "logAvgGDPpc", var2 = "avgGenderDiffNorm", fill = "region",
            labs = c("Log GDP p/c", 
                     "Average Gender Differences"))
## --------------------------------------------------------------------------- #

## --------------------- 3.3 PCA on the Gender Index ------------------------- #
# NOTE: After adding this, the previous plot changes, not understood why yet
genderIndex <- GenderIndex(data_all)

summaryGenderIndex <- summaryIndex[genderIndex, GenderIndex := i.GenderIndex, on = "country"]
summaryGenderIndex <- summaryGenderIndex[complete.cases(summaryGenderIndex)]
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
# Since the coefficient of GEI is closer to 0 than the coefficient of GDP, and 
# their sd have barely overlapping values, this may tell us that there is small
# additional values in knowing the GEI once we know the GDP
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


# ========================== #
#### WRITE DATA SUMMARIES ####
# ========================== #

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
#   Millennials: 1981 - 1996 (31 - 15 years)
#   Generation X: 1965 - 1980 (47 - 32 years)
#   Baby Boomers: 1946 - 1964 (66 - 48 years)
#   Silent Generation: 1928 - 1945 (84 - 67 years)
#   Greatest Generation: 1901 - 1927 (111 - 85 years)

dataGeneration <- dataComplete[age <= 31, generation := "millennials"]
dataGeneration[is.na(generation) & age <= 47, generation := "genX"]
dataGeneration[is.na(generation) & age <= 66, generation := "babyBoomers"]
dataGeneration[is.na(generation) & age > 66, generation := "older"]


colsVarGen <- c(colsVar, "generation")
# Select the data to fit
dataGen <- dataGeneration %>% select(all_of(colsVarGen))
generations <- unique(dataGen$generation)


modelsGen <- lapply(generations, function(x) {
  modelsTmp <- lapply(preferences, function(y) {
    form <- paste0(y, " ~ gender + subj_math_skills")
    model <- EstimateModel(dat = dataGen[generation == x], formula = form, var = "country")
  })
})
names(modelsGen) <- generations

names(modelsGen$millennials) <- preferences
names(modelsGen$genX) <- preferences
names(modelsGen$babyBoomers) <- preferences
names(modelsGen$older) <- preferences
## --------------------------------------------------------------------------- #

## ------------- 2.2 Summarise the preferences for each country -------------- #
dt_tmp <- lapply(modelsGen, function(mod) {
    SummaryCoeffPerPreferencePerCountry(mod)
})


dataCoeffGen <- data.table()
i <- 1
for (generation in generations) {
  dataCoeffGen_tmp <- cbind(dt_tmp[[i]], generation)
  dataCoeffGen <- rbind(dataCoeffGen_tmp, dataCoeffGen)
  i <- i + 1
}

# Add data for plotting
dataCoeffGen[data_all$data, `:=` (isocode     = i.isocode,
                                  logAvgGDPpc = log(i.avgGDPpc)), 
             on = "country"]
## --------------------------------------------------------------------------- #

pcaMillennials <- PreferencesPCA(dataCoeffGen[generation == "millennials"])
pcaGenX <- PreferencesPCA(dataCoeffGen[generation == "genX"])
pcaBabyBoomers <- PreferencesPCA(dataCoeffGen[generation == "babyBoomers"])
pcaOlder <- PreferencesPCA(dataCoeffGen[generation == "older"])
## --------------------------------------------------------------------------- #

## ------------------------- 3.2 Prepare summary data ------------------------ #
summaryIndexGen <- dataCoeffGen[, .(country = unique(country), 
                                    isocode = unique(isocode), 
                                    logAvgGDPpc = unique(logAvgGDPpc))]
columnsToKeep <- c("country", "isocode", "logAvgGDPpc")


summaryIndexMill <- data.table(generation = "millennials", 
                               avgGenderDiff = pcaGenX$x[, 1])
summaryIndexGenX <- data.table(generation = "genX", 
                               avgGenderDiff = pcaGenX$x[, 1])
summaryIndexBB <- data.table(generation = "babyBoomers", 
                             avgGenderDiff = pcaBabyBoomers$x[, 1])
summaryIndexOlder <- data.table(generation = "older", 
                                avgGenderDiff = pcaOlder$x[, 1])


summaryIndexMill <- cbind(summaryIndexMill, 
                           summaryIndexGen)
summaryIndexGenX <- cbind(summaryIndexGenX,
                           summaryIndexGen)
summaryIndexBB <- cbind(summaryIndexBB,
                        summaryIndexGen)
summaryIndexOlder <- cbind(summaryIndexOlder,
                          summaryIndexGen)

summaryIndexProva <- rbind(summaryIndexMill, summaryIndexGenX, summaryIndexBB, summaryIndexOlder)


summaryIndexProva <- merge(summaryIndexProva, data_all$world_area, by = "country") 
summaryIndexProva[, avgGenderDiffNorm := (avgGenderDiff - min(avgGenderDiff)) /
                   (max(avgGenderDiff) - min(avgGenderDiff)), by = "generation"]
## --------------------------------------------------------------------------- #

## --------------------------------- PLOT ------------------------------------ #
PlotSummary(data = summaryIndexProva, 
            var1 = "logAvgGDPpc", var2 = "avgGenderDiffNorm", var3 = "generation", fill = "region")

## --------------------------------------------------------------------------- #


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


ggplot(data = dataGeneration) +
  geom_histogram(aes(x = generation), stat = "count")
