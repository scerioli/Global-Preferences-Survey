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
abstract: |
  This study replicates and extends the work of @doi:10.1126/science.aas9899, where gender differences in economic preferences (patience, altruism, willingness to take risk, negative and positive reciprocity, and trust) were hypothesized to be related to economic development and gender equality. During the replication, we found very similar results in terms of coefficients’ magnitude and statistical significance of the correlation of aggregated gender differences in economic preferences with economic development and gender equality. However, we also identified several points to further examine that we developed in our extended analysis. First, we investigated potential issues in using certain indicators of gender equality and conducted our analysis using only indexes well-established in gender studies. A strong correlation between gender differences in economic preferences with economic development conditional on gender equality still holds in the analysis of these indexes. However, the evidence of this association with gender equality conditional on economic development is weak. Conducting a refined analysis, we break down this association further and determine the role of individual economic preferences in its formation. Overall, we conclude that economic development plays a significant role in predicting gender differences in economic preferences, whereas gender equality may have a lesser or potentially negligible influence.
  
---

<!--
**JEL:**  	C19	- Econometrics and Statistical Methods: Other, D010 - Microeconomic Behavior: Underlying Principles, C91- Laboratory, Individual Behavior, D630 - Equity, Justice, Inequality, and Other Normative Criteria and Measurement, D64 - Altruism, D810 - Criteria for Decision-Making under Risk and Uncertainty, D910 - Micro-Based Behavioral Economics: Role and Effects of Psychological, Emotional, Social, and Cognitive Factors on Decision Making, F000 International Economics: General

C30	General
C38	Classification Methods • Cluster Analysis • Principal Components • Factor Models
C26	Instrumental Variables (IV) Estimation; 
C83	Survey Methods
D71	Social Choice 
E7	Macro-Based Behavioral Economics: E70	General
E71	Role and Effects of Psychological, Emotional, Social, and Cognitive Factors on the Macro Economy
JEL Classification:	 C91, D91, D63, D64
Keywords:	 gender, preferences, cross-country variation


**Keywords:** replication study, gender differences, economic preferences, cross-country variation


**Data availability:** The code for this analysis can be found on GitHub at https://github.com/scerioli/Global-Preferences-Survey
-->


# 1. Introduction

