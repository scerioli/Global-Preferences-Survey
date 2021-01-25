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
dataSummary <- fread("files/outcome/main_data_for_histograms.csv")
summaryIndex <- fread("files/outcome/main_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
dataCoeff_summary <- fread("files/outcome/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")
dataCoeffAlternative <- fread("files/outcome/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficients_alternativeModel.csv")


# =========================== #
#### 1. MAIN ARTICLE PLOTS ####
# =========================== #

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
ggsave(filename = "plots/main_Fig1A.png", plot = plotHistA)

## ----------------------------- Fig. 1 B ------------------------------------ #
PlotSummary(data = summaryIndex,
            var1 = "logAvgGDPpc", var2 = "avgGenderDiffNorm",# fill = "region",
            labs = c("Log GDP p/c",
                     "Average Gender Differences (Index)"),  
          #  display = TRUE,
            save = "plots/main_Fig1B.png")

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
ggsave(filename = "plots/main_Fig1C.png", plot = plotHistC)

## ----------------------------- Fig. 1 D ------------------------------------ #
PlotSummary(data = summaryIndex,
            var1 = "GenderIndex", 
            var2 = "avgGenderDiffNorm", # fill = "region",
            labs = c("Gender Equality Index",
                     "Average Gender Differences (Index)"),  
          #  display = TRUE,
            save = "plots/main_Fig1D.png")


## ------------------------------ Fig. 2 A ----------------------------------- #
PlotSummary(data = summaryIndex,
            var1 = "residualslogAvgGDPpcNorm",
            var2 = "residualsavgGenderDiffNorm_GEI",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Average Gender Differences (residualized using Gender Equality Index)",
                     "Economic Development"),
          #  display = TRUE,
            save = "plots/main_Fig2A.png")

## ------------------------------ Fig. 2 B ----------------------------------- #
PlotSummary(data = summaryIndex,
            var1 = "residualsGenderIndexNorm",
            var2 = "residualsavgGenderDiffNorm_GDP",
            labs = c("Gender Equality Index (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)",
                     "Gender Equality"),
          #  display = TRUE,
            save = "plots/main_Fig2B.png")

## ------------------------------ Fig. 2 C ----------------------------------- #
PlotSummary(data = summaryIndex,
            var1 = "residualsScoreWEFNorm",
            var2 = "residualsavgGenderDiffNorm_GDP",
            labs = c("WEF Global Gender Gap Index (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)",
                     "WEF Global Gender Gap Index"),
          #  display = TRUE,
            save = "plots/main_Fig2C.png")

## ------------------------------ Fig. 2 D ----------------------------------- #
PlotSummary(data = summaryIndex,
            var1 = "residualsValueUNNorm",
            var2 = "residualsavgGenderDiffNorm_GDP",
            labs = c("UN Gender Equality Index (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)",
                     "UN Gender Equality Index"),
          #  display = TRUE,
            save = "plots/main_Fig2D.png")

## ------------------------------ Fig. 2 E ----------------------------------- #
PlotSummary(data = summaryIndex,
            var1 = "residualsavgRatioLaborNorm",
            var2 = "residualsavgGenderDiffNorm_GDP",
            labs = c("Ratio Female to Male (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)",
                     "Ratio Female to Male LFP"),
          #  display = TRUE,
            save = "plots/main_Fig2E.png")

## ------------------------------ Fig. 2 F ----------------------------------- #
PlotSummary(data = summaryIndex,
            var1 = "residualsDateNorm",
            var2 = "residualsavgGenderDiffNorm_GDP",
            labs = c("Time since Women's Suffrage (residualized using Log GDP p/c)",
                     "Average Gender Differences (residualized using Log GDP p/c)",
                     "Time since Women's Suffrage"),
          #  display = TRUE,
            save = "plots/main_Fig2F.png")



# ===================================== #
#### 2. SUPPLEMENTARY MATERIAL PLOTS ####
# ===================================== #

# -------------------------------- Fig. S2 ----------------------------------- #
PlotSummary(data = dataCoeff_summary,
            var1 = "logAvgGDPpc", var2 = "gender", var3 = "preference",
            labs = c("Log GDP p/c",
                     "Gender Differences (in standard deviations)"),
           # display = TRUE,
            save = "plots/supplementary_FigS2.png")

