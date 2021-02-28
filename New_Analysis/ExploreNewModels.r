############################  EXPLORE NEW MODELS  ##############################

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
# Set map first choice to rethinking package
map <- rethinking::map

# Define logit function
logit <- function(x) {
  log(x / (1 - x))
}

# Load the data
data_all <- LoadData()
# Load useful already standardized data
summaryIndex <- fread("files/output/main_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

data_all <- PrepareData(data_all)

# Standardize preferences at country level
data_all$data <- Standardize(data    = data_all$data, 
                             columns = c(5:10), 
                             level   = "country")

# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]

preferences <- c("posrecip", "altruism", "negrecip", 
                 "patience", "trust", "risktaking")

# Round the values of each preference and make them start from 0, to make them
#  simpler to analyse
for (pref in preferences) {
  dataComplete[, paste0(pref, "_round") := floor(eval(as.name(pref)) + 
                                                   abs(min(eval(as.name(pref)))) + 1)]
}


# ======================== #
#### 2. LOAD THE MODELS ####
# ======================== #

#### 2.1 Basic model with only gender as coefficient ####

models_posrecip_coeff <- fread("tmp/model_posrecip_gender_byCountry.csv")


# Extract the minimum and maximum gender coefficients
minCoeffGender <- models_posrecip_coeff[namesCoeff == "bG", .(coefficients, country)][order(coefficients)][1]
maxCoeffGender <- models_posrecip_coeff[namesCoeff == "bG", .(coefficients, country)][rev(order(coefficients))][1]

# Cambodia corresponds to the 11th element of the list --> min gender coeff
# Botswana corresponds to the 9th element --> max gender coeff
# Malawi corresponds to the 38th element --> min logAvgGDPpc
# Switzerland corresponds to the 59th element --> max logAvgGDPpc


# Let's plot it
post <- extract.samples(model_posrecip[[38]])

plot(1, 1, type = "n" , xlab = "posrecip" , ylab = "probability" ,
     xlim = c(0, 1), ylim = c(0, 1), xaxp = c(0, 1, 1), yaxp = c(0, 1, 2))

kG <- 0:1

for (s in 1:100) {
  p <- post[s, ]
  ak <- as.numeric(p[1:9])
  phi <- p$bG * kG
  pk <- pordlogit(1:9, a = ak, phi = phi)
  for (i in 1:9)
    lines(kG, pk[, i], col = col.alpha(rangi2, 0.1))
}
mtext(concat("gender = ", ifelse(kG == 0, "0 [male], ", "1 [female]")))


post <- extract.samples(m_posrecip_pred_tmp)

plot(1, 1, type = "n" , xlab = "posrecip" , ylab = "probability" ,
     xlim = c(0, 1), ylim = c(0, 1), xaxp = c(0, 1, 1), yaxp = c(0, 1, 2))

kG <- 0:1
pdat <- data.frame(gender = kG)
phi <- link(m_posrecip_pred_tmp, data = pdat)

post <- extract.samples(m_posrecip_pred_tmp)
for (s in 1:50) {
  pk <- pordlogit(1:9, phi[s, ], post$cutpoints[s, ])
  for (i in 1:9) {
    lines(kG , pk[, i], col = col.alpha(rangi2, 0.1))
  }
}

mtext(concat(" gender = ", ifelse(kG == 0, "0 [male], ", "1 [female]")))

sim <- rethinking::sim

kG <- 0:1
kSMS <- 0
pdat <- data.frame(gender = kG)
s <- sim(m_posrecip_pred_tmp, data = pdat, n = 1)
simplehist(s, xlab = "response")

#### 2.2 Model with subj_math_skills as ordered categorical predictor together with gender ####

dt_posrecip_gSMS <- fread("tmp/models_posrecip_SMS_gender_byCountry.csv")


dataToPlot <- merge(summaryIndex, models_posrecip_coeff, by = "country")

# ggplot(dataToPlot[namesCoeff == "bG"]) +
#   geom_histogram(aes(coefficients))
# 
# ggplot(dataToPlot[namesCoeff == "bG"]) +
#   geom_point(aes(x = logAvgGDPpc, y = coefficients, size = sd)) +
#   geom_smooth(aes(x = logAvgGDPpc, y = coefficients), method = "lm", color = "red")



####### OLD PART ######

# Plot the data
simplehist(dataComplete[country == "Botswana" & gender == 0, posrecip_round], xlab = "posrecip_round")
simplehist(dataComplete$altruism_round, xlab = "altruism_round")
simplehist(dataComplete$negrecip_round, xlab = "negrecip_round")
simplehist(dataComplete$patience_round, xlab = "patience_round")
simplehist(dataComplete$trust_round, xlab = "trust_round")
simplehist(dataComplete$risktaking_round, xlab = "risktaking_round")

# discrete proportion of each response value
pr_k <- table(dataComplete$posrecip_round) / nrow(dataComplete)
# cumsum converts to cumulative proportions
cum_pr_k <- cumsum(pr_k)
# plot
plot(1:9, cum_pr_k, type = "b", xlab = "posrecip",
     ylab = "cumulative proportion")


# Transform the data with logit function
lco <- logit(cum_pr_k)


# Create the model
m_posrecip <- map(alist(posrecip_round ~ dordlogit(phi, c(a1, a2, a3, a4, a5, a6, a7, a8)),
                        phi <- 0,
                        c(a1, a2, a3, a4, a5, a6, a7, a8) ~ dnorm(0, 10)),
                  data = dataComplete, 
                  start = list(a1 = -4, a2 = -3, a3 = -2, a4 = 0, a5 = 2, 
                               a6 = 3, a7 = 4, a8 = 4.5))

logistic(coef(m_posrecip))
precis(m_posrecip)

# Add the predictors
m_posrecip_pred <- map(alist(posrecip_round ~ dordlogit(phi, c(a1, a2, a3, a4, 
                                                               a5, a6, a7, a8)),
                             phi <- bG * gender,
                             c(bG) ~ dnorm(0, 10),
                             c(a1, a2, a3, a4, a5, a6, a7, a8) ~ dnorm(0, 10)),
                       data = dataComplete,
                       start = list(a1 = -9.83, a2 = -7.11, a3 = -4.98, a4 = -3.26,
                                    a5 = -1.64, a6 = -0.23, a7 = 1.63, a8 = 7.55))

# Add the prdered predictor
dataList <- list(posrecip_round = dataComplete$posrecip_round,
                 gender = dataComplete$gender,
                 SMS = dataComplete$subj_math_skills,
                 alpha = rep(2, 10))

m_posrecip_pred <- ulam(alist(posrecip_round ~ dordlogit(phi, kappa),
                              phi <- bSMS * sum(delta_j[1:SMS]) + bG * gender,
                              kappa ~ normal(0, 1.5),
                              c(bSMS, bG) ~ normal(0, 1),
                              vector[11]: delta_j <<- append_row(0, delta),
                              simplex[10]: delta ~ dirichlet(alpha)),
                        data = dataList, chains = 3, cores = 3)


