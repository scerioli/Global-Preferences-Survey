## ============================================================================ #
####  ANALYSIS OF GLOBAL PREFERENCES with ROBUST LINEAR REGRESSION and GDI  ####
# ============================================================================ #
# This script is intended to help the reprodcution of the plots and tables
# present in the main article and its supplementary material. The focus, in 
# opposition to the CreatePlotsArticle.r, is not to reproduce all the work done
# by FH, but to replicate our work. 
# Additional plots can be created with the use of the variables and the data 
# tables provided.


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

# Load the data
dataSummary_robust <- fread("ExtendedAnalysis/files/output/robust_data_for_histograms.csv")
summaryIndex_robust <- fread("ExtendedAnalysis/files/output/robust_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")
dataCoeff_summary_robust <- fread("ExtendedAnalysis/files/output/robust_data_aggregatedByCountry_singlePreference_genderCoefficients.csv")


# ================================================== #
#### RESULTS IN OUR SUMMARY TABLES (MAIN ARTICLE) ####
# ================================================== #

## ------------------------------ Table 1 ----------------------------------- #
# Log GDP p/c conditional on GEI
PlotSummary(data = summaryIndex_robust,
            var1 = "residualslogAvgGDPpcStd_GEI",
            var2 = "residualsavgGenderDiffStd_GEI",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Aggregated Gender Differences \n(residualized using Gender Equality Index)",
                     "Economic Development"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2A_FH.png"
)

