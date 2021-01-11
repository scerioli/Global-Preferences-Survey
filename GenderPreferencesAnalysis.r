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
                               logAvgGDPpc = log(i.avgGDPpc)),
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
plotHistA <- ggplot(data = unique(dataSummary[, c(-3, -5)])) +
  geom_col(aes(x = GDPquant, y = meanGender, fill = preference), width = 0.5) +
  facet_wrap(~ preference) +
  xlab("GDP") + ylab("Average Gender Differences")

## ----------------------------- Fig. 1 B ------------------------------------ #
PlotSummary(data = summaryIndex,
            var1 = "logAvgGDPpc", var2 = "avgGenderDiffNorm",# fill = "region",
            labs = c("Log GDP p/c",
                     "Average Gender Differences (Index)"),  display = TRUE,
            )

## ----------------------------- Fig. 1 C ------------------------------------ #
plotHistC <- ggplot(data = unique(dataSummary[, c(-2, -4)])) +
  geom_col(aes(x = GEIquant, y = meanGenderGEI, fill = preference), width = 0.5) +
  facet_wrap(~ preference) +
  xlab("Gender equality Index") + ylab("Average Gender Differences")

## ----------------------------- Fig. 1 D ------------------------------------ #
PlotSummary(data = summaryIndex,
            var1 = "GenderIndex", var2 = "avgGenderDiff", # fill = "region",
            labs = c("Gender Equality Index",
                     "Average Gender Differences (Index)"), display = TRUE,
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

