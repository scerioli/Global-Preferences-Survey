---
title: |
  **Replicate and extend the results of the article "Relationship of gender differences in preferences to economic development and gender equality"**
author: 
- Sara Cerioli
- Andrey Formozov
output:
  pdf_document: default
bibliography: bibliography.bibtex
csl: bib_style/./mee.csl
abstract: |
  This study attempts to replicate and extend the results of the article of @FH measuring the gender differences economic preferences relating them to economic development and to gender equality of the countries. In the original paper, the authors use data from the Gallup World Poll 2012, which included a Global Preference Survey conducted on almost 80000 people in 76 countries all around the world. The dataset covers almost 90% of the world population representation, with each country having around 1000 participants answering questions related to their time preference (patience), altruism, will of risk taking, negative and positive reciprocity, and trust. The dataset is available in its integrity only with a license to be paid. The free version has only partial data that can also be used for this purpose because, according to the FH study, the gender differences can be studied also only taking in consideration a smaller number of predictors (according to the supplementary material, see [@FH_SM]). In this replication study, therefore, we use only a subset of predictors that are made publicly available to check whether the results can still be reproduced and are consistent. The outcome of the replication is that we see similar results as the ones obtained by the original authors for the relationship of gender differences and the economic development, but with differences (some times minor, some times significantly large) regarding the gender equality, especially when comparing the results of the single indexes building the general Gender Equality Index. Beyond the replication, we have extended the analysis using a robust linear regression instead of the OLS used by the authors, finding that the results are not robust under this change of model. Moreover, using a different measurement for the gender equality of the countries, the Gender Development Index from the UN Human Development reports, the correlation between gender differences and Gender Development of the country disappears, when a conditional analysis on the Economic Development is performed.
---


**JEL:**  D010 - Microeconomic Behavior: Underlying Principles, D630 - Equity, Justice, Inequality, and Other Normative Criteria and Measurement, D810 - Criteria for Decision-Making under Risk and Uncertainty, D910 - Micro-Based Behavioral Economics: Role and Effects of Psychological, Emotional, Social, and Cognitive Factors on Decision Making, F000 International Economics: General

**Keywords:** replication study, gender differences, economic preferences


# 1. Introduction

Gender differences are nowadays extensively used as arguments and counter-arguments for decision and policy making, and the differences concerning the economic behaviors, such as happiness [@SPSU], competition [@CG; @GLL], or work preferences [@BG], are being studied in many sectors of the economy and economy-related fields.

One of the problems common for many experiments in social sciences is the lack of large and heterogeneous datasets that can be used to check for such differences reducing some of the bias induced, for example, by having students or specific sets of people interviewed for the study.

The Gallup World Poll 2012 included a Global Preference Survey conducted on almost 80000 people in 76 countries all around the world, that aimed to fill this gap: Covering almost 90% of the world population representation, with each country having around 1000 participants answering questions related to their time preference (patience), altruism, will of risk taking, negative and positive reciprocity, and trust.

The dataset provides a unique insight in the economic preferences of a heterogeneous amount of people. The original study published in the Quarterly Journal of Economics [@QJE_Falk, 133 (4) pp. 1645-1692] focused on more general questions about the economic preferences distributions in different countries, trying to explore different covariates from the Gallup World Poll. While, the subsequent article, replicated in this work, focused specifically on the gender differences arising from the previous study.

The main question that the article wants to study is whether the gender differences in economic preferences increase or decrease as the economic development and gender equality of the countries increase. In the first scenario, the gender differences increase as the economic development increases because the gender-neutral goal of substistence is removed, and therefore the real preferences can be pursued. Moreover, since those countries are usually also the ones with more gender equal societies, we would have more women and men allowed to express their desires and preferences in an independent way. This would be the so-called resources hypothesis. On the other hand, there is the social role hypothesis stating that the more economically developed and gender-equal the country, the smaller the gender differences because of the attenuation of the social roles related to the genders. The conclusion of the article is that the trends in the data shows a positive correlation of gender differences with GDP p/c and with the gender equality of the countries, and thus "confirming" the resources hypothesis.

<!-- 
Talk about the problems of the gender equality index, quote the article https://www.econstor.eu/bitstream/10419/157265/1/882698184.pdf
!-->


# 2. Methods 

## Overview

We replicate the results using the R programming language version 4.0.3 (2020-10-10), and its open-source IDE RStudio for an easy access of the code. In the Appendix, we include a list of the packages used and their corresponding versions.

For an in-depth look at the replication methods, including the data collection, cleaning, and standardization of the different indicators and data sources, and the data analysis details, please refer to the Supplementary Material.


## Data Analysis

The article uses the following methods commonly accepted in the field: 

