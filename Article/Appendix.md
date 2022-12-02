---
title: |
  Appendix
subtitle: |
  **Gender differences in economic preferences and gender equality are yet unrelated: a replication of Falk and Hermle (*Science*, 2018)**
author: 
- Sara Cerioli
- Andrey Formozov
header-includes:
- |
  ```{=latex}
  \usepackage{authblk}
  \author{Sara Cerioli$^1$}
  \author{Andrey Formozov$^2$}
  \affil{\small{$^1$Independent researcher, Hamburg, Germany \\
          $^2$Research Group Synaptic Wiring and Information Processing, Center for Molecular Neurobiology Hamburg, University Medical Center Hamburg-Eppendorf, Hamburg, Germany\\ 
         Correspondence: sara.cerioli@outlook.com, formozoff@gmail.com}}
  ```
output:
  pdf_document: default
bibliography: bibliography.bibtex
csl: bib_style/./mee.csl
---

# Methods 

## Overview

We replicate the results using the R programming language version 4.0.3 (2020-10-10), and its open-source IDE RStudio. The following packages with respective versions are used:

|Package | $\quad$ | Version |
--- | --- | ---
| data.table | | 1.13.2 |
| bit64 | | 4.0.5 |
| bit | | 4.0.4 |
| plyr | | 1.8.6 |
| dplyr | | 1.0.7 |
| haven | | 2.4.1 |
| ggplot2 | | 3.3.2 |
| missMDA | | 1.18 |
| MASS    | | 7.3-53 |


## Data Collection, Cleaning, and Standardization

### Global Preferences Survey and Gallup World Poll datasets

