########################### DESCRIPTIVE ANALYIS ################################
# Using the response variable "trust" raw (meaning, with no standardization), 
# we try to visualize in different ways the peculiarities of the countries in
# terms of gender, subjective math skills and age.

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



# ======================== #
#### 2. GENDER ANALYSIS ####
# ======================== #

# Define mean and standard error of the mean for each country and each gender
dataComplete[, mean_trust := mean(trustNumb, na.rm = T), 
             by = c("country", "gender")]
dataComplete[, sem_trust := sd(trustNumb, na.rm = T) / sqrt(.N), 
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


# Total number of people per country
dataComplete[, total := .N, by = .(country)]
# Total number of men and women per country
dataComplete[, totalGender := .N, by = .(country, gender)]
# Calculate the fraction of people who chose a certain preference in a certain
# country, and its sigma (divided by 2 is because we wanted to normalize by all 
# people, otherwise the fraction is only referred to men and women separately)
dataComplete[, fracN := .N / unique(totalGender) / 2, 
             by = .(gender, trustRaw, country)]
dataComplete[, sigmaTrustGender := sqrt(.N) / unique(totalGender) / 2, 
             by = .(country, gender, trustRaw)]

# Create the heat map data-set for the trust
dataHeatMapTrust <- CreateHeatMap(dataComplete, "country", "trustNumb", "gender")
setnames(dataHeatMapTrust, c("X", "Y", "Z"), c("country", "trust", "gender"))
# Merge information about logGDP and mean
dataHeatMapTrust[dataComplete, logAvgGDPpc := i.logAvgGDPpc, on = "country"]
dataHeatMapTrust[dataComplete, mean_trust  := i.mean_trust, 
                 on = c("country", "gender")]

# Create the data-set for the difference between women and men on trust
differenceTrust <- dataHeatMapTrust[gender == 1][dataHeatMapTrust[gender == 0], 
                                                 .(diff = fracN - i.fracN,
                                                   diffPerc = (fracN - i.fracN) / fracN,
                                                   sigmaDiff = sqrt(sigmaN^2 + i.sigmaN^2),
                                                   diffMean = mean_trust - i.mean_trust,
                                                   trust = i.trust,
                                                   logAvgGDPpc = i.logAvgGDPpc,
                                                   country = i.country),
                                                 on = c("country", "trust")]
# Define the maximum and the magnitude of the differences by country
differenceTrust[, maxDiff := max(abs(diff)), by = "country"]
differenceTrust[, magnitude := sum(abs(diff)) / 2, by = "country"]
# Merge the error on single bins for trust
differenceTrust[dataComplete, sigmaTrustGender := i.sigmaTrustGender, 
                on = c("country == country", "trust == trustRaw")]


# Create heat map for the subjective math skills
dataHeatMapSMS <- CreateHeatMap(dataComplete, "country", "subj_math_skills", "gender")
setnames(dataHeatMapSMS, c("X", "Y", "Z"), c("country", "subj_math_skills", "gender"))
dataHeatMapSMS[dataComplete, logAvgGDPpc := i.logAvgGDPpc, on = "country"]

differenceSMS <- dataHeatMapSMS[gender == 1][dataHeatMapSMS[gender == 0], 
                                             .(diff = fracN - i.fracN,
                                               diffPerc = (fracN - i.fracN) / fracN,
                                               sigmaDiff = sqrt(sigmaN^2 + i.sigmaN^2),
                                               subj_math_skills = i.subj_math_skills,
                                               logAvgGDPpc = i.logAvgGDPpc,
                                               country = i.country),
                                             on = c("country", "subj_math_skills")]
# Define the maximum and the magnitude of the differences by country
differenceSMS[, maxDiff := max(abs(diff)), by = "country"]
differenceSMS[, magnitude := sum(abs(diff)) / 2, by = "country"]



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

heatMap_trust_GDP <- ggplot(dataHeatMapTrust, aes(x = reorder(country, logAvgGDPpc), 
                                                  y = trust, fill = fracN)) +
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
  ggplot(dataHeatMapTrust[gender == 0], aes(x = reorder(country, mean_trust), 
                                            y = trust, fill = fracN)) +
  geom_tile() +
  geom_point(aes(x = reorder(country, mean_trust), y = mean_trust)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        legend.position = "none") +
  xlab("Country (ordered by mean difference)") + ylab("Trust") +
  scale_fill_gradient2(low = "white", high = "blue")

heatMap_trust_mean_f <- 
  ggplot(dataHeatMapTrust[gender == 1], aes(x = reorder(country, mean_trust), 
                                            y = trust, fill = fracN)) +
  geom_tile() +
  geom_point(aes(x = reorder(country, mean_trust), y = mean_trust)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5),
        legend.title = element_blank()) +
  xlab("Country (ordered by mean difference)") +
  scale_fill_gradient2(low = "white", high = "blue")

