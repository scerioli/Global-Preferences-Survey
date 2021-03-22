######################### USE A NEW MODEL ON TRUST # ###########################

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
library(MASS)
library(lmtest)
require(GGally)
require(reshape2)
require(lme4)
require(compiler)
require(parallel)
require(boot)
require(lattice)
select <- dplyr::select
melt <- reshape2::melt

# Load the data
data_all <- LoadData()
genderIndicators <- fread("tmp/GenderBias.csv")
OECDlist <- fread("tmp/OECD_countries.csv")


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

data_all <- PrepareData(data_all)

# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]
dataComplete[genderIndicators, `:=` (explicit = i.Explicit,
                                     implicit = i.Implicit), on = "country"]
dataComplete[OECDlist, OECDmember := TRUE, on = "country"]
dataComplete[is.na(OECDmember), OECDmember := FALSE]

# Shift the values to have a scale of 0-10
dataComplete[, trustRaw := round(((trust - min(trust)) / 
                                    (max(trust) - min(trust))) * 10),
             by = "country"]

dataComplete[, logAvgGDPpc := log(avgGDPpc), by = "country"]
dataComplete[, avgGDPpc := NULL]

# Define mean and standard error of the mean for each country and each gender
dataComplete[, mean_trust := mean(trustRaw, na.rm = T), 
             by = c("country", "gender")]
dataComplete[, sem_trust := sd(trustRaw, na.rm = T) / sqrt(.N), 
             by = c("country", "gender")]

dataComplete[, `:=` (trustRaw = as.factor(trustRaw),
                     gender = as.factor(gender),
                     age = as.numeric(age))]

# Add the age as category
dataComplete[age <= 32, ageCateg := 1]
dataComplete[age > 32 & age <= 53, ageCateg := 2]
dataComplete[age > 53, ageCateg := 3]

dataComplete[, ageCateg := as.factor(ageCateg)]



# ======================= #
#### 2. MODEL ANALYSIS ####
# ======================= #

# What does influences the results on trust?
# TODO: 
# - Table to summarise the odds
# - Compare predicted and observed odds

# Intercept only
model <- dlply(dataComplete, "country", function(dt)
  polr(trustRaw ~ 1, 
       data = dt, Hess = TRUE))
# Only gender
# model_g <- dlply(dataComplete, "country", function(dt)
#   polr(trustRaw ~ gender, 
#        data = dt, Hess = TRUE))
# Gender and subjective math skills
model_gSMS <- dlply(dataComplete, "country", function(dt)
  polr(trustRaw ~ gender + subj_math_skills, 
       data = dt, Hess = TRUE))
# Gender, subjective math skills and age
# model_gSMSa <- dlply(dataComplete, "country", function(dt)
#   polr(trustRaw ~ gender + subj_math_skills + age, 
#        data = dt, Hess = TRUE))
# Gender, subjective math skills and age as category
model_gSMSaCat <- dlply(dataComplete, "country", function(dt)
  polr(trustRaw ~ gender + subj_math_skills + ageCateg, 
       data = dt, Hess = TRUE))
# Gender and age
# model_ga <- dlply(dataComplete, "country", function(dt)
#   polr(trustRaw ~ gender + age, 
#        data = dt, Hess = TRUE))

# Linear model (trustRaw must be converted to numeric otherwise it gives problems)
# linear_model <- dlply(dataComplete[, trustRaw := as.numeric(trustRaw)], "country", 
#                       function(dt)
#                         lm(trustRaw ~ gender + subj_math_skills + age + I(age^2), 
#                            data = dt))

# Comparing the models
AIC_models <- Map(function(intercepts, genderSMS, genderSMSageCateg)
  AIC(intercepts, genderSMS, genderSMSageCateg), 
  model, model_gSMS, model_gSMSaCat)

# Linear model can't be compared
LRtest <- Map(function(intercepts, genderSMS, genderSMSageCateg)
  lrtest(intercepts, genderSMS, genderSMSageCateg), 
  model, model_gSMS, model_gSMSaCat)