Published findings on gender differences in human traits, such as happiness [@SPSU], competition [@10.1257/jel.47.2.448; @https://doi.org/10.3982/ECTA6690; @NBERw11474; @KPS], and work preferences [@BEBLO201819], and their relation to gender inequality, are frequently used to influence decisions and policy-making, both in the public and private sectors. In turn, gender inequality topics are becoming a more integral part of the agenda for many institutions and organizations, and it is essential for the stakeholders to reveal, estimate, monitor, and prevent gender inequalities on an individual, group, and nationwide level. 

The study of behavioral gender differences on a world scale is challenging. One challenge that hampers progress is the lack of large and homogeneous data sets across different social groups and countries. The Gallup World Poll 2012 included a Global Preference Survey aiming to be a data set representative of country samples, covering a majority of cultures and therefore is able to capture their variations while providing reliable measurements. This poll provides a unique insight into the economic preferences of a heterogeneous group of people.

The article that presented the first analysis of this data set was published in the Quarterly Journal of Economics [@10.1093/qje/qjy013]. It focused on general questions about the distributions of economic preferences in different countries, exploring several covariates from the Gallup World Poll. The subsequent article [@doi:10.1126/science.aas9899], replicated in this work, focused explicitly on the gender differences highlighted in the previous study and reported evidence for the relationship between economic development and gender equality, and gender differences in economic preference. The authors (FH) proposed two competing hypotheses to be tested. The first hypothesis is that gender differences in economic preferences will decrease for more economically developed and gender-equal countries because social roles relating to gender are attenuated. On the contrary, the second hypothesis is that for more economically developed and gender-equal countries, gender differences in economic preferences will increase because the gender-neutral goal of subsistence is removed and thus people can pursue their more unconstrained set of preferences. Their analysis showed a positive correlation between gender differences in economic preferences and economic development (expressed as Log GDP p/c), as well as a positive correlation between gender differences in economic preferences and gender equality. Therefore, FH's conclusion favors the second hypothesis, predicting an increase in the differences as women and men obtain sufficient access to resources to develop and express their intrinsic preferences independently. We give a brief summary of the original article in Section 2.

In our work, we first aimed to replicate the original study (found in Section 3 of this work and the Supplementary Material provided). When replicating the analysis of FH, we found very similar results in terms of coefficients’ magnitude and statistical significance of the correlation of gender differences in economic preferences with economic development and gender equality. However, we also identified several points to consider during the replication which we develop further in our extended analysis in Section 4. 

One point is the lack of justification for introducing the Gender Equality Index as a customized index for gender equality, which limits its interpretability. Instead, one could simply utilize a set of well-established indexes that have already been extensively discussed in the existing literature. In our analysis, we chose to expand upon this by examining gender differences in economic preferences in relation to the WEF Global Gender Gap Index and the UNDP Gender Inequality Index, which is also used by FH in building their custom index. We also incorporated an index newly introduced by UNDP, the Gender Development Index, which is used as a replacement for outdated and criticized indexes. Within this analysis, we inspected separate contributions of economic development and gender equality in manifestation of gender differences in economic preferences. Another focus of the extended analysis was assessing the effects of gender differences in individual economic preferences and revealing the possible major contributors to such differences with respect to economic development and gender equality. Finally, in the Discussion (Section 5), we evaluated the relevance of the results for further studies and in application-related domains.

The code used to perform the analysis, the input, and the output data are publicly available (or referenced to be downloaded) at https://github.com/scerioli/Global-Preferences-Survey.


# 2. Summary of the original article

In this section, we summarize the analysis and main findings of the original article. The authors used the Gallup World Poll 2012 Global Preference Survey to measure gender differences in economic preferences across 76 countries, with a total of almost 80,000 people surveyed and representing nearly 90% of the world population, with each country having around 1,000 participants. The economic preferences are defined as time preference (also referred to as patience in the study), altruism, willingness to take risks, negative and positive reciprocity, and trust.

The people participating in the survey were asked to answer qualitative and quantitative questions and their score on each preference was assigned based on a weighted mean of the answers given (for more details, we refer to @FH_SM, section “Extended Materials and Methods”). Therefore, for each person in the data set, a score of each of the six economic preferences was taken. Additional individual level variables indicating age, sex, education level, subjective math skills (as a proxy for cognitive skills), and household income quintile were taken.

The authors (FH) proposed two competing hypotheses to be tested, as described in the Introduction and as will be explained further in Section 3. Their analysis focused on the relationship between gender differences in economic preferences, and economic development and gender equality. To summarize gender differences among the six economic preferences, a principal component analysis (PCA) is performed on the gender coefficients. The first component of the PCA is then used as a summary index for gender differences in economic preferences. The logarithm of GDP per capita is used as a proxy for economic development of the countries under study, while for gender equality FH used a customized gender equality index, called Gender Equality Index (GEI). This GEI is built using the first component of a PCA applied on four different indexes for gender equality: the World Economic Forum Gender Global Gap Index (WEF GGGI), the United Nations Development Programme Gender Inequality Index (UNDP GII), the ratio of female to male labor force participation (F/M LFP), taken from the World Bank database, and the Time Since Women's Suffrage (TSWS), from the Inter-Parliamentary Union Website.

The study reported a positive, large and statistically significant correlation between gender differences in economic preferences and Log GDP p/c (r = 0.67, p-value < 0.0001), and between gender differences in economic preferences and GEI (r = 0.56, p-value < 0.0001), reflected in the Research article summary and in the graphic abstract of the original study. The authors also conducted a conditional analysis to isolate the impact of economic development and gender equality. The correlation was found to be of a slightly smaller magnitude but still rather moderately strong and statistically significant (r = 0.53, p-value < 0.0001) when gender differences were related to Log GDP p/c conditioned by GEI, while moderately weak and statistically significant (r = 0.32, p-value = 0.003) when relating to GEI and controlling for Log GDP p/c.

The authors concluded that the evidence indicates that higher levels of economic development and gender equality favor the manifestation of gender differences in preferences across countries, “highlighting the critical role of availability of material and social resources, as well as gender-equal access to these resources, in facilitating the independent formation and expression of gender-specific preferences.” [@doi:10.1126/science.aas9899].


# 3. Replication of the original analysis

In this section, we describe the methodology used to replicate the analysis in FH and we compare our results to theirs. Additionally, we make use of the robust linear regression model on the same data to take into account the non-normality of the data set. We did not find any substantial differences from the original authors’ results.

## Data

To conduct the replication, we downloaded the Gallup World Poll 2012 Global Preferences Survey data set from the [briq - Institute on Behavior & Inequality](https://www.briq-institute.org/global-preferences/home). The full data set is under restricted access, and education level and household income quintile on the individual level are not available in the open-access version (for more information, see Supplementary Material "Data Collection, Cleaning, and Standardization"). In their Supplementary Material,  @FH_SM provides a complementary analysis where all the independent variables (except for gender) are dropped, and the results were coherent with what was found in their main analysis. Therefore, we decided to continue the replication study without having access to education level and income quintile.


## Methods and Results

Following FH analysis, we built a multilinear regression model to assess the relationship between each of the six economic preferences and the independent variables associated to the individuals across countries:

\begin{equation}
\textrm{preference}^c_i = \beta_1^c \textrm{female}_i + \beta_2^c \textrm{age}_i + \beta_3^c \textrm{age}^2_i + \beta_4^c \textrm{subjectiveMathSkills}_i + \epsilon_i
\end{equation}

where the subscript $i$ is the index of a survey participant and $c$ is the index for a country. This results in six models – one for each economic preference – with four coefficients. The coefficient for the dummy variable *female*, $\beta_1^c$, is used as a measure for gender difference. The multilinear regression has been conducted independently for each country. Therefore, in total, there is one coefficient representing gender differences for each of the six economic preferences for 76 countries. 

We performed a PCA on the six coefficients for gender differences in individual economic preferences and used the first component to obtain a single measure for gender differences. FH refer to this summarized index as "average gender differences". We find this nomenclature potentially confusing, therefore we refer to it as either “aggregated index”, or as “summarized index”, rather than "average". The PCA technique has also been applied on the four gender equality indexes to get a joint index (GEI) already described in the section 2 of this paper.

The competing hypotheses presented by FH are:

1. Social role hypothesis: “Following social role theory, one may hypothesize that gender differences in preferences attenuate in more developed, gender-egalitarian countries [...]. As a consequence, according to the social role hypothesis, higher economic development and gender equality (and the associated dissolution of traditional gender roles) should lead to a narrowing of gender differences in preferences."

2. Resource hypothesis: "In contrast, there is reason to expect that gender differences in preferences expand with economic development and gender equality [...]. In sum, greater availability of material and social resources to both women and men may facilitate the independent development and expression of gender-specific preferences, and hence may lead to an expansion of gender differences in more developed and gender-egalitarian countries."

We can formally write the hypotheses using the following linear model:

\begin{equation}
\textrm{Gender Differences} \propto \beta_{Economic Development} \ \textrm{Economic Development} + \beta_{Gender Equality} \ \textrm{Gender Equality}
\end{equation}

Therefore, we would expect that:

1. If the social role hypothesis is correct, the model above will result in negative coefficients for economic development and gender equality.

2. If the resource hypothesis is correct, then we will have positive coefficients for economic development and gender equality.

Following these statements, the null hypothesis is that there is no correlation between gender differences in economic preferences and economic development, and between gender differences in economic preferences and gender equality. Any other scenario (for example, when one coefficient in the model is positive and the other is negative) is left out of the original hypotheses and would require the formulation of additional hypotheses and further studies. 

This model takes into account the correlation between economic development and gender equality [@10.2307/23644911; @GGGreport2015], by allowing for the conditioning on one over the other. The theorem from Frisch–Waugh–Lovell [@10.2307/1907330; @doi:10.1080/01621459.1963.10480682] guarantees that the coefficients found are the same as those found in the residual analysis, as performed in FH. To check the correlation between economic development and gender equality of the countries analyzed in the study, we regressed Log GDP p/c on GEI. The correlation found is moderately strong (r = 0.544) and statistically significant (p-value < 0.0001), as one can see in the Supplementary Material, Figure 3.

In practice, for the model above, the proxies for economic development and for gender equality (Log GDP p/c and GEI), are used to assess the summarized gender differences in economic preferences. Apart from the tests with GEI, FH applied the linear regression on the gender equality indexes, used to build GEI, that is WEF GGGI, UNDP GII, F/M LFP, and TSWS.

We summarize in Table 1 the comparison of our analysis to FH (from Figures 2 A-F of @doi:10.1126/science.aas9899). The results found are all in agreement with the original ones (although with some differences in p-values), except for the coefficient found for TSWS. The difference is not surprising, as TSWS was one of the most difficult indicators to replicate because of a lack of clear instructions in FH (see also our Supplementary Material, "Data Collection, Cleaning, and Standardization"). Note also that the coefficients for economic development conditional on the four single indexes for gender equality are not provided in the original analysis.


## Robust Linear Regression

Within the Global Preference Survey, the way economic preferences have been measured is by seeking both qualitative and quantitative responses: For all the preferences, a qualitative question about each participant’s level of economic preference has been measured with a Likert scale between 0 and 10, while a quantitative measurement has been performed on every preferences excluding trust (please refer to @FH_SM for further details). This mixed approach of semi-continuous and ordered categorical variables has lead us to question the appropriateness of the OLS method for the data.

A diagnostic test on the data for each preference and each country, carried out using a Shapiro-Wilk test, indicated the presence of non-normality for all the measured economic preferences. In all cases, the distribution of the data has been detected to be non-normally distributed.

Based on this outcome, we ran the previous analysis using the robust linear regression (RLR) instead of ordinary linear regression, to mitigate potential biases introduced by outliers. The results obtained with the robust linear regression did not differ significantly from the original and the replication analysis (see Table 1 below).


Table: Comparison of the conditional analysis results from the original study (where OLS was used) and our replication using the OLS and the RLR. Reported are the slopes of the linear regressions and the corresponding p-value. In parenthesis, we indicate the standard error of the coefficient. Note that the errors related to FH study are missing because they were not reported in the article. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

| Coefficient | Regression on | Conditional on | Original (OLS) | Replication (OLS) | Replication (RLR) |
--- | --- | --- | --- | --- | --- |
| $\beta_{Econ Develop}$ | Log GDP p/c | GEI     | 0.5258***  | 0.50 (0.09)***   | 0.49 (0.10)*** | 
| $\beta_{Econ Develop}$ | Log GDP p/c | WEF GGGI| -          | 0.62 (0.09)***   | 0.63 (0.09)*** | 
| $\beta_{Econ Develop}$ | Log GDP p/c | UNDP GII| -          | 0.40 (0.20)*     | 0.42 (0.20)*   | 
| $\beta_{Econ Develop}$ | Log GDP p/c | F/M LFP | -          | 0.66 (0.08)***   | 0.65 (0.09)*** |
| $\beta_{Econ Develop}$ | Log GDP p/c | TSWS    | -          | 0.64 (0.09)***   | 0.63 (0.09)*** | 
| $\beta_{Gender Equality}$ | GEI      | Log GDP p/c | 0.3192** | 0.36 (0.09)*** | 0.34 (0.10)**  |
| $\beta_{Gender Equality}$ | WEF GGGI | Log GDP p/c | 0.2327** | 0.22 (0.09)*   | 0.21 (0.09)*   | 
| $\beta_{Gender Equality}$ | UNDP GII | Log GDP p/c | 0.2911   | 0.30 (0.20)    | 0.30 (0.20)    | 
| $\beta_{Gender Equality}$ | F/M LFP  | Log GDP p/c | 0.2453*  | 0.22 (0.08)**  | 0.20 (0.09)*   | 
| $\beta_{Gender Equality}$ | TSWS     | Log GDP p/c | 0.2988** | 0.19 (0.09)*   | 0.19 (0.10)*   |



# 4. Extended analysis

This section brings attention to various unresolved concerns regarding GEI. One significant issue is the lack of interpretability associated with this index. The interpretability of a socioeconomic measure is crucial, as an index that cannot be effectively understood loses its value in describing reality. We also delve deeper into the correlation of the individual economic preferences and gender equality because it can help us better understand where the largest differences come from and therefore it may help shed light, or provoke new research on the specific correlation(s) found. We extended the analysis to state-of-the-art indexes such as WEF GGGI, UNDP GII, and UNDP Gender Development Index (GDI). 

## Gender equality indexes and potential issues

During the replication analysis, we encountered potential issues related to the gender equality indexes that we considered worthy of analyzing further.

One concern is the way GEI has been built and the reason for it to be taken as a measure for gender equality. The justification for using GEI rather than internationally recognized, studied, adopted and already available indexes was omitted in FH. To characterize the structure of GEI, we visualized its composition with the diagram shown in Figure 2 and here below we briefly summarize the main issues found.

![The custom Gender Equality Index decomposed in its sub-indexes, as used by FH. The repeated indexes and sub-indexes are highlighted with different colors. In the index "Time since Women's Suffrage" there are missing points which have been taken from another source, the "WEF Global Gender Gap Report 2006", following what FH did in their article. Note that for each sub-index WEF GGGI calculates a weight to balance its impact on the overall index, while UNDP GII treats the sub-indexes without extra weighting. See also the technical notes of the @GGGreport2015 and of @UNDP2021](figures/GenderEqualityIndex.png){width=80%}

- The most critical point for the use of PCA is the interpretability of the index, which is a central question when it comes to building an index that can measure differences in the society without losing its descriptive power and the ability to identify effective policies for closing the gender gap [@GGGreport2015]. Without interpretability, the outcomes of research hold little practical use, and if policymakers base decisions on such studies without comprehending the (often strong) assumptions they rely on, it may potentially harm the development of society.

- As seen in Figure 1, the components of GEI used in the original study contain repetitions. The two indexes WEF GGGI and UNDP GII share three sub-indexes, indicated here with different colors: *ratio of female to male labor force participation* (purple), the *share of seats in parliament* (green), and *enrollment into secondary education* (blue). As a third variable to construct GEI, FH used the *ratio of female to male labor force participation*, already included in the previous two indexes as a weighted sub-index. While the PCA technique in some cases permits the aggregation of variables even in the presence of large correlations among the inputs, in the present case, such a procedure may lead to an imbalance in favor of these specific repetitive indexes (especially female and male labor force participation) over other factors, which were already balanced in the design of WEF GGGI and UNDP GII indexes. 

- The *Time Since Women's Suffrage* indicator, introduced by FH, is used as a proxy to track the long-lasting effects of the right to vote. It is based on the assumption that, during the time, development has always had a monotonic effect and its magnitude is proportional to the time since women’s suffrage was established. The data on the year of suffrage is available on a global scale but provides a very limited overview of gender disparities in politics, as discussed in @GIS1820. Indeed, even after the right to vote has been granted, many discriminating laws may still be present, and the alignment of law together with the executive branch of the government and elimination of discrimination takes more time – for example, despite gaining the right to vote, the right to work can still be suppressed for several decades. The assumption that suffrage played a long-lasting effect on the balance of gender equality sounds reasonable but requires further investigation to be used as a robust estimator. Note also that in Figure 1 for some countries there is no reported data for this indicator, therefore FH took the missing points from the WEF Global Gender Gap Report of 2006. 

For all the reasons above, we decided to avoid continuing with the use of GEI and to exclude the F/M LFP and the TSWS indicators from further analysis, and instead carry on only with WEF GGGI and UNDP GII. 

Although these indexes are widely used by many researchers and policy makers, they are not exempt from critics. The UNDP GII has been criticized by several authors [@Klasen2017UNDP; @18350; @Permanyer], said to be highly related to economic development, as it includes reproductive health indicators that can penalize less-developed countries, and it measures welfare loss associated to inequality based on a calculated gender equality measure not documented publicly. Instead, the power and limitation of WEF GGGI remains mostly undiscussed in academic literature, with a few exceptions [@RePEc:spr:soinre:v:144:y:2019:i:3:d:10.1007_s11205-019-02080-5; @10.1080/13545701.2010.530607]. As our investigation reveals (Figure 1), one point of concern could be the inclusion of a subjective measure, based on a panel of experts’ best guesses, called "wage equality between men and women for similar work". This measure of economic participation and opportunity represents a substantial ~30% of the sub-index. The index is thought to be the least dependent on economic development since it measures the gap between male and female access to resources and opportunities [@GGGreport2015]. However, this dependence exists and is not negligible (see Supplementary Material, Figure 3).

We conducted extensive research in the literature to understand which options are available at this time to evaluate gender equality. In addition to the two indexes above-mentioned, we found that the Gender Development Index added from 2014 to the UNDP report is a good candidate for this kind of evaluation. This index is defined as the ratio of the Human Development Index for females to males, and it captures three dimensions in terms of health, knowledge, and living standards, separately for males and females. Life expectancy, the expected year of schooling and mean years of schooling, and GNI per capita are calculated within these dimensions. This index has been discussed in @Klasen2017UNDP, being praised for the clarity in interpretability and for the focus on gender equality (rather than the sole female relative achievements). Therefore, we included this index in our extended analysis, along with WEF GGGI and UNDP GII.

## Conditional analysis of gender differences in economic preferences and their relationship to economic development and gender equality

Here, we explore the relationship of the summarized gender differences in economic preferences with economic development and gender equality, using the gender equality indexes referred above (WEF GGGI, UNDP GII, and UNDP GDI). We run the same robust linear regression using the model in Equation 3 on these indexes and present the results in Figure 2. One can see that gender differences in economic preferences have a strong, positive, and statistically significant correlation with economic development when the conditional analysis is performed on the individual gender equality indexes, suggesting that economic development plays a key role on gender differences in economic preferences. Conversely, the correlation between gender differences in economic preferences and gender equality, conditioned on economic development, is only statistically significant for WEF GGGI (r = 0.28, p-value = 0.0241), while for UNDP GII and GDI, the correlation is weak to null, with no statistical significance at 5% confidence level. 

![Correlation between gender differences in economic preferences and economic development, and between gender differences in economic preferences and gender equality indexes, using the residuals plots. On the left, gender differences are regressed on economic development conditioned on gender equality for the different indexes (WEF GGGI, UNDP GGI, and GDI). On the right, the corresponding values of gender differences are regressed on gender equality indexes conditioned on economic development. We also report the slope coefficients and the corresponding p-values.](figures/Fig2.png){width=100%}

To investigate the role of economic development and gender equality on individual preferences, we used a multilinear regression model for each preference, similar to what we have done for the summarized gender differences: 

\begin{equation}
\textrm{GenderDiff}^{p}_c = \beta_{EconomDevelop}^{p} \ \textrm{EconomDevelop}_c + \beta_{GenderEquality}^{p} \ \textrm{GenderEquality}_c + \epsilon_c
\end{equation}

where index $c$ indicates the country-level, while the index $p$ indicates economic preferences.  GenderDiff$^{p}_c$ indicates gender difference in the original six economic preferences, and GenderEquality$_c$ indicates the three individual indexes (WEF GGGI, UNDP GII, and UNDP GDI) for gender equality. 

As one can see in Table 2, the correlation between gender differences in individual economic preferences and economic development controlling for gender equality (written as $r_{LogGDPpc}$) is in most cases positive, strong, and statistically significant. On the other hand, when we look at the correlation between gender differences in individual economic preferences and each individual gender equality index conditional on economic development ($r_{GenderEquality}$ of Table 3), we see that in 16 of the 18 regressor-regressee pairs, no statistically significant correlations were observed. In only two cases statistically significant correlations are found: Between the pairs WEF GGG-Altruism and UNDP GII-Risk Taking. 

It is important to say that FH also explored the individual economic preferences conducting a conditional analysis on Log GDP p/c and GEI. They found a statistically significant correlation between GEI and only three of the six preferences, while all the preferences were correlated with Log GDP p/c conditional on GEI (refer to Figures S5 and S6 in @FH_SM).

The results presented in Figure 2 and Tables 2-3 suggest a lack of evidence of a correlation between gender differences in individual economic preferences and gender equality indexes for the absolute majority of the preferences, while the correlation between gender differences in individual economic preferences and economic development holds. 

This lack of consistency in the results leads us to the conclusion that either there is a correlation but it is weak, or that such a correlation does not exist at all. In the latter case, the set of hypotheses should not be limited to the two alternatives that were proposed as main hypotheses in FH.


<!--
The UNDP GII index is the index with the highest correlation with Log GDP p/c and therefore an effect of multicollinearity might take place, deflating the values of the multilinear regression.

Not sure if we want to include this. Should I check this further to be sure that we aren't missing something?
-->


Table: Correlation between gender differences in each economic preference and Log GDP p/c. RLR method is used. The correlation terms, their standard errors and significance levels $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*) are reported. 

| Preference  |  r$_{LogGDPpc}$ (WEF GGGI) | r$_{LogGDPpc}$ (UNDP GII) | r$_{LogGDPpc}$ (UNDP GDI) |
--- | ---|  --- |  ---  |
|          Trust |  0.52 (0.10)$^{***}$ |  0.19 (0.11)          |  0.50 (0.10)$^{***}$   |
|       Altruism |  0.53 (0.10)$^{***}$ |  0.35 (0.11)$^{***}$  |  0.45 (0.10)$^{***}$   |
|    Pos. Recip. |  0.29 (0.11)$^{*}$   |  0.21 (0.11)          |  0.19 (0.11)           | 
|    Neg. Recip. |  0.40 (0.11)$^{**}$  |  0.07 (0.12)          |  0.39 (0.11)$^{***}$   |
|    Risk Taking |  0.35 (0.11)$^{**}$  |  0.03 (0.12)          |  0.32 (0.11)$^{**}$   |
|       Patience |  0.37 (0.11)$^{**}$  |  0.10 (0.12)          |  0.33 (0.11)$^{**}$   |



Table: Correlation between gender differences in each economic preference and on the three gender equality indexes. RLR method is used. The correlation terms, their standard errors and significance levels $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*) are reported. 