together <- ggpubr::ggarrange(heatMap_trust_mean_m, heatMap_trust_mean_f)
# ggsave(filename = "New_Analysis/plots/heatmap_trust_mean.png",
#        plot = together)


# Ordered by mean_trust only on one country
diff_trust_maxDiff <- ggplot(differenceTrust) +
  geom_point(aes(x = reorder(country, maxDiff), y = maxDiff)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  xlab("Country (ordered by absolute difference)") + ylab("Difference in trust")
# ggsave(filename = "New_Analysis/plots/diff_trust_maxDiff.png",
#        plot = diff_trust_maxDiff)

diff_heatmap_trust <- ggplot(differenceTrust) +
  geom_tile(aes(x = reorder(country, magnitude), y = trust, fill = diff)) +
  scale_fill_gradient2(low = "blue", high = "red", 
                       #limits = c(-0.065, 0.065)
  ) +
  labs(fill = "Difference") +
  xlab("Country") + ylab("Trust") +
  theme_bw(base_size = 15) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 15),
        axis.text.y = element_text(size = 15))
# ggsave(filename = "New_Analysis/plots/diff_heatmap_trust.png",
#        plot = diff_heatmap_trust)

ggplot(differenceTrust) +
  geom_point(aes(x = reorder(country, logAvgGDPpc), y = maxDiff)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  xlab("Country (ordered by absolute difference)") + ylab("Difference in Trust")

ggplot(differenceTrust) +
  geom_tile(aes(x = reorder(country, logAvgGDPpc), y = trust, fill = diff)) +
  xlab("Country (ordered by log GDP p/c)") + ylab("Trust") +
  scale_fill_gradient2(low = "blue", high = "red") +
  theme_bw(base_size = 15) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 15),
        axis.text.y = element_text(size = 15))

# What do these differences mean?
# Let's take a simple example: we have a uniform distribution (that means, no
# differences between men and women's trust choices) of 100 individuals.
# This is 10 people for each of the 11 categories. The mean in this case is 5.
# > (10*(sum(0:10))) / 110 
# [1] 5
# If we now suppose that one person changes their preference in trust for 
# whatever reason, transforming themselves from a very suspicious person to a 
# super trusty one (so changing their preference from 0 to 10), we will have a
# shift in the mean of ~1.8% 
# > (10*(sum(1:9)) + 11*10) / 110 
# [1] 5.090909
# If we now assume instead that there are 100 women with uniform distribution
# and 100 men with uniform distribution, and 1 woman chooses an extreme value
# of trust of 10, and 1 man chooses instead 0, we will have:
# mean of the women: (10*(sum(0:9)) + 11*10) / 111 = 5.045045
# mean of men: (10*(sum(1:10))) / 111 = 4.954955
# (incomplete because we realized we are not treating the mean)
# 
# If we see a difference in magnitude that is around 8%, for 1000 people it 
# means that we see 80 people outside the uniform distribution (again I take
# the example of the uniform distribution for simplicity, it can be whatever
# distribution with no differences between men and women).
# These 80 people who are choosing different values for men and women must be 
# related to the random variance of the sample of the population.
# If we assume in a simplicistic way that we have a variance on each single 
# bin that is the square root of the number of people in the bin, having our
# uniform distribution with 1000 people in total distributed among 11 bins, it
# ends up being sqrt(1000/11) = 9.534626. So around 9 people in each bin are
# allowed to vary without changing the assumption on the distribution.
# So if we now calculate it for each bin, we can compare the difference seen.


diff <- ggplot(differenceTrust[country == "Russia"], aes(x = trust, y = diff)) + 
  geom_bar(position = position_dodge(), stat = "identity") +
  geom_errorbar(aes(ymin = diff - sigmaDiff/2, ymax = diff + sigmaDiff/2),
                width = .2,
                position = position_dodge(.9))

# Fraction of men and women choosing trust with error bars
hist <- ggplot(dataComplete[country == "Russia"], 
               aes(x = factor(trustRaw), y = fracN, fill = factor(gender))) +
  geom_bar(position = "dodge", stat = "identity") + 
  geom_errorbar(aes(ymin = fracN - sigmaTrustGender/2, 
                    ymax = fracN + sigmaTrustGender/2),
                width = .2,
                position = position_dodge(.9)) +
  xlab("Trust") + ylab("") +
  theme_bw(base_size = 15) +
  theme(legend.position = "none")

