# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("~/Desktop/Projects/Global-Preferences-Survey/")

# Source helper functions
source("ReproductionAnalysis/functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "ReproductionAnalysis/functions/")
SourceFunctions(path = "ReproductionAnalysis/functions/helper_functions/")
SourceFunctions(path = "ExtendedAnalysis/functions/")

# Load libraries
LoadRequiredLibraries_new()

# Load the data
dataSummary <- fread("ExtendedAnalysis/files/output/main_data_for_histograms.csv")
summaryIndex <- fread("ExtendedAnalysis/files/output/main_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
dataCoeff_summary <- fread("ExtendedAnalysis/files/output/supplementary_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")

# =========================== #
#### 1. MAIN ARTICLE PLOTS ####
# =========================== #

## ----------------------------- Fig. 1 A ------------------------------------ #
dataSummary$preference_f <- factor(dataSummary$preference, 
                                   levels = c("altruism", "trust", "posrecip",
                                              "negrecip", "risktaking", "patience"))
labels_preferences <- c("Altruism (+)", "Trust (+)", "Pos. Recip. (+)",
                        "Neg. Recip. (-)", "Risk Taking (-)", "Patience (-)")
names(labels_preferences) <- c("altruism", "trust", "posrecip",
                               "negrecip", "risktaking", "patience")

plotHistA <-
  ggplot(data = unique(dataSummary[, c(1, 2, 5, 8)])) +
  geom_col(aes(x = GDPquant, y = meanGenderGDP, fill = preference), width = 0.5) +
  facet_wrap(~ preference_f, labeller = labeller(preference_f = labels_preferences)) +
  xlab("") + ylab("Average Gender Differences (in Standard Deviations)") +
  scale_fill_brewer(palette = "Dark2") +
  scale_y_continuous(breaks = c(0.0, 0.05, 0.1, 0.15, 0.2, 0.25)) +
  scale_x_discrete(breaks = element_blank()) +
  theme_bw() +
  theme(legend.title     = element_blank(),
        strip.background = element_rect(colour = "white", fill = "white"),
        axis.title.y     = element_text(size = 12, angle = 90),
        legend.position  = "none",
        axis.text.x      = element_blank(),
        axis.ticks.x     = element_blank(),
        panel.spacing.y  = unit(1.5, "lines"),
        strip.text.x     = element_text(size = 14)) +
  annotate(geom = "text", x = 1.3, y = -0.05, color = 'black', size = 4,
           label = "Poorer Countries") +
  annotate(geom = "text", x = 3.7, y = -0.05, color = 'black', size = 4,
           label = "Richer Countries") +
  coord_cartesian(ylim = c(-0.01, 0.27), clip = "off")
ggsave(filename = "ExtendedAnalysis/plots/main_Fig1A.png", plot = plotHistA)

## ----------------------------- Fig. 1 B ------------------------------------ #
PlotSummary_robust(data = summaryIndex,
                   var1 = "logAvgGDPpc", 
                   var2 = "avgGenderDiffRescaled",
                   labs = c("Log GDP p/c",
                            "Average Gender Differences (Index)"),  
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/main_Fig1B.png"
)

## ----------------------------- Fig. 1 C ------------------------------------ #
plotHistC <-
  ggplot(data = unique(dataSummary[, c(1, 3, 6, 8)])) +
  geom_col(aes(x = GEIquant, y = meanGenderGEI, fill = preference), width = 0.5) +
  facet_wrap(~ preference_f, labeller = labeller(preference_f = labels_preferences)) +
  xlab("") + ylab("Average Gender Differences (in Standard Deviations)") +
  scale_fill_brewer(palette = "Dark2") +
  scale_y_continuous(breaks = c(0.0, 0.05, 0.1, 0.15, 0.2, 0.25)) +
  scale_x_discrete(breaks = element_blank()) +
  theme_bw() +
  theme(legend.title     = element_blank(),
        strip.background = element_rect(colour = "white", fill = "white"),
        axis.title.y     = element_text(size = 12, angle = 90),
        legend.position  = "none",
        axis.text.x      = element_blank(),
        axis.ticks.x     = element_blank(),
        panel.spacing.y  = unit(2, "lines"),
        plot.margin      = unit(c(1, 1, 1, 1), "lines"),
        strip.text.x     = element_text(size = 15)) +
  annotate(geom = "text", x = 1.3, y = -0.065, color = 'black', size = 3,
           label = "Less Gender\nEqual Countries") +
  annotate(geom = "text", x = 3.7, y = -0.065, color = 'black', size = 3,
           label = "More Gender\nEqual Countries") +
  coord_cartesian(ylim = c(-0.01, 0.27), clip = "off")
ggsave(filename = "ExtendedAnalysis/plots/main_Fig1C.png", plot = plotHistC)

## ----------------------------- Fig. 1 D ------------------------------------ #
PlotSummary_robust(data = summaryIndex,
                   var1 = "GenderIndexRescaled", 
                   var2 = "avgGenderDiffRescaled",
                   labs = c("Gender Equality Index",
                            "Average Gender Differences (Index)"),  
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/main_Fig1D.png"
)

## ------------------------------ EXTRA -------------------------------------- #
plotHistExtra <-
  ggplot(data = unique(dataSummary[, c(1, 4, 7, 8)])) +
  geom_col(aes(x = GDIquant, y = meanGenderGDI, fill = preference), width = 0.5) +
  facet_wrap(~ preference_f, labeller = labeller(preference_f = labels_preferences)) +
  xlab("") + ylab("Average Gender Differences (in Standard Deviations)") +
  scale_fill_brewer(palette = "Dark2") +
  scale_y_continuous(breaks = c(0.0, 0.05, 0.1, 0.15, 0.2, 0.25)) +
  scale_x_discrete(breaks = element_blank()) +
  theme_bw() +
  theme(legend.title     = element_blank(),
        strip.background = element_rect(colour = "white", fill = "white"),
        axis.title.y     = element_text(size = 12, angle = 90),
        legend.position  = "none",
        axis.text.x      = element_blank(),
        axis.ticks.x     = element_blank(),
        panel.spacing.y  = unit(2, "lines"),
        plot.margin      = unit(c(1, 1, 1, 1), "lines"),
        strip.text.x     = element_text(size = 15)) +
  annotate(geom = "text", x = 1.3, y = -0.065, color = 'black', size = 3,
           label = "Less Gender\nDeveloped Countries") +
  annotate(geom = "text", x = 3.7, y = -0.065, color = 'black', size = 3,
           label = "More Gender\nDeveloped Countries") +
  coord_cartesian(ylim = c(-0.01, 0.27), clip = "off")
ggsave(filename = "ExtendedAnalysis/plots/main_ExtraHist.png", plot = plotHistExtra)


PlotSummary_robust(data = summaryIndex,
                   var1 = "GDI", 
                   var2 = "avgGenderDiffRescaled",
                   labs = c("Gender Development Index",
                            "Average Gender Differences (Index)"),  
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/main_ExtraGDI.png"
)



## ------------------------------ Fig. 2 A ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualslogAvgGDPpc",
                   var2 = "residualsavgGenderDiff_GEI",
                   labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                            "Average Gender Differences \n(residualized using Gender Equality Index)",
                            "Economic Development"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/main_Fig2A.png"
)

## ------------------------------ Fig. 2 B ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualsGenderIndexStd",
                   var2 = "residualsavgGenderDiff_GDP",
                   labs = c("Gender Equality Index (residualized using Log GDP p/c)",
                            "Average Gender Differences \n(residualized using Log GDP p/c)",
                            "Gender Equality"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/main_Fig2B.png"
)

## ------------------------------ Fig. 2 C ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualsScoreWEFStd",
                   var2 = "residualsavgGenderDiff_GDP",
                   labs = c("WEF Global Gender Gap Index (residualized using Log GDP p/c)",
                            "Average Gender Differences \n(residualized using Log GDP p/c)",
                            "WEF Global Gender Gap Index"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/main_Fig2C.png"
)

## ------------------------------ Fig. 2 D ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualsValueUNStd",
                   var2 = "residualsavgGenderDiff_GDP",
                   labs = c("UN Gender Equality Index (residualized using Log GDP p/c)",
                            "Average Gender Differences \n(residualized using Log GDP p/c)",
                            "UN Gender Equality Index"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/main_Fig2D.png"
)

## ------------------------------ Fig. 2 E ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualsavgRatioLaborStd",
                   var2 = "residualsavgGenderDiff_GDP",
                   labs = c("Ratio Female to Male (residualized using Log GDP p/c)",
                            "Average Gender Differences \n(residualized using Log GDP p/c)",
                            "Ratio Female to Male LFP"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/main_Fig2E.png"
)

## ------------------------------ Fig. 2 F ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualsDateStd",
                   var2 = "residualsavgGenderDiff_GDP",
                   labs = c("Time since Women's Suffrage (residualized using Log GDP p/c)",
                            "Average Gender Differences \n(residualized using Log GDP p/c)",
                            "Time since Women's Suffrage"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/main_Fig2F.png"
)

## --------------------------------- EXTRA ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualsGDIStd",
                   var2 = "residualsavgGenderDiff_GDP",
                   labs = c("Gender Development Index (residualized using Log GDP p/c)",
                            "Average Gender Differences \n(residualized using Log GDP p/c)",
                            "Gender Development Index"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/main_ExtraResidualised.png"
)

# ===================================== #
#### 2. SUPPLEMENTARY MATERIAL PLOTS ####
# ===================================== #

# -------------------------------- Fig. S1 ----------------------------------- #
toPlot <- unique(dataCoeff_summary[, .(preference, meanGender, stdGender)])

toPlot$preference_f <- factor(toPlot$preference, 
                              levels = c("altruism", "trust", "posrecip",
                                         "negrecip", "risktaking", "patience"))

plotS1 <-
  ggplot(toPlot, aes(x = preference_f, y = meanGender)) +
  geom_bar(stat = "identity", aes(fill = preference), width = 0.4) +
  geom_errorbar(aes(ymin = meanGender - stdGender / 2, ymax = meanGender + stdGender / 2),
                width = .1, size = 0.3) +
  scale_fill_brewer(palette = "Dark2") +
  theme_bw() +
  theme(legend.title     = element_blank(),
        strip.background = element_rect(colour = "white", fill = "white"),
        axis.title.y     = element_text(size = 12, angle = 90),
        legend.position  = "none",
        axis.text.x      = element_text(size = 12, colour = "black"),
        axis.ticks.x     = element_blank(),
        panel.spacing.y  = unit(1.5, "lines"),
        strip.text.x     = element_text(size = 14)) +
  xlab("") + ylab("Gender Difference (in Standard Deviations)") +
  scale_x_discrete(labels = c("altruism" = "Altruism", 
                              "trust"    = "Trust", 
                              "posrecip" = "Pos. Recip.",
                              "negrecip" = "Neg. Recip.", 
                              "risktaking" = "Risk Taking", 
                              "patience"   = "Patience"))
ggsave(filename = "ExtendedAnalysis/plots/supplementary_FigS1.png", plot = plotS1)

# -------------------------------- Fig. S2 ----------------------------------- #
PlotSummary_robust(data = dataCoeff_summary,
                   var1 = "logAvgGDPpc", 
                   var2 = "gender", 
                   var3 = "preference",
                   labs = c("Log GDP p/c",
                            "Gender Differences (in standard deviations)"),
                  # display = TRUE
                  save = "ExtendedAnalysis/plots/supplementary_FigS2.png"
)

# -------------------------------- Fig. S3 ----------------------------------- #
PlotSummary_robust(data = dataCoeff_summary,
                   var1 = "GenderIndex", 
                   var2 = "gender", 
                   var3 = "preference",
                   labs = c("Gender Equality Index",
                            "Gender Differences (in standard deviations)"),
                   #  display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS3.png"
)

## ------------------------------- Fig. S4 ----------------------------------- #
PlotSummary_robust(data = summaryIndex, 
                   var1 = "ScoreWEFStd", 
                   var2 = "avgGenderDiffRescaled",
                   labs = c("WEF Global Gender Gap Index (Standardized)",
                            "Average Gender Differences (Index)",
                            "WEF Global Gender Gap Index"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS4A.png"
)

PlotSummary_robust(data = summaryIndex, 
                   var1 = "ValueUNStd", 
                   var2 = "avgGenderDiffRescaled",
                   labs = c("UN Gender Equality Index (Standardized)",
                            "Average Gender Differences (Index)",
                            "UN Gender Equality Index"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS4B.png"
)

PlotSummary(data = summaryIndex, 
            var1 = "avgRatioLaborStd", 
            var2 = "avgGenderDiffRescaled",
            labs = c("Ratio Female to Male (Standardized)",
                     "Average Gender Differences (Index)",
                     "Ratio Female to Male LFP"),
            #  display = TRUE,
            save = "ExtendedAnalysis/plots/supplementary_FigS4C.png"
)

PlotSummary_robust(data = summaryIndex, 
                   var1 = "DateStd", 
                   var2 = "avgGenderDiffRescaled",
                   labs = c("Time since Women's Suffrage (Standardized)",
                            "Average Gender Differences (Index)",
                            "Time since Women's Suffrage"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS4D.png"
)

PlotSummary_robust(data = summaryIndex, 
                   var1 = "GDIStd", 
                   var2 = "avgGenderDiffRescaled",
                   labs = c("Gender Development Index (Standardized)",
                            "Average Gender Differences (Index)",
                            "Gender Development Index"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigExtra.png"
)

## ------------------------------- Fig. S5 ----------------------------------- #
PlotSummary_robust(data = dataCoeff_summary[preference == "trust"],
                   var1 = "residualslogAvgGDPpc_trust",
                   var2 = "residualsgenderGEI_trust",
                   labs = c("Log GDP p/c \n(residualized using Gender Equality Index)",
                            "Gender Differences \n(residualized using Gender Equality Index)",
                            "Trust (+)"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS5A.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "altruism"],
                   var1 = "residualslogAvgGDPpc_altruism",
                   var2 = "residualsgenderGEI_altruism",
                   labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                            "Gender Differences (residualized using Gender Equality Index)",
                            "Altruism (+)"),
                   #  display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS5B.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "posrecip"],
                   var1 = "residualslogAvgGDPpc_posrecip",
                   var2 = "residualsgenderGEI_posrecip",
                   labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                            "Gender Differences (residualized using Gender Equality Index)",
                            "Positive Reciprocity (+)"),
                   #  display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS5C.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "negrecip"],
                   var1 = "residualslogAvgGDPpc_negrecip",
                   var2 = "residualsgenderGEI_negrecip",
                   labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                            "Gender Differences (residualized using Gender Equality Index)",
                            "Negative Reciprocity (-)"),
                   #  display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS5D.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "risktaking"],
                   var1 = "residualslogAvgGDPpc_risktaking",
                   var2 = "residualsgenderGEI_risktaking",
                   labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                            "Gender Differences (residualized using Gender Equality Index)",
                            "Risk Taking (-)"),
                   #  display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS5E.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "patience"],
                   var1 = "residualslogAvgGDPpc_patience",
                   var2 = "residualsgenderGEI_patience",
                   labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                            "Gender Differences (residualized using Gender Equality Index)",
                            "Patience (-)"),
                   #  display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS5F.png"
)

## ------------------------------- Fig. S6 ----------------------------------- #
PlotSummary_robust(data = dataCoeff_summary[preference == "trust"],
                   var1 = "residualsGenderIndex_trust",
                   var2 = "residualsgenderGDP_trust",
                   labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                            "Gender Differences \n(residualized using Log GDP p/c)",
                            "Trust (+)"),
                   #  display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS6A.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "altruism"],
                   var1 = "residualsGenderIndex_altruism",
                   var2 = "residualsgenderGDP_altruism",
                   labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                            "Gender Differences \n(residualized using Log GDP p/c)",
                            "Altruism (+)"),
                   #  display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS6B.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "posrecip"],
                   var1 = "residualsGenderIndex_posrecip",
                   var2 = "residualsgenderGDP_posrecip",
                   labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                            "Gender Differences \n(residualized using Log GDP p/c)",
                            "Positive Reciprocity (+)"),
                   #  display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS6C.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "negrecip"],
                   var1 = "residualsGenderIndex_negrecip",
                   var2 = "residualsgenderGDP_negrecip",
                   labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                            "Gender Differences \n(residualized using Log GDP p/c)",
                            "Negative Reciprocity (-)"),
                   #  display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS6D.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "risktaking"],
                   var1 = "residualsGenderIndex_risktaking",
                   var2 = "residualsgenderGDP_risktaking",
                   labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                            "Gender Differences \n(residualized using Log GDP p/c)",
                            "Risk taking (-)"),
                   #  display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS6E.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "patience"],
                   var1 = "residualsGenderIndex_patience",
                   var2 = "residualsgenderGDP_patience",
                   labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                            "Gender Differences \n(residualized using Log GDP p/c)",
                            "Patience (-)"),
                   #  display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigS6F.png"
)

## ----------------------------- Fig. S Extra -------------------------------- #
PlotSummary_robust(data = dataCoeff_summary[preference == "trust"],
                   var1 = "residualsGenderIndex_trust",
                   var2 = "residualsgenderGDI_trust",
                   labs = c("Gender Development Index (residualized using Log GDP p/c)",
                            "Gender Differences \n(residualized using Log GDP p/c)",
                            "Trust (+)"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigSExtra1.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "altruism"],
                   var1 = "residualsGenderIndex_altruism",
                   var2 = "residualsgenderGDI_altruism",
                   labs = c("Gender Development Index (residualized using Log GDP p/c)",
                            "Gender Differences \n(residualized using Log GDP p/c)",
                            "Altruism (+)"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigSExtra2.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "posrecip"],
                   var1 = "residualsGenderIndex_posrecip",
                   var2 = "residualsgenderGDI_posrecip",
                   labs = c("Gender Development Index (residualized using Log GDP p/c)",
                            "Gender Differences \n(residualized using Log GDP p/c)",
                            "Positive Reciprocity (+)"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigSExtra3.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "negrecip"],
                   var1 = "residualsGenderIndex_negrecip",
                   var2 = "residualsgenderGDI_negrecip",
                   labs = c("Gender Development Index (residualized using Log GDP p/c)",
                            "Gender Differences \n(residualized using Log GDP p/c)",
                            "Negative Reciprocity (-)"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigSExtra4.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "risktaking"],
                   var1 = "residualsGenderIndex_risktaking",
                   var2 = "residualsgenderGDI_risktaking",
                   labs = c("Gender Development Index (residualized using Log GDP p/c)",
                            "Gender Differences \n(residualized using Log GDP p/c)",
                            "Risk taking (-)"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigSExtra5.png"
)

PlotSummary_robust(data = dataCoeff_summary[preference == "patience"],
                   var1 = "residualsGenderIndex_patience",
                   var2 = "residualsgenderGDI_patience",
                   labs = c("Gender Development Index (residualized using Log GDP p/c)",
                            "Gender Differences \n(residualized using Log GDP p/c)",
                            "Patience (-)"),
                   # display = TRUE,
                   save = "ExtendedAnalysis/plots/supplementary_FigSExtra6.png"
)
