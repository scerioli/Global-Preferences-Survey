## ============================================================================ #
####  ANALYSIS OF GLOBAL PREFERENCES with ROBUST LINEAR REGRESSION and GDI  ####
# ============================================================================ #
# This analysis is divided into two main parts:
# 1. Additional data analysis, using the Gender Development Index instead of the
#    Gender Equality Index, as indicated in the technical notes of the United 
#    Nations Human Development Indicators (version of 2020):
#    http://hdr.undp.org/sites/default/files/hdr2020_technical_notes.pdf
# 2. Use of the robust linear regression instead of OLS, for the whole 
#    replication analysis and the new data added here.


#### 0. Load Data and Set Paths ####
# -------------------------------- #

# Set the path
setwd("~/Desktop/Projects/Global-Preferences-Survey/")

# Source helper functions
source("ReproductionAnalysis/functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "ReproductionAnalysis/functions/")
SourceFunctions(path = "ReproductionAnalysis/functions/helper_functions/")
SourceFunctions(path = "ExtendedAnalysis/functions/")

# Load libraries
LoadRequiredLibraries()


# ================= #
#### 1. NEW DATA ####
# ================= #

# Load the data
dataSummary_new <- fread("ExtendedAnalysis/files/output/newData_data_for_histograms.csv")
summaryIndex_new <- fread("ExtendedAnalysis/files/output/newData_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
dataCoeff_summary_new <- fread("ExtendedAnalysis/files/output/newData_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")

#### Main Plots ####
# ---------------- #

dataSummary_new$preference_f <- factor(dataSummary_new$preference, 
                                       levels = c("altruism", "trust", "posrecip",
                                                  "negrecip", "risktaking", "patience"))
labels_preferences <- c("Altruism (+)", "Trust (+)", "Pos. Recip. (+)",
                        "Neg. Recip. (-)", "Risk Taking (-)", "Patience (-)")
names(labels_preferences) <- c("altruism", "trust", "posrecip",
                               "negrecip", "risktaking", "patience")


plotHist_newData <-
  ggplot(data = unique(dataSummary_new[, c(1, 4, 7, 8)])) +
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
# ggsave(filename = "ExtendedAnalysis/plots/newData_Fig1A.png",
#  plot = plotHist_newData)


PlotSummary(data = summaryIndex_new,
            var1 = "GDI", 
            var2 = "avgGenderDiffRescaled",
            labs = c("Gender Development Index",
                     "Average Gender Differences (Index)"),  
            robust = FALSE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/extended_genderDiff_GDI.pdf"
)


## --------------------------------- EXTRA ----------------------------------- #
## ----- WEF ------- #
PlotSummary(data = summaryIndex_new,
            var1 = "residualslogAvgGDPpcStd_WEF",
            var2 = "residualsavgGenderDiffStd_WEF",
            labs = c("Log GDP p/c (residualized using WEF GGI)",
                     "Average Gender Differences \n(residualized using WEF GGI)",
                     "Economic Development"),
            corr = FALSE,
            display = TRUE,
            #  save = "ExtendedAnalysis/plots/main_ExtraResidualised.png"
)

PlotSummary(data = summaryIndex_new,
            var1 = "residualsScoreWEFStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Average Gender Differences \n(residualized using Log GDP p/c)",
                     "WEF Global Gender Gap Index"),
            corr = FALSE,
            display = TRUE,
            #  save = "ExtendedAnalysis/plots/main_ExtraResidualised.png"
)

## ------ UNDP ------ #
PlotSummary(data = summaryIndex_new,
            var1 = "residualslogAvgGDPpcStd_UN",
            var2 = "residualsavgGenderDiffStd_UN",
            labs = c("Log GDP p/c (residualized using UNDP GII)",
                     "Average Gender Differences \n(residualized using UNDP GII)",
                     "Economic Development"),
            corr = FALSE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_ExtraResidualised2.png"
)

PlotSummary(data = summaryIndex_new,
            var1 = "residualsValueUNStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("UNDP GI Index (residualized using Log GDP p/c)",
                     "Average Gender Differences \n(residualized using Log GDP p/c)",
                     "UNDP Gender Inequality Index Index"),
            corr = FALSE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_ExtraResidualised2.png"
)

