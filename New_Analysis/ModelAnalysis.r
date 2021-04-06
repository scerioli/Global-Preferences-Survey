######################### USE A NEW MODEL ON TRUST # ###########################
# Having fun applying the ordered logistic model with different predictors to
# identify those predictors with more power. 
# Trying to interpret the result of the model in a visual way (incomplete).

# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("~/Desktop/Projects/Global-Preferences-Survey/")

# Source helper functions
source("ReproductionAnalysis/functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "ReproductionAnalysis/functions/")
SourceFunctions(path = "ReproductionAnalysis/functions/helper_functions/")
SourceFunctions(path = "New_Analysis/functions/")

# Load libraries
LoadRequiredLibraries()
LoadLibrariesNewModels()
select <- dplyr::select
melt <- reshape2::melt

# Load the data
data_all <- LoadData()


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

data_all <- PrepareData(data_all)

# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]

# Add important column
dataComplete[, logAvgGDPpc := log(avgGDPpc), by = "country"]
dataComplete[, avgGDPpc := NULL]

# Adjust some of the columns and add new ones
dataComplete <- AdjustColumns(dataComplete)


# ======================= #
#### 2. MODEL ANALYSIS ####
# ======================= #

# What does influences the most the results on trust?

# Intercept only
model <- dlply(dataComplete, "country", function(dt)
  polr(trustRaw ~ 1, 
       data = dt, Hess = TRUE))
# Only gender
model_g <- dlply(dataComplete, "country", function(dt)
  polr(trustRaw ~ gender,
       data = dt, Hess = TRUE))
# Only subjective math skills
model_SMS <- dlply(dataComplete, "country", function(dt)
  polr(trustRaw ~ subj_math_skills,
       data = dt, Hess = TRUE))
# Gender and subjective math skills
model_gSMS <- dlply(dataComplete, "country", function(dt)
  polr(trustRaw ~ gender + subj_math_skills, 
       data = dt, Hess = TRUE))
# Gender, subjective math skills and age
model_gSMSa <- dlply(dataComplete, "country", function(dt)
  polr(trustRaw ~ gender + subj_math_skills + age,
       data = dt, Hess = TRUE))
# Gender, subjective math skills and age as category
model_gSMSaCat <- dlply(dataComplete, "country", function(dt)
  polr(trustRaw ~ gender + subj_math_skills + ageCateg, 
       data = dt, Hess = TRUE))
# Gender and age
model_ga <- dlply(dataComplete, "country", function(dt)
  polr(trustRaw ~ gender + age,
       data = dt, Hess = TRUE))


# Comparing the models
AIC_models <- Map(function(model, model_g, model_SMS, model_gSMS, model_ga, model_gSMSa, model_gSMSaCat)
  AIC(model, model_g, model_SMS, model_gSMS, model_ga, model_gSMSa, model_gSMSaCat),
  model, model_g, model_SMS, model_gSMS, model_ga, model_gSMSa, model_gSMSaCat)

# Extract the minimum AIC for each country to check which variables contribute
# the most overall
modelMinAIC <- ExtractModelMinAIC(AIC_models)

# How many countries have each model listed as minimum AIC?
ggplot(modelMinAIC) +
  geom_histogram(aes(modelMinAIC), stat = "count")
# How does the min AIC look like? (Consider that the countries outside the range
# are those with more and with less individuals in the survey)
ggplot(modelMinAIC, aes(x = country, y = minAIC)) +
  geom_point(aes(col = modelMinAIC)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

# Extract confident intervals from models
confint_g <- lapply(model_g, function(x) confint(x))
confint_gSMS <- lapply(model_gSMS, function(x) confint(x))
confint_gSMSaCat <- lapply(model_gSMSaCat, function(x) confint(x))

# Counts how many times GENDER is not including 0 (printing how many times it
# is relevant)
# Only gender model
inf_g <- lapply(confint_g, '[', 1)
sup_g <- lapply(confint_g, '[', 2)
containsZero_g <- inf_g <= 0 & sup_g >= 0
length(containsZero_g[containsZero_g != TRUE])
# Gender + subjective math skills
inf_gSMS <- lapply(confint_gSMS, '[', 1)
sup_gSMS <- lapply(confint_gSMS, '[', 3)
containsZero_gSMS <- inf_gSMS <= 0 & sup_gSMS >= 0
length(containsZero_gSMS[containsZero_gSMS != TRUE])
# Gender + subjective math skills + age
inf_gSMSaCat <- lapply(confint_gSMSaCat, '[', 1)
sup_gSMSaCat <- lapply(confint_gSMSaCat, '[', 5)
containsZero_gSMSaCat <- inf_gSMSaCat <= 0 & sup_gSMSaCat >= 0
length(containsZero_gSMSaCat[containsZero_gSMSaCat != TRUE])

# Counts how many times SUBJ MATH SKILLS is not including 0 (printing how many
# times it is relevant)
# Gender + subjective math skills
inf_gSMS <- lapply(confint_gSMS, '[', 2)
sup_gSMS <- lapply(confint_gSMS, '[', 4)
containsZero_gSMS <- inf_gSMS <= 0 & sup_gSMS >= 0
length(containsZero_gSMS[containsZero_gSMS != TRUE])
# Gender + subjective math skills + age
inf_gSMSaCat <- lapply(confint_gSMSaCat, '[', 2)
sup_gSMSaCat <- lapply(confint_gSMSaCat, '[', 6)
containsZero_gSMSaCat <- inf_gSMSaCat <= 0 & sup_gSMSaCat >= 0
length(containsZero_gSMSaCat[containsZero_gSMSaCat != TRUE])


# Counts how many times AGE is not including 0 (printing how many times it is 
# relevant)
# Gender + subjective math skills + age cat 2 vs 1
inf_gSMSaCat <- lapply(confint_gSMSaCat, '[', 3)
sup_gSMSaCat <- lapply(confint_gSMSaCat, '[', 7)
containsZero_gSMSaCat <- inf_gSMSaCat <= 0 & sup_gSMSaCat >= 0
length(containsZero_gSMSaCat[containsZero_gSMSaCat != TRUE])
# Gender + subjective math skills + age cat 3 vs 1
inf_gSMSaCat <- lapply(confint_gSMSaCat, '[', 4)
sup_gSMSaCat <- lapply(confint_gSMSaCat, '[', 8)
containsZero_gSMSaCat <- inf_gSMSaCat <= 0 & sup_gSMSaCat >= 0
length(containsZero_gSMSaCat[containsZero_gSMSaCat != TRUE])

# In general, the subjective math skill is relevant for almost all the countries
# (except for one/two) for what concerns the trust, while the gender influences
# even less than the age (25 non-zero vs. 35 non-zero).
# NOTE: I am still not sure if I want to use the age or age as categorical



# ============================= #
#### 3. MODEL INTERPRETATION ####
# ============================= #

# ------------- Still needs to be understood completely :/ ------------------- #

# Barplot of the probability
toPlot <- dataComplete[, .(trustRaw, gender, country)]
totalSample <- toPlot[, .N, by = .(gender, country)]
singleNumb <- toPlot[, .N, by = .(gender, trustRaw, country)]
singleNumb[totalSample, on = .(gender, country), fracN := N / i.N]

ggplot(singleNumb[country == "Germany"]) +
  geom_bar(aes(x = gender, y = fracN, fill = trustRaw), stat = "identity") +
  labs(title = singleNumb[country == "Germany", unique(country)])



# Interpreting the model & visualize the changes
newdat <- data.table(gender = factor(rep(0:1, 110)),
                     subj_math_skills = rep(0:10, each = 100))

new <- c()

for (i in 1:length(model_gSMSa)) {
  tmp <- cbind(newdat, predict(model_gSMS[[i]], newdat, type = "probs"),
               country = names(model_gSMS)[[i]])
  
  new <- rbind(new, tmp)
}


lnewdat <- melt(new, id.vars = c("gender", "subj_math_skills", "country"),
                variable.name = "Trust", value.name = "Probability")


setDT(lnewdat)
lnewdat[, Probability := strtrim(Probability, 8)]
lnewdat[, Probability := as.numeric(Probability)]
lnewdat[, gender := int(gender)]

set.seed(123)
randomSample <- lnewdat[sample(1:nrow(lnewdat), 8000), ]
setDT(randomSample)
randomSample[, Probability := strtrim(Probability, 8)]
randomSample[, Probability := as.numeric(Probability)]
randomSample[, gender := int(gender)]

ggplot(lnewdat[country %in% c("Italy")], 
       aes(x = subj_math_skills, y = Probability, col = Trust)) +
  geom_line(size = 1.5) +
  facet_wrap(~ gender)

ggplot(lnewdat[country %in% c("Russia")], 
       aes(x = gender, y = Probability, col = Trust)) +
  geom_line(size = 1.5) +
  facet_wrap(~ subj_math_skills, ncol = 5)


