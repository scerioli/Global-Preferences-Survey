#################################### TOY MODEL #################################
# We compare different models on a subset of data to understand which model fits
# better for the type of our data. Using only trust as a response variable since
# this is the only variable that has only one Likert scale and had no 
# combination with other Likert scales.

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


# ============================= #
#### 2. CHECK DATA NORMALITY ####
# ============================= #

# Random choice of 5000 elements (max size for shapiro.test)
index <- createDataPartition(dataComplete$trust, p = 0.06, list = FALSE)
dataNorm1 <- dataComplete[index, ]

## Trust ####
shapiro.test(dataNorm1$trust)

## Altruism ####
shapiro.test(dataNorm1$altruism)

## Patience ####
shapiro.test(dataNorm1$patience)

## Positive Reciprocity ####
shapiro.test(dataNorm1$posrecip)

## Negative Reciprocity ####
shapiro.test(dataNorm1$negrecip)

## Risk Taking ####
shapiro.test(dataNorm1$risktaking)

# Results: p-value < 2.2e-16 for all the preferences
# Note: I checked that the sample distribution corresponds in shape to the 
# original one "by eyes"


# ======================= #
#### 3. DUMMY ANALYSIS ####
# ======================= #

#### Prepare Dummy Data ####
dataDummy <- dataComplete[country == "Italy", 
                          .(gender, age, ageCateg, trustRaw, trustNumb, subj_math_skills, 
                            country, trust, language, region)]

# Split the data into train and test
index <- createDataPartition(dataDummy$trustRaw, p = 0.7, list = FALSE)

dummyTrain <- dataDummy[index, ]
dummyTest <- dataDummy[-index, ]


# Try out different models

#### Ordered Logistic Model ####
dummy_polr_base <- polr(trustRaw ~ gender, 
                   data = dummyTrain, Hess = TRUE)

dummy_polr <- polr(trustRaw ~ gender*subj_math_skills + age, 
                   data = dummyTrain, Hess = TRUE)

dummy_polr2 <- polr(trustRaw ~ gender*subj_math_skills + gender*age, 
                    data = dummyTrain, Hess = TRUE)

dummy_polr3 <- polr(trustRaw ~ gender*subj_math_skills + gender*age + subj_math_skills*age, 
                   data = dummyTrain, Hess = TRUE)

#### Multinomial Logit Model ####
dummy_mlm <- multinom(trustRaw ~ subj_math_skills + gender + age,
                      data = dummyTrain, Hess = TRUE)

#### Multinomial Ordered Logit with Heteroskedasticity ####
dummy_oglm <- oglmx(trustNumb ~ subj_math_skills*gender + ageCateg, 
                    data = dummyTrain,
                    constantMEAN = FALSE, link = "probit", constantSD = FALSE, 
                    delta = 0, threshparam = NULL)

#### Partial Proportional Odds ####
dummy_ppo <- clm(trustRaw ~ subj_math_skills + age, nominal = ~ gender,
                 data = dummyTrain, link = "logit", threshold = "flexible")

dummy_ppo_min <- clm(trustRaw ~ 1,
                     data = dummyTrain, link = "logit", threshold = "flexible")

dummy_ppo2 <- clm(trustRaw ~ subj_math_skills*gender + age, nominal = ~ gender,
                  data = dummyTrain, link = "logit", threshold = "flexible")

dummy_ppo3 <- clm(trustRaw ~ subj_math_skills*gender + ageCateg, nominal = ~ gender,
                  data = dummyTrain, link = "logit", threshold = "flexible")
# To extract p-values from the summary: summary(dummy_ppo)[[6]]

#### Bayes Ordinal Regression ####
# dummy_bayes <- brm(trustRaw ~ gender*subj_math_skills + age, 
#                    data = dummyTrain,
#                    family = cumulative("logit"), seed = 1)
# 
# dummy_bayes2 <- brm(trustRaw ~ gender*subj_math_skills + ageCateg, 
#                     data = dummyTrain,
#                     family = cumulative("logit"), seed = 1)

#### Linear ####
dumb <- lm(trustNumb ~ gender + subj_math_skills + age, data = dummyTrain)


# dummy_bayes <- brm(trustNumb ~ logAvgGDPpc + gender +
#                      logAvgGDPpc:gender +
#                      (gender | country), 
#                    data = dataComplete, 
#                    family = "gaussian", seed = 1)

AIC(dummy_polr, dummy_mlm, dummy_oglm, dummy_ppo, dummy_ppo2, dummy_ppo3, dumb)


### Going multilevel 

# Step 1: Create the first multilevel model using only the random intercept and 
# grouping by the variable that might be significant for the level 2
dumb_multi <- clmm(trustRaw ~ 1 + (1 | country), 
                   data = dataComplete, link = "probit",
                   threshold = "flexible", Hess = TRUE)