- Linear regression for each Country for each preference to extract the gender coefficient as a measure of the gender differences. 

- Principal Component Analysis on 6 gender coefficients to summarize an overall measure of the gender differences, and 4 gender equality indexes of the countries to summarize an overall Gender Equality Index.

- Variable Conditioning to separate further between economic development and gender equality in the country.

The main focus of the extended analysis that we performed was on the model creations and on the additional index for the gender (in)equality.


### Linear Models Diagnostic

As already mentioned in the previous paragraph, part of the data to reproduce the article is under restricted access: education level and household income quintile on the individual level are not available in open access version. As the FH article addresses the gender differences, the main focus is on that individual variable and all the others provided in the dataset (education level, income quitile, age, and subjective math skills) are taken as control variables, meaning that the presence of these variables may not affect the result of the correlation.

The linear model for each country is created using the equation:

$p_i = \beta_1^c female_i + \beta_2^c age_i + \beta_3^c age^2_i + \beta_4^c subjective \ math \ skills_i + \epsilon_i$

This resulted in 6 models -- one for each preference measure, $p_i$ -- having intercept and 4 weights, each of the weight being related to the variable in the formula above. The weight for the dummy variable "female", $\beta_1^c$, is used as a measure of the country-level gender difference. Therefore, in total, we have 6 weights that represent the preference difference related to the gender for 76 countries.

We now question the normality of the input data and therefore of the robustness of the linear regression performed as described. In order to verify our doubts, we used the diagnostic plots for the linear regression, in particular focusing on the so called "Normal Q-Q" plot. This plot helps determining the normality of the residuals by looking at their distribution along a straight diagonal line.

In the Figures "normQQ" we present some example of these plots, chosen randomly for some countries and some preferences, where one can deduce that the normality of the residuals is not respected.

One way to address the problem of the long tails resulting in non-normally distributed residuals can be to choose a model with less restrictive assumptions, for instance the robust linear regression. In the robust linear regression, the data is weighted based on its "extremeness", meaning, the more an observation deviates from the linearity, the more it is penalized by giving less weight. In the end, the OLS is simply a robust linear regression where all the weights are equal to 1. 

There are many common methods to assign the weights to data. Here, we use the package ```MASS``` from R and its function ```rlm```, in which by default the method used for the weights is called "Huber".

The models for each countries are therefore created by using the robust linear regression, and same substitution happens for every model created using linear regression by the original authors (that is, the conditional analysis later on, and plotting the final results and calculation of the resulting coefficients).


# 3. Comparison to the Original Article

In this section, we describe how to reproduce the plots and compare the results in terms of z-scores.

## Reproducing the Plots of the Main Article

To reproduce the plot of Fig. 1A, we grouped the countries in quartiles based on the logarithm of their average GDP p/c, extracted the mean of each preference from the gender coefficients (the $\beta_1^c$) of the countries for each quartile, after standardizing them. The same method was applied to the Gender Equality Index in correlation to the gender differences for each economic preference, to reproduce the plot in Fig. 1C.

Then, we related the magnitude of the summarised gender difference coefficients (the first component of the PCA) with the logarithm of the average GDP per capita to see the effect of the economic development. This reproduced Fig. 1B of the original article. We used a linear model to fit the correlation and extract the p-value, and for the plot the variables on the y-axis were additionally transformed as (y-y_min)/(y_max-y_min). We applied the same method to extract the correlation between the Gender Equality Index and the summarised gender preference, to see the effect of the gender equality in the countries (Fig. 1D). Note that here also the Gender Equality Index is transformed to be on a scale between 0 and 1.

We finally reproduced the plots in Fig. 2A-F using the variable conditioning analysis. This has been done for the economic development, for the Gender Equality Index, and for each of the four indicators building the Gender Equality Index. The variable used on the y-axis is the first Principal Component of the PCA made on the gender differences on the six preferences. All the variables used have been standardize to have mean at 0 and standard deviation of 1 before applying the conditional analysis. Using the residuals, built as described in the Data Analysis section of the Method paragraph, we performed a linear regression on the data points, and we extracted correlation coefficients and p-values.


## Tables and z-scores

The comparison of the replication analysis and of the extended analysis to the original article has been done checking the z-scores of the correlation coefficients, and comparing the statistical significance. Unfortunately, in the case of the slope coefficients (Table 4) it is not possible to compare them without having the standard deviation of the regression coefficient from the original author study.

Here below we report the tables with the corresponding values of the correlation for the original article, our replication study, and the z-scores calculated from them. In this article, the sample size of the data, needed for the calculation of the z-scores, is 76 (the number of the countries involved in this studies) for the GDP correlations, and 68 for the Gender Equality Index, due to the missing data. For the original article, the sample size is 76 for the GDP, and 71 for the Gender Equality Index (see @FH_SM, pp. 32, Table S4). 

