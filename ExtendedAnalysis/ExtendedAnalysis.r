###########################  EXTENDED ANALYSIS  ################################
# The idea of this section is to extend some unclear points of the previous 
# analysis to shed some light on them. The critical points are the following,
# and most of them relates to the Gender Equality Index:
# 1. How the index is built:
#    The authors used the Principal Component Analysis technique to create their
#    own index out of four: The WEF score, the value from the UN, the ratio of
#    female to male labor force participation, and the time since women suffrage.
#    The critics comes when we explore these datasets and see that the 
#    composition of the four is sometimes overlapping. We want to understand if
#    this affects the PCA outcome, and how.
# 2. Cohen effect size:
#    The authors never discuss the effect size of what they show, so we would
#    like to establish how big is the effect of the gender differences.
# 3. Assuming no bias from cultural background:
#    The assumption that only because in recent years (between 2008 and 2012)
#    the countries under exam had higher development and also higher "gender
#    equality" lets aside the fact that the gender parity is a recent topic in
#    human history, that might affect only superficially the prejudice of
#    people when it comes to expectations, also in terms of economic preferences.
#    We would like to explore more the implicit bias related to the gender, in
#    particular using the IAT Gender-Career test results to understand if there
#    is any correlation between explicit/implicit bias and economic development.
#    We would expect that the explicit bias diminish in higher developed 
#    countries, but that the implicit bias would stay constant for any country.
#    This would be because the implicit bias is some indicator of our inner 
#    cultural background, and all the countries used in this dataset are rooted
#    in patriarchy. On the other side, we would expect a positive correlation 
#    of implicit bias and gender differences, meaning that the more the inner 
#    bias is present, the more a person is lead to behave according to specific
#    gender stereotypes conveyed by the society around them.
#    If this assumption is true, it would disprove the fact that gender 
#    differences increases because of what the authors observed.


# =============================== #
#### 0. LOAD DATA AND SET PATH ####
# =============================== #

# Set the path
setwd("/Users/sara/Desktop/Projects/Global-Preferences-Survey/ReproductionAnalysis/")

# Source helper functions
source("functions/helper_functions/SourceFunctions.r")
SourceFunctions(path = "functions/")
SourceFunctions(path = "functions/helper_functions/")
SourceFunctions(path = "../ExtendedAnalysis/functions/")

# Load libraries
LoadRequiredLibraries()
# visualization of PCA
library(factoextra)
# For t-SNE
library(tidyverse)
library(Rtsne)
# For reading sav files
library(haven)


# Load the data
data_all <- LoadData()
summaryIndex <- fread("files/output/main_data_aggregatedByCountry_preferencePCA_genderIndexPCA.csv")


# ====================================== #
#### 1. EXPLORE THE PCA CONTRIBUTIONS ####
# ====================================== #

# Create the PCA of Gender Equality Index
pca_GEI <- prcomp(summaryIndex[, c(5:8)], scale. = T)
# Visualize the percentage of variance explained by each PC
fviz_eig(pca_GEI)

# Visualize the individual countries 
groups <- as.factor(summaryIndex$region)
fviz_pca_ind(pca_GEI,
             col.ind = groups, # color by groups
             addEllipses = TRUE, # Concentration ellipses
             ellipse.type = "confidence",
             legend.title = "Groups",
             repel = TRUE
)

# Get the features contribution
features_pca <- get_pca_var(pca_GEI)
features_pca$contrib


# ========================== #
#### 2. COHEN EFFECT SIZE ####
# ========================== #

data_all <- PrepareData(data_all)
# Standardize preferences at country level
data_all$data <- Standardize(data    = data_all$data, 
                             columns = c(5:10), 
                             level   = "country")

# Use only the complete dataset
dataComplete <- data_all$data[complete.cases(data_all$data)]
# Adjust data for plotting
dataComplete[, logAvgGDPpc := log(avgGDPpc), by = "country"]

