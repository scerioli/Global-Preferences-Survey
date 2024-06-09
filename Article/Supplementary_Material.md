---
title: |
  Supplementary Material
subtitle: |
  **More on the influence of gender equality on gender differences in economic preferences**
output:
  pdf_document: default
header-includes: 
- |
  ```{=latex}
  \usepackage{authblk}
  \author{Sara Cerioli$^1$}
  \author{Andrey Formozov$^2$}
  \affil{\small{$^1$Independent researcher, Mannheim, Germany \\
                $^2$Department of Neurophysiology, MCTN, Medical Faculty Mannheim, Heidelberg University,\\ 68167 Mannheim, Germany\\
         Correspondence: sara.cerioli@outlook.com, formozoff@gmail.com}}
  ```
bibliography: bibliography.bibtex

---

# Methods 

## Overview

We performed our study using the R programming language version 4.2.1 (2022-06-23), and its open-source IDE RStudio. Table 1 shows which packages with respective versions are used.

Table: Packages and their versions used in this replication study.

|Package | $\quad$ | Version |
--- | --- | ---
| data.table | | 1.14.2 |
| bit64 | | 4.0.5 |
| bit | | 4.0.5 |
| plyr | | 1.8.7 |
| dplyr | | 1.1.2 |
| haven | | 2.5.1 |
| ggplot2 | | 3.4.2 |
| missMDA | | 1.18 |
| MASS    | | 7.3-58.1 |


## Data Collection, Cleaning, and Standardization

Here we provide a concise summary of the data sets utilized in @doi:10.1126/science.aas9899, referred to as FH hereafter. We also outline the primary difficulties we encountered while replicating the original article.

### Global Preferences Survey and Gallup World Poll data sets

To download the GPS data set, one can go to the website of the Global Preferences Survey "[briq - Institute on Behavior & Inequality](https://www.briq-institute.org/global-preferences/home)", in the section "downloads". This data is protected by copyright and can not be given to third parties. Check the website for more information about it. The data set is not provided in the rawest form: some variables were mixed and already standardized. Some sociodemographic variables (for instance, education level or income quintile) are not part of the Global Preference Survey, but of the Gallup World Poll data set that is not openly available. 

### Log GDP p/c and Gender Equality Indexes

