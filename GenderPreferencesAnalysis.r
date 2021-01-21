#####################  ANALYSIS OF GLOBAL PREFERENCES  #########################

# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("/Users/sara/Desktop/Projects/Global_Preferences_Survey/")

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

# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]


# ========================== #
#### 2. CREATE THE MODELS ####
# ========================== #

# Model on country level of the preferences
models <- CreateModelsForPreferencesCountryLevel(dataComplete)

# Summarize the preferences for each country
dataCoeff <- SummaryCoeffPerPreferencePerCountry(models)

# Adjust data for plotting
dataCoeff[data_all$data, `:=` (isocode     = i.isocode,
                               logAvgGDPpc = log(i.avgGDPpc)),
          on = "country"]
setnames(dataCoeff, old = "gender1", new = "gender")


# ===================================== #
#### 3. PRINCIPAL COMPONENT ANALYSIS ####
# ===================================== #

# PCA on the preferences
summaryIndex <- AvgGenderDiffPreferencesPCA(dataCoeff)

# Prepare summary index
summaryIndex <- CreateCompleteSummaryIndex(summaryIndex, data_all)


# ================================ #
#### 4. VARIABLES CONDITIONING  ####
# ================================ #

summaryIndex <- AddResiduals(summaryIndex)


# ================== #
#### 5. PLOTTING  ####
# ================== #

# Prepare summary histograms
dataSummary <- SummaryHistograms(dataCoeff, summaryIndex)

## ----------------------------- Fig. 1 A ------------------------------------ #
labels_preferences <- c("Altruism (+)", "Trust (+)", "Pos. Recip. (+)",
                        "Neg. Recip. (-)", "Risk Taking (-)", "Patience (-)")
names(labels_preferences) <- c("altruism", "trust", "posrecip",
                               "negrecip", "risktaking", "patience")

plotHistA <-
  ggplot(data = unique(dataSummary[, c(-3, -5)])) +
  geom_col(aes(x = GDPquant, y = meanGender, fill = preference), width = 0.5) +
  facet_wrap(~ preference, labeller = labeller(preference = labels_preferences)) +
  xlab("") + ylab("Average Gender Differences (in Standard Deviations)") +
  scale_fill_brewer(palette = "Dark2") +
  theme_bw() +
  theme(legend.title = element_blank(),
        strip.background = element_rect(colour = "white", fill = "white"),
        axis.title.y = element_text(size = 12, angle = 90),
        legend.position = "none",
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        panel.spacing.y = unit(1.5, "lines"),
        strip.text.x = element_text(size = 12)) +
  annotate(geom = "text", x = 1.3, y = -0.05, color = 'black',
           label = "Poorer Countries") +
  annotate(geom = "text", x = 3.7, y = -0.05, color = 'black',
           label = "Richer Countries") +
  coord_cartesian(ylim = c(-0.02, 0.3), clip = "off")

## ----------------------------- Fig. 1 B ------------------------------------ #
PlotSummary(data = summaryIndex,
            var1 = "logAvgGDPpc", var2 = "avgGenderDiffNorm",# fill = "region",
            labs = c("Log GDP p/c",
                     "Average Gender Differences (Index)"),  display = TRUE,
            )

## ----------------------------- Fig. 1 C ------------------------------------ #
plotHistC <-
  ggplot(data = unique(dataSummary[, c(-2, -4)])) +
  geom_col(aes(x = GEIquant, y = meanGenderGEI, fill = preference), width = 0.5) +
  facet_wrap(~ preference, labeller = labeller(preference = labels_preferences)) +
  xlab("") + ylab("Average Gender Differences (in Standard Deviations)") +
  scale_fill_brewer(palette = "Dark2") +
  theme_bw() +
  theme(legend.title = element_blank(),
        strip.background = element_rect(colour = "white", fill = "white"),
        axis.title.y = element_text(size = 12, angle = 90),
        legend.position = "none",
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        panel.spacing.y = unit(2, "lines"),
        plot.margin = unit(c(1, 1, 1, 1), "lines"),
        strip.text.x = element_text(size = 12)) +
  annotate(geom = "text", x = 1.3, y = -0.035, color = 'black', size = 3,
           label = "Less Gender\nEqual Countries") +
  annotate(geom = "text", x = 3.7, y = -0.035, color = 'black', size = 3,
           label = "More Gender\nEqual Countries") +
  coord_cartesian(ylim = c(-0.001, 0.25), clip = "off")

