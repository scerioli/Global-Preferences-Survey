################################################################################
######################### INTERNATIONAL WOMEN'S DAY ############################
################################################################################

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

# Load the data
data_all <- LoadData()
dataUIS  <- fread("tmp/UISdataset.csv")


# ========================= #
#### 1. PREPARE THE DATA ####
# ========================= #

data_all <- PrepareData(data_all)

# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]
dataComplete[data_all$world_area, area := i.region, on = "country"]

dataComplete[, logAvgGDPpc := log(avgGDPpc), by = "country"]
dataComplete[, avgGDPpc := NULL]

# Select only interesting indicator
dataUIS <- dataUIS %>%
  mutate(country = Country, isocode = LOCATION, year = TIME) %>%
  filter(INDICATOR == "FPERSP_TFTE") %>%
  select(country, isocode, year, Value)

dataUIS[country == "Czechia", country := "Czech Republic"]
dataUIS[country == "Republic of Moldova", country := "Moldova"]
dataUIS[country == "Iran (Islamic Republic of)", country := "Iran"]
dataUIS[country == "Bosnia and Herzegovina", country := "Bosnia Herzegovina"]
dataUIS[country == "United Republic of Tanzania", country := "Tanzania"]
dataUIS[country == "Viet Nam", country := "Vietnam"]

dataUIS[, avgFemalePerc := mean(Value), by = .(country)]


# ======================== #
#### 2. GENDER ANALYSIS ####
# ======================== #

getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}

# Normalize data by gender
dataComplete[, totalGender := .N, by = .(country, gender)]
dataComplete[, fracN := .N / unique(totalGender) / 2, 
             by = .(gender, subj_math_skills, country)]
dataComplete[, meanSMS := mean(subj_math_skills), by = .(country, gender)]
dataComplete[, meanPopulation := mean(subj_math_skills), by = "country"]

dataMeanMale   <- dataComplete[gender == 0, .(meanSMS = unique(meanSMS)), by = "country"]
dataMeanFemale <- dataComplete[gender == 1, .(meanSMS = unique(meanSMS)), by = "country"]

# Select only differences
dataMean <- dataMeanMale[dataMeanFemale, `:=` (diffMean = meanSMS - i.meanSMS), 
                         on = "country"]
dataMean[dataComplete, meanPopulation := i.meanPopulation, on = "country"]
dataMean[dataComplete, area := i.area, on = "country"]

# Prepare heat map for subjective math skills base
nSample <-  dataComplete[, .N, by = c("country", "gender")]
nSample$total <- nSample$N
nSample$N <- NULL

# Create heat map
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
dataHeatMap[, fracN := N / total / 2, by = c("country", "gender")]
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

# Summarise the difference between men and women by country and by subjective
# math skills
differenceSMS <- dataHeatMap[gender == 1][dataHeatMap[gender == 0], 
                                          .(diff = fracN - i.fracN,
                                            Y = i.Y,
                                            country = i.country),
                                          on = c("country", "Y")]
# Add the mean to be able to plot it later
differenceSMS[dataMean, diffSMS := i.diffMean, on = "country"]

dataMean[dataComplete, logGDP := i.logAvgGDPpc, on = "country"]
dataMean[dataComplete, isocode := i.isocode, on = "country"]

# TODO: needs to check the gender index
extra <- dataMean[dataUIS, avgFemalePerc := i.avgFemalePerc, on = "country"]
extra[data_all$UNindex, score := i.Value, on = "country"]
extra[data_all$timeWomenSuff, date := i.Date, on = "country"]
extra[data_all$WEF, rank := i.Score, on = "country"]
extra[data_all$ratioLabor, ratioLabor := i.avgRatioLabor, on = "country"]
extra$genderIndex <- GenderIndexPCA(extra[, c(8:12)])

extra <- extra[!is.na(avgFemalePerc)]


# ============= #
#### 3. PLOT ####
# ============= #

# Difference between mean of subjective math skills between men and women by
# country, ordered by difference
meanDiff <- ggplot(dataMean, aes(x = reorder(country, diffMean), y = diffMean)) +
  geom_point(size = 3) +
  geom_hline(yintercept = 0, col = "red") +
  theme_bw(base_size = 15) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 15),
        axis.text.y = element_text(size = 15)) +
  ylab("Mean difference of subjective math skills") + xlab("")# +
