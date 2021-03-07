######################## DESCRIPTIVE ANALYIS - TRUST ###########################

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
# library(GGally)
# library(reshape2)
# library(lme4)
# require(compiler)
# require(parallel)
# require(boot)
# require(lattice)

# Load the data
data_all <- LoadData()


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

data_all <- PrepareData(data_all)

# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]

# Shift the values to have a scale of 0-10
dataComplete[, trustRaw := round(((trust - min(trust)) / 
                                    (max(trust) - min(trust))) * 10),
             by = "country"]

dataComplete[, logAvgGDPpc := log(avgGDPpc), by = "country"]
dataComplete[, avgGDPpc := NULL]


# ======================== #
#### 2. GENDER ANALYSIS ####
# ======================== #

# Define mean and standard error of the mean for each country and each gender
dataComplete[, mean_trust := mean(trustRaw, na.rm = T), 
             by = c("country", "gender")]
dataComplete[, sem_trust := sd(trustRaw, na.rm = T) / sqrt(.N), 
             by = c("country", "gender")]

# Weighted Linear Regression
Weighted_fit_m <- MASS::rlm(mean_trust ~ logAvgGDPpc,
                            data = dataComplete[gender == 0], 
                            weights = 1 / (sem_trust)^2)

Weighted_fit_f <- MASS::rlm(mean_trust ~ logAvgGDPpc,
                            data = dataComplete[gender == 1], 
                            weights = 1 / (sem_trust)^2)

# Add the predictions of the model to the data
dataComplete[gender == 0, pred := Weighted_fit_m$coefficients[[1]] + 
               logAvgGDPpc * Weighted_fit_m$coefficients[[2]],
             by = c("country")]
dataComplete[gender == 1, pred := Weighted_fit_f$coefficients[[1]] + 
               logAvgGDPpc * Weighted_fit_f$coefficients[[2]],
             by = c("country")]


# Prepare heat map base
nSample <-  dataComplete[, .N, by = c("country", "gender")]
nSample$total <- nSample$N
nSample$N <- NULL

x <- unique(dataComplete$country)
y <- min(dataComplete$trustRaw):max(dataComplete$trustRaw)
g <- unique(dataComplete$gender)
dataHeatMap <- expand.grid(country = x, Y = y, gender = g)

dataHeatMap <- merge(dataHeatMap, 
                     dataComplete[, .N, by = c("trustRaw", "country", "gender")],
                     by.x = c("Y", "country", "gender"), 
                     by.y = c("trustRaw", "country", "gender"))
# Make it a data table for comfortable use
setDT(dataHeatMap)
# Merge with sample
dataHeatMap[nSample, total := i.total, on = c("country", "gender")]
dataHeatMap[, fracN := N / total, by = c("country", "gender")]
# Set the variables to the correct format
dataHeatMap[, `:=` (Y       = as.factor(Y), 
                    country = as.character(country), 
                    fracN   = as.numeric(fracN),
                    gender  = as.numeric(gender))]
dataHeatMap[, `:=` (N = NULL, total = NULL)]
# Fill the missing data
for(C in unique(dataHeatMap$country)) {
  for (idx in unique(dataHeatMap$Y)) {
    for (G in unique(dataHeatMap$gender)) {
      if (nrow(dataHeatMap[country == C & Y == idx & gender == G]) == 0) {
        newRow <- data.table(Y = as.numeric(idx), 
                             country = as.character(C), 
                             fracN = as.numeric(0),
                             gender = as.numeric(G))
        dataHeatMap <- rbind(dataHeatMap, newRow)
      }
    }
  }
}

dataHeatMap[dataComplete, logAvgGDPpc := i.logAvgGDPpc, on = "country"]
dataHeatMap[dataComplete, mean_trust  := i.mean_trust, 
            on = c("country", "gender")]


# Prepare heat map for subjective math skills base
nSample <-  dataComplete[, .N, by = c("country", "gender")]
nSample$total <- nSample$N
nSample$N <- NULL