## ----------------------------- Fig. 1 D ------------------------------------ #
PlotSummary(data = summaryIndex,
            var1 = "GenderIndex", 
            var2 = "avgGenderDiffNorm", # fill = "region",
            labs = c("Gender Equality Index",
                     "Average Gender Differences (Index)"),  display = TRUE,
            )

## ------------------------------ Fig. 2 A ----------------------------------- #
PlotSummary(data = summaryIndex,
            var1 = "residualslogAvgGDPpcNorm",
            var2 = "residualsavgGenderDiffNorm_GEI",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Average Gender Differences (residualized using Gender Equality Index)"),
            display = TRUE)

## ------------------------------ Fig. 2 B ----------------------------------- #
PlotSummary(data = summaryIndex,
            var1 = "residualsGenderIndexNorm",
            var2 = "residualsavgGenderDiffNorm_GDP",
            labs = c("Gender Equality Index (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)"),
            display = TRUE)

## ------------------------------ Fig. 2 C ----------------------------------- #
PlotSummary(data = summaryIndex,
            var1 = "residualsScoreWEFNorm",
            var2 = "residualsavgGenderDiffNorm_GDP",
            labs = c("WEF Global Gender Gap Index (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)"),
            display = TRUE)

## ------------------------------ Fig. 2 D ----------------------------------- #
PlotSummary(data = summaryIndex,
            var1 = "residualsValueUNNorm",
            var2 = "residualsavgGenderDiffNorm_GDP",
            labs = c("UN Gender Equality Index (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)"),
            display = TRUE)

## ------------------------------ Fig. 2 E ----------------------------------- #
PlotSummary(data = summaryIndex,
            var1 = "residualsavgRatioLaborNorm",
            var2 = "residualsavgGenderDiffNorm_GDP",
            labs = c("Ratio Female to Male (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)"),
            display = TRUE)

## ------------------------------ Fig. 2 F ----------------------------------- #
PlotSummary(data = summaryIndex,
            var1 = "residualsDateNorm",
            var2 = "residualsavgGenderDiffNorm_GDP",
            labs = c("Time since Women's Suffrage (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)"),
            display = TRUE)


# =============================== #
#### 6. SUPPLEMENTARY MATERIAL ####
# =============================== #

colsToKeep <- c("GenderIndexNorm", "ScoreWEFNorm", "ValueUNNorm", "DateNorm",
                "avgRatioLaborNorm", "residualslogAvgGDPpcNorm",
                "residualsavgGenderDiffNorm_GEI", "country")
dataCoeff_summary <- merge(dataCoeff, summaryIndex[, ..colsToKeep],
                           by = "country")

dataCoeff_summary[preference == "risktaking", gender := -1 * gender]
dataCoeff_summary[preference == "negrecip", gender := -1 * gender]
dataCoeff_summary[preference == "patience", gender := -1 * gender]

dataCoeff_summary <- AddResidualsSinglePreference(dataCoeff_summary)


# -------------------------------- Fig. S2 ----------------------------------- #
PlotSummary(data = dataCoeff_summary,
            var1 = "logAvgGDPpc", var2 = "gender", var3 = "preference",
            labs = c("Log GDP p/c",
                     "Average Gender Differences (Index)"),
            display = TRUE
            )

# -------------------------------- Fig. S3 ----------------------------------- #
PlotSummary(data = dataCoeff_summary,
            var1 = "GenderIndexNorm", var2 = "gender", var3 = "preference",
            labs = c("Gender Equality Index",
                     "Average Gender Differences (Index)"),
            display = TRUE
)

## ------------------------------- Fig. S4 ----------------------------------- #
PlotSummary(data = summaryIndex, var1 = "ScoreWEFNorm", var2 = "avgGenderDiffNorm",
            labs = c("WEF Global Gender Gap Index",
                     "Average Gender Differences (Index)"),
            display = TRUE)

PlotSummary(data = summaryIndex, var1 = "ValueUNNorm", var2 = "avgGenderDiffNorm",
            labs = c("UN Gender Equality Index",
                     "Average Gender Differences (Index)"),
            display = TRUE)

PlotSummary(data = summaryIndex, var1 = "avgRatioLaborNorm", var2 = "avgGenderDiffNorm",
            labs = c("Ratio Female to Male",
                     "Average Gender Differences (Index)"),
            display = TRUE)

PlotSummary(data = summaryIndex, var1 = "DateNorm", var2 = "avgGenderDiffNorm",
            labs = c("Time since Women's Suffrage",
                     "Average Gender Differences (Index)"),
            display = TRUE)

## ------------------------------- Fig. S5 ----------------------------------- #
# I still need to create the correct residuals for it
PlotSummary(data = dataCoeff_summary[preference == "trust"],
            var1 = "residualslogAvgGDPpcNorm",
            var2 = "residualsgender_trust",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)"),
            display = TRUE)

PlotSummary(data = dataCoeff_summary[preference == "altruism"],
            var1 = "residualslogAvgGDPpcNorm",
            var2 = "residualsgender_altruism",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)"),
            display = TRUE)

PlotSummary(data = dataCoeff_summary[preference == "posrecip"],
            var1 = "residualslogAvgGDPpcNorm",
            var2 = "residualsgender_posrecip",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)"),
            display = TRUE)

PlotSummary(data = dataCoeff_summary[preference == "negrecip"],
            var1 = "residualslogAvgGDPpcNorm",
            var2 = "residualsgender_negrecip",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)"),
            display = TRUE)

PlotSummary(data = dataCoeff_summary[preference == "risktaking"],
            var1 = "residualslogAvgGDPpcNorm",
            var2 = "residualsgender_risktaking",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)"),
            display = TRUE)

PlotSummary(data = dataCoeff_summary[preference == "patience"],
            var1 = "residualslogAvgGDPpcNorm",
            var2 = "residualsgender_patience",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)"),
            display = TRUE)


## Alternative model
modelsAlternative <- CreateAlternativeModels(dataComplete)
dataCoeffAlternative <- SummaryCoeffPerPreferencePerCountry(modelsAlternative)

# Adjust data for plotting
dataCoeffAlternative[data_all$data, `:=` (isocode     = i.isocode,
                                          logAvgGDPpc = log(i.avgGDPpc)),
                     on = "country"]
dataCoeffAlternative[preference == "risktaking", gender := -1 * gender]
dataCoeffAlternative[preference == "negrecip", gender := -1 * gender]
dataCoeffAlternative[preference == "patience", gender := -1 * gender]

setnames(dataCoeffAlternative, old = "gender1", new = "gender")

# ------------------------------- Fig. S9 ------------------------------------ #
PlotSummary(data = dataCoeffAlternative,
            var1 = "logAvgGDPpc", var2 = "gender", var3 = "preference",
            labs = c("Log GDP p/c",
                     "Average Gender Differences (Index)"),
            display = TRUE
)


# ================================ #
#### 7. MODEL EVALUATION  ####
# ================================ #

# Add the data from the article
dt_article <- fread("files/Data_Extract_From_World_Development_Indicators/dataFromArticle2.csv")

# Create a data table for a quick comparison
fakeDT <- dt_article[summaryIndex, .(avgDiffArticle = AverageGenderDifference,
                                     avgDiffOurs = i.avgGenderDiffNorm,
                                     isocode = i.isocode), on = "isocode"]
fakeDT <- fakeDT[complete.cases(fakeDT)]

# Plot the results
PlotSummary(data = fakeDT, var1 = "avgDiffArticle", var2 = "avgDiffOurs",
            labs = c("Average Gender Differences from the Article",
                     "Average Gender Differences from our Model"),
            display = TRUE
            )
# Compare with the Bayesian Supersedes the t-Test method
# Plots can be reproduced using the plotAll function
comparison <- BESTmcmc(dt_article$AverageGenderDifference,
                       summaryIndex$avgGenderDiffNorm)


# ========================== #
#### WRITE DATA SUMMARIES ####
# ========================== #

## ---------------------- Write csv data summaries -------------------------- ##
fwrite(dataSummary,
       file = "files/outcome/data_for_histograms.csv")
fwrite(summaryIndex,
       file = "files/outcome/data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
#------------------------------------------------------------------------------#
