---
title: |
  **A Refined Perspective on the Influence of Gender Equality on Gender Differences in Economic Preferences**
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
csl: bib_style/./mee.csl

---

# Methods 

## Overview

We performed our study using the R programming language version 4.2.1 (2022-06-23), and its open-source IDE RStudio. Table 1 shows which packages with respective versions are used.

Table: Packages and versions used in this replication study.

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

Here we provide a concise summary of the data sets utilized in  @doi:10.1126/science.aas9899, referred to as FH hereafter. We also outline the primary difficulties we encountered while replicating the original article.

### Global Preferences Survey and Gallup World Poll data sets

To download the GPS data set, one can go to the website of the Global Preferences Survey "[briq - Institute on Behavior & Inequality](https://www.briq-institute.org/global-preferences/home)", in the section "downloads". The data set is not provided in the rawest form: some variables were mixed and already standardized. Some sociodemographic variables (for instance, education level or income quintile) are not part of the Global Preference Survey, but of the Gallup World Poll data set that is not openly available. This data is protected by copyright and can not be given to third parties. Check the website of the [briq - Institute on Behavior & Inequality](https://www.briq-institute.org/global-preferences/home) for more information about it.

### Log GDP p/c and gender equality indexes

From the website of the [World Bank](https://data.worldbank.org/indicator/), one can access the data about the GDP per capita for a certain set of years. The data for Log GDP p/c calculated in 2005 US dollars was already archived. We used Log GDP p/c in 2010 US dollars instead. To build an estimator for Log GDP p/c, we averaged the data from 2003 until 2012 for all the available countries, as done in FH.

The Gender Equality Index used in FH (described in Section 2 of our article) was built by performing a Principle Component Analysis on four data sets and using the first component as summarized gender equality index. The four data sets were:

- **World Economic Forum Global Gender Gap Index:** Taken from the [World Economic Forum Global Gender Gap Report 2015](http://reports.weforum.org/).

- **United Nation Development Programme Gender Inequality Index:** Taken from the [Human Development Report 2015](http://hdr.undp.org/sites/default/files/hdr_2016_statistical_annex.pdf). We kept only the table called "Gender Inequality Index". Values were inverted to create an index of equality.

- **Ratio of female and male labor force participation:** An average of estimates from 2004 to 2013 provided by the International Labor Organization in [World Bank database](http://data.worldbank.org/indicator/SL.TLF.CACT.FM.ZS). Note that originally the data set was created taking the values between the years 2003 to 2012.

- **Time since women’s suffrage:** This indicator was build based on the data about the year of suffrage in a given country taken from the [Inter-Parliamentary Union Website](http://www.ipu.org/wmn-e/suffrage.htm#Note1). For several countries more than one date was provided (for example, the right to be elected and the right to vote might be granted in two different dates). We use the last date when both vote and stand for election rights were granted, with no other restrictions commented. Some countries were colonies or within a union of the countries, as for instance, Kazakhstan in the Soviet Union. For these countries, the rights to vote and be elected might be technically granted two times - within a union and as an independent state. In this case, we kept the first date. It was difficult to decide on South Africa because its history shows how racism was very entangled with women's rights [@SAHO]. We kept the latest date when also Black women could vote. For Nigeria, considering the distinctions between North and South, we decided to keep only the North data because, again, it was showing the completeness of the country and it was the last date. For countries where data was missing, data was added from the World Economic Forum Global Gender Gap Report 2006, as reported in the original article. 

In our extended analysis, we also involved the following index:

- **United Nation Development Programme Gender Development Index** taken from [Human Development Reports 2020](https://hdr.undp.org/en/content/gender-development-index-gdi). Note that we have downloaded the two tables of the Human Development Index for males and females, and used the ratio of the two as a GDI index, as described in the report.


### Missing Data and Imputation 

One of the challenges we encountered while attempting to replicate the article's results was the presence of missing data in certain datasets. FH did not provide detailed information on how they handled missing data in the indexes. In the Supplementary Material (page 14), they mention the following: "For countries where data were missing, data were added from the World Economic Forum Global Gender Gap Report 2006 (http://www3.weforum.org/docs/WEF_GenderGap_Report_2006.pdf)." However, when it comes to the specific year when women gained the right to vote in a particular country, the missing values pertain to the United Arab Emirates and Saudi Arabia. These countries have not yet granted the right to vote to women, neither in 2006 (when the WEF Global Gender Gap Report, referenced by the authors, was published) nor in the present year (2023). Additionally, missing data was found in other sources mentioned by the authors. Upon conducting a quick search for the missing countries in the 2015 WEF report, we discovered that these countries were not included in the 2006 report either. While missing data and imputation may not be critical for replicating the analysis, they are not desirable. The problem of missing data for a specific country often does not significantly impact the overall trends of observed correlations. However, it does complicate the reliable comparison of results.


# Pure replication and comparison to the Original Article

In this section, we describe how to reproduce the Figures found in FH and compare our results to theirs. For the results presented in the Tables, both simple linear regression (OLS) and robust linear regression (RLR) were used. When the Figures were replicated, we used the OLS, to ease the comparison with FH Figures.

## Reproducing the figures of the Main Article

To replicate Figure 1A of FH, we categorized countries into quartiles based on their Log GDP p/c. We then extracted the mean preference gender coefficients ($\beta_1^c$ in Equation 1 of our article) for each quartile, after standardizing them. The same approach was employed to reproduce Figure 1C of FH, where we examined the relationship between the Gender Equality Index (GEI) and gender differences in each economic preference. Subsequently, we analyzed the association between the magnitude of the summarized gender difference coefficients (the first component of the PCA) and the Log GDP p/c to assess the impact of economic development. This enabled us to reproduce Figure 1B of FH. To determine the correlation and obtain the corresponding p-value, we utilized a linear model. Additionally, for the plot, we transformed the variables on the y-axis as $(y-y_{min})/(y_{max}-y_{min})$, following the implementation in the original article. We applied the same methodology to derive the correlation between the GEI and the summarized gender preferences, aiming to evaluate the influence of gender equality (Figure 1D of FH). It is worth noting that in this case, the GEI was also transformed to a scale ranging from 0 to 1. However, it is important to emphasize that such a transformation may be misleading, as a GEI value of 1 does not indicate complete gender equality (as no country has achieved this status), and a GEI value of 0 does not necessarily signify the absence of gender equality entirely. Table 2 provides a summary of the results obtained for Figure 1B and 1D. Additionally, we include the results obtained using the RLR model instead of the OLS model in the same table.

![Reproduction of the Fig 1 A-D of FH analysis. In the top left figure, the countries were grouped by quartiles from poorer to richer, and the standardized coefficient for the gender differences is plotted for each of the individual economic preferences. Similarly, on the bottom left, with less equal to more equal countries. On the right, the correlation between gender differences in economic preferences summarized into one single coefficient using the PCA, and economic development (on top) and gender equality (bottom).](figures/appendix/main_Fig1.pdf)


Table: Correlation between gender differences in economic preferences vs Log GDP p/c and Gender Equality Index. Significance $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*)

|                       | Original  | Replication (OLS) | Replication (RLR) |
---                     | ---       | ---               | --- |
| Log GDP p/c           | 0.6685*** | 0.68 (0.08)***    | 0.67 (0.09)*** |
| Gender Equality Index | 0.5580*** | 0.61 (0.09)***    | 0.59 (0.09)***|


We reproduced Figures 2A-F of FH using the variable conditioning analysis (Figure 2). This has been done for economic development, for the GEI, and for each of the four indexes building the GEI. The variable used on the y-axis is the first component of the PCA performed on the gender differences of the six preferences. All the variables have been standardized to have mean at 0 and standard deviation of 1 before performing the conditional analysis. We then performed a linear regression on the residuals and extracted correlation coefficients and p-values.

![Relationship between summarized gender differences in economic preferences and economic development conditional on gender equality (Figure 2A), and between summarized gender differences in economic preferences and gender equality conditional on economic development, with gender equality being represented by GEI (Fig 2B), by WEF GGGI (Figure 2C), by UNDP GII (Figure 2D), by F/M LFP (Figure 2E), and by TSWS (Figure 2F).](figures/appendix/main_Fig2.pdf)


## Correlation between Economic Development and Gender Equality

As mentioned in our article, the fact that there is a correlation between economic development and gender equality is revealed [@10.2307/23644911] and reported in the @GGGreport2015. We checked the correlation between Log GDP p/c and GEI and we reported it here in Figure 3. In addition, we checked the correlation of Log GDP p/c with the three indexes used in our extended analysis for the measure of gender equality (also in Figure 3): the WEF GGGI from the [World Economic Forum Global Gender Gap Report 2015](http://reports.weforum.org/), the UNDP GII [Human Development Report 2015](http://hdr.undp.org/sites/default/files/hdr_2016_statistical_annex.pdf), and the UNDP [Gender Development Index](http://hdr.undp.org/en/indicators/137906) (GDI).

![Correlation between gender equality indexes and economic development by country. Note that only the countries that participated in the original study are included. ](figures/appendix/corr_equality_economicdev.pdf)


## Reproducing the results of FH Supplementary Material

For the comparison of the results of Figure S4 in @FH_SM, we refer to Table 3, showing the correlation between the summarized gender differences to the single gender equality indexes. In parenthesis, we put the standard deviation for the relative correlation coefficient to have an overview of the level of agreement between the original and the replication study. We report the replication results using both the OLS and the RLR.


Table: Individual indexes for gender equality correlated with gender differences in economic preferences. Significance $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*)

|        | Original  | Replication (OLS) | Replication (RLR) |
---      | ---       | ---               | --- |
WEF GGGI | 0.4097*** | 0.41 (0.11)***    | 0.39 (0.11)**  |
UNDP GII | 0.6482*** | 0.67 (0.09)***    | 0.66 (0.09)*** |
F/M LFP  | 0.2661*   | 0.29 (0.11)*      | 0.26 (0.11)*   |
TSWS     | 0.5139*** | 0.45 (0.10)***    | 0.45 (0.10)*** |


For the comparison of the results of the Figure S5 and S6 of @FH_SM to ours, refer to Table 4 and Table 5. These results show the correlation between gender differences in individual economic preferences to economic development, conditioning for GEI (Table 4), and the correlation between gender differences in individual econoic preferences and GEI, conditioning on Log GDP p/c (Table 5).

Table: Correlation between gender differences in individual economic preferences regressed on Log GDP p/c conditioning for Gender Equality Index. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

|           |  Original | Replication (OLS) | Replication (RLR) |
---         | ---       | ---               | --- |
| Trust     | 0.4574*** | 0.43 (0.11)***  | 0.45 (0.10)*** |
| Altruism  | 0.4751*** | 0.43 (0.10)***  | 0.40 (0.11)*** |
| Pos. Rec. | 0.2771*   | 0.25 (0.11)*    | 0.25 (0.11)   |
| Neg. Rec. | 0.2444*   | 0.21 (0.11)     | 0.25 (0.11)*  |
| Risk Tak. | 0.2868*   | 0.23 (0.11)     | 0.22 (0.11)*  |
| Patience  | 0.2621*   | 0.23 (0.11)*    | 0.24 (0.11)*  |
 

Table: Correlation between gender differences in single economic preferences regressed on Gender Equality Index, conditional on Log GDP p/c. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

|           |  Original | Replication (OLS) | Replication (RLR) |
---         | ---       | ---               | --- |
| Trust     | 0.2050    | 0.25 (0.11)*   | 0.25 (0.11)*  |
| Altruism  | 0.3304**  | 0.27 (0.11)*   | 0.24 (0.11)   |
| Pos. Rec. | -0.0115   | 0.05 (0.12)    | 0.05 (0.12)   |
| Neg. Rec. | 0.2788*   | 0.22 (0.11)   | 0.20 (0.11)*  |
| Risk Tak. | 0.1973    | 0.19 (0.11)   | 0.19 (0.11)*  |
| Patience  | 0.2967*   | 0.28 (0.11)*   | 0.28 (0.11)*  |


Lastly, we have reproduced the results from Figures S8 and S9 of @FH_SM. Table 6 compares the results of Figure S8, where the correlation between gender differences in economic preferences and economic development is calculated using preferences standardized on the global level. Table 7 summarizes the results obtained by correlating gender differences in economic preferences to economic development, when the gender coefficients were obtained by performing a linear regression without additional independent variables.


Table: Correlation btween gender differences and economic development using preferences standardized at the global level. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

|           |  Original | Replication (OLS) |
---         | ---       | ---               | 
| Trust     | 0.5787*** | 0.58 (0.10)***  | 
| Altruism  | 0.5505*** | 0.59 (0.09)***  | 
| Pos. Rec. | 0.2819*   | 0.32 (0.11)**   |
| Neg. Rec. | 0.2980**  | 0.37 (0.11)**  | 
| Risk Tak. | 0.2974**  | 0.36 (0.11)**   | 
| Patience  | 0.4391*** | 0.41 (0.11)***  |


Table: Gender differences and economic development by preference without controls (OLS being performed using only gender as a independent variable). Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

|           |  Original | Replication (OLS) |
---         | ---       | ---               | 
| Trust     | 0.5434*** | 0.55 (0.10)***  | 
| Altruism  | 0.5808*** | 0.59 (0.09)***  | 
| Pos. Rec. | 0.2748*   | 0.28 (0.11)*    |
| Neg. Rec. | 0.4038*** | 0.39 (0.11)***  | 
| Risk Tak. | 0.3860*** | 0.39 (0.11)***  | 
| Patience  | 0.4830*** | 0.48 (0.10)***  |


### Further notes on the replication

The Figure S7 of @FH_SM could not be replicated because there is no access to raw data. For the replication of several tables in their supplementary material, the description of the data sets, and the analysis approach was not sufficient for replication.

# References