|  Preference  | r$_{GenderEq}$ (WEF GGGI) | r$_{GenderEq}$ (UNDP GII) |  r$_{GenderEq}$ (UNDP GDI) |
--- | --- | ---| --- |
|  Trust       | 0.13 (0.12)         | 0.22 (0.11)    | 0.08 (0.12)       |
|  Altruism    | 0.36 (0.11)$^{**}$  | $-0.04$ (0.12) | 0.10 (0.12)       |
|  Pos. Recip. | 0.04 (0.12)         | $-0.04$ (0.12) | 0.20 (0.11)       |
|  Neg. Recip. | 0.17 (0.11)         | 0.17 (0.11)    | $-0.10$ (0.12)    |
|  Risk Taking | 0.03 (0.12)         | 0.22 (0.11)$^{*}$ | $-0.03$ (0.12) |
|  Patience    | 0.23 (0.11)         | 0.17 (0.11)    |   0.08 (0.12)     |


# 5. Discussion and conclusions

In the present article, we replicated and extended the results of the work by @doi:10.1126/science.aas9899 which relates gender differences in economic preferences to economic development and gender equality. 

As a first milestone, we performed a nearly exact replication, obtaining the data from the Gallup World Poll 2012 Global Preference Survey, using the same methodology as in the original article. Unfortunately, the data set is publicly available only in a pre-processed form and is partially restricted. Nevertheless, we managed to replicate the analysis and the results were similar to those of the original article. In addition, we ran the same analysis using robust linear regression instead of ordinary linear regression as the data revealed signs of non-normality and outliers, but no significant changes in the results were observed.

