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



# ======================= #
#### 2. DUMMY ANALYSIS ####
# ======================= #

#### Prepare Dummy Data ####
dataDummy <- dataComplete[country == "Afghanistan", 
                          .(gender, age, ageCateg, trustRaw, trustNumb, subj_math_skills, 
                            country, trust, language, region)]

# Split the data into train and test
index <- createDataPartition(dataDummy$trustRaw, p = 0.7, list = FALSE)

dummyTrain <- dataDummy[index, ]
dummyTest <- dataDummy[-index, ]


# Try out different models

#### Ordered Logistic Model ####
dummy_polr <- polr(trustRaw ~ gender*subj_math_skills + age, 
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
dummy_bayes <- brm(trustRaw ~ gender*subj_math_skills + age, 
                   data = dummyTrain,
                   family = cumulative("logit"), seed = 1)

dummy_bayes2 <- brm(trustRaw ~ gender*subj_math_skills + ageCateg, 
                    data = dummyTrain,
                    family = cumulative("logit"), seed = 1)

#### Linear ####
dumb <- lm(trustNumb ~ gender + subj_math_skills + age, data = dummyTrain)

#### Multilevel ####
# Need more studies, it is not clear how to achieve the goal of having country
# random effects
dumb_multi <- clmm(trustRaw ~ subj_math_skills + age + (1 | country), nominal = ~ gender,
                   data = dataComplete, link = "probit", threshold = "flexible")

dumb_multi2 <- clmm2(trustRaw ~ subj_math_skills + age, nominal = ~ gender,
                     data = dataComplete, link = "probit", threshold = "flexible")


# xgboost
library(xgboost)
library(xgboostExplainer)
# https://medium.com/applied-data-science/new-r-package-the-xgboost-explainer-51dd7d1aa211
# Thanks to David Foster!
set.seed(123)

dataDummy2 <- dataComplete[country == "Italy", 
                           .(gender, age, trustRaw, subj_math_skills)]

# Split the data into train and test
index <- createDataPartition(dataDummy2$trustRaw, p = 0.7, list = FALSE)

dummyTrain2 <- dataDummy2[index, ]
dummyTest2 <- dataDummy2[-index, ]

train_x <- model.matrix(~.+0, data = dummyTrain2[, -c("gender")], with = F)
train_y <- dummyTrain2$gender

test_x <- model.matrix(~.+0, data = dummyTest2[, -c("gender")], with = F)
test_y <- dummyTest2$gender

xgb_train <- xgb.DMatrix(data = train_x, label = train_y)
xgb_test <- xgb.DMatrix(data = test_x, label = test_y)

params <- list(booster = "gbtree", eta = 0.3, 
               gamma = 0, max_depth = 6, min_child_weight = 1, subsample = 1, 
               colsample_bytree = 1)

watchlist = list(train = xgb_train, test = xgb_test)

#fit XGBoost model and display training and testing data at each round
dummy_xgboost = xgb.train(data = xgb_train, nrounds = 100, watchlist = watchlist,
                          gamma = 3, max_depth = 2, min_child_weight = 1,
                          eta = 0.1, subsampla = 1)

#define final model
final = xgboost(data = xgb_train, max.depth = 2, gamma = 1, nrounds = 10, verbose = 0, eta = 0.3)

xgboost_predict <- predict(final, xgb_test)
pred_y = as.factor((levels(test_y))[round(xgboost_predict)])
confusionMatrix(pred_y, test_y)

#view variable importance plot
mat <- xgb.importance(feature_names = colnames(train_x), model = final)
xgb.plot.importance(importance_matrix = mat) 

explainer <- buildExplainer(final, xgb_train, type = "binary", base_score = 0.5)
pred.breakdown <- explainPredictions(final, explainer, xgb_test)

cat('Breakdown Complete','\n')
weights = rowSums(pred.breakdown)
pred.xgb = 1/(1+exp(-weights))
cat(max(xgboost_predict-pred.xgb),'\n')
idx_to_get = as.integer(200)
dummyTest2[idx_to_get]
showWaterfall(final, explainer, xgb_test, data.matrix(dummyTest2[, -c("gender")]),
              idx_to_get, type = "binary")
####### IMPACT AGAINST VARIABLE VALUE
plot(dummyTest2[, subj_math_skills], pred.breakdown[, subj_math_skills], 
     cex=0.4, pch=16, xlab = "Subj Math Skils", ylab = "Subj Math Skils impact on log-odds")
plot(dummyTest2[, age], pred.breakdown[, age], 
     cex=0.4, pch=16, xlab = "Age", ylab = "Age impact on log-odds")
cr <- colorRamp(c("blue", "red"))
plot(dummyTest2[,age], pred.breakdown[,age], 
   #  col = rgb(cr(dummyTest2[, gender]), max=255), 
     cex=0.4, pch=16, xlab = "Age", ylab = "Age impact on log-odds")

# cbind(orig = as.character(test_y),
#       factor = as.factor(test_y),
#       pred = xgboost_predict,
#       rounded = round(xgboost_predict),
#       pred = as.character(levels(test_y))[round(xgboost_predict)])


# ======================= #
#### 3. MODEL ANALYSIS ####
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
cumulativemodelfit(trustRaw ~ subj_math_skills*gender + ageCateg, data = dummyTrain)

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
#### 4. PREDICTION ANALYSIS ####
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



