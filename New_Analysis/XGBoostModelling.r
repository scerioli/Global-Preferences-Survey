############################ XGBOOST MODELLING #################################
# Trying to use some ML approach to data in order to improve (hopefully) our
# predictive power.

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
library(xgboost)
library(xgboostExplainer)
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



