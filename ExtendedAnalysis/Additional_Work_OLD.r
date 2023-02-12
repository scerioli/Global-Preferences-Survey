## ============================================================================ #
####  EXPLORATION WITH EXTRA DATA SETS AND SUGGESTIONS FROM PHD WORKSHOP  ####
# ============================================================================ #
# Interesting ideas to explore:
# - Interaction effects between Log GDP and GEI
# - Use another economic development indicator (such as GINI index)
# - Split the HDI sub-indexes to understand which contributes more


#### 0. Load Libraries and Set Path ####
# ------------------------------------ #
# Set the path
setwd("C:/Users/ceriosar/OneDrive - Mars Inc/Desktop/Private Sara/Global-Preferences-Survey/")

# Source helper functions
source("ReproductionAnalysis/functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "ReproductionAnalysis/functions/")
SourceFunctions(path = "ReproductionAnalysis/functions/helper_functions/")
SourceFunctions(path = "ExtendedAnalysis/functions/")

# Load libraries
LoadRequiredLibraries()
library(effects)


#### 1. INTERACTION EFFECTS ####
# ============================ #

# 1.1 Using the GEI from the authors
# ----------------------------------
# (This will be needed for later)
GDI_index <- CreateGDIindex()
# Load and prepare the data
data_all <- LoadData()
data_all$GDI_index <- GDI_index
data_all <- PrepareData_new(data_all)
data_all$data <- Standardize(data    = data_all$data,
                             columns = c(5:10),
                             level   = "country")
dataComplete <- data_all$data[complete.cases(data_all$data)]

# Create the models
models <- CreateModelsForPreferencesCountryLevel(dataComplete, robust = FALSE)
dataCoeff <- SummaryCoeffPerPreferencePerCountry(models)
dataCoeff[data_all$data, `:=` (isocode     = i.isocode,
                               logAvgGDPpc = log(i.avgGDPpc)),
          on = "country"]
setnames(dataCoeff, old = "gender1", new = "gender")

# PCA on the preferences
summaryIndex <- AvgGenderDiffPreferencesPCA(dataCoeff)
summaryIndex <- CreateSummaryIndex_new(summaryIndex, data_all)
summaryIndex$GenderIndex <- GenderIndexPCA(summaryIndex[, c(5:8)])
summaryIndex <- Standardize(data    = summaryIndex, 
                            columns = c(2, 4:9, 14),
                            newName = TRUE)
summaryIndex[, GenderIndexRescaled := Rescale(GenderIndex)]


# Create the simple linear model
lr <- lm(avgGenderDiffStd ~ logAvgGDPpcStd + GenderIndexStd, data = summaryIndex)
summary(lr)

# Create the linear model with interaction effects
lri <- lm(avgGenderDiffStd ~ logAvgGDPpcStd * GenderIndexStd, data = summaryIndex)
summary(lri)

anova(lr, lri)
# Interaction effect needs to be included!

# This here is just for plotting purposes
lri_b <- lm(avgGenderDiffStd ~ GenderIndexStd * logAvgGDPpcStd, data = summaryIndex)

# If log GDP is "average" (centered on 0) then the gender differences increase
# of 0.47 std dev for those countries with 1 std dev GEI higher.
# If GEI is "average", then the gend diff increase of 0.33 std dev for those
# countries with 1 std dev log GDP higher.
# Each std dev of GEI or of log GDP increases the gend diff by 0.2 std dev

plot(effect(term = "logAvgGDPpcStd:GenderIndexStd", mod = lri))
plot(effect(term = "GenderIndexStd:logAvgGDPpcStd", mod = lri_b))

# The effect of the economic development increases with the increase of the GEI
# and vice-versa, with low economic development the effect of the GEI on the
# gender differences is lost, while it starts to have an effect for more economically
# developed countries.

# 1.2 Using the GDI from UNDP
# ---------------------------
lr2 <- lm(avgGenderDiffStd ~ logAvgGDPpcStd + GDIStd, data = summaryIndex)
summary(lr2)

# Create the linear model with interaction effects
lri2 <- lm(avgGenderDiffStd ~ logAvgGDPpcStd * GDIStd, data = summaryIndex)
summary(lri2)

anova(lr2, lri2)

# Plotting purposes only
lri2_b <- lm(avgGenderDiffStd ~ GDIStd * logAvgGDPpcStd, data = summaryIndex)


plot(effect(term = "logAvgGDPpcStd:GDIStd", mod = lri2))
plot(effect(term = "GDIStd:logAvgGDPpcStd", mod = lri2_b))


# 1.3 Using the GGGI from WEF
# ---------------------------
lr3 <- lm(avgGenderDiffStd ~ logAvgGDPpcStd + ScoreWEFStd, data = summaryIndex)
summary(lr3)

# Create the linear model with interaction effects
lri3 <- lm(avgGenderDiffStd ~ logAvgGDPpcStd * ScoreWEFStd, data = summaryIndex)
summary(lri3)

anova(lr3, lri3)

# Plotting purposes only
lri3_b <- lm(avgGenderDiffStd ~ ScoreWEFStd * logAvgGDPpcStd, data = summaryIndex)


plot(effect(term = "logAvgGDPpcStd:ScoreWEFStd", mod = lri3))
plot(effect(term = "ScoreWEFStd:logAvgGDPpcStd", mod = lri3_b))

# All the models are telling a similar story:
# The interaction effect between economic development and gender equality increases
# the gender differences with an estimation between 0.15 and 0.22 std dev.
# In all the cases, we see that at below-the-average to average economic development,
# the gender equality of the country doesn't play a role (or it gives even a slight 
# negative contribution) to the gender differences in economic preferences.
# When the economic development starts to be above the average, we see that the 
# contribution of the gender equality starts to become bigger and bigger (the slope
# is steeper with higher gender equality index).
# Another interesting observation is that the models with interactions are more 
# coherent to each other: the GDI gives now some statistically significant p-value
# as for the other ,odels, and all have a similar magnitude:



#### 2. USING DIFFERENT ECONOMIC DEVELOPMENT INDEX ####
# =================================================== #
