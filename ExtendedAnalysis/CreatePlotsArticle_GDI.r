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
LoadRequiredLibraries()

# Load the data
dataSummary <- fread("ExtendedAnalysis/files/output/main_data_for_histograms.csv")
summaryIndex <- fread("ExtendedAnalysis/files/output/main_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")


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
  ggplot(data = unique(dataSummary[, c(1, 3, 6, 9)])) +
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
ggsave(filename = "plots/main_Fig1A.png", plot = plotHistA)

## ----------------------------- Fig. 1 B ------------------------------------ #
PlotSummary_robust(data = summaryIndex,
                   var1 = "logAvgGDPpc", 
                   var2 = "avgGenderDiffRescaled",
                   labs = c("Log GDP p/c",
                            "Average Gender Differences (Index)"),  
                   display = TRUE,
                   # save = "plots/main_Fig1B.png"
)

## ----------------------------- Fig. 1 C ------------------------------------ #
plotHistC <-
  ggplot(data = unique(dataSummary[, c(1, 4, 7, 9)])) +
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
ggsave(filename = "plots/main_Fig1C.png", plot = plotHistC)

## ----------------------------- Fig. 1 D ------------------------------------ #
PlotSummary_robust(data = summaryIndex,
                   var1 = "GenderIndexRescaled", 
                   var2 = "avgGenderDiffRescaled",
                   labs = c("Gender Equality Index",
                            "Average Gender Differences (Index)"),  
                   display = TRUE,
                   #  save = "plots/main_Fig1D.png"
)

## ------------------------------ EXTRA -------------------------------------- #
ggplot(data = unique(dataSummary[, c(1, 5, 8, 9)])) +
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
# ggsave(filename = "plots/main_ExtraHist.png", plot = plotHistC)


PlotSummary_robust(data = summaryIndex,
                   var1 = "GDI", 
                   var2 = "avgGenderDiffRescaled",
                   labs = c("Gender Development Index",
                            "Average Gender Differences (Index)"),  
                   display = TRUE,
                   #  save = "plots/main_ExtraGDI.png"
)



## ------------------------------ Fig. 2 A ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualslogAvgGDPpc",
                   var2 = "residualsavgGenderDiff_GEI",
                   labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                            "Average Gender Differences \n(residualized using Gender Equality Index)",
                            "Economic Development"),
                   display = TRUE,
                   # save = "plots/main_Fig2A.png"
)

## ------------------------------ Fig. 2 B ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualsGenderIndexStd",
                   var2 = "residualsavgGenderDiff_GDP",
                   labs = c("Gender Equality Index (residualized using Log GDP p/c)",
                            "Average Gender Differences \n(residualized using Log GDP p/c)",
                            "Gender Equality"),
                   display = TRUE,
                   #  save = "plots/main_Fig2B.png"
)

## ------------------------------ Fig. 2 C ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualsScoreWEFStd",
                   var2 = "residualsavgGenderDiff_GDP",
                   labs = c("WEF Global Gender Gap Index (residualized using Log GDP p/c)",
                            "Average Gender Differences \n(residualized using Log GDP p/c)",
                            "WEF Global Gender Gap Index"),
                   display = TRUE,
                   #  save = "plots/main_Fig2C.png"
)

## ------------------------------ Fig. 2 D ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualsValueUNStd",
                   var2 = "residualsavgGenderDiff_GDP",
                   labs = c("UN Gender Equality Index (residualized using Log GDP p/c)",
                            "Average Gender Differences \n(residualized using Log GDP p/c)",
                            "UN Gender Equality Index"),
                   display = TRUE,
                   # save = "plots/main_Fig2D.png"
)

## ------------------------------ Fig. 2 E ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualsavgRatioLaborStd",
                   var2 = "residualsavgGenderDiff_GDP",
                   labs = c("Ratio Female to Male (residualized using Log GDP p/c)",
                            "Average Gender Differences \n(residualized using Log GDP p/c)",
                            "Ratio Female to Male LFP"),
                   display = TRUE,
                   #  save = "plots/main_Fig2E.png"
)

## ------------------------------ Fig. 2 F ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualsDateStd",
                   var2 = "residualsavgGenderDiff_GDP",
                   labs = c("Time since Women's Suffrage (residualized using Log GDP p/c)",
                            "Average Gender Differences \n(residualized using Log GDP p/c)",
                            "Time since Women's Suffrage"),
                   display = TRUE,
                   #  save = "plots/main_Fig2F.png"
)

## --------------------------------- EXTRA ----------------------------------- #
PlotSummary_robust(data = summaryIndex,
                   var1 = "residualsGDIStd",
                   var2 = "residualsavgGenderDiff_GDP",
                   labs = c("Gender Development Index (residualized using Log GDP p/c)",
                            "Average Gender Differences \n(residualized using Log GDP p/c)",
                            "Gender Development Index"),
                   display = TRUE,
                   #  save = "plots/main_ExtraResidualised.png"
)

