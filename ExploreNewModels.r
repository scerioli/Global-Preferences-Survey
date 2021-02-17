#####################  ANALYSIS OF GLOBAL PREFERENCES  #########################

# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("~/Desktop/Projects/Global-Preferences-Survey/")

# Source helper functions
source("functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "functions/")
SourceFunctions(path = "functions/helper_functions/")

# Load libraries
LoadRequiredLibraries()

# Load the data
data_all <- LoadData()


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

map <- rethinking::map

# Plot the data
simplehist(dataComplete$posrecip, xlab = "posrecip")
simplehist(dataComplete$altruism, xlab = "altruism")
simplehist(dataComplete$negrecip, xlab = "negrecip")
simplehist(dataComplete$patience, xlab = "patience")
simplehist(dataComplete$trust, xlab = "trust")
simplehist(dataComplete$risktaking, xlab = "risktaking")

dataComplete[, posrecip_round := floor(posrecip) + 7]
# discrete proportion of each response value
pr_k <- table(dataComplete$posrecip_round) / nrow(dataComplete)
# cumsum converts to cumulative proportions
cum_pr_k <- cumsum(pr_k)
# plot
plot(1:9, cum_pr_k, type = "b", xlab = "posrecip",
     ylab = "cumulative proportion")

# Define logit function
logit <- function(x) {
  log(x / (1 - x))
}

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

precis(m_posrecip_pred)

# Let's plot it
post <- extract.samples(m_posrecip_pred)

plot(1, 1, type = "n" , xlab = "posrecip" , ylab = "probability" ,
     xlim=c(0,1) , ylim=c(0,1) , xaxp=c(0,1,1) , yaxp=c(0,1,2) )

kG <- 0:1

for (s in 1:100) {
  p <- post[s, ]
  ak <- as.numeric(p[1:9])
  phi <- p$bG*kG
  pk <- pordlogit(1:9, a = ak, phi = phi)
  for (i in 1:9)
    lines(kG, pk[, i], col = col.alpha(rangi2, 0.1))
}
mtext(concat(" gender = ", kG))

# What to do next:
# - divide by countries
# - find the coefficient for gender for each country
# - plot it vs the logGDPpc
# - what does this difference mean? How big is the effect? What is the overall
# variation of being male or female?
# - do it for all the preferences