# -------------------------------- Fig. S3 ----------------------------------- #
PlotSummary(data = dataCoeff_summary,
            var1 = "GenderIndexNorm", var2 = "gender", var3 = "preference",
            labs = c("Gender Equality Index",
                     "Gender Differences (in standard deviations)"),
            display = TRUE,
            save = "plots/supplementary_FigS3.png")

## ------------------------------- Fig. S4 ----------------------------------- #
PlotSummary(data = summaryIndex, var1 = "ScoreWEFNorm", var2 = "avgGenderDiffNorm",
            labs = c("WEF Global Gender Gap Index",
                     "Average Gender Differences (Index)",
                     "WEF Global Gender Gap Index"),
          #  display = TRUE,
            save = "plots/supplementary_FigS4A.png")

PlotSummary(data = summaryIndex, var1 = "ValueUNNorm", var2 = "avgGenderDiffNorm",
            labs = c("UN Gender Equality Index",
                     "Average Gender Differences (Index)",
                     "UN Gender Equality Index"),
          #  display = TRUE,
            save = "plots/supplementary_FigS4B.png")

PlotSummary(data = summaryIndex, var1 = "avgRatioLaborNorm", var2 = "avgGenderDiffNorm",
            labs = c("Ratio Female to Male",
                     "Average Gender Differences (Index)",
                     "Ratio Female to Male LFP"),
          #  display = TRUE,
            save = "plots/supplementary_FigS4C.png")

PlotSummary(data = summaryIndex, var1 = "DateNorm", var2 = "avgGenderDiffNorm",
            labs = c("Time since Women's Suffrage",
                     "Average Gender Differences (Index)",
                     "Time since Women's Suffrage"),
          #  display = TRUE,
            save = "plots/supplementary_FigS4D.png")

## ------------------------------- Fig. S5 ----------------------------------- #
# I still need to create the correct residuals for it
PlotSummary(data = dataCoeff_summary[preference == "trust"],
            var1 = "residualslogAvgGDPpc",
            var2 = "residualsgenderGEI_trust",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Trust (+)"),
            display = TRUE)

PlotSummary(data = dataCoeff_summary[preference == "altruism"],
            var1 = "residualslogAvgGDPpc",
            var2 = "residualsgenderGEI_altruism",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Altruism (+)"),
            display = TRUE)

PlotSummary(data = dataCoeff_summary[preference == "posrecip"],
            var1 = "residualslogAvgGDPpc",
            var2 = "residualsgenderGEI_posrecip",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Positive Reciprocity (+)"),
            display = TRUE)

PlotSummary(data = dataCoeff_summary[preference == "negrecip"],
            var1 = "residualslogAvgGDPpc",
            var2 = "residualsgenderGEI_negrecip",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Negative Reciprocity (-)"),
            display = TRUE)

PlotSummary(data = dataCoeff_summary[preference == "risktaking"],
            var1 = "residualslogAvgGDPpc",
            var2 = "residualsgenderGEI_risktaking",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Risk Taking (-)"),
            display = TRUE)

PlotSummary(data = dataCoeff_summary[preference == "patience"],
            var1 = "residualslogAvgGDPpc",
            var2 = "residualsgenderGEI_patience",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Patience (-)"),
            display = TRUE)

## ------------------------------- Fig. S6 ----------------------------------- #
# I still need to create the correct residuals for it
PlotSummary(data = dataCoeff_summary[preference == "trust"],
            var1 = "residualsGenderIndex",
            var2 = "residualsgenderGDP_trust",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences (residualized using Log GDP p/c)",
                     "Trust (+)"),
            display = TRUE)



# ------------------------------- Fig. S9 ------------------------------------ #
PlotSummary(data = dataCoeffAlternative,
            var1 = "logAvgGDPpc", var2 = "gender", var3 = "preference",
            labs = c("Log GDP p/c",
                     "Gender Differences (in standard deviations)",
                     "Alternative Model without Control Variables"),
          #  display = TRUE,
            save = "plots/supplementary_FigS9.png")

