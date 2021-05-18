############################## MULTILEVEL MODEL ################################
# We use Linear Mixed Model to predict on the same dataset and compare if,
# taking into account the hierarchy of the data, some information changes.

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
library(lme4)
library(optimx)
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

# Rescale the predictors
rescaled_vars <- c("subj_math_skills", "age")
dataComplete[, paste0(rescaled_vars, "_rescaled") := lapply(.SD, scale), .SDcols = rescaled_vars]


# ======================= #
#### 2. DUMMY ANALYSIS ####
# ======================= #


# Step 1: Random intercept
linear_multi <- lmer(trustNumb ~ 1 + (1 | country), REML = TRUE, data = dataComplete)

# Step 2: Random Slopes and Intercepts
# - Add the gender as Level One variable
linear_multi2 <- lmer(trustNumb ~ gender + (gender | country), data = dataComplete)
coef(summary(linear_multi2))[, "t value"]
# Gender t-value is almost 2 --> at the limit of commonly-used acceptability
# TODO: Would be nice to plot

# - Add the logGDP as a Level Two variable
linear_multi3 <- lmer(trustNumb ~ logAvgGDPpc + gender + logAvgGDPpc:gender + (gender | country), 
                      data = dataComplete)

# - Add the subjective math skills at Level One
linear_multi4 <- lmer(trustNumb ~ logAvgGDPpc + gender + subj_math_skills +
                        logAvgGDPpc:gender + subj_math_skills:gender + subj_math_skills:logAvgGDPpc +
                        (gender + subj_math_skills | country), 
                      data = dataComplete, 
                      control = lmerControl(
                        optimizer ='optimx', optCtrl = list(method = 'nlminb')))

# - Add the subjective math skills at Level One
linear_multi5 <- lmer(trustNumb ~ logAvgGDPpc + gender + subj_math_skills +
                        logAvgGDPpc:gender + subj_math_skills:gender + subj_math_skills:logAvgGDPpc +
                        (gender + subj_math_skills | country), 
                      data = dataComplete, 
                      control = lmerControl(
                        optimizer ='optimx', optCtrl = list(method = 'nlminb')))

# - Add the age: Only works with partial bayesian approach
# To "solve" the problem with the convergence, set the tolerance to larger values...
# Subjective math skills rescaled -- the only one working
linear_multi_bayes_rescaled <- blmer(trustNumb ~ logAvgGDPpc + gender + subj_math_skills_rescaled + ageCateg +
                                       logAvgGDPpc:gender + subj_math_skills_rescaled:gender
                                     + subj_math_skills_rescaled:logAvgGDPpc +
                                       (gender + subj_math_skills_rescaled + ageCateg | country),
                                     data = dataComplete,
                                     control = lmerControl(
                                       optimizer ='optimx', 
                                       optCtrl = list(method = 'nlminb'),
                                       check.conv.grad = .makeCC("warning", tol = 1e-2)))

# Add the rescaled age squared instead of simple rescaled age
linear_multi_bayes_rescaled2 <- blmer(trustNumb ~ logAvgGDPpc + gender + subj_math_skills_rescaled + 
                                        age_rescaled + I(age_rescaled^2) + logAvgGDPpc:gender + 
                                        subj_math_skills_rescaled:gender + subj_math_skills_rescaled:logAvgGDPpc +
                                        (gender + subj_math_skills_rescaled + age_rescaled + I(age_rescaled^2) | country),
                                      data = dataComplete,
                                      control = lmerControl(
                                        optimizer ='optimx', 
                                        optCtrl = list(method = 'nlminb'),
                                        check.conv.grad = .makeCC("warning", tol = 1e-2)))

# Some notes/ideas:
# - The model seems to be faster and happier if at least the age is either 
#   categorical or rescaled
# - Subjective math skills not rescaled make the model slower and failed to 
#   converge with tolerance = 0.002 --> Change tolerance, make it larger!
#   --> Still problem of optimx convergence code: 1 (none)
# - How to interpret the model result with the rescaled variables?
# - Add a prior to the model to improve it!!
# - Anova results show that the multi4 performs worse than the bayes (both of them),
#   and the bayes have the same score (as expected, but glad to see)
#   --> Still need to understand the differences between rescaled and not rescaled
# - Added the rescaled age squared instead of simple rescaled age --> seems similar
#   results as the split in 3 age categories, and the anova result is better
# NOTE: Rescaled != standardised!!! 