From the website of the [World Bank](https://data.worldbank.org/indicator/), one can access the data about the GDP per capita for a certain set of years. The data for the GDP p/c calculated in 2005 US dollars was already archived. We used the GDP p/c in 2010 US dollars instead. To build an estimator for economic development, we averaged the data from 2003 until 2012 for all the available countries, as done in FH, and then applied the logarithm to it.

The Gender Equality Index used in FH was built by performing a Principle Component Analysis on four data sets and using the first component as summarized gender equality index. The four data sets were:

- **World Economic Forum Global Gender Gap Index:** Taken from the [World Economic Forum Global Gender Gap Report 2015](http://reports.weforum.org/).

- **United Nations Development Programme Gender Inequality Index:** Taken from the [Human Development Report 2015](http://hdr.undp.org/sites/default/files/hdr_2016_statistical_annex.pdf). We kept only the table called "Gender Inequality Index". Values were inverted to create an index of equality.

- **Ratio of female and male labor force participation:** An average of estimates from 2004 to 2013 provided by the International Labor Organization in [World Bank database](http://data.worldbank.org/indicator/SL.TLF.CACT.FM.ZS). Note that originally the data set was created taking the values between the years 2003 to 2012.

- **Time since women’s suffrage:** This indicator was build based on the data about the year of suffrage in a given country taken from the [Inter-Parliamentary Union Website](http://www.ipu.org/wmn-e/suffrage.htm#Note1). For several countries more than one date was provided (for example, the right to be elected and the right to vote might be granted in two different dates). We use the last date when both vote and stand for election rights were granted, with no other restrictions commented. Some countries were colonies or within a union of the countries, as for instance, Kazakhstan in the Soviet Union. For these countries, the rights to vote and be elected might be technically granted two times -- within a union and as an independent state. In this case, we kept the first date. It was difficult to decide on South Africa because its history shows how racism was very entangled with women's rights [@SAHO]. We kept the latest date when also Black women could vote. For Nigeria, considering the distinctions between North and South, we decided to keep only the North data because, again, it was showing the completeness of the country and it was the last date. For countries where data was missing, data was added from the World Economic Forum Global Gender Gap Report 2006, as reported in the original article. 

In our extended analysis, we also involved the following index:

- **United Nations Development Programme Gender Development Index** taken from [Human Development Reports 2020](https://hdr.undp.org/en/content/gender-development-index-gdi). Note that we have downloaded the two tables of the Human Development Index for males and females, and used the ratio of the two as a GDI index, as described in the report.


### Missing Data and Imputation 

One of the challenges we encountered while attempting to replicate the article's results was the presence of missing data in certain data sets. FH did not provide detailed information on how they handled missing data in the indexes. In their Supplementary Material (page 14), they mention the following: "For countries where data were missing, data were added from the World Economic Forum Global Gender Gap Report 2006 (http://www3.weforum.org/docs/WEF_GenderGap_Report_2006.pdf)." However, when it comes to the specific year when women gained the right to vote in a particular country, the missing values pertain to the United Arab Emirates and Saudi Arabia. These countries have not yet granted the right to vote to women, neither in 2006 (when the WEF Global Gender Gap Report, referenced by the authors, was published) nor in the year in which this replication was conducted (2023). Additionally, missing data was found in other sources mentioned by the authors. Upon conducting a quick search for the missing countries in the 2015 WEF report, we discovered that these countries were not included in the 2006 report either. While missing data and imputation may not be critical for replicating the analysis, they are not desirable. The problem of missing data for a specific country often does not significantly impact the overall trends of observed correlations. However, it does complicate the reliable comparison of results.


# Pure Replication and Comparison to the Original Article

In this section, we describe how to reproduce the Figures found in FH and compare our results to theirs. For the results presented in the Tables, both simple linear regression (OLS) and robust linear regression (RLR) were used. When the Figures were replicated, we used the OLS to ease the comparison with FH Figures.

## Reproducing the Figures of the Main Article

To replicate Figure 1A of FH, we categorized countries into quartiles based on their Log GDP p/c (Figure 1, top left). We then extracted the mean preference gender coefficients ($\beta_1^c$ in Equation 1 of our article) for each quartile. The same approach was employed to reproduce Figure 1C of FH, where we examined the relationship between their custom Gender Equality Index and gender differences in each economic preference (Figure 1, bottom left). Subsequently, we analyzed the association between the magnitude of the aggregated gender difference coefficients (the first component of the PCA) and Log GDP p/c to assess the impact of economic development. This enabled us to reproduce Figure 1B of FH (here in Figure 1, top right). To determine the correlation and obtain the corresponding p-value, we performed a linear regression. Additionally, for the plot, we transformed the variables on the y-axis as $(y-y_{min})/(y_{max}-y_{min})$, following the implementation in the original article. We applied the same methodology to derive the correlation between the Gender Equality Index and the aggregated gender preferences, aiming to evaluate the influence of gender equality (Figure 1D of FH to be compared to Figure 1, bottom right, in the present Supplementary Material). It is worth noting that in this case, the Gender Equality Index was also transformed to a scale ranging from 0 to 1. However, such a transformation may be misleading, as a Gender Equality Index value of 1 does not indicate complete gender equality (as no country has achieved this status), and a Gender Equality Index value of 0 does not necessarily signify the absence of gender equality entirely. Table 2 provides a summary of the results obtained for Figure 1B and 1D. Additionally, we include the results obtained using the RLR model instead of the OLS model in the same table.

![**Reproduction of the Fig 1 A-D of FH analysis**. In the top left figure, the countries were grouped by quartiles from poorer to richer, and the coefficient for gender differences is plotted for each of the separate economic preferences. Similarly, on the bottom left, with less equal to more equal countries. On the right, the correlation between gender differences in economic preferences aggregated into one single coefficient using the PCA, and economic development (on top) and gender equality (bottom).](figures/appendix/main_Fig1.pdf)


Table: **Comparison of the results from Fig 1B and 1D of FH analysis with ours.** Correlation between gender differences in economic preferences vs Log GDP p/c and Gender Equality Index. Significance levels $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*)are reported. 

|                       | FH (OLS)  | Replication (OLS) | Replication (RLR) |
---                     | ---       | ---               | --- |
| Log GDP p/c           | 0.67*** | 0.68 (0.08)***    | 0.67 (0.09)*** |
| Gender Equality Index | 0.56*** | 0.61 (0.09)***    | 0.59 (0.09)***|


We reproduced Figures 2A-F of FH using the variable conditioning analysis. This has been done for economic development, for Gender Equality Index, and for each of the four indexes building the Gender Equality Index. The variable used on the y-axis is the first component of the PCA performed on the coefficients of gender differences of the six preferences. All the variables have been standardized to have mean at 0 and standard deviation of 1 before performing the conditional analysis. We then performed a linear regression on the residuals and extracted correlation coefficients and p-values. Our results can be seen in Figure 2 below.

![**Reproduction of the Fig 2 A-F of FH analysis**. Relationship between average (aggregated) gender differences in economic preferences and economic development conditional on gender equality, and between average (aggregated) gender differences in economic preferences and gender equality conditional on economic development. Gender equality is represented by the Gender Equality Index, by WEF GGGI, by UNDP GII, by F/M LFP, and by TSWS.](figures/appendix/main_Fig2.pdf)


## Correlation between Economic Development and Gender Equality

As mentioned in our article, the fact that there is a correlation between economic development and gender equality is known [@10.2307/23644911] and reported in the @GGGreport2015. We checked the correlation between Log GDP p/c and Gender Equality Index and we reported it here in Figure 3. In addition, we checked the correlation of Log GDP p/c with the three indexes used in our extended analysis for the measure of gender equality (also in Figure 3): WEF GGGI from the [World Economic Forum Global Gender Gap Report 2015](http://reports.weforum.org/), UNDP GII [Human Development Report 2015](http://hdr.undp.org/sites/default/files/hdr_2016_statistical_annex.pdf), and UNDP [Gender Development Index](http://hdr.undp.org/en/indicators/137906) (GDI).

![**Correlation between gender equality indexes and economic development by country**. Note that only the countries that participated in the original study are included. ](figures/appendix/corr_equality_economicdev.pdf)


## Separate Economic Preferences and their Correlation to Economic Development and to Gender Equality

Here below we add the equivalent of Table 2 and 3 of our main article reporting the correlation coefficients instead of the regression coefficients. We report them here to enable the readers to have a direct comparison to the Tables 5 and 6, and to FH Supplementary Material (Figure S5 and S6). 

Table: **Correlation between gender differences in separate economic preference and Log GDP p/c.** RLR method is used. As in FH, the symbols (+)/($-$) indicate the general direction of the difference. (+) indicates that women exhibited higher levels of the respective preference compared to men, ($-$) indicates that men on average exhibited higher levels of the respective preference. The correlation terms, their standard errors and significance levels $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*) are reported. 

| Preference  |  r$_{LogGDPpc}$ (WEF GGGI) | r$_{LogGDPpc}$ (UNDP GII) | r$_{LogGDPpc}$ (UNDP GDI) |
--- | ---|  --- |  ---  |
|      Trust (+)  |  0.52 (0.10)$^{***}$ |  0.19 (0.11)          |  0.50 (0.10)$^{***}$   |
|   Altruism (+)  |  0.53 (0.10)$^{***}$ |  0.35 (0.11)$^{***}$  |  0.45 (0.10)$^{***}$   |
| Pos. Recip. (+) |  0.29 (0.11)$^{*}$   |  0.21 (0.11)          |  0.19 (0.11)           | 
| Neg. Recip. ($-$) |  0.40 (0.11)$^{**}$  |  0.07 (0.12)        |  0.39 (0.11)$^{***}$   |
| Risk Taking ($-$) |  0.35 (0.11)$^{**}$  |  0.03 (0.12)        |  0.32 (0.11)$^{**}$    |
|    Patience ($-$) |  0.37 (0.11)$^{**}$  |  0.10 (0.12)        |  0.33 (0.11)$^{**}$    |


Table: **Correlation between gender differences in separate economic preference conditional on the three different gender equality indexes.** RLR method is used. As in FH, the symbols (+)/($-$) indicate the general direction of the difference. (+) indicates that women exhibited higher levels of the respective preference compared to men, ($-$) indicates that men on average exhibited higher levels of the respective preference. The correlation terms, their standard errors and significance levels $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*) are reported. 


|  Preference  | r$_{GenderEq}$ (WEF GGGI) | r$_{GenderEq}$ (UNDP GII) |  r$_{GenderEq}$ (UNDP GDI) |
--- | --- | ---| --- |
|  Trust (+)      | 0.13 (0.12)         | 0.22 (0.11)    | 0.08 (0.12)       |
| Altruism (+)    | 0.36 (0.11)$^{**}$  | $-0.04$ (0.12) | 0.10 (0.12)       |
| Pos. Recip. (+) | 0.04 (0.12)         | $-0.04$ (0.12) | 0.20 (0.11)       |
| Neg. Recip. ($-$) | 0.17 (0.11)         | 0.17 (0.11)    | $-0.10$ (0.12)    |
| Risk Taking ($-$) | 0.03 (0.12)         | 0.22 (0.11)$^{*}$ | $-0.03$ (0.12) |
|    Patience ($-$) | 0.23 (0.11)         | 0.17 (0.11)    |   0.08 (0.12)     |


## Analysis of the Effect Size of the Gender Differences

Our analysis has been performed by *standardizing* gender differences in separate preferences ($Gender \ Diff^p$ in Eq.3). This imparts slope coefficients with the meaning of indicating a specific country's deviation from the global average gender difference, measured in standard deviations. To assess the actual magnitude of modulation of gender differences for each separate preference, one needs to remove the standardization, yielding gender coefficients that quantify the extent to which men and women differ in a given preference in terms of standard deviations. This exercise reveals that the increase in gender differences in separate preferences lies in the range between 0.03 and 0.08 standard deviations for one standard deviation change in Log GDP p/c, when conditioning on gender equality (Table 5). As already noted above, for gender equality indexes only altruism for WEF GGGI and risk-taking for UNDP GII give a statistically significant result, which is not higher than 0.05 standard deviation increase (Table 6).

Table: **Slope coefficients that quantify the magnitude of increase in gender differences for separate preferences per one standard deviation change in Log GDP p/c.** RLR method is used. As in FH, the symbols (+)/(-) indicate the general direction of the difference. (+) indicates that women exhibited higher levels of the respective preference compared to men, (-) indicates that men on average exhibited higher levels of the respective preference. The regression coefficients, their standard errors in brackets, and significance levels $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*) are reported. RLR method is used.

| Preference  |  $\beta^p_{LogGDPpc}$ (WEF GGGI) | $\beta^p_{LogGDPpc}$ (UNDP GII) | $\beta^p_{LogGDPpc}$ (UNDP GDI) |
--- | ---|  --- |  ---  |
| Trust (+)       |  0.06 (0.01)$^{***}$ |  0.03 (0.02)          |  0.07 (0.02)$^{***}$   |
| Altruism (+)    |  0.07 (0.01)$^{***}$ |  0.08 (0.02)$^{***}$  |  0.07 (0.01)$^{***}$   |
| Pos. Recip. (+) |  0.03 (0.01)$^{*}$   |  0.03 (0.02)          |  0.02 (0.01)           |
| Neg. Recip. ($-$) |  0.04 (0.01)$^{**}$  |  0.01 (0.02)          |  0.05 (0.01)$^{***}$   |
| Risk Taking ($-$) |  0.04 (0.01)$^{**}$  |  0.00 (0.02)          |  0.05 (0.01)$^{**}$   |
| Patience ($-$)    |  0.04 (0.01)$^{**}$  |  0.02 (0.02)          |  0.04 (0.01)$^{**}$   |


Table: **Slope coefficients that quantify the magnitude of increase in gender differences for separate preferences per one standard deviation change in gender equality (WEF GGGI, UNDP GII, UNDP GDI).** RLR method is used. As in FH, the symbols (+)/($-$) indicate the general direction of the difference. (+) indicates that women exhibited higher levels of the respective preference compared to men, ($-$) indicates that men on average exhibited higher levels of the respective preference. The regression coefficients, their standard errors in brackets, and significance levels $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*) are reported. RLR method is used.

|  Preference  | $\beta^p_{GenderEq}$ (WEF GGGI) | $\beta^p_{GenderEq}$ (UNDP GII) |  $\beta^p_{GenderEq}$ (UNDP GDI) |
--- | --- | ---| --- |
|  Trust (+)       | 0.01 (0.01)         | 0.04 (0.02)         | 0.01 (0.01)       |
|  Altruism (+)    | 0.03 (0.01)$^{**}$  | $-0.01$ (0.02)      | 0.01 (0.01)       |
|  Pos. Recip. (+) | 0.00 (0.01)         | 0.00 (0.02)         | 0.02 (0.01)       |
|  Neg. Recip. ($-$) | 0.01 (0.01)         | 0.04 (0.02)       | $-0.01$ (0.01)    |
|  Risk Taking ($-$) | 0.01 (0.01)         | 0.05 (0.02)$^{*}$ | $-0.01$ (0.01)    |
|  Patience ($-$)    | 0.02 (0.01)         | 0.03 (0.02)       | 0.01 (0.01)       |


## Reproducing the Results of FH Supplementary Material

For the comparison of the results of Figure S4 in @FH_SM, we refer to Table 7, showing the correlation between the aggregated gender differences to the separate gender equality indexes. We report the replication results using both the OLS and the RLR.


Table: **Comparison of results from Fig S4 of FH analysis to ours.** Individual indexes for gender equality correlated with gender differences in economic preferences. Significance $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*)

|        | FH (OLS)  | Replication (OLS) | Replication (RLR) |
---      | ---       | ---               | --- |
WEF GGGI | 0.41*** | 0.41 (0.11)***    | 0.39 (0.11)**  |
UNDP GII | 0.65*** | 0.67 (0.09)***    | 0.66 (0.09)*** |
F/M LFP  | 0.27*   | 0.29 (0.11)*      | 0.26 (0.11)*   |
TSWS     | 0.51*** | 0.45 (0.10)***    | 0.45 (0.10)*** |


For the comparison of the results of the Figure S5 and S6 of @FH_SM to ours, refer to Table 8 and Table 9. These results show the correlation between gender differences in separate economic preferences to economic development, conditioning for Gender Equality Index (Table 8), and the correlation between gender differences in separate economic preferences and Gender Equality Index, conditioning on Log GDP p/c (Table 9).

Table: **Comparison of results from Fig S5 of FH analysis to ours.** Correlation between gender differences in separate economic preferences regressed on Log GDP p/c conditioning for Gender Equality Index. As in FH, the symbols (+)/($-$) indicate the general direction of the difference. (+) indicates that women exhibited higher levels of the respective preference compared to men, ($-$) indicates that men on average exhibited higher levels of the respective preference. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

|           |  FH (OLS) | Replication (OLS) | Replication (RLR) |
---         | ---       | ---               | --- |
| Trust (+)     | 0.46*** | 0.43 (0.11)***  | 0.45 (0.10)*** |
| Altruism  (+) | 0.48*** | 0.43 (0.10)***  | 0.40 (0.11)*** |
| Pos. Rec. (+) | 0.28*   | 0.25 (0.11)*    | 0.25 (0.11)   |
| Neg. Rec. ($-$) | 0.24*   | 0.21 (0.11)     | 0.25 (0.11)*  |
| Risk Tak. ($-$) | 0.29*   | 0.23 (0.11)     | 0.22 (0.11)*  |
| Patience  ($-$) | 0.26*   | 0.23 (0.11)*    | 0.24 (0.11)*  |
 

Table: **Comparison of results from Fig S6 of FH analysis to ours.** Correlation between gender differences in single economic preferences regressed on Gender Equality Index, conditional on Log GDP p/c. As in FH, the symbols (+)/($-$) indicate the general direction of the difference. (+) indicates that women exhibited higher levels of the respective preference compared to men, ($-$) indicates that men on average exhibited higher levels of the respective preference. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

|           |  FH (OLS) | Replication (OLS) | Replication (RLR) |
---         | ---       | ---               | --- |
| Trust (+)     | 0.21    | 0.25 (0.11)*   | 0.25 (0.11)*  |
| Altruism  (+) | 0.33**  | 0.27 (0.11)*   | 0.24 (0.11)   |
| Pos. Rec. (+) | -0.01   | 0.05 (0.12)    | 0.05 (0.12)   |
| Neg. Rec. ($-$) | 0.28*   | 0.22 (0.11)   | 0.20 (0.11)*  |
| Risk Tak. ($-$) | 0.20    | 0.19 (0.11)   | 0.19 (0.11)*  |
| Patience  ($-$) | 0.30*   | 0.28 (0.11)*   | 0.28 (0.11)*  |


Lastly, we have reproduced the results from Figures S8 and S9 of @FH_SM. Table 10 compares the results of Figure S8, where the correlation between gender differences in economic preferences and economic development is calculated using preferences standardized on the global level. Table 11 summarizes the results obtained by correlating gender differences in economic preferences to economic development, when the gender coefficients were obtained by performing a linear regression without additional independent variables.


Table: **Comparison of results from Fig S8 of FH analysis to ours.** Correlation between gender differences and economic development using preferences standardized at the global level. As in FH, the symbols (+)/($-$) indicate the general direction of the difference. (+) indicates that women exhibited higher levels of the respective preference compared to men, ($-$) indicates that men on average exhibited higher levels of the respective preference. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

|           |  FH (OLS) | Replication (OLS) |
---         | ---       | ---               | 
| Trust (+)     | 0.58*** | 0.58 (0.10)***  | 
| Altruism  (+) | 0.55*** | 0.59 (0.09)***  | 
| Pos. Rec. (+) | 0.28*   | 0.32 (0.11)**   |
| Neg. Rec. ($-$) | 0.30**  | 0.37 (0.11)**  | 
| Risk Tak. ($-$) | 0.30**  | 0.36 (0.11)**   | 
| Patience  ($-$) | 0.44*** | 0.41 (0.11)***  |


Table: **Comparison of results from Fig S9 of FH analysis to ours.** Gender differences and economic development by preference without controls (OLS being performed using only gender as a independent variable). As in FH, the symbols (+)/($-$) indicate the general direction of the difference. (+) indicates that women exhibited higher levels of the respective preference compared to men, ($-$) indicates that men on average exhibited higher levels of the respective preference. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

|           |  FH (OLS) | Replication (OLS) |
---         | ---       | ---               | 
| Trust (+)     | 0.54*** | 0.55 (0.10)***  | 
| Altruism (+)  | 0.58*** | 0.59 (0.09)***  | 
| Pos. Rec. (+) | 0.27*   | 0.28 (0.11)*    |
| Neg. Rec. ($-$) | 0.40*** | 0.39 (0.11)***  | 
| Risk Tak. ($-$) | 0.39*** | 0.39 (0.11)***  | 
| Patience  ($-$) | 0.48*** | 0.48 (0.10)***  |


### Further Notes on the Replication

The Figure S7 of @FH_SM could not be replicated because there is no access to raw data. For the replication of several tables in their supplementary material, the description of the data sets and the analysis approach were not sufficient for replication.

# References