# Then, I do the same but I exclude the grouping variable
dumb_nonmulti <- clm(trustRaw ~ 1, 
                     data = dataComplete, link = "probit",
                     threshold = "flexible", Hess = TRUE)
# Comparing the models, I see that including the country has an impact
anova(dumb_multi, dumb_nonmulti)

# Step 2: I add a variable that might be meaningful both on level 1 and on 
# level 2 . I used the language as an example, as it varies across individuals
# in the same countries
dumb_multi2 <- clmm(trustRaw ~ gender + subj_math_skills + (subj_math_skills | country), 
                    data = dataComplete,
                    link = "probit")


dumb_multi3 <- clmm(trustRaw ~ gender + subj_math_skills + age + (subj_math_skills + age | country), 
                    data = dataComplete,
                    link = "probit")



# ======================= #
#### 4. MODEL ANALYSIS ####
# ======================= #

# Many thanks to Kevin Stadler for this trick found here:
# https://kevinstadler.github.io/blog/bayesian-ordinal-regression-with-random-effects-using-brms/
cumulativemodelfit <- function(formula, data, 
                               links = c("logit", "probit", "cloglog", "cauchit"),
                               thresholds = c("flexible", "equidistant"),
                               verbose = TRUE) {
  names(links) <- links
  names(thresholds) <- thresholds
  llks <- outer(links, thresholds,
                Vectorize(function(link, threshold)
                  # catch error for responses with 2 levels
                  tryCatch(ordinal::clm(formula = formula, data = data, link = link, 
                                        threshold = threshold)$logLik,
                           error = function(e) NA)))
  print(llks)
  if (verbose) {
    bestfit <- which.max(llks)
    cat("\nThe best link function is ", links[bestfit %% length(links)], " with a ",
        thresholds[1 + bestfit %/% length(thresholds)], " threshold (logLik ", llks[bestfit],
        ")\n", sep = "")
  }
  invisible(llks)
}

# Choose the best link function and thresholds
cumulativemodelfit(trustRaw ~ subj_math_skills*gender + age, data = dummyTrain)

# Compare the models
# NOTE: linear models can't be compared because they lack AIC
AIC(dummy_polr, dummy_mlm, dummy_oglm, dummy_ppo, dummy_ppo2, dummy_ppo3)

# Test if ordered logit and multinomial models can be seen as "the same" model
# - if p-value is small, mlm != polr --> better to use mlm because it is more
#   flexible and hence it reflects better our data
# - if p-value is big --> hard to say if polr and mlm are different models, you
#   can keep polr for it is simpler
(G <- -2 * (logLik(dummy_polr)[1] - logLik(dummy_mlm)[1]))
pchisq(G, 3, lower.tail = FALSE)


# Why using a ppo assumption:
# here gender is significant and must be treated with flexible threshold
nominal_test(clm(trustRaw ~ subj_math_skills + gender + age,
                 data = dummyTrain, link = "logit"))
scale_test(clm(trustRaw ~ subj_math_skills + gender + age,
               data = dummyTrain, link = "logit"))



# ============================ #
#### 5. PREDICTION ANALYSIS ####
# ============================ #

# Predictions

dumb_predict_polr <- predict(dummy_polr, type = "class")
table(dummyTrain$trustNumb, dumb_predict_polr)

dumb_predict_ppo <- predict(dummy_ppo, newdata = dummyTest, type = "class")
tab <- table(dumb_predict_ppo$fit, dummyTest$trustNumb)
sum(diag(tab)) / sum(tab)

dumb_predict_ppo2 <- predict(dummy_ppo2, newdata = dummyTest, type = "class")
table(dumb_predict_ppo2$fit, dummyTest$trustNumb)

dumb_predict_lm <- predict(dumb, newdata = dummyTest, type = "response")
tab <- table(as.integer(dumb_predict_lm), dummyTest$trustNumb)
sum(diag(tab)) / sum(tab)



dummy_coef <- data.table(coef(summary(dummy_polr)))
dummy_or <- exp(coef(dummy_polr))

stargazer(dummy_polr, type = "text", coef = list(dummy_or), p.auto = F, out = "dummy.htm")

mlm_coef = exp(coef(mlm))

stargazer(mlm, type = "text", coef = list(mlm_coef), p.auto = F, out = "dummy3.htm")

z <- summary(mlm)$coefficients/summary(mlm)$standard.errors

p <- (1 - pnorm(abs(z), 0, 1)) * 2

head(pp <- fitted(mlm))

# We check the accuracy
dummyTrain$trustPredicted <- predict(mlm, newdata = dummyTrain, "class")
# Building classification table
tab <- table(dummyTrain$trustRaw, dummyTrain$trustPredicted)
# Calculating accuracy - sum of diagonal elements divided by total obs
round((sum(diag(tab))/sum(tab)) * 100, 2)