# Let's try the full bayesian approach
# This works! Check https://bookdown.org/marklhc/notes_bookdown/hierarchical-multilevel-models.html
# dummy_bayes <- brm(trustNumb ~ 1 + (1 | country), 
#                    data = dataComplete, 
#                    prior = c(
#                      prior(normal(5, 2), class = "Intercept"),
#                      prior(student_t(2, 0, 5), class = "sigma"),
#                      prior(gamma(2, 0.125), class = "sd", coef = "Intercept", group = "country")
#                    ),
#                    control = list(adapt_delta = .99))
# save(dummy_bayes, file = "tmp/files/dummy_bayes.RData")
load("tmp/files/dummy_bayes.RData")

# Interesting fact: Grouping by language instead of country results in an almost
# doubled ICC (0.14 vs 0.08)
# dummy_bayes2 <- brm(trustNumb ~ 1 + (1 | language), 
#                     data = dataComplete, 
#                     prior = c(
#                       prior(normal(5, 2), class = "Intercept"),
#                       prior(student_t(2, 0, 5), class = "sigma"),
#                       prior(gamma(2, 0.125), class = "sd", coef = "Intercept", group = "language")
#                     ),
#                     control = list(adapt_delta = .99))

# Whoever you are, I love you:
# https://kevinstadler.github.io/notes/bayesian-ordinal-regression-with-random-effects-using-brms/
# This lasted something like 10 hours...!
# This had no warning, no errors, nothing <3
# Saved in tmp/files
# dummy_bayes3 <- brm(trustRaw ~ gender + (gender | country),
#                     data = dataComplete,
#                     family = cumulative("logit"), file = "dummy_bayes3")
# 
# dummy_bayes4 <- brm(trustRaw ~ gender*logAvgGDPpc + (gender | country),
#                     data = dataComplete,
#                     family = cumulative("logit"), file = "dummy_bayes4",
#                     cores = 4, max_treedepth = 15)
# 
# dummy_bayes5 <- brm(trustRaw ~ gender*logAvgGDPpc + subj_math_skills + 
#                       subj_math_skills:gender + subj_math_skills:logAvgGDPpc +
#                       (gender + subj_math_skills | country),
#                     data = dataComplete,
#                     family = cumulative("logit"), file = "dummy_bayes5",
#                     cores = 4)


#### STATISTICAL RETHINKING ####
###  0. Ordered logit model ####

# Add 1 because having 0 is disturbing it
# Change from char to numeric
data <- list(trust = as.numeric(dataComplete$trustNumb) + 1,
             gender = dataComplete$gender,
             country = as.factor(dataComplete$country))
data$country <- as.numeric(data$country)

dummy_stat_reth <- ulam(
  alist(
    trust ~ dordlogit(phi, cutpoints),
    phi <- bG * gender,
    bG ~ dnorm(0, 0.5),
    cutpoints ~ dnorm(0, 1.5)),
  data = data,
  chains = 4)


##### Multilevel ####
### 1. Super simple model with only random intercept, to start with ####
dummy_stat_reth2 <- ulam(
  alist(
    trust ~ dordlogit(phi, cutpoints),
    phi <- bG[country] * gender,
    bG[country] ~ dnorm(bG_bar, sigmaG),
    cutpoints[country] ~ dnorm(cutpoints_bar, sigmacut),
    bG_bar ~ dnorm(0, 1.5),
    sigmaG ~dexp(1),
    cutpoints_bar ~ dnorm(0, 1.5),
    sigmacut ~ dexp(1)),
  data = data,
  chains = 4, log_lik = TRUE)

### 2. Adding the first slope ####
dummy_stat_reth3 <- ulam(
  alist(
    trust ~ dordlogit(phi, cutpoints),
    phi <- bG[country] * gender,
    bG[country] ~ dnorm(0, 0.5),
    cutpoints ~ dnorm(0, 1.5)),
  data = data,
  chains = 4)



# TODO: 
# - Finish the interpretation/to write the model
# - Add age (and language?)


# Interesting way to predict
iqrvec <- sapply(simulate(linear_multi4, 1000), IQR)
obsval <- IQR(dataComplete$trustNumb)
post.pred.p <- mean(obsval >= c(obsval, iqrvec))