ggpubr::ggarrange(diff, hist, ncol = 1)

# Just to avoid overrriding the values:
# If an effect is not significant, then we set it to 0 to avoid confusion
dataHeatMapDiff <- differenceTrust
dataHeatMapDiff[abs(diff / (sigmaDiff / 2)) < 1, diff := 0]

# effect side heat map, where all the not significant effects have been set
# to 0
ggplot(dataHeatMapDiff) +
  geom_tile(aes(x = reorder(country, logAvgGDPpc), y = trust, fill = diff / (sigmaDiff))) +
  scale_fill_gradient2(low = "blue", high = "red") +
  labs(fill = "Effect Size") +
  xlab("Country (ordered by LogGDP p/c") + ylab("Trust") +
  theme_bw(base_size = 15) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 15),
        axis.text.y = element_text(size = 15))


ggplot(differenceTrust) +
  geom_tile(aes(x = reorder(country, magnitude), y = trust, fill = diff / (sigmaDiff))) +
  scale_fill_gradient2(low = "blue", high = "red") +
  labs(fill = "Effect Size") +
  xlab("Country (ordered by magnitude of difference)") + ylab("Trust") +
  theme_bw(base_size = 15) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 15),
        axis.text.y = element_text(size = 15))


ggplot(differenceSMS) +
  geom_point(aes(x = reorder(country, logAvgGDPpc), y = maxDiff)) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  xlab("Country (ordered by absolute difference)") + ylab("Difference in Subjective Math Skills")
# ggsave(filename = "New_Analysis/plots/diff_maxDiff_subjMathSkills.png",
#        plot = diff_maxDiff_SMS)

ggplot(differenceSMS) +
  geom_tile(aes(x = reorder(country, logAvgGDPpc), y = subj_math_skills, fill = diff)) +
  scale_fill_gradient2(low = "blue", high = "red", 
                      # limits = c()
                       ) +
  xlab("Country (ordered by logGDP p/c)") + ylab("Subjective Math Skills") +
  theme_bw(base_size = 15) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 15),
        axis.text.y = element_text(size = 15))
# ggsave(filename = "New_Analysis/plots/diff_heatmap_subjMathSkills.png",
#        plot = diff_heatmap_SMS)

# Extra: Visualize the correlation between trust and subjective math skills
dataComplete[, totalPop := nrow(dataComplete)]
p <- ggplot(dataComplete, aes(x = factor(trustNumb), y = factor(subj_math_skills))) +
  geom_bin2d(bins = 11) +
  scale_fill_continuous(type = "viridis") +
  theme_bw() +
  facet_wrap(~ gender)

ggplotly(p)



# ------------- Added afterwards, still not neat and clean ------------------- #

# Barplot of the probability
sampleToPlot <- dataComplete[, .(trustRaw, gender, country)]
totalSample <- sampleToPlot[, .N, by = .(gender, country)]
singleNumb <- sampleToPlot[, .N, by = .(gender, trustRaw, country)]
singleNumb[totalSample, on = .(gender, country), fracN := N / i.N]

ggplot(singleNumb[country == "Germany"]) +
  geom_bar(aes(x = gender, y = fracN, fill = trustRaw), stat = "identity") +
  labs(title = singleNumb[country == "Germany", unique(country)])


# Another nice plot
sampleTable <- table(dataComplete[country == "Kazakhstan", .(subj_math_skills, trustRaw, gender)])
sampleTable <- as.data.table(sampleTable)
sampleTable$subj_math_skills <- factor(sampleTable$subj_math_skills, ordered = TRUE, 
                                 levels = c("0", "1", "2", "3", "4", "5", 
                                            "6", "7", "8", "9", "10"))
sampleTable$trustRaw <- factor(sampleTable$trustRaw, ordered = TRUE, 
                         levels = c("0", "1", "2", "3", "4", "5", 
                                    "6", "7", "8", "9", "10"))
sampleTable$gender <- factor(sampleTable$gender, levels = c("0", "1"))
levels(sampleTable$gender) <- list("Male" = "0", "Female" = "1")

ggplot(sampleTable) +
  geom_col(aes(x = trustRaw, y = N, fill = gender), position = "dodge") +
  facet_wrap(~ subj_math_skills, ncol = 11) +
  coord_flip() +
  ylab("") + xlab("Trust") +
  labs(title = "Kazakhstan", subtitle = "Subjective math skills", fill = "Gender") +
  theme_bw(base_size = 15) +
  theme(plot.subtitle = element_text(hjust = 0.5))