x <- unique(dataComplete$country)
y <- min(dataComplete$subj_math_skills):max(dataComplete$subj_math_skills)
g <- unique(dataComplete$gender)
dataHeatMap <- expand.grid(country = x, Y = y, gender = g)

dataHeatMap <- merge(dataHeatMap, 
                     dataComplete[, .N, by = c("subj_math_skills", "country", "gender")],
                     by.x = c("Y", "country", "gender"), 
                     by.y = c("subj_math_skills", "country", "gender"))
# Make it a data table for comfortable use
setDT(dataHeatMap)
# Merge with sample
dataHeatMap[nSample, total := i.total, on = c("country", "gender")]
dataHeatMap[, fracN := N / total, by = c("country", "gender")]
# Set the variables to the correct format
dataHeatMap[, `:=` (Y       = as.factor(Y), 
                    country = as.character(country), 
                    fracN   = as.numeric(fracN),
                    gender  = as.numeric(gender))]
dataHeatMap[, `:=` (N = NULL, total = NULL)]
# Fill the missing data
for(C in unique(dataHeatMap$country)) {
  for (idx in unique(dataHeatMap$Y)) {
    for (G in unique(dataHeatMap$gender)) {
      if (nrow(dataHeatMap[country == C & Y == idx & gender == G]) == 0) {
        newRow <- data.table(Y = as.numeric(idx), 
                             country = as.character(C), 
                             fracN = as.numeric(0),
                             gender = as.numeric(G))
        dataHeatMap <- rbind(dataHeatMap, newRow)
      }
    }
  }
}

dataHeatMap[dataComplete, logAvgGDPpc := i.logAvgGDPpc, on = "country"]
# dataHeatMap[dataComplete, mean_trust  := i.mean_trust, 
#             on = c("country", "gender")]


# ============= #
#### 3. PLOT ####
# ============= #

# Plot the mean and the standard error of the mean of each gender vs logGDP,
# together with the fitted weighted linear regression
mean_trust_errorbars <- ggplot(dataComplete, aes(x = logAvgGDPpc, y = mean_trust)) +
  geom_point(fill = "white") +
  geom_errorbar(aes(ymin = mean_trust - sem_trust, 
                    ymax = mean_trust + sem_trust), width = .05) +
  geom_line(aes(x = logAvgGDPpc, y = pred), col = "red") +
  xlab("Country") + ylab("Mean in Trust") + ylim(c(3, 7.5)) +
  facet_grid(~ gender)
# ggsave(filename = "New_Analysis/plots/mean_trust_errorbars.png", 
# plot = mean_trust_errorbars)

heatMap_trust_GDP <- ggplot(dataHeatMap, aes(x = reorder(country, logAvgGDPpc), 
                                             y = Y, fill = fracN)) +
  geom_tile() +
  geom_point(aes(x = reorder(country, logAvgGDPpc), y = mean_trust)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        legend.title = element_blank()) +
  xlab("Country (ordered by log GDP p/c)") + ylab("Trust") +
  scale_fill_gradient2(low = "white", high = "blue") +
  facet_grid(~ gender)
# ggsave(filename = "New_Analysis/plots/heatmap_trust_GDP.png", 
#        plot = heatMap_trust_GDP)

# Heat map ordered by mean_trust
heatMap_trust_mean_m <- 
  ggplot(dataHeatMap[gender == 0], aes(x = reorder(country, mean_trust), 
                                       y = Y, fill = fracN)) +
  geom_tile() +
  geom_point(aes(x = reorder(country, mean_trust), y = mean_trust)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        legend.position = "none") +
  xlab("Country (ordered by mean difference)") + ylab("Trust") +
  scale_fill_gradient2(low = "white", high = "blue")

heatMap_trust_mean_f <- 
  ggplot(dataHeatMap[gender == 1], aes(x = reorder(country, mean_trust), 
                                       y = Y, fill = fracN)) +
  geom_tile() +
  geom_point(aes(x = reorder(country, mean_trust), y = mean_trust)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        legend.title = element_blank()) +
  xlab("Country (ordered by mean difference)") +
  scale_fill_gradient2(low = "white", high = "blue")