# Log GDP p/c conditional on WEF GGGI
PlotSummary(data = summaryIndex_robust,
            var1 = "residualslogAvgGDPpcStd_WEF",
            var2 = "residualsavgGenderDiffStd_WEF",
            labs = c("Log GDP p/c (residualized using WEF GGGI)",
                     "Gender Differences \n(residualized using WEF GGGI)",
                     "Economic Development"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/extra_Fig2A.png"
)

# Log GDP p/c conditional on UNDP GII
PlotSummary(data = summaryIndex_robust,
            var1 = "residualslogAvgGDPpcStd_UN",
            var2 = "residualsavgGenderDiffStd_UN",
            labs = c("Log GDP p/c (residualized using UNDP GII)",
                     "Gender Differences \n(residualized using UNDP GII)",
                     "Economic Development"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/extra_Fig2B.png"
)

# Log GDP p/c conditional on F/M LFP
PlotSummary(data = summaryIndex_robust,
            var1 = "residualslogAvgGDPpcStd_LFP",
            var2 = "residualsavgGenderDiffStd_LFP",
            labs = c("Log GDP p/c (residualized using F/M Labor Force Participation)",
                     "Gender Differences \n(residualized using F/M Labor Force Participation)",
                     "Economic Development"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/extra_Fig2C.png"
)

# Log GDP p/c conditional on TSWS
PlotSummary(data = summaryIndex_robust,
            var1 = "residualslogAvgGDPpcStd_TSWS",
            var2 = "residualsavgGenderDiffStd_TSWS",
            labs = c("Log GDP p/c (residualized using Time since Women's Suffrage)",
                     "Gender Differences \n(residualized using Time since Women's Suffrage)",
                     "Economic Development"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/extra_Fig2D.png"
)

# GEI conditional on Log GDP p/c
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsGenderIndexStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("Gender Equality Index (residualized using Log GDP p/c)",
                     "Aggregated Gender Differences \n(residualized using Log GDP p/c)",
                     "Gender Equality"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2B_FH.png"
)

# WEF GGGI conditional on Log GDP p/c
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsScoreWEFStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("WEF GGGI (residualized using Log GDP p/c)",
                     "Aggregated Gender Differences \n(residualized using Log GDP p/c)",
                     "WEF Global Gender Gap Index"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/extra_Fig2E.png"
)

# UNDP GII conditional on Log GDP p/c
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsValueUNStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Aggregated Gender Differences \n(residualized using Log GDP p/c)",
                     "UNDP Gender Equality Index"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2D_FH.png"
)

# F/M LFP conditional on Log GDP p/c
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsavgRatioLaborStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("F/M Labor Force Participation (residualized using Log GDP p/c)",
                     "Aggregated Gender Differences \n(residualized using Log GDP p/c)",
                     "Ratio Female to Male LFP"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2E_FH.png"
)

# TSWS conditional on Log GDP p/c
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsDateStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("Time since Women's Suffrage (residualized using Log GDP p/c)",
                     "Aggregated Gender Differences \n(residualized using Log GDP p/c)",
                     "Time since Women's Suffrage"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2F_FH.png"
)



## -------------------------------- Fig. 2 ----------------------------------- #
# Log GDP p/c conditional on WEF GGGI 
PlotSummary(data = summaryIndex_robust,
            var1 = "residualslogAvgGDPpcStd_WEF",
            var2 = "residualsavgGenderDiffStd_WEF",
            labs = c("Log GDP p/c (residualized using WEF GGGI)",
                     "Gender Differences \n(residualized using WEF GGGI)",
                     "Economic Development"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2A.pdf"
)

# Log GDP p/c conditional on UNDP GII
PlotSummary(data = summaryIndex_robust,
            var1 = "residualslogAvgGDPpcStd_UN",
            var2 = "residualsavgGenderDiffStd_UN",
            labs = c("Log GDP p/c (residualized using UNDP GII)",
                     "Gender Differences \n(residualized using UNDP GII)",
                     "Economic Development"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2C.pdf"
)

# Log GDP p/c conditional on UNDP GDI
PlotSummary(data = summaryIndex_robust,
            var1 = "residualslogAvgGDPpcStd_GDI",
            var2 = "residualsavgGenderDiffStd_GDI",
            labs = c("Log GDP p/c (residualized using UNDP GDI)",
                     "Gender Differences \n(residualized using UNDP GDI)",
                     "Economic Development"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2E.pdf"
)

# WEF GGGI conditional on Log GDP p/c
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsScoreWEFStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("WEF GGGI (residualized using Log GDP p/c)",
                     "Aggregated Gender Differences \n(residualized using Log GDP p/c)",
                     "WEF Global Gender Gap Index"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2B.pdf"
)

# UNDP GII conditional on Log GDP p/c
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsValueUNStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Aggregated Gender Differences \n(residualized using Log GDP p/c)",
                     "UNDP Gender Equality Index"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2D.pdf"
)

# UNDP GDI conditional on Log GDP p/c
PlotSummary(data = summaryIndex_robust,
            var1 = "residualsGDIStd",
            var2 = "residualsavgGenderDiffStd_GDP",
            labs = c("UNDP GDI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "UNDP Gender Development Index"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig2F_ours.pdf"
)


# ------------------------------ Table 2 ------------------------------------- #
## ------ WEF ------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualslogAvgGDPpc_WEF_trust",
            var2 = "residualsgenderWEF_trust",
            labs = c("Log GDP p/c \n(residualized using WEF GGGI)",
                     "Gender Differences \n(residualized using WEF GGGI)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-WEF_trust.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualslogAvgGDPpc_WEF_altruism",
            var2 = "residualsgenderWEF_altruism",
            labs = c("Log GDP p/c (residualized using WEF GGGI)",
                     "Gender Differences \n(residualized using WEF GGGI)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-WEF_altruism.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualslogAvgGDPpc_WEF_posrecip",
            var2 = "residualsgenderWEF_posrecip",
            labs = c("Log GDP p/c (residualized using WEF GGGI)",
                     "Gender Differences \n(residualized using WEF GGGI)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-WEF_posrecip.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualslogAvgGDPpc_WEF_negrecip",
            var2 = "residualsgenderWEF_negrecip",
            labs = c("Log GDP p/c (residualized using WEF GGGI)",
                     "Gender Differences \n(residualized using WEF GGGI)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-WEF_negrecip.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualslogAvgGDPpc_WEF_risktaking",
            var2 = "residualsgenderWEF_risktaking",
            labs = c("Log GDP p/c (residualized using WEF GGGI)",
                     "Gender Differences \n(residualized using WEF GGGI)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-WEF_risktaking.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualslogAvgGDPpc_WEF_patience",
            var2 = "residualsgenderWEF_patience",
            labs = c("Log GDP p/c (residualized using WEF GGGI)",
                     "Gender Differences \n(residualized using WEF GGGI)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-WEF_patience.png"
)

## ------ UN ------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualslogAvgGDPpc_UN_trust",
            var2 = "residualsgenderUN_trust",
            labs = c("Log GDP p/c (residualized using UNDP GII)",
                     "Aggregated Gender Differences \n(residualized using UNDP GII)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-GII_trust.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualslogAvgGDPpc_UN_altruism",
            var2 = "residualsgenderUN_altruism",
            labs = c("Log GDP p/c (residualized using UNDP GII)",
                     "Gender Differences \n(residualized using UNDP GII)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-GII_altruism.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualslogAvgGDPpc_UN_posrecip",
            var2 = "residualsgenderUN_posrecip",
            labs = c("Log GDP p/c (residualized using UNDP GII)",
                     "Gender Differences \n(residualized using UNDP GII)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-GII_posrecip.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualslogAvgGDPpc_UN_negrecip",
            var2 = "residualsgenderUN_negrecip",
            labs = c("Log GDP p/c (residualized using UNDP GII)",
                     "Gender Differences \n(residualized using UNDP GII)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-GII_negrecip.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualslogAvgGDPpc_UN_risktaking",
            var2 = "residualsgenderUN_risktaking",
            labs = c("Log GDP p/c (residualized using UNDP GII)",
                     "Gender Differences \n(residualized using UNDP GII)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-GII_risktaking.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualslogAvgGDPpc_UN_patience",
            var2 = "residualsgenderUN_patience",
            labs = c("Log GDP p/c (residualized using UNDP GII)",
                     "Gender Differences \n(residualized using UNDP GII)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-GII_patience.png"
)

## ------ GDI ------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualslogAvgGDPpc_GDI_trust",
            var2 = "residualsgenderGDI_trust",
            labs = c("Log GDP p/c (residualized using UNDP GDI)",
                     "Gender Differences \n(residualized using UNDP GDI)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-GDI_trust.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualslogAvgGDPpc_GDI_altruism",
            var2 = "residualsgenderGDI_altruism",
            labs = c("Log GDP p/c (residualized using UNDP GDI)",
                     "Gender Differences \n(residualized using UNDP GDI)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-GDI_altruism.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualslogAvgGDPpc_GDI_posrecip",
            var2 = "residualsgenderGDI_posrecip",
            labs = c("Log GDP p/c (residualized using UNDP GDI)",
                     "Gender Differences \n(residualized using UNDP GDI)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-GDI_posrecip.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualslogAvgGDPpc_GDI_negrecip",
            var2 = "residualsgenderGDI_negrecip",
            labs = c("Log GDP p/c (residualized using UNDP GDI)",
                     "Gender Differences \n(residualized using UNDP GDI)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-GDI_negrecip.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualslogAvgGDPpc_GDI_risktaking",
            var2 = "residualsgenderGDI_risktaking",
            labs = c("Log GDP p/c (residualized using UNDP GDI)",
                     "Gender Differences \n(residualized using UNDP GDI)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-GDI_risktaking.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualslogAvgGDPpc_GDI_patience",
            var2 = "residualsgenderGDI_patience",
            labs = c("Log GDP p/c (residualized using UNDP GDI)",
                     "Gender Differences \n(residualized using UNDP GDI)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDP-GDI_patience.png"
)

## -------------------------------- Table 3 ---------------------------------- #
## ---------- WEF ------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualsWEF_GDP_trust",
            var2 = "residualsgenderGDPStd_trust",
            labs = c("WEF GGGI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_WEF-GDP_trust.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualsWEF_GDP_altruism",
            var2 = "residualsgenderGDPStd_altruism",
            labs = c("WEF GGGI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_WEF-GDP_altruism.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualsWEF_GDP_posrecip",
            var2 = "residualsgenderGDPStd_posrecip",
            labs = c("WEF GGGI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_WEF-GDP_posrecip.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualsWEF_GDP_negrecip",
            var2 = "residualsgenderGDPStd_negrecip",
            labs = c("WEF GGGI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_WEF-GDP_negrecip.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualsWEF_GDP_risktaking",
            var2 = "residualsgenderGDPStd_risktaking",
            labs = c("WEF GGGI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_WEF-GDP_risktaking.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualsWEF_GDP_patience",
            var2 = "residualsgenderGDPStd_patience",
            labs = c("WEF GGGI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_WEF-GDP_patience.png"
)

## ---------- UN ------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualsUN_GDP_trust",
            var2 = "residualsgenderGDPStd_trust",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GII-GDP_trust.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualsUN_GDP_altruism",
            var2 = "residualsgenderGDPStd_altruism",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GII-GDP_altruism.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualsUN_GDP_posrecip",
            var2 = "residualsgenderGDPStd_posrecip",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GII-GDP_posrecip.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualsUN_GDP_negrecip",
            var2 = "residualsgenderGDPStd_negrecip",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GII-GDP_negrecip.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualsUN_GDP_risktaking",
            var2 = "residualsgenderGDPStd_risktaking",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GII-GDP_risktaking.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualsUN_GDP_patience",
            var2 = "residualsgenderGDPStd_patience",
            labs = c("UNDP GII (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GII-GDP_patience.png"
)

## ---------- GDI ------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualsGDI_GDP_trust",
            var2 = "residualsgenderGDPStd_trust",
            labs = c("UNDP GDI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDI-GDP_trust.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualsGDI_GDP_altruism",
            var2 = "residualsgenderGDPStd_altruism",
            labs = c("UNDP GDI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDI-GDP_altruism.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualsGDI_GDP_posrecip",
            var2 = "residualsgenderGDPStd_posrecip",
            labs = c("UNDP GDI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDI-GDP_posrecip.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualsGDI_GDP_negrecip",
            var2 = "residualsgenderGDPStd_negrecip",
            labs = c("UNDP GDI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDI-GDP_negrecip.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualsGDI_GDP_risktaking",
            var2 = "residualsgenderGDPStd_risktaking",
            labs = c("UNDP GDI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDI-GDP_risktaking.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualsGDI_GDP_patience",
            var2 = "residualsgenderGDPStd_patience",
            labs = c("UNDP GDI (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_GDI-GDP_patience.png"
)



# ============================ #
#### SUPPLEMENTARY MATERIAL ####
# ============================ #

# -------------------------------- Table 2 ----------------------------------- #
# Gender differences regressed on Log GDP p/c
PlotSummary(data = summaryIndex_robust,
            var1 = "logAvgGDPpc", 
            var2 = "avgGenderDiffRescaled",
            labs = c("Log GDP p/c",
                     "Average Gender Differences (Index)"),  
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig1B.pdf"
)

# Gender differences regressed on Gender Equality Index (Rescaled)
PlotSummary(data = summaryIndex_robust,
            var1 = "GenderIndexRescaled", 
            var2 = "avgGenderDiffRescaled",
            labs = c("Gender Equality Index",
                     "Aggregated Gender Differences (Index)"), 
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/main_Fig1D.pdf"
)


# Fig 1. and 2. of our Supplementary Material can be reproduced by using the
# equivalent code under "ReproductionAnalysis".


# ------------------------------- Fig. 3 ------------------------------------- #
# Correlation between Log GDP p/c and Gender Equality Index
PlotSummary(data = dataCoeff_summary_robust,
            var1 = "logAvgGDPpcStd",
            var2 = "GenderIndexRescaled",
            labs = c("Log GDP p/c (Standardized)",
                     "Gender Equality Index",
                     "Gender Equality Index"),
            display = TRUE)

# Correlation between Log GDP p/c and WEF GGGI
PlotSummary(data = dataCoeff_summary_robust,
            var1 = "logAvgGDPpcStd",
            var2 = "ScoreWEFStd",
            labs = c("Log GDP p/c (Standardized)",
                     "WEF GGGI (Standardized)",
                     "WEF Global Gender Gap Index"),
            display = TRUE)

# Correlation between Log GDP p/c and UNDP GII
PlotSummary(data = dataCoeff_summary_robust,
            var1 = "logAvgGDPpcStd",
            var2 = "ValueUNStd",
            labs = c("Log GDP p/c (Standardized)",
                     "UNDP GII (Standadized)",
                     "UNDP Gender Inequality Index"),
            display = TRUE)

# Correlation between Log GDP p/c and UNDP GDI
PlotSummary(data = dataCoeff_summary_robust,
            var1 = "logAvgGDPpcStd",
            var2 = "GDIStd",
            labs = c("Log GDP p/c (Standardized)",
                     "UNDP GDI (Standardized)",
                     "UNDP Gender Development Index"),
            display = TRUE)


# Table 3 reports the correlation values as created for Table 2 of the main
# article.
# Table 4 reports the correlation values as created for Table 3 of the main
# article.

# Table 5 and 6 can be created simply by running the following code:
SummaryRLR(dat = dataCoeff_summary_robust[preference == "trust"],
           predictor = "gender",
           var1 = "logAvgGDPpcStd",
           var2 = "ScoreWEFStd")

SummaryRLR(dat = dataCoeff_summary_robust[preference == "altruism"],
           predictor = "gender",
           var1 = "logAvgGDPpcStd",
           var2 = "ScoreWEFStd")

SummaryRLR(dat = dataCoeff_summary_robust[preference == "posrecip"],
           predictor = "gender",
           var1 = "logAvgGDPpcStd",
           var2 = "ScoreWEFStd")

SummaryRLR(dat = dataCoeff_summary_robust[preference == "negrecip"],
           predictor = "gender",
           var1 = "logAvgGDPpcStd",
           var2 = "ScoreWEFStd")

SummaryRLR(dat = dataCoeff_summary_robust[preference == "risktaking"],
           predictor = "gender",
           var1 = "logAvgGDPpcStd",
           var2 = "ScoreWEFStd")

SummaryRLR(dat = dataCoeff_summary_robust[preference == "patience"],
           predictor = "gender",
           var1 = "logAvgGDPpcStd",
           var2 = "ScoreWEFStd")

# ------------------------------- Table 7 ------------------------------------ #
PlotSummary(data = summaryIndex_robust, 
            var1 = "ScoreWEFStd", 
            var2 = "avgGenderDiffRescaled",
            labs = c("WEF Global Gender Gap Index (Standardized)",
                     "Aggregated Gender Differences (Index)",
                     "WEF Global Gender Gap Index"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS4A_FH.png"
)

PlotSummary(data = summaryIndex_robust, 
            var1 = "ValueUNStd", 
            var2 = "avgGenderDiffRescaled",
            labs = c("UN Gender Equality Index (Standardized)",
                     "Aggregated Gender Differences (Index)",
                     "UN Gender Equality Index"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS4B_FH.png"
)

PlotSummary(data = summaryIndex_robust, 
            var1 = "avgRatioLaborStd", 
            var2 = "avgGenderDiffRescaled",
            labs = c("Ratio Female to Male (Standardized)",
                     "Aggregated Gender Differences (Index)",
                     "Ratio Female to Male LFP"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS4C_FH.png"
)

PlotSummary(data = summaryIndex_robust, 
            var1 = "DateStd", 
            var2 = "avgGenderDiffRescaled",
            labs = c("Time since Women's Suffrage (Standardized)",
                     "Aggregated Gender Differences (Index)",
                     "Time since Women's Suffrage"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS4D_FH.png"
)

# ------------------------------ Table 8 ------------------------------------- #
PlotSummary(data = dataCoeff_summary_robust[preference == "trust"],
            var1 = "residualslogAvgGDPpc_GEI_trust",
            var2 = "residualsgenderGEI_trust",
            labs = c("Log GDP p/c \n(residualized using Gender Equality Index)",
                     "Gender Differences \n(residualized using Gender Equality Index)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS5A_FH.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualslogAvgGDPpc_GEI_altruism",
            var2 = "residualsgenderGEI_altruism",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS5B_FH.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualslogAvgGDPpc_GEI_posrecip",
            var2 = "residualsgenderGEI_posrecip",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS5C_FH.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualslogAvgGDPpc_GEI_negrecip",
            var2 = "residualsgenderGEI_negrecip",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS5D_FH.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualslogAvgGDPpc_GEI_risktaking",
            var2 = "residualsgenderGEI_risktaking",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Risk Taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS5E_FH.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualslogAvgGDPpc_GEI_patience",
            var2 = "residualsgenderGEI_patience",
            labs = c("Log GDP p/c (residualized using Gender Equality Index)",
                     "Gender Differences (residualized using Gender Equality Index)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS5F_FH.png"
)

## ------------------------------- Table 9 ----------------------------------- #
PlotSummary(data = dataCoeff_summary[preference == "trust"],
            var1 = "residualsGenderIndex_GDP_trust",
            var2 = "residualsgenderGDP_trust",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Trust (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS6A_FH.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "altruism"],
            var1 = "residualsGenderIndex_GDP_altruism",
            var2 = "residualsgenderGDP_altruism",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Altruism (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS6B_FH.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "posrecip"],
            var1 = "residualsGenderIndex_GDP_posrecip",
            var2 = "residualsgenderGDP_posrecip",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Positive Reciprocity (+)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS6C_FH.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "negrecip"],
            var1 = "residualsGenderIndex_GDP_negrecip",
            var2 = "residualsgenderGDP_negrecip",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Negative Reciprocity (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS6D_FH.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "risktaking"],
            var1 = "residualsGenderIndex_GDP_risktaking",
            var2 = "residualsgenderGDP_risktaking",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Risk taking (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS6E_FH.png"
)

PlotSummary(data = dataCoeff_summary_robust[preference == "patience"],
            var1 = "residualsGenderIndex_GDP_patience",
            var2 = "residualsgenderGDP_patience",
            labs = c("Gender Equality (Index) (residualized using Log GDP p/c)",
                     "Gender Differences \n(residualized using Log GDP p/c)",
                     "Patience (-)"),
            robust = TRUE,
            display = TRUE,
            # save = "ExtendedAnalysis/plots/supplementary_FigS6F_FH.png"
)