i <- 1
for (lr in LRtest) {
  dt_lr <- data.table(country = names(LRtest)[i],
                      model = c("Intercepts", 
                                "Gender + SMS",
                                "Gender + SMS + AgeCat"))
  lr <- as.data.table(LRtest[[i]])
  new <- cbind(dt_lr, lr)
  fwrite(new, file = "LRtest.csv", append = T)
  i <- i + 1
}

plotLR <- fread("LRtest.csv")


# Extract confident intervals from models
confint_g <- lapply(model_g, function(x) confint(x))
confint_gSMS <- lapply(model_gSMS, function(x) confint(x))
confint_gSMSa <- lapply(model_gSMSa, function(x) confint(x))
confint_linear <- lapply(linear_model, function(x) confint(x))

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
inf_gSMSa <- lapply(confint_gSMSa, '[', 1)
sup_gSMSa <- lapply(confint_gSMSa, '[', 4)
containsZero_gSMSa <- inf_gSMSa <= 0 & sup_gSMSa >= 0
length(containsZero_gSMSa[containsZero_gSMSa != TRUE])
# Linear model
inf_linear <- lapply(confint_linear, '[', 2)
sup_linear <- lapply(confint_linear, '[', 6)
containsZero_linear <- inf_linear <= 0 & sup_linear >= 0
length(containsZero_linear[containsZero_linear != TRUE])

# Counts how many times SUBJ MATH SKILLS is not including 0 (printing how many
# times it is relevant)
# Gender + subjective math skills
inf_gSMS <- lapply(confint_gSMS, '[', 2)
sup_gSMS <- lapply(confint_gSMS, '[', 4)
containsZero_gSMS <- inf_gSMS <= 0 & sup_gSMS >= 0
length(containsZero_gSMS[containsZero_gSMS != TRUE])
# Gender + subjective math skills + age
inf_gSMSa <- lapply(confint_gSMSa, '[', 2)
sup_gSMSa <- lapply(confint_gSMSa, '[', 4)
containsZero_gSMSa <- inf_gSMSa <= 0 & sup_gSMSa >= 0
length(containsZero_gSMSa[containsZero_gSMSa != TRUE])
# Linear model
inf_linear <- lapply(confint_linear, '[', 3)
sup_linear <- lapply(confint_linear, '[', 7)
containsZero_linear <- inf_linear <= 0 & sup_linear >= 0
length(containsZero_linear[containsZero_linear != TRUE])

# Counts how many times AGE is not including 0 (printing how many times it is 
# relevant)
# Gender + subjective math skills + age
inf_gSMSa <- lapply(confint_gSMSa, '[', 3)
sup_gSMSa <- lapply(confint_gSMSa, '[', 6)
containsZero_gSMSa <- inf_gSMSa <= 0 & sup_gSMSa >= 0
length(containsZero_gSMSa[containsZero_gSMSa != TRUE])
# Linear model
inf_linear <- lapply(confint_linear, '[', 4)
sup_linear <- lapply(confint_linear, '[', 8)
containsZero_linear <- inf_linear <= 0 & sup_linear >= 0
length(containsZero_linear[containsZero_linear != TRUE])

# In general, the subjective math skill is relevant for almost all the countries
# (except for one/two) for what concerns the trust, while the gender influences
# even less than the age (25 non-zero vs. 35 non-zero).



# What about plotting the gender coefficient for the new model as they did, 
# and see the difference to what they have with the linear model?

dt_coefficients <- c()

# Extract gender coefficient from linear model
for (i in 1:length(linear_model)) {
  dt_tmp <- data.table(country = names(linear_model)[[i]],
                       genderCoeff = coef(linear_model[[i]])[[2]],
                       SMSCoeff = coef(linear_model[[i]])[[3]],
                       ageCoeff = coef(linear_model[[i]])[[4]],
                       inf_g = inf_linear[[i]],
                       sup_g = sup_linear[[i]],
                       modelType = "linear")
  dt_coefficients <- rbind(dt_coefficients, dt_tmp)
}

# Extract gender coefficient from ordered logit model
for (i in 1:length(model_gSMSa)) {
  dt_tmp <- data.table(country = names(model_gSMSa)[[i]],
                       genderCoeff = coef(model_gSMSa[[i]])[[1]],
                       SMSCoeff = coef(model_gSMSa[[i]])[[2]],
                       ageCoeff = coef(model_gSMSa[[i]])[[3]],
                       inf_g = inf_gSMSa[[i]],
                       sup_g = sup_gSMSa[[i]],
                       modelType = "ordlog")
  dt_coefficients <- rbind(dt_coefficients, dt_tmp)
}