together <- ggpubr::ggarrange(heatMap_trust_mean_m, heatMap_trust_mean_f)
# ggsave(filename = "New_Analysis/plots/heatmap_trust_mean.png",
#        plot = together)

dataToPlot <- dataHeatMap[gender == 0][dataHeatMap[gender == 1],
                                       meanFemale := i.mean_trust,
                                       on = "country"]

trust_mean_orderedMean <- 
  ggplot(dataToPlot[gender == 0]) +
  geom_point(aes(x = reorder(country, meanFemale), y = meanFemale)) +
  geom_point(aes(x = reorder(country, meanFemale), y = mean_trust), col = "red") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        legend.position = "none") +
  xlab("Country (ordered by mean difference)") + ylab("Trust")
# ggsave(filename = "New_Analysis/plots/trust_mean_orderedMean.png",
#        plot = trust_mean_orderedMean)


difference <- dataHeatMap[gender == 1][dataHeatMap[gender == 0], 
                                       .(diff = fracN - i.fracN,
                                         diffPerc = (fracN - i.fracN) / fracN,
                                         diffMean = mean_trust - i.mean_trust,
                                         Y = i.Y,
                                         logAvgGDPpc = i.logAvgGDPpc,
                                         country = i.country),
                                       on = c("country", "Y")]


difference <- difference[, maxDiff := max(abs(diff)), by = c("country")]

# Ordered by mean_trust only on one country
diff_trust_maxDiff <- ggplot(difference) +
  geom_point(aes(x = reorder(country, maxDiff), y = maxDiff)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  xlab("Country (ordered by absolute difference)") + ylab("")
# ggsave(filename = "New_Analysis/plots/diff_trust_maxDiff.png",
#        plot = diff_trust_maxDiff)

diff_heatmap_trust <- ggplot(difference) +
  geom_tile(aes(x = reorder(country, logAvgGDPpc), y = Y, fill = diff)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  scale_fill_gradient2(low = "blue", high = "red") +
  xlab("Country (ordered by logGDP p/c)") + ylab("")
# ggsave(filename = "New_Analysis/plots/diff_heatmap_trust.png",
#        plot = diff_heatmap_trust)

ggplot(difference, aes(x = reorder(country, logAvgGDPpc), y = Y, fill = diffPerc)) +
  geom_tile() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  xlab("Country (ordered by log GDP p/c)") + ylab("Trust") +
  scale_fill_gradient2(low = "blue", high = "red")




differenceSMS <- dataHeatMap[gender == 1][dataHeatMap[gender == 0], 
                                       .(diff = fracN - i.fracN,
                                         diffPerc = (fracN - i.fracN) / fracN,
                                         Y = i.Y,
                                         logAvgGDPpc = i.logAvgGDPpc,
                                         country = i.country),
                                       on = c("country", "Y")]


differenceSMS <- differenceSMS[, maxDiff := max(abs(diff)), by = c("country")]

diff_maxDiff_SMS <- ggplot(differenceSMS) +
  geom_point(aes(x = reorder(country, maxDiff), y = maxDiff)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  xlab("Country (ordered by absolute difference)") + ylab("")

ggsave(filename = "New_Analysis/plots/diff_maxDiff_subjMathSkills.png",
         plot = diff_maxDiff_SMS)

diff_heatmap_SMS <- ggplot(differenceSMS) +
  geom_tile(aes(x = reorder(country, logAvgGDPpc), y = Y, fill = diff)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  scale_fill_gradient2(low = "blue", high = "red") +
  xlab("Country (ordered by logGDP p/c)") + ylab("")
ggsave(filename = "New_Analysis/plots/diff_heatmap_subjMathSkills.png",
       plot = diff_heatmap_SMS)



ggplot(dataComplete[country == "Guatemala"], aes(x = trustRaw, fill = factor(gender))) +
  geom_histogram(aes(y = 0.5 * ..density..), position = "dodge")


ggplot(prova, aes(x = reorder(country, diffMean), 
                  y = diffMean)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  xlab("Country (ordered by mean difference)") + ylab("")


ggpairs(dataComplete[, c("gender", "subj_math_skills", "age")])