# Summary for the GDP
dataComplete[logAvgGDPpc <= quantile(logAvgGDPpc, 0.25, na.rm = TRUE),
             GDPquant := 1]
dataComplete[is.na(GDPquant) & logAvgGDPpc <= quantile(logAvgGDPpc, 0.50, na.rm = TRUE),
             GDPquant := 2]
dataComplete[is.na(GDPquant) & logAvgGDPpc <= quantile(logAvgGDPpc, 0.75, na.rm = TRUE),
             GDPquant := 3]
dataComplete[is.na(GDPquant),
             GDPquant := 4]

# Idea to implement:
# We want to understand how big is the effect of the gender differences where 
# we see the larger difference. So we would need to take the distribution of 
# males and of females for each preference in the aggregated "richer countries"
# (first histogram) and correspondingly also the egalitarian societies, and
# plot the Cohen's d coefficient.
# How to understand "how big is big"? We could try to approach the problem in
# the following way:
# - calculate the "largest" d cohen of the data
# - compare it to the d cohen found for gender differences
# - how big is big?

d_patience <- ExtractEffectSize(dataComplete, "patience")
d_altruism <- ExtractEffectSize(dataComplete, "altruism")
d_risktaking <- ExtractEffectSize(dataComplete, "risktaking")
d_posrecip <- ExtractEffectSize(dataComplete, "posrecip")
d_negrecip <- ExtractEffectSize(dataComplete, "negrecip")
d_trust <- ExtractEffectSize(dataComplete, "trust")


# ==================================== #
#### 3. IMPLICIT BIAS GENDER-CAREER ####
# ==================================== #

# Load the file
path <- "../ExtendedAnalysis/files/input/Gender-Career_IAT.public.2005/"
countries <- fread("../ExtendedAnalysis/files/input/list_of_countries.csv",
                   sep = ";")
genderIAT <- read_sav(paste0(path, "Gender-Career IAT.public.2005.sav"))
genderIAT <- as.data.table(genderIAT)
genderIAT[countries, country := i.country, on = "countrycit"]

setdiff(unique(dataComplete$country), unique(genderIAT$country))
# All countries present but Serbia


# ===================== #
#### 4. t-SNE METHOD ####
# ===================== #

# Some people answered in the same way so the data are not unique.
dt_sne <- unique(dataComplete[,  .(risktaking, altruism, patience, 
                                negrecip, posrecip, trust
                                # subj_math_skills, gender, age
                                )])

dataComplete[summaryIndex, world := i.region, on = "country"]

dataComplete[, world := as.factor(world)]
colors <- rainbow(length(unique(dataComplete[, world])))
names(colors) <- unique(dataComplete[, world])

tsne_per2 <- Rtsne(dt_sne, dims = 2, perplexity = 2, verbose = TRUE, max_iter = 500)

plot(tsne_per2$Y, pch = ".", main = "tsne perplexity 2")
points(tsne_per2$Y, pch = ".", col = colors[dataComplete[, world]])

tsne_per10 <- Rtsne(dt_sne, dims = 2, perplexity = 10, verbose = TRUE, max_iter = 500)

plot(tsne_per10$Y, pch = ".", main = "tsne perplexity 10")
points(tsne_per10$Y, pch = "." , col = colors[dataComplete[, world]])

tsne_per30 <- Rtsne(dt_sne, dims = 2, perplexity = 30, verbose = TRUE, max_iter = 500)

plot(tsne_per30$Y, pch = ".", main = "tsne perplexity 30")
points(tsne_per30$Y, pch = ".", col = colors[dataComplete[, world]])

tsne_per100 <- Rtsne(dt_sne, dims = 2, perplexity = 100, verbose = TRUE, max_iter = 500)

plot(tsne_per100$Y, pch = ".", main = "tsne perplexity 100")
text(tsne_per100$Y, labels = unique(dataComplete$world), col = colors[dataComplete[, world]])