labs(title = "Difference of the mean of subjective math skills between men and women by country")
ggsave(filename = "PublicPosts/plots/difference_mean_subjMathSkills.png")


# Difference between mean of subjective math skills between men and women by
# country, ordered by log GDP
modelGDP <- lm(diffMean ~ logGDP, data = extra)

labels <- data.table(correlation = paste0("Correlation = ", round(cor(extra$logGDP, extra$diffMean), 4)),
                     pvalue = paste0("P-value = ", round(summary(modelGDP)$coefficients[, "Pr(>|t|)"][2], 4)))

ggplot(extra, aes(x = logGDP, y = diffMean)) +
  geom_point(shape = 21, size = 3, fill = "white") +
  geom_text(aes(label = isocode), color = "gray20", size = 3,
            check_overlap = F, hjust = -0.5) +
  geom_smooth(aes(x = logGDP, y = diffMean), method = "lm", se = T, col = "red") +
  geom_text(x = min(extra$logGDP) + 0.5, y = max(extra$diffMean) - 0.01,
            data = labels, aes(label = correlation), hjust = 0) +
  geom_text(x = min(extra$logGDP) + 0.5, y = max(extra$diffMean) - 0.1,
            data = labels, aes(label = pvalue), hjust = 0) +
  ylab("Difference of the mean") + xlab("Country") +
  labs(title = "Difference of the mean of subjective math skills between men and women by country")

# Difference between mean of subjective math skills between men and women by
# country, ordered by GEI
modelGEI <- lm(diffMean ~ genderIndex, data = extra)

labels <- data.table(correlation = paste0("Correlation = ", round(cor(extra$genderIndex, extra$diffMean), 4)),
                     pvalue = paste0("P-value = ", round(summary(modelGEI)$coefficients[, "Pr(>|t|)"][2], 4)))

ggplot(extra, aes(x = genderIndex, y = diffMean)) +
  geom_point(shape = 21, size = 3, fill = "white") +
  geom_text(aes(label = isocode), color = "gray20", size = 3,
            check_overlap = F, hjust = -0.5) +
  geom_smooth(aes(x = genderIndex, y = diffMean), method = "lm", se = T, col = "red") +
  geom_text(x = min(extra$genderIndex) + 0.5, y = max(extra$diffMean) - 0.01,
            data = labels, aes(label = correlation), hjust = 0) +
  geom_text(x = min(extra$genderIndex) + 0.5, y = max(extra$diffMean) - 0.1,
            data = labels, aes(label = pvalue), hjust = 0) +
  ylab("Difference of the mean") + xlab("Country") +
  labs(title = "Difference of the mean of subjective math skills between men and women by country")

# Difference between mean of subjective math skills between men and women by
# country, ordered by log fraction of women in STEM
modelFratio <- lm(diffMean ~ avgFemalePerc, data = extra)

labels <- data.table(correlation = paste0("Correlation = ", round(cor(extra$avgFemalePerc, extra$diffMean), 4)),
                     pvalue = paste0("P-value = ", round(summary(modelFratio)$coefficients[, "Pr(>|t|)"][2], 4)))

ggplot(extra, aes(x = avgFemalePerc, y = diffMean)) +
  geom_point(shape = 21, size = 3, fill = "white") +
  geom_text(aes(label = isocode), color = "gray20", size = 3,
            check_overlap = F, hjust = -0.5) +
  geom_smooth(aes(x = avgFemalePerc, y = diffMean), method = "lm", se = T, col = "red") +
  geom_text(x = min(extra$avgFemalePerc) + 0.5, y = max(extra$diffMean) - 0.01,
            data = labels, aes(label = correlation), hjust = 0) +
  geom_text(x = min(extra$avgFemalePerc) + 0.5, y = max(extra$diffMean) - 0.1,
            data = labels, aes(label = pvalue), hjust = 0) +
  ylab("Difference of the mean") + xlab("Country") +
  labs(title = "Difference of the mean of subjective math skills between men and women by country")


# Single countries plot