We then investigated the indexes used to estimate gender equality and their relationship with economic development. We analyzed the Gender Equality Index built by FH and its individual components. Some methodological issues were identified, and the usage of this custom index over a more established, balanced index lacks justification and remains to be questioned. Therefore, we conducted our further analysis based on separate, widely-accepted indexes of gender equality used in the original article (WEF Global Gender Gap Index and UNDP Gender Inequality Index), plus an additional index – the UNDP Gender Development Index.

We examined gender differences in economic preferences and their relationship with economic development and gender equality using the above-mentioned indexes. Performing a conditional analysis, we found a positive, strong, and statistically significant correlation between summarized gender differences in economic preferences and economic development, controlling for WEF GGGI and UNDP GDI. While controlling for UNDP GII the correlation was somewhat milder. On the other hand, when controlling for economic development, no correlation between UNDP GII or GDI and the summarized gender differences in economic preferences was found. Only the correlation between summarized gender differences in economic preferences and WEF GGGI was weak and statistically significant. Therefore, the dependency of gender differences in economic preferences on gender equality can not be consistently supported when only established, commonly recognized indexes are used. This lack of consistency in the results leads us to the conclusion that either there is a weak correlation, or that the correlation does not exist at all. In the latter case, the set of hypotheses should not be limited to the two alternatives that were proposed as main hypotheses in FH.