dataToPlot <- dt_coefficients[dataComplete, `:=` (logAvgGDPpc = i.logAvgGDPpc,
                                                  isocode = i.isocode,
                                                  implicit = i.implicit,
                                                  explicit = i.explicit), 
                              on = "country"]
dataToPlot[data_all$world_area, `:=` (area =i.region,
                                      personal = i.personal,
                                      telephone = i.telephone),
           on = "country"]

ggplot(dataToPlot, aes(x = logAvgGDPpc, y = genderCoeff)) +
  geom_point(aes(x = logAvgGDPpc, y = genderCoeff)) +
  geom_errorbar(aes(ymin = genderCoeff - abs(inf_g), 
                    ymax = genderCoeff + abs(sup_g)), width = .05) +
  xlab("log GDP p/c") + ylab("Gender Coefficient") +
  facet_grid(~ modelType)

ggplot(dataToPlot) +
  geom_point(aes(x = logAvgGDPpc, y = SMSCoeff)) +
  facet_wrap(~ modelType)

PlotSummary(data = dataToPlot[!is.na(implicit)], var1 = "logAvgGDPpc", var2 = "genderCoeff",
            fill = "personal",
           # var3 = "modelType",
            regression = TRUE, display = T)

# What about the average age within the dataset?
dataComplete[, meanAge := as.numeric(mean(age)), by = c("country", "gender")]

ggplot(dataComplete[, .(logAvgGDPpc, meanAge, gender, country)]) +
  geom_point(aes(x = logAvgGDPpc, y = meanAge)) +
  geom_smooth(aes(x = logAvgGDPpc, y = meanAge), method = "lm") +
  facet_grid(~ gender)


PlotSummary(data = dataComplete, var1 = "logAvgGDPpc", var2 = "meanAge",
            var3 = "gender",
            regression = TRUE, display = F, 
            save = "New_Analysis/plots/trust_logGDP_meanAge.png")

# The age is higher for the more developed countries, and the age of female is 
# higher with respect to the male age for more developed countries.
# Can this explain the differences?
# What about subjective math skills?

dataComplete[, meanSMS := mean(subj_math_skills), by = c("country", "gender")]

ggplot(dataComplete[, .(logAvgGDPpc, meanSMS, gender, country)]) +
  geom_point(aes(x = logAvgGDPpc, y = meanSMS)) +
  geom_smooth(aes(x = logAvgGDPpc, y = meanSMS), method = "lm") +
  facet_grid(~ gender)


# Let's try another model: Mixed Effects Logistic Regression
# Model with gender and subjective math skills as level
# categorical predictor, and age with a random intercept
glme_gSMSa <- glmer(trustRaw ~ gender + subj_math_skills + age + (1 | country) + (1 | region),
                    data = dataComplete, family = binomial,
                    control = glmerControl(optimizer = "bobyqa"),
                    nAGQ = 1)


lattice::dotplot(ranef(glme_gSMSa, which = "country", condVar = TRUE))
lattice::dotplot(ranef(glme_gSMSa, which = "region", condVar = TRUE))

se <- sqrt(diag(vcov(glme_gSMSa)))
# table of estimates with 95% CI
tab <- cbind(Est = fixef(glme_gSMSa), LL = fixef(glme_gSMSa) - 1.96 * se, 
             UL = fixef(glme_gSMSa) + 1.96 *se)


# ============================= #
#### 3. MODEL INTERPRETATION ####
# ============================= #

# Barplot of the probability
prova <- dataComplete[, .(trustRaw, gender, country)]
totalSample <- prova[, .N, by = .(gender, country)]
singleNumb <- prova[, .N, by = .(gender, trustRaw, country)]
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

ggplot(lnewdat[country %in% c("Russia")], 
       aes(x = gender, y = Probability, col = Trust)) +
  geom_line() +
  facet_wrap(~ subj_math_skills)

prova <-randomSample
setkey(prova, gender, country)
prova[, diff := Probability - shift(Probability, fill = max(Probability)), by = gender]