To download the GPS dataset, one can go to the website of the Global Preferences Survey [briq - Institute on Behavior & Inequality](https://www.briq-institute.org/global-preferences/home) in the section "downloads". The dataset is not provided in the rawest form: some variables were mixed and already standardized. Some sociodemographic variables (for instance, education level or income quintile) are not part of the Global Preference Survey, but of the Gallup World Poll dataset that is not openly available. This data is protected by copyright and can't be given to third parties. Check the website of the [briq - Institute on Behavior & Inequality](https://www.briq-institute.org/global-preferences/home) for more information on it.

### Log GDP p/c and gender equality indexes

From the [website of the World Bank](https://data.worldbank.org/indicator/), one can access the data about the GDP per capita on a certain set of years. The data for Log GDP p/c calculated in 2005 US dollars was already archived. We used Log GDP p/c in 2010 US dollars, instead. To build an estimator for Log GDP p/c, we averaged the data from 2003 until 2012 for all the available countries, as done in the original article.

The Gender Equality Index used in the original article was composed of four main datasets as the first principle component of the Principal Component Analysis performed on them:

- **World Economic Forum Global Gender Gap Index:** Taken from the [World Economic Forum Global Gender Gap Report 2015](http://reports.weforum.org/). For countries where data was missing, data was added from the World Economic Forum Global Gender Gap Report 2006, as reported in the original article. 

- **United Nation Development Programme Gender Inequality Index:** Taken from the [Human Development Report 2015](http://hdr.undp.org/sites/default/files/hdr_2016_statistical_annex.pdf). We kept only the table called "Gender Inequality Index".

- **Ratio of female and male labor force participation:** An average of estimates from 2004 to 2013 provided by the International Labor Organization in World Bank database (http://data.worldbank.org/indicator/SL.TLF.CACT.FM.ZS). Values were inverted to create an index of equality. Note that originally the dataset was created taking the values between the years 2003 to 2012.

- **Time since women’s suffrage:** This indicator was build based on the data about the year of suffrage in a given coutry taken from the [Inter-Parliamentary Union Website](http://www.ipu.org/wmn-e/suffrage.htm#Note1). For several countries more than one date where provided (for example, the right to be elected and the right to vote). We use the last date when both vote and stand for election rights were granted, with no other restrictions commented. Some countries were colonies or within a union of the countries (for instance, Kazakhstan in the Soviet Union). For these countries, the rights to vote and be elected might be technically granted two times within a union and as an independent state. In this case, we kept the first date. It was difficult to decide on South Africa because its history shows the racism part very entangled with women's rights [@SAHO]. We kept the latest date when also Black women could vote. For Nigeria, considering the distinctions between North and South, we decided to keep only the North data because, again, it was showing the completeness of the country and it was the last date. 

In this work we additionally involve the following index:

- **United Nation Development Programme Gender Development Index** taken from [Human Development Reports 2020](https://hdr.undp.org/en/content/gender-development-index-gdi). Note that we have downloaded the two tables of the Human Development Index for males and females, and used the ratio of the two as a GDI index, as described in the report.


### Missing Data and Imputation 

One of the issues that we faced while trying to reproduce the results of the article has been the missing data.

During the reproduction of the article, we found that the original authors didn't describe in detail how they handled missing data in the indicators. They mention on page 14 of the Supplementary Material, that (quoting): "For countries where data were missing, data were added from the World Economic Forum Global Gender Gap Report 2006 (http://www3.weforum.org/docs/WEF_GenderGap_Report_2006.pdf)."

However, regarding the year when women received the right to vote in a specific country, the missing values are the ones coming from the United Arab Emirates and Saudi Arabia, that neither in 2006 (when the WEF Global Gender Gap Report that the authors quote as a reference for the missing values) nor now (in 2022) have guaranteed the right to vote for women yet. There is missing data also in the other sources that the authors quote. So a quick search for the missing countries of the WEF report of 2015, shows us that these countries can’t be found in the report of 2006 either. Missing data and imputation, in general, may not be crucial for the replication of the analysis, although are not desirable. The problem of missing data for a given country often does not influence much the overall trends of found correlations. However, it becomes very relevant for checking the implications of the study concerning a specific country of interest.


# Pure replication and comparison to the Original Article

In this section, we describe how to reproduce the plots and compare the results, indicating the difference between original and replication with a z-score. The number of observations for each country-level indicator is shown in the table below, and it is used in the z-score calculation.

Table: Number of observations for each country-level indicator. Note that the difference in the number of observations for GEI is due to the imputation that we performed in our analysis.


| Indicator | Original | Replication | Extended |
--- | --- | --- | --- |
| Log GDP p/c | 76 | 76 | 76 |
| GEI | 71 | 76 | 76 |
| WEF GGGI | 72 | 72 |  72 |
| UNDP GII | 75 | 75 | 75 |
| F/M LFP | 76 | 76 | 76 |
| TSWS | 76 | 74 | 74 | 
| UNDP GDI | -- | 76 | 76 |

## Reproducing the Plots of the Main Article

To reproduce the plot of Figure 1A of the original article @doi:10.1126/science.aas9899, we grouped the countries in quartiles based on the logarithm of their average GDP p/c, extracted the mean of each preference from the gender coefficients (the $\beta_1^c$) of the countries for each quartile, after standardizing them. The same method was applied to the GEI in correlation to the gender differences for each economic preference, to reproduce the plot in Figure 1C of @doi:10.1126/science.aas9899. Then, we related the magnitude of the summarized gender difference coefficients (the first component of the PCA) with the logarithm of the average GDP per capita to see the effect of the economic development. This reproduced Figure 1B of the original article. We used a linear model to fit the correlation and extract the p-value, and for the plot the variables on the y-axis were additionally transformed as $(y-y_{min})/(y_{max}-y_{min})$, as it was implemented in the original article. We applied the same method to extract the correlation between the GEI and the summarized gender preference, to see the effect of gender equality in the countries (Figure 1D,  of @doi:10.1126/science.aas9899). Note that here also the GEI is transformed to be on a scale between 0 and 1. It is important to underline that such transformation may be misleading, as GEI = 1 does not mean full gender equality (no country achieved this state) as well as GEI = 0 does not necessary mean the full absence of it.

![](figures/replication/main_Fig1A.pdf){width=50%}
![](figures/replication/main_Fig1B.pdf){width=50%}
![](figures/replication/main_Fig1C.pdf){width=50%}
![](figures/replication/main_Fig1D.pdf){width=50%}

We reproduced the plots in Figure 2A-F in @doi:10.1126/science.aas9899 using the variable conditioning analysis. This has been done for the economic development, for the GEI, and each of the four indicators building the GEI. The variable used on the y-axis is the first Principal Component of the PCA made on the gender differences on the six preferences. All the variables used have been standardized to have a mean at 0 and a standard deviation of 1 before applying the conditional analysis. Using the residuals, we performed a linear regression on the data points and extracted correlation coefficients and p-values.

![](figures/replication/main_Fig2A.pdf){width=50%}
![](figures/replication/main_Fig2B.pdf){width=50%}
![](figures/replication/main_Fig2C.pdf){width=50%}
![](figures/replication/main_Fig2D.pdf){width=50%}
![](figures/replication/main_Fig2E.pdf){width=50%}
![](figures/replication/main_Fig2F.pdf){width=50%}

## Reproducing the results in the Supplementary Material

For the comparison of the results from Figure S4 in @FH_SM, we refer to Table 3, showing the correlation between the average gender differences to the single-gender equality indicators. To assess the consistency of the original and reproduction analyzes and approximately estimate the difference between correlation coefficients, we used z-scores. As the tables below show, all correlation coefficients were found to be consistent  (*z-score* $< 2$). 

Table: Single indicators for the gender equality at the country level correlated with gender differences in economic preferences. Significance $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*)

|  |             | WEF GGGI  | UNDP GII  | F/M LFP | TSWS | 
--- | --- | --- | --- |  --- | --- |
| Original |     | 0.4097*** | 0.6482*** | 0.2661* | 0.5139*** |
| Replication (OLS) |  | 0.4075*** | 0.6680*** | 0.2860* | 0.4517*** |
| | *z-score*    | 0.016     | -0.210    | -0.130  | 0.487 |
| Replication (RLR) |     | 0.3937**  | 0.6586*** | 0.2645* | 0.4535*** |
| | *z-score*    |  0.112    | -0.109    | 0.01    | 0.473 |


For the comparison of the results of the Figure S5 and S6 of @FH_SM to ours, refer to Table 4 and Table 5.

Table: Gender differences in single economic preferences regressed on Log GDP p/c conditional on Gender Equality Index. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

| |             | Trust     | Altruism | Pos. Rec. | Neg. Rec. | Risk Tak. | Patience | 
--- | --- | --- | --- | --- | --- | --- | --- |
| Original    | | 0.4574*** | 0.4751*** | 0.2771*  | 0.2444* | 0.2868* | 0.2621* |
| Replication (OLS) | | 0.4265*** | 0.4338*** | 0.2509   | 0.2111  | 0.2256* | 0.2288* |
| | *z-score*   | 0.228     | 0.309     | 0.167    | 0.208   | 0.389   | 0.210  |
| Replication (RLR) |    | 0.4450*** | 0.3959*** | 0.2524   | 0.2451* | 0.2191* |  0.2444* |
| | *z-score*   | 0.092     | 0.581     | 0.158    | -0.0044 | 0.429   | 0.112 |


Table: Gender differences in single economic preferences regressed on Gender Equality Index, conditional on Log GDP p/c. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

| |             | Trust     | Altruism | Pos. Rec. | Neg. Rec. | Risk Tak. | Patience | 
--- | --- | --- | --- | --- | --- | --- | --- |
| Original    | | 0.2050    | 0.3304** | -0.0115   | 0.2788* | 0.1973  | 0.2967* |
| Replication (OLS) | | 0.2472*   | 0.2696*  | 0.0481    | 0.2240* | 0.1863* | 0.2841* |
| | *z-score*   | -0.264    | 0.397    | -0.354    | 0.347   | 0.068   | 0.082 |
| Replication (RLR) |    | 0.2521*   | 0.2401   | 0.051     | 0.2037* | 0.1868* | 0.2781* |
| | *z-score*   | -0.295    | 0.584    | -0.371    | 0.473   | 0.065   | 0.120 |


Lastly, we have reproduced the results from Figures S8 and S9 of @FH_SM in Tables 6 and 7.


Table: Gender differences and economic development by preference and country using preferences standardized at the global level. Economic preferences were standardized at the global level, instead of using country level. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

| |             | Trust     | Altruism  | Pos. Rec. | Neg. Rec. | Risk Tak. | Patience | 
--- | --- | --- | --- | --- | --- | --- | --- |
| Original    | | 0.5787*** | 0.5505***  | 0.2819*  | 0.2980** | 0.2974** | 0.4391*** |
| Replication (OLS) | | 0.5761*** | 0.5882*** | 0.3216** | 0.3683** | 0.3649** | 0.4124*** |
| | *z-score*   | 0.024     |  -0.337   | -0.264   |  -0.478  | -0.458   | 0.197 |


Table: Gender differences and economic development by preference and country without controls (OLS being performed using only gender as a independent variable). Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).


| |             | Trust     | Altruism | Pos. Rec. | Neg. Rec. | Risk Tak. | Patience | 
--- | --- | --- | --- | --- | --- | --- | --- |
| Original    | | 0.5434*** | 0.5808*** | 0.2748*  | 0.4038*** | 0.3860*** | 0.4830*** |
| Replication (OLS) | | 0.5462*** | 0.5881*** | 0.2826*  | 0.3864*** | 0.3886*** | 0.4804*** |
| | *z-score*   | -0.024    | -0.067   | -0.051   | 0.125     |  -0.018   | 0.020 |


### Further notes on the replication

The Figure S7 of @FH_SM could not be replicated because there is no access to raw data. For the replication of several tables in the supplementary material, the description of the datasets and the analysis approach was not sufficient for replication.

# References