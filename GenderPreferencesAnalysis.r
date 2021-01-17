#####################  ANALYSIS OF GLOBAL PREFERENCES  #########################

# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("/Users/sara/Desktop/Projects/Global_Preferences_Survey/")

# Source helper functions
source("functions/SourceFunctions.r")
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

## ------------- 2.1 Model on country level of the preferences --------------- #
models <- CreateModelsForPreferencesCountryLevel(dataComplete)

## ------------- 2.2 Summarize the preferences for each country -------------- #
dataCoeff <- SummaryCoeffPerPreferencePerCountry(models)

# Adjust data for plotting
dataCoeff[data_all$data, `:=` (isocode     = i.isocode,
                               logAvgGDPpc = log10(i.avgGDPpc)),
          on = "country"]
setnames(dataCoeff, old = "gender1", new = "gender")


# ===================================== #
#### 3. PRINCIPAL COMPONENT ANALYSIS ####
# ===================================== #

## ----------------------- 3.1 PCA on the preferences ------------------------ #
summaryIndex <- AvgGenderDiffPreferencesPCA(dataCoeff)

## ----------------------- 3.2 Prepare summary index ------------------------- #
summaryIndex <- CreateCompleteSummaryIndex(summaryIndex, data_all)

# ---------------------- 3.3 Prepare summary histograms ---------------------- #
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
  annotate(geom = "text", x = 1.3, y = -0.05, color = 'black', label = "Poorer Countries") +
  annotate(geom = "text", x = 3.7, y = -0.05, color = 'black', label = "Richer Countries") +
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
  annotate(geom = "text", x = 1.3, y = -0.035, color = 'black', size = 3, label = "Less Gender\nEqual Countries") +
  annotate(geom = "text", x = 3.7, y = -0.035, color = 'black', size = 3, label = "More Gender\nEqual Countries") +
  coord_cartesian(ylim = c(-0.001, 0.25), clip = "off")

## ----------------------------- Fig. 1 D ------------------------------------ #
PlotSummary(data = summaryIndex,
            var1 = "GenderIndex", var2 = "avgGenderDiffNorm", # fill = "region",
            labs = c("Gender Equality Index",
                     "Average Gender Differences (Index)"), # display = TRUE,
            )


# ================================ #
#### 4. VARIABLES CONDITIONING  ####
# ================================ #

summaryIndex <- AddResiduals(summaryIndex)

## ------------------------------ Fig. 2 A ----------------------------------- #
PlotSummary(data = summaryIndex, var1 = "residualsGEIx", var2 = "residualsGEIy",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Average Gender Differences (residualized using Gender Equality Index)"),
            display = TRUE)

## ------------------------------ Fig. 2 B ----------------------------------- #
PlotSummary(data = summaryIndex, var1 = "residualsGDPx", var2 = "residualsGDPy",
            labs = c("Gender Equality Index (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)"),
            display = TRUE)

## ------------------------------ Fig. 2 C ----------------------------------- #
PlotSummary(data = summaryIndex, var1 = "residualsWEFx", var2 = "residualsGDPy",
            labs = c("WEF Global Gender Gap Index (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)"),
            display = TRUE)

## ------------------------------ Fig. 2 D ----------------------------------- #
PlotSummary(data = summaryIndex, var1 = "residualsUNx", var2 = "residualsGDPy",
            labs = c("UN Gender Equality Index (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)"),
            display = TRUE)

## ------------------------------ Fig. 2 E ----------------------------------- #
PlotSummary(data = summaryIndex, var1 = "residualsRatiox", var2 = "residualsGDPy",
            labs = c("Ratio Female to Male (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)"),
            display = TRUE)

## ------------------------------ Fig. 2 F ----------------------------------- #
PlotSummary(data = summaryIndex, var1 = "residualsDatex", var2 = "residualsGDPy",
            labs = c("Time since Women's Suffrage (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)"),
            display = TRUE)


# =============================== #
#### 5. SUPPLEMENTARY MATERIAL ####
# =============================== #

# -------------------------------- Fig. S2 ----------------------------------- #
PlotSummary(data = dataCoeff, var1 = "logAvgGDPpc", var2 = "gender", var3 = "preference",
            labs = c("Log GDP p/c",
                     "Average Gender Differences (Index)"),
            display = TRUE
            )


# ================================ #
#### 6. MODEL EVALUATION  ####
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
comparison <- BESTmcmc(dt_article$`Average Gender Difference (Index)`,
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