# Max gender differences in favor of women
kazakhstan <- 
  ggplot(dataComplete[country == "Russia"]) +
  geom_col(aes(x = factor(subj_math_skills), y = fracN, fill = factor(gender)), position = "dodge") + 
  scale_fill_manual(values = c("#999999", "#E69F00"), name = "Gender", 
                    labels = c("Male", "Female")) +
  geom_vline(xintercept = dataComplete[gender == 0 & country == "Russia", meanSMS], 
             col = "grey40", lty = "dashed", size = 1.5, show.legend = T) + 
  geom_vline(xintercept = dataComplete[gender == 1 & country == "Russia", meanSMS], 
             col = "darkgoldenrod1", size = 1.5, show.legend = T) +
  xlab("Subjective Math Skills") + ylab("Percentage over the whole country") +
  labs(title = "Russia") + ylim(c(0, 0.125)) +
  theme_bw() 

# Max gender differences in favor of men
afghanistan <- 
  ggplot(dataComplete[country == "United States"]) +
  geom_col(aes(x = factor(subj_math_skills), y = fracN, fill = factor(gender)), position = "dodge") + 
  scale_fill_manual(values = c("#999999", "#E69F00"), name = "Gender", 
                    labels = c("Male", "Female")) +
  geom_vline(xintercept = dataComplete[gender == 0 & country == "United States", meanSMS], 
             col = "grey40", lty = "dashed", size = 1.5, show.legend = T) + 
  geom_vline(xintercept = dataComplete[gender == 1 & country == "United States", meanSMS], 
             col = "darkgoldenrod1", size = 1.5, show.legend = T) +
  xlab("Subjective Math Skills") + ylab("") +
  labs(title = "United States") + ylim(c(0, 0.125)) +
  theme_bw() 


ggpubr::ggarrange(kazakhstan, afghanistan, common.legend = TRUE, align = "v")


# Similar mean, very different distribution
germany <- 
  ggplot(dataComplete[country == "Germany"]) +
  geom_col(aes(x = factor(subj_math_skills), y = fracN, fill = factor(gender)), position = "dodge") + 
  scale_fill_manual(values = c("#999999", "#E69F00"), name = "Gender", 
                    labels = c("Male", "Female")) +
  geom_vline(xintercept = dataComplete[gender == 0 & country == "Germany", meanSMS], 
             col = "grey40", lty = "dashed", size = 1.5, show.legend = T) + 
  geom_vline(xintercept = dataComplete[gender == 1 & country == "Germany", meanSMS], 
             col = "darkgoldenrod1", size = 1.5, show.legend = T) +
  xlab("Subjective Math Skills") + ylab("") +
  labs(title = "Germany") + ylim(c(0, 0.13)) +
  theme_bw(base_size = 15)

italy <- 
  ggplot(dataComplete[country == "Italy"]) +
  geom_col(aes(x = factor(subj_math_skills), y = fracN, fill = factor(gender)), position = "dodge") + 
  scale_fill_manual(values = c("#999999", "#E69F00"), name = "Gender", 
                    labels = c("Male", "Female")) +
  geom_vline(xintercept = dataComplete[gender == 0 & country == "Italy", meanSMS],
             col = "grey40", lty = "dashed", size = 1.5, show.legend = T) + 
  geom_vline(xintercept = dataComplete[gender == 1 & country == "Italy", meanSMS], 
             col = "darkgoldenrod1", size = 1.5, show.legend = T) +
  xlab("Subjective Math Skills") + ylab("Percentage over the whole country") +
  labs(title = "Italy") + ylim(c(0, 0.13)) +
  theme_bw(base_size = 15)

together <- ggpubr::ggarrange(italy, germany, common.legend = TRUE, align = "v")

ggsave(filename = "PublicPosts/plots/together_histograms.png", together)

# Plot the heat map of the gender differences distributions ordered by difference
heatmap_diff <- ggplot(differenceSMS) +
  geom_tile(aes(x = reorder(country, diffSMS), y = Y, fill = diff)) +
  scale_fill_gradient2(low = "blue", high = "red", 
                       limits = c(-0.065, 0.065)) +
  labs(fill = "Difference") +
  xlab("Country") + ylab("Subjective Math Skills") +
  theme_bw(base_size = 15) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 15),
        axis.text.y = element_text(size = 15))
ggsave(filename = "PublicPosts/plots/heatmap_countries.png", heatmap_diff)