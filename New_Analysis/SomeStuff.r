############################ DESCRIPTIVE ANALYIS ###############################

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


# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]


preferences <- c("posrecip", "altruism", "negrecip", 
                 "patience", "trust", "risktaking")

# Shift the values to have a scale of 0-10
dataComplete[, trustNew := round(((trust - min(trust)) / (max(trust) - min(trust))) * 10),
             by = "country"]



# Round the values of each preference and make them start from 0, to make them
#  simpler to analyse
for (pref in preferences) {
  dataComplete[, paste0(pref, "_round") := floor(eval(as.name(pref)) + 
                                                   abs(min(eval(as.name(pref)))) + 1)]
  dataComplete[, paste0("mean_", pref) := mean(eval(as.name(paste0(pref, "_round")))),
               by = c("country", "gender")]
  dataComplete[, paste0("sd_", pref) := sd(eval(as.name(paste0(pref, "_round")))),
               by = c("country", "gender")]
}


dataComplete[summaryIndex, logAvgGDPpc := i.logAvgGDPpc, on = "country"]
dataComplete[summaryIndex, isocode := i.isocode, on = "country"]

# Todo:
# - Descriptive analysis for each country: 
#   - Normalize number of men and women in sample, plot the different answers
#   - Quantify how much variety there is among men and among women of the same
#     country, and then among men and women in the same country, and then the
#     maximum differences and the differences in the min-max logGDPpc
# - train the model only gender on less data, do the same for linear regression
# - compare the results

ggplot(dataComplete, aes(x = posrecip_round, fill = factor(gender))) +
  geom_histogram(position = "dodge")


g0_m <- ggplot(dataComplete[gender == 0], aes(x = reorder(factor(country), mean_posrecip))) +
  geom_point(aes(y = pmean_posrecip), col = "dodgerblue") +
  #  scale_color_brewer(palette = "Set1")  +
  scale_x_reordered() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Country") + ylab("Mean in Pos. Recip.")

g1_m <- ggplot(dataComplete[gender == 1], aes(x = reorder(factor(country), mean_posrecip))) +
  geom_point(aes(y = mean_posrecip), col = "red") +
  #  scale_color_brewer(palette = "Set1")  +
  scale_x_reordered() +
  ylim(c(dataComplete[gender == 0, min(mean_posrecip)], dataComplete[gender == 0, max(mean_posrecip)])) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Country") + ylab("Mean in Pos. Recip.")

ggpubr::ggarrange(g0_m, g1_m, ncol = 2)

# Plot the SD of each gender ordered from min to max vs country

g0 <- ggplot(dataComplete[gender == 0], aes(x = reorder(factor(country), SDposrecip))) +
  geom_point(aes(y = SDposrecip), col = "dodgerblue") +
  #  scale_color_brewer(palette = "Set1")  +
  scale_x_reordered() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Country") + ylab("Standard Deviation in Pos. Recip.")

g1 <- ggplot(dataComplete[gender == 1], aes(x = reorder(factor(country), SDposrecip))) +
  geom_point(aes(y = SDposrecip), col = "red") +
  #  scale_color_brewer(palette = "Set1")  +
  scale_x_reordered() +
  ylim(c(dataComplete[gender == 0, min(SDposrecip)], dataComplete[gender == 0, max(SDposrecip)])) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Country") + ylab("Standard Deviation in Pos. Recip.")

ggpubr::ggarrange(g0, g1, ncol = 2)



# Plot the mean of each gender vs logGDP
ggplot(dataComplete, aes(x = logAvgGDPpc, y = mean_posrecip)) +
  geom_point(fill = "white") +
  geom_errorbar(aes(ymin = mean_posrecip - sd_posrecip, 
                    ymax = mean_posrecip + sd_posrecip), width = .05) +
  geom_line() +
  geom_smooth(method = "lm") +
  xlab("Country") + ylab("Mean in Pos. Recip.") +
  facet_wrap(~ gender)

ggplot(dataComplete, aes(x = logAvgGDPpc, y = mean_risktaking)) +
  geom_point(fill = "white") +
  geom_errorbar(aes(ymin = mean_risktaking - sd_risktaking, 
                    ymax = mean_risktaking + sd_risktaking), width = .05) +
  geom_line() +
  geom_smooth(method = "lm") +
  xlab("Country") + ylab("Mean in Risk Taking") +
  facet_wrap(~ gender)

ggplot(dataComplete, aes(x = logAvgGDPpc, y = mean_patience)) +
  geom_point(fill = "white") +
  geom_errorbar(aes(ymin = mean_patience - sd_patience, 
                    ymax = mean_patience + sd_patience), width = .05) +
  geom_smooth(method = "lm", col = "red") +
  xlab("Country") + ylab("Mean in Patience") +
  facet_wrap(~ gender)

ggplot(dataComplete, aes(x = logAvgGDPpc, y = mean_negrecip)) +
  geom_point(fill = "white") +
  geom_errorbar(aes(ymin = mean_negrecip - sd_negrecip, 
                    ymax = mean_negrecip + sd_negrecip), width = .05) +
  geom_smooth(method = "lm") +
  xlab("Country") + ylab("Mean in Neg. Recip.") +
  facet_wrap(~ gender)

ggplot(dataComplete, aes(x = logAvgGDPpc, y = mean_trust)) +
  geom_point(fill = "white") +
  geom_errorbar(aes(ymin = mean_trust - sd_trust, 
                    ymax = mean_trust + sd_trust), width = .05) +
  geom_smooth(method = "lm") +
  xlab("Country") + ylab("Mean in Trust") +
  facet_wrap(~ gender)

ggplot(dataComplete, aes(x = logAvgGDPpc, y = mean_altruism)) +
  geom_point(fill = "white") +
  geom_errorbar(aes(ymin = mean_altruism - sd_altruism, 
                    ymax = mean_altruism + sd_altruism), width = .05) +
  geom_smooth(method = "lm") +
  xlab("Country") + ylab("Mean in Altruism") +
  facet_wrap(~ gender)


# Create heatmap
nSample <-  dataComplete[, .N, by = c("country")]
nSample$total <- nSample$N
nSample$N <- NULL

# Males
x <- unique(dataComplete[gender == 0, country])
y <- min(dataComplete$trust_round):max(dataComplete$trust_round)
dataHeatMap_m <- expand.grid(country = x, Y = y)

dataHeatMap_m <- merge(dataHeatMap_m, 
                       dataComplete[gender == 0, .N, 
                                    by = c("trust_round", "country")],
                       by.x = c("Y", "country"), 
                       by.y = c("trust_round", "country"))

setDT(dataHeatMap_m)
dataHeatMap_m[nSample, total := i.total, on = "country"]
dataHeatMap_m[, fracN := N / total, by = c("country")]

dataHeatMap_m[, `:=` (Y = as.factor(Y), 
                      country = as.character(country), 
                      fracN = as.numeric(fracN))]
dataHeatMap_m[, `:=` (N = NULL, total = NULL)]

for(C in unique(dataHeatMap_m$country)) {
  for (idx in y) {
    if (nrow(dataHeatMap_m[country == C & Y == idx]) == 0) {
      newRow <- data.table(Y = as.numeric(idx), 
                           country = as.character(C), 
                           fracN = as.numeric(0))
      dataHeatMap_m <- rbind(dataHeatMap_m, newRow)
    }
  }
}

# Females
x <- unique(dataComplete[gender == 1, country])
y <- min(dataComplete$trust_round):max(dataComplete$trust_round)
dataHeatMap_f <- expand.grid(country = x, Y = y)

dataHeatMap_f <- merge(dataHeatMap_f, 
                       dataComplete[gender == 1, .N, 
                                    by = c("trust_round", "country")],
                       by.x = c("Y", "country"), 
                       by.y = c("trust_round", "country"))

setDT(dataHeatMap_f)
dataHeatMap_f[nSample, total := i.total, on = "country"]
dataHeatMap_f[, fracN := N / total, by = c("country")]

dataHeatMap_f[, `:=` (Y = as.factor(Y), 
                      country = as.character(country), 
                      fracN = as.numeric(fracN))]
dataHeatMap_f[, `:=` (N = NULL, total = NULL)]

for(C in unique(dataHeatMap_f$country)) {
  for (idx in y) {
    if (nrow(dataHeatMap_f[country == C & Y == idx]) == 0) {
      newRow <- data.table(Y = as.numeric(idx), 
                           country = as.character(C), 
                           fracN = as.numeric(0))
      dataHeatMap_f <- rbind(dataHeatMap_f, newRow)
    }
  }
}

dataHeatMap_m[summaryIndex, logAvgGDPpc := i.logAvgGDPpc, on = "country"]
dataHeatMap_f[summaryIndex, logAvgGDPpc := i.logAvgGDPpc, on = "country"]

dataHeatMap_m[dataComplete[gender == 0], mean_trust := i.mean_trust, on = "country"]
dataHeatMap_f[dataComplete[gender == 1], mean_trust := i.mean_trust, on = "country"]

rng = range(dataHeatMap_f$fracN, dataHeatMap_m$fracN)


male <- ggplot(dataHeatMap_m, aes(x = reorder(country, logAvgGDPpc), 
                                  y = Y, fill = fracN)) +
  geom_tile() +
  geom_point(aes(x = reorder(country, logAvgGDPpc), y = mean_trust)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = "none") +
  xlab("Country (ordered by mean difference)") + ylab("Trust") +
  scale_fill_gradient2(low = "white", high = "blue",
                       limits = c(floor(rng[1]), ceiling(rng[2])))

female <- ggplot(dataHeatMap_f, aes(x = reorder(country, logAvgGDPpc), 
                                    y = Y, fill = fracN)) +
  geom_tile() +
  geom_point(aes(x = reorder(country, logAvgGDPpc), y = mean_trust)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Country (ordered by mean difference)") + ylab("") +
  scale_fill_gradient2(low = "white", high = "blue",
                       limits = c(floor(rng[1]), ceiling(rng[2])))

ggpubr::ggarrange(male, female, ncol = 2)



male <- ggplot(dataHeatMap_m, aes(x = reorder(country, mean_trust), 
                                  y = Y, fill = fracN)) +
  geom_tile() +
  geom_point(aes(x = reorder(country, mean_trust), y = mean_trust)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position = "none") +
  xlab("Country (ordered by mean difference)") + ylab("Trust") +
  scale_fill_gradient2(low = "white", high = "blue",
                       limits = c(floor(rng[1]), ceiling(rng[2])))

female <- ggplot(dataHeatMap_f, aes(x = reorder(country, mean_trust), 
                                    y = Y, fill = fracN)) +
  geom_tile() +
  geom_point(aes(x = reorder(country, mean_trust), y = mean_trust)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("Country (ordered by mean difference)") + ylab("") +
  scale_fill_gradient2(low = "white", high = "blue",
                       limits = c(floor(rng[1]), ceiling(rng[2])))

ggpubr::ggarrange(male, female, ncol = 2)



ggplot(dataComplete[country %in% c("Afghanistan", "Germany") & gender == 1, .(country, trust_round)]) +
  geom_histogram(aes(x = trust_round, fill = factor(country)), position = "dodge")

ggplot(dataComplete[country %in% c("United States", "Cambodia") & gender == 0, .(country, trust_round)]) +
  geom_histogram(aes(x = trust_round, fill = factor(country)), position = "dodge")

ggplot(dataComplete[country %in% c("United Arab Emirates", "Malawi") & gender == 0, .(country, trust_round, gender)]) +
  geom_histogram(aes(x = trust_round, fill = factor(country)), position = "dodge")

# Plot the data
simplehist(dataComplete[gender == 1, posrecip_round], xlab = "posrecip_round")
simplehist(dataComplete[gender == 1, altruism_round], xlab = "altruism_round")
simplehist(dataComplete$negrecip_round, xlab = "negrecip_round")
simplehist(dataComplete$patience_round, xlab = "patience_round")
simplehist(dataComplete$trust_round, xlab = "trust_round")
simplehist(dataComplete$risktaking_round, xlab = "risktaking_round")