We also indicate the significance level for each correlation using the following scheme: 

Significance $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*)

#### Table 1: Correlations between Log GDP p/c and country-level gender differences

|Variable |Corr. original article | Corr. this analysis| z-score|
--- | --- | --- | ---
|Altruism |0.58***  | 0.64*** |  |
|Trust    |0.59***  |0.55*** |   |
|Positive Reciprocity |0.31***  | 0.31* |  |
|Negative Reciprocity |0.35***  |0.46*** |  |
|Risk Taking |0.37***  | 0.42*** |  |
|Patience |0.38***  |0.43*** |  |

#### Table 2: Correlations between Gender Equality Index and country-level gender differences

|Variable |Corr. original article | Corr. this analysis| z-score|
--- | --- | --- | ---
|Altruism |0.51***  | 0.51*** | |
|Trust    |0.41***  |0.48*** | |
|Positive Reciprocity |0.13  | 0.22 | |
|Negative Reciprocity |0.40***  |0.35** |  |
|Risk Taking |0.34***  | 0.31** | |
|Patience |0.43***  |0.44*** |  |

#### Table 3: Correlation between Log GDP p/c and Gender Equality Index, and summarised gender differences

|Variable |Corr. original article | Corr. this analysis| z-score|
--- | --- | --- | ---
|Log GDP p/c |0.6685***  | 0.7119*** | -0.5 |
|Gender Equality Index | 0.5580***  |0.5852*** | -0.23  |

#### Table 4: Conditional analysis to separate the impacts of economic development and gender equality on gender differences

|Variable | Residualized on | Slope coeff. original article | Slope coeff. this analysis|
--- | --- | --- | --- |
|Log GDP p/c | Gender Equality Index | 0.5258***  | 0.5628*** |
|Gender Equality Index | Log GDP p/c | 0.3192***  | 0.2991* |
|WEF Global Gender Gap | Log GDP p/c | 0.2327***  | 0.2634* |
|UN Gender Equality Index | Log GDP p/c | 0.2911  | 0.1684 |
|F/M in Labor Force Participation | Log GDP p/c | 0.2453*  | 0.2123 |
|Years since Women Suffrage | Log GDP p/c | 0.2988**  | 0.1901 |


# 4. Discussion of the Results

Comparing the results of our analysis to the one from the original paper, starting with the single preferences correlations to the economic development, we see that our analysis brings us to very similar results in terms of correlation coefficients (see Table 1). The p-values, although different, are all indicating a statistically significant correlation, as in the original paper, and when calculating the z-scores thanks to Fisher’s r to z transformation, we see that each one is below 2 (which is usually taken as threshold to be statistically significant). This means that our correlations were not statistically significantly different from the ones in the original article.

We do the same for the Gender Equality Index (Table 2), and again we don’t find any large difference in the correlation. The p-values tend to be different with respect to the original article, but all of them are pointing towards the same direction. Also the z-scores are in absolute values below 2.

In Table 3, we compare the two core concepts of the article, where the summarised gender differences are regressed on the log GDP p/c and on the Gender Equality Index. The correlations found are similarly positive, strong, and statistically significant. Again, the correlations found in our analysis are not statistically significantly different from the correlations found in the original article.

Lastly, we have the conditional analysis (Table 4). For the two main country-level variable, we see that the values tend to agree and be on the same direction (similar slope coefficients and significant p-value). But when we start to check for the single indexes, we see that there are some differences which are worthy to discuss. 

The first thing to say is that we had to make choices on how to impute data and also how to handle the missing data (see discussion above in paragraph "Methods"). The main imputation on missing data has been done on the "time since women’s suffrage" dataset, that is where we see a substantial difference in the results. Other datasets, on the other hand, has not been treated for missing data but still they present some difference. For instance, the dataset "F/M in Labor Force Participation" in our analysis has a non-statistically significant correlation, while in the original paper they found a correlation with p-value less than 0.05.

A first thought was that this might be the result of using a different dataset for the GDP (the 2010 USD instead of 2005), but in our opinion this can’t be an explanation but rather a check about how robust the results are. So this question about the differences that were found is kept open. 


# 5. Conclusions

The study indicates that higher economic development and higher gender equality are associated with an increase in the gender differences in preferences, and therefore rules out the social-role theory over the post-materialistic one: When more resources are available to both men and women, the expression of the gender specific preferences can be seen. Our replication leads to the same conclusions, but we have some open questions regarding unexplained differences that might lead to further checks on the results’ robustness. 


# References