## ------- GDI ------ #
PlotSummary(data = summaryIndex_new,
            var1 = "residualslogAvgGDPpcStd_GDI",
            var2 = "residualsavgGenderDiffStd_GDI",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Average Gender Differences \n(residualized using Gender Development Index)",
                     "Economic Development"),
            corr = FALSE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_ExtraResidualised2.png"
)

PlotSummary(data = summaryIndex_new,
            var1 = "residualsGDIStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Average Gender Differences \n(residualized using Log GDP p/c)",
                     "Gender Development Index"),
            corr = FALSE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_ExtraResidualised2.png"
)


#### Supplementary Plots ####
# ------------------------- #

# ------------------------------ Fig. SExtra --------------------------------- #
PlotSummary(data = dataCoeff_summary_new,
            var1 = "GDIStd", 
            var2 = "gender", 
            var3 = "preference",
            labs = c("Gender Development Index",
                     "Gender Differences (in standard deviations)"),
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS3Extra.png"
)


## ----------------------------- Fig. S5 Extra ------------------------------- #
## ------ WEF ------- #
PlotSummary(data = dataCoeff_summary_new[preference == "trust"],
            var1 = "residualslogAvgGDPpc_WEF_trust",
            var2 = "residualsgenderWEF_trust",
            labs = c("Log GDP p/c \n(residualized using WEF GGG Index)",
                     "Gender Differences \n(residualized using WEF GGG Index)",
                     "Trust (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5A_WEF.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "altruism"],
            var1 = "residualslogAvgGDPpc_WEF_altruism",
            var2 = "residualsgenderWEF_altruism",
            labs = c("Log GDP p/c (residualized using WEF GGG Index)",
                     "Gender Differences \n(residualized using WEF GGG Index)",
                     "Altruism (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5B_WEF.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "posrecip"],
            var1 = "residualslogAvgGDPpc_WEF_posrecip",
            var2 = "residualsgenderWEF_posrecip",
            labs = c("Log GDP p/c (residualized using WEF GGG Index)",
                     "Gender Differences \n(residualized using WEF GGG Index)",
                     "Positive Reciprocity (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5C_WEF.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "negrecip"],
            var1 = "residualslogAvgGDPpc_WEF_negrecip",
            var2 = "residualsgenderWEF_negrecip",
            labs = c("Log GDP p/c (residualized using WEF GGG Index)",
                     "Gender Differences \n(residualized using WEF GGG Index)",
                     "Negative Reciprocity (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5D_WEF.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "risktaking"],
            var1 = "residualslogAvgGDPpc_WEF_risktaking",
            var2 = "residualsgenderWEF_risktaking",
            labs = c("Log GDP p/c (residualized using WEF GGG Index)",
                     "Gender Differences \n(residualized using WEF GGG Index)",
                     "Risk taking (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5E_WEF.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "patience"],
            var1 = "residualslogAvgGDPpc_WEF_patience",
            var2 = "residualsgenderWEF_patience",
            labs = c("Log GDP p/c (residualized using WEF GGG Index)",
                     "Gender Differences \n(residualized using WEF GGG Index)",
                     "Patience (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5F_WEF.png"
)


## ------ UN ------- #
PlotSummary(data = dataCoeff_summary_new[preference == "trust"],
            var1 = "residualslogAvgGDPpc_UN_trust",
            var2 = "residualsgenderUN_trust",
            labs = c("Log GDP p/c (residualized using UN GI Index)",
                     "Summarised Gender Differences \n(residualized using UN GI Index)",
                     "Trust (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5A_UN.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "altruism"],
            var1 = "residualslogAvgGDPpc_UN_altruism",
            var2 = "residualsgenderUN_altruism",
            labs = c("Log GDP p/c (residualized using UN GI Index)",
                     "Gender Differences \n(residualized using UN GI Index)",
                     "Altruism (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5B_UN.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "posrecip"],
            var1 = "residualslogAvgGDPpc_UN_posrecip",
            var2 = "residualsgenderUN_posrecip",
            labs = c("Log GDP p/c (residualized using UN GI Index)",
                     "Gender Differences \n(residualized using UN GI Index)",
                     "Positive Reciprocity (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5C_UN.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "negrecip"],
            var1 = "residualslogAvgGDPpc_UN_negrecip",
            var2 = "residualsgenderUN_negrecip",
            labs = c("Log GDP p/c (residualized using UN GI Index)",
                     "Gender Differences \n(residualized using UN GI Index)",
                     "Negative Reciprocity (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5D_UN.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "risktaking"],
            var1 = "residualslogAvgGDPpc_UN_risktaking",
            var2 = "residualsgenderUN_risktaking",
            labs = c("Log GDP p/c (residualized using UN GI Index)",
                     "Gender Differences \n(residualized using UN GI Index)",
                     "Risk taking (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5E_UN.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "patience"],
            var1 = "residualslogAvgGDPpc_UN_patience",
            var2 = "residualsgenderUN_patience",
            labs = c("Log GDP p/c (residualized using UN GI Index)",
                     "Gender Differences \n(residualized using UN GI Index)",
                     "Patience (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5F_UN.png"
)

## ------ GDI ------- #
PlotSummary(data = dataCoeff_summary_new[preference == "trust"],
            var1 = "residualslogAvgGDPpc_GDI_trust",
            var2 = "residualsgenderGDI_trust",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Gender Differences \n(Gender Development Index)",
                     "Trust (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5A_GDI.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "altruism"],
            var1 = "residualslogAvgGDPpc_GDI_altruism",
            var2 = "residualsgenderGDI_altruism",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Gender Differences \n(residualized using Gender Development Index)",
                     "Altruism (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5B_GDI.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "posrecip"],
            var1 = "residualslogAvgGDPpc_GDI_posrecip",
            var2 = "residualsgenderGDI_posrecip",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Gender Differences \n(residualized using Gender Development Index)",
                     "Positive Reciprocity (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5C_GDI.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "negrecip"],
            var1 = "residualslogAvgGDPpc_GDI_negrecip",
            var2 = "residualsgenderGDI_negrecip",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Gender Differences \n(residualized using Gender Development Index)",
                     "Negative Reciprocity (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5D_GDI.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "risktaking"],
            var1 = "residualslogAvgGDPpc_GDI_risktaking",
            var2 = "residualsgenderGDI_risktaking",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Gender Differences \n(residualized using Gender Development Index)",
                     "Risk taking (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5E_GDI.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "patience"],
            var1 = "residualslogAvgGDPpc_GDI_patience",
            var2 = "residualsgenderGDI_patience",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Gender Differences \n(residualized using Gender Development Index)",
                     "Patience (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS5F_GDI.png"
)

## ----------------------------- Fig. S6 Extra ------------------------------- #
## ---------- WEF ------- #
PlotSummary(data = dataCoeff_summary_new[preference == "trust"],
            var1 = "residualsWEF_GDP_trust",
            var2 = "residualsgenderGDP_trust",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Trust (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6A_WEF.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "altruism"],
            var1 = "residualsWEF_GDP_altruism",
            var2 = "residualsgenderGDP_altruism",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Altruism (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6B_WEF.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "posrecip"],
            var1 = "residualsWEF_GDP_posrecip",
            var2 = "residualsgenderGDP_posrecip",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Positive Reciprocity (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6C_WEF.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "negrecip"],
            var1 = "residualsWEF_GDP_negrecip",
            var2 = "residualsgenderGDP_negrecip",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Negative Reciprocity (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6D_WEF.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "risktaking"],
            var1 = "residualsWEF_GDP_risktaking",
            var2 = "residualsgenderGDP_risktaking",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Risk taking (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6E_WEF.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "patience"],
            var1 = "residualsWEF_GDP_patience",
            var2 = "residualsgenderGDP_patience",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Patience (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6F_WEF.png"
)

## ---------- UN ------- #
PlotSummary(data = dataCoeff_summary_new[preference == "trust"],
            var1 = "residualsUN_GDP_trust",
            var2 = "residualsgenderGDP_trust",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Trust (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6A_UN.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "altruism"],
            var1 = "residualsUN_GDP_altruism",
            var2 = "residualsgenderGDP_altruism",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Altruism (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6B_UN.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "posrecip"],
            var1 = "residualsUN_GDP_posrecip",
            var2 = "residualsgenderGDP_posrecip",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Positive Reciprocity (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6C_UN.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "negrecip"],
            var1 = "residualsUN_GDP_negrecip",
            var2 = "residualsgenderGDP_negrecip",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Negative Reciprocity (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6D_UN.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "risktaking"],
            var1 = "residualsUN_GDP_risktaking",
            var2 = "residualsgenderGDP_risktaking",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Risk taking (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6E_UN.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "patience"],
            var1 = "residualsUN_GDP_patience",
            var2 = "residualsgenderGDP_patience",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Patience (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6F_UN.png"
)

## ---------- GDI ------- #
PlotSummary(data = dataCoeff_summary_new[preference == "trust"],
            var1 = "residualsGDI_GDP_trust",
            var2 = "residualsgenderGDP_trust",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Trust (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6A_GDI.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "altruism"],
            var1 = "residualsGDI_GDP_altruism",
            var2 = "residualsgenderGDP_altruism",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Altruism (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6B_GDI.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "posrecip"],
            var1 = "residualsGDI_GDP_posrecip",
            var2 = "residualsgenderGDP_posrecip",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Positive Reciprocity (+)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6C_GDI.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "negrecip"],
            var1 = "residualsGDI_GDP_negrecip",
            var2 = "residualsgenderGDP_negrecip",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Negative Reciprocity (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6D_GDI.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "risktaking"],
            var1 = "residualsGDI_GDP_risktaking",
            var2 = "residualsgenderGDP_risktaking",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Risk taking (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6E_GDI.png"
)

PlotSummary(data = dataCoeff_summary_new[preference == "patience"],
            var1 = "residualsGDI_GDP_patience",
            var2 = "residualsgenderGDP_patience",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Patience (-)"),
            # display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6F_GDI.png"
)


# ================================= #
#### 2. ROBUST LINEAR REGRESSION ####
# ================================= #

# Load the data
dataSummary_robust <- fread("ExtendedAnalysis/files/output/robust_data_for_histograms.csv")
summaryIndex_robust <- fread("ExtendedAnalysis/files/output/robust_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
dataCoeff_summary_robust <- fread("ExtendedAnalysis/files/output/robust_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")


#### Main Plots ####
# ---------------- #

## ----------------------------- Fig. 1 A ------------------------------------ #
dataSummary_robust$preference_f <- factor(dataSummary_robust$preference, 
                                          levels = c("altruism", "trust", "posrecip",
                                                     "negrecip", "risktaking", "patience"))
labels_preferences <- c("Altruism (+)", "Trust (+)", "Pos. Recip. (+)",
                        "Neg. Recip. (-)", "Risk Taking (-)", "Patience (-)")
names(labels_preferences) <- c("altruism", "trust", "posrecip",
                               "negrecip", "risktaking", "patience")

plotHistA_robust <-
  ggplot(data = unique(dataSummary_robust[, c(1, 2, 5, 8)])) +
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
# ggsave(filename = "ExtendedAnalysis/plots/robust_Fig1A.png", 
# plot = plotHistA_robust)

## ----------------------------- Fig. 1 B ------------------------------------ #
PlotSummary(data = summaryIndex_robust,
            var1 = "logAvgGDPpc", 
            var2 = "avgGenderDiffRescaled",
            labs = c("Log GDP p/c",
                     "Average Gender Differences (Index)"),  
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig1B.pdf"
)

## ----------------------------- Fig. 1 C ------------------------------------ #
plotHistC_robust <-
  ggplot(data = unique(dataSummary_robust[, c(1, 3, 6, 8)])) +
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
# ggsave(filename = "ExtendedAnalysis/plots/robust_Fig1C.png", 
# plot = plotHistC_robust)

## ----------------------------- Fig. 1 D ------------------------------------ #
PlotSummary(data = summaryIndex_robust,
            var1 = "GenderIndexRescaled", 
            var2 = "avgGenderDiffRescaled",
            labs = c("Gender Equality Index",
                     "Average Gender Differences (Index)"), 
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig1D.pdf"
)

## ------------------------------ EXTRA -------------------------------------- #
plotHist_newData_robust <-
  ggplot(data = unique(dataSummary_robust[, c(1, 4, 7, 8)])) +
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
# ggsave(filename = "ExtendedAnalysis/plots/robust_ExtraHist.png", 
#        plot = plotHist_newData_robust)


PlotSummary(data = summaryIndex_robust,
            var1 = "GDI", 
            var2 = "avgGenderDiffRescaled",
            labs = c("Gender Development Index",
                     "Average Gender Differences (Index)"),  
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/extended_genderDiff_GDI.pdf"
)


## ------------------------------ Fig. 2 A ----------------------------------- #
PlotSummary(data = summaryIndex_robust,
            var1 = "residualslogAvgGDPpcStd_GEI",
            var2 = "residualsavgGenderDiffStd_GEI",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Average Gender Differences \n(residualized using Gender Equality Index)",
                     "Economic Development"),
            corr = FALSE,
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2A.png"
)

## ------------------------------ Fig. 2 B ----------------------------------- #
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsGenderIndexStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("Gender Equality Index (residualized using Log GDP p/c)",
                     "Average Gender Differences \n(residualized using Log GDP p/c)",
                     "Gender Equality"),
            corr = FALSE,
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2B.png"
)

## ------------------------------ Fig. 2 C ----------------------------------- #
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsScoreWEFStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("WEF Global Gender Gap Index (residualized using Log GDP p/c)",
                     "Average Gender Differences \n(residualized using Log GDP p/c)",
                     "WEF Global Gender Gap Index"),
            corr = FALSE,
            robust = TRUE,
            display = TRUE,
            #save = "ExtendedAnalysis/plots/main_Fig2C.png"
)

## ------------------------------ Fig. 2 D ----------------------------------- #
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsValueUNStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("UN Gender Equality Index (residualized using Log GDP p/c)",
                     "Average Gender Differences \n(residualized using Log GDP p/c)",
                     "UN Gender Equality Index"),
            corr = FALSE,
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2D.png"
)

## ------------------------------ Fig. 2 E ----------------------------------- #
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsavgRatioLaborStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("Ratio Female to Male (residualized using Log GDP p/c)",
                     "Average Gender Differences \n(residualized using Log GDP p/c)",
                     "Ratio Female to Male LFP"),
            corr = FALSE,
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2E.png"
)

## ------------------------------ Fig. 2 F ----------------------------------- #
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsDateStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("Time since Women's Suffrage (residualized using Log GDP p/c)",
                     "Average Gender Differences \n(residualized using Log GDP p/c)",
                     "Time since Women's Suffrage"),
            corr = FALSE,
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2F.png"
)

## --------------------------------- EXTRA ----------------------------------- #
PlotSummary(data = summaryIndex_robust,
            var1 = "residualslogAvgGDPpcStd.y",
            var2 = "residualsavgGenderDiffStd_GDI",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Average Gender Differences \n(residualized using Gender Development Index)",
                     "Economic Development"),
            corr = FALSE,
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_ExtraResidualised.png"
)

PlotSummary(data = summaryIndex_robust,
            var1 = "residualsGDIStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Average Gender Differences \n(residualized using Log GDP p/c)",
                     "Gender Development Index"),
            corr = FALSE,
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_ExtraResidualised2.png"
)


#### Supplementary Plots ####
# ------------------------- #

# -------------------------------- Fig. S1 ----------------------------------- #
toPlot <- unique(dataCoeff_summary_robust[, .(preference, meanGender, stdGender)])

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
# ggsave(filename = "ExtendedAnalysis/plots/supplementary_FigS1.png", plot = plotS1)

# -------------------------------- Fig. S2 ----------------------------------- #
PlotSummary(data = dataCoeff_summary_robust,
            var1 = "logAvgGDPpcStd", 
            var2 = "gender", 
            var3 = "preference",
            labs = c("Log GDP p/c",
                     "Gender Differences (in standard deviations)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS2.png"
)

# -------------------------------- Fig. S3 ----------------------------------- #
PlotSummary(data = dataCoeff_summary_robust,
            var1 = "GenderIndexStd", 
            var2 = "gender", 
            var3 = "preference",
            labs = c("Gender Equality Index",
                     "Gender Differences (in standard deviations)"),
            robust = TRUE,
            display = TRUE,
            #save = "ExtendedAnalysis/plots/supplementary_FigS3.png"
)

# ------------------------------ Fig. SExtra --------------------------------- #
PlotSummary(data = dataCoeff_summary_robust,
            var1 = "GDI", 
            var2 = "gender", 
            var3 = "preference",
            labs = c("Gender Development Index",
                     "Gender Differences (in standard deviations)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS3Extra.png"
)

## ------------------------------- Fig. S4 ----------------------------------- #
PlotSummary(data = summaryIndex_robust, 
            var1 = "ScoreWEFStd", 
            var2 = "avgGenderDiffRescaled",
            labs = c("WEF Global Gender Gap Index (Standardized)",
                     "Average Gender Differences (Index)",
                     "WEF Global Gender Gap Index"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS4A.png"
)

PlotSummary(data = summaryIndex_robust, 
            var1 = "ValueUNStd", 
            var2 = "avgGenderDiffRescaled",
            labs = c("UN Gender Equality Index (Standardized)",
                     "Average Gender Differences (Index)",
                     "UN Gender Equality Index"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS4B.png"
)

PlotSummary(data = summaryIndex_robust, 
            var1 = "avgRatioLaborStd", 
            var2 = "avgGenderDiffRescaled",
            labs = c("Ratio Female to Male (Standardized)",
                     "Average Gender Differences (Index)",
                     "Ratio Female to Male LFP"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS4C.png"
)

PlotSummary(data = summaryIndex_robust, 
            var1 = "DateStd", 
            var2 = "avgGenderDiffRescaled",
            labs = c("Time since Women's Suffrage (Standardized)",
                     "Average Gender Differences (Index)",
                     "Time since Women's Suffrage"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS4D.png"
)

PlotSummary(data = summaryIndex_robust, 
            var1 = "GDIStd", 
            var2 = "avgGenderDiffRescaled",
            labs = c("Gender Development Index (Standardized)",
                     "Average Gender Differences (Index)",
                     "Gender Development Index"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigExtra.png"
)

## ------------------------------- Fig. S5 ----------------------------------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualslogAvgGDPpc_GEI_trust",
            var2 = "residualsgenderGEI_trust",
            labs = c("Log GDP p/c \n(residualized using Gender Equality Index)",
                     "Gender Differences \n(residualized using Gender Equality Index)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS5A.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualslogAvgGDPpc_GEI_altruism",
            var2 = "residualsgenderGEI_altruism",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS5B.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualslogAvgGDPpc_GEI_posrecip",
            var2 = "residualsgenderGEI_posrecip",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS5C.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualslogAvgGDPpc_GEI_negrecip",
            var2 = "residualsgenderGEI_negrecip",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS5D.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualslogAvgGDPpc_GEI_risktaking",
            var2 = "residualsgenderGEI_risktaking",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Risk Taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS5E.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualslogAvgGDPpc_GEI_patience",
            var2 = "residualsgenderGEI_patience",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            #  save = "ExtendedAnalysis/plots/supplementary_FigS5F.png"
)

## ------------------------------- Fig. S6 ----------------------------------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualsGenderIndex_GDP_trust",
            var2 = "residualsgenderGDP_trust",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            #  save = "ExtendedAnalysis/plots/supplementary_FigS6A.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualsGenderIndex_GDP_altruism",
            var2 = "residualsgenderGDP_altruism",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS6B.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualsGenderIndex_GDP_posrecip",
            var2 = "residualsgenderGDP_posrecip",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS6C.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualsGenderIndex_GDP_negrecip",
            var2 = "residualsgenderGDP_negrecip",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS6D.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualsGenderIndex_GDP_risktaking",
            var2 = "residualsgenderGDP_risktaking",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS6E.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualsGenderIndex_GDP_patience",
            var2 = "residualsgenderGDP_patience",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS6F.png"
)

## ----------------------------- Fig. S5 Extra ------------------------------- #
## ------ WEF ------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualslogAvgGDPpc_WEF_trust",
            var2 = "residualsgenderWEF_trust",
            labs = c("Log GDP p/c \n(residualized using WEF GGG Index)",
                     "Gender Differences \n(residualized using WEF GGG Index)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5A_WEF.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualslogAvgGDPpc_WEF_altruism",
            var2 = "residualsgenderWEF_altruism",
            labs = c("Log GDP p/c (residualized using WEF GGG Index)",
                     "Gender Differences \n(residualized using WEF GGG Index)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5B_WEF.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualslogAvgGDPpc_WEF_posrecip",
            var2 = "residualsgenderWEF_posrecip",
            labs = c("Log GDP p/c (residualized using WEF GGG Index)",
                     "Gender Differences \n(residualized using WEF GGG Index)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5C_WEF.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualslogAvgGDPpc_WEF_negrecip",
            var2 = "residualsgenderWEF_negrecip",
            labs = c("Log GDP p/c (residualized using WEF GGG Index)",
                     "Gender Differences \n(residualized using WEF GGG Index)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5D_WEF.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualslogAvgGDPpc_WEF_risktaking",
            var2 = "residualsgenderWEF_risktaking",
            labs = c("Log GDP p/c (residualized using WEF GGG Index)",
                     "Gender Differences \n(residualized using WEF GGG Index)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5E_WEF.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualslogAvgGDPpc_WEF_patience",
            var2 = "residualsgenderWEF_patience",
            labs = c("Log GDP p/c (residualized using WEF GGG Index)",
                     "Gender Differences \n(residualized using WEF GGG Index)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5F_WEF.png"
)


## ------ UN ------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualslogAvgGDPpc_UN_trust",
            var2 = "residualsgenderUN_trust",
            labs = c("Log GDP p/c (residualized using UN GI Index)",
                     "Summarised Gender Differences \n(residualized using UN GI Index)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5A_UN.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualslogAvgGDPpc_UN_altruism",
            var2 = "residualsgenderUN_altruism",
            labs = c("Log GDP p/c (residualized using UN GI Index)",
                     "Gender Differences \n(residualized using UN GI Index)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5B_UN.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualslogAvgGDPpc_UN_posrecip",
            var2 = "residualsgenderUN_posrecip",
            labs = c("Log GDP p/c (residualized using UN GI Index)",
                     "Gender Differences \n(residualized using UN GI Index)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5C_UN.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualslogAvgGDPpc_UN_negrecip",
            var2 = "residualsgenderUN_negrecip",
            labs = c("Log GDP p/c (residualized using UN GI Index)",
                     "Gender Differences \n(residualized using UN GI Index)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5D_UN.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualslogAvgGDPpc_UN_risktaking",
            var2 = "residualsgenderUN_risktaking",
            labs = c("Log GDP p/c (residualized using UN GI Index)",
                     "Gender Differences \n(residualized using UN GI Index)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5E_UN.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualslogAvgGDPpc_UN_patience",
            var2 = "residualsgenderUN_patience",
            labs = c("Log GDP p/c (residualized using UN GI Index)",
                     "Gender Differences \n(residualized using UN GI Index)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5F_UN.png"
)

## ------ GDI ------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualslogAvgGDPpc_GDI_trust",
            var2 = "residualsgenderGDI_trust",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Gender Differences \n(Gender Development Index)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5A_GDI.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualslogAvgGDPpc_GDI_altruism",
            var2 = "residualsgenderGDI_altruism",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Gender Differences \n(residualized using Gender Development Index)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5B_GDI.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualslogAvgGDPpc_GDI_posrecip",
            var2 = "residualsgenderGDI_posrecip",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Gender Differences \n(residualized using Gender Development Index)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5C_GDI.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualslogAvgGDPpc_GDI_negrecip",
            var2 = "residualsgenderGDI_negrecip",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Gender Differences \n(residualized using Gender Development Index)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5D_GDI.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualslogAvgGDPpc_GDI_risktaking",
            var2 = "residualsgenderGDI_risktaking",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Gender Differences \n(residualized using Gender Development Index)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5E_GDI.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualslogAvgGDPpc_GDI_patience",
            var2 = "residualsgenderGDI_patience",
            labs = c("Log GDP p/c (residualized using Gender Development Index)",
                     "Gender Differences \n(residualized using Gender Development Index)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS5F_GDI.png"
)

## ----------------------------- Fig. S6 Extra ------------------------------- #
## ---------- WEF ------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualsWEF_GDP_trust",
            var2 = "residualsgenderGDP_trust",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6A_WEF.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualsWEF_GDP_altruism",
            var2 = "residualsgenderGDP_altruism",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            save = "ExtendedAnalysis/plots/FigS6B_WEF.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualsWEF_GDP_posrecip",
            var2 = "residualsgenderGDP_posrecip",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6C_WEF.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualsWEF_GDP_negrecip",
            var2 = "residualsgenderGDP_negrecip",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6D_WEF.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualsWEF_GDP_risktaking",
            var2 = "residualsgenderGDP_risktaking",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6E_WEF.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualsWEF_GDP_patience",
            var2 = "residualsgenderGDP_patience",
            labs = c("WEF GGG Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6F_WEF.png"
)

## ---------- UN ------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualsUN_GDP_trust",
            var2 = "residualsgenderGDP_trust",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6A_UN.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualsUN_GDP_altruism",
            var2 = "residualsgenderGDP_altruism",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6B_UN.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualsUN_GDP_posrecip",
            var2 = "residualsgenderGDP_posrecip",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6C_UN.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualsUN_GDP_negrecip",
            var2 = "residualsgenderGDP_negrecip",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6D_UN.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualsUN_GDP_risktaking",
            var2 = "residualsgenderGDP_risktaking",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6E_UN.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualsUN_GDP_patience",
            var2 = "residualsgenderGDP_patience",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6F_UN.png"
)

## ---------- GDI ------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualsGDI_GDP_trust",
            var2 = "residualsgenderGDP_trust",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6A_GDI.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualsGDI_GDP_altruism",
            var2 = "residualsgenderGDP_altruism",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6B_GDI.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualsGDI_GDP_posrecip",
            var2 = "residualsgenderGDP_posrecip",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6C_GDI.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualsGDI_GDP_negrecip",
            var2 = "residualsgenderGDP_negrecip",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6D_GDI.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualsGDI_GDP_risktaking",
            var2 = "residualsgenderGDP_risktaking",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6E_GDI.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualsGDI_GDP_patience",
            var2 = "residualsgenderGDP_patience",
            labs = c("Gender Development Index (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/FigS6F_GDI.png"
)