We additionally analyzed how gender differences in individual economic preferences are related to economic development and gender equality. Interestingly, we observed contrasting patterns in the correlations between gender differences in each specific economic preference and both Log GDP p/c and gender equality for WEF GGGI and UNDP indexes. Specifically, we found positive, strong, and statistically significant correlations when examining the associations between gender differences in individual economic preferences and Log GDP p/c, when controlling for WEF GGGI and UNDP GDI. We found only one economic preference (altruism) that correlates with Log GDP p/c when controlling for UNDP GII. However, among the six economic preferences studied, the only correlations we found with gender equality indexes were in altruism (which exhibited a correlation with WEF GGGI) and risk taking (with a correlation with UNDP GII). 

These findings align with the results obtained from the summarized gender differences, but it is worth noting that the preferences exhibiting statistically significant correlations were few. Therefore, the dependency of gender differences in economic preferences on gender equality became more nuanced, with a more differentiated picture emerging. This differentiation becomes particularly important in the realms of decision-making and policy formulation.

Meanwhile, the strong impact of economic development on the manifestation of gender differences in preferences should also be further investigated. As an outlook, it might be worth conducting research on the origins of these gender differences, considering hypotheses encompassing economic development and other potential country-level variables not considered in FH that could explain these disparities. For instance, one may speculate that at the higher level of economic development, the market expands and diversifies its offerings to cater to a wider range of consumers, exploiting status quo gender stereotypes as a starting point for the promotion of goods. In this case, a potential accentuation of gender differences by reinforcing gender stereotypical behaviors may occur.



# References


