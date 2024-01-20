---
title: |
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
abstract: |
  This study replicates and extends the work of Falk and Hermle (2018), who hypothesized that gender differences in economic preferences (patience, altruism, willingness to take risks, negative and positive reciprocity, and trust) were related to economic development and gender equality. While we were able to replicate their main results, we found that a number of methodological choices called for reexamination. Specifically, the use of an ad hoc gender equality index built by the authors lacked systematic justification, which led us to employ solely well-established indexes from gender studies in the subsequent analysis. This new analysis confirmed a positive and statistically significant association between aggregated gender differences in economic preferences and economic development conditional on gender equality. However, in contrast to the original article, the evidence of the relationship between gender differences and gender equality conditional on economic development was weak. We also investigated the relationships for the separate economic preferences and found that economic development predicts gender differences in all six preferences, whereas gender equality seems to have a negligible or null influence on most of them. Our findings provide a more nuanced view of the gender differences in economic preferences, with possible implications for policy-making.
  
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

-->


# 1. Introduction

Published findings on gender differences in human perceptions and behaviors, such as happiness [@SPSU], competition [@10.1257/jel.47.2.448; @https://doi.org/10.3982/ECTA6690; @NBERw11474; @KPS], and work preferences [@BEBLO201819], and their relation to gender inequality, are frequently used to influence decisions and policy-making, both in the public and private sectors [@world2012world]. Furthermore, issues related to gender inequality are becoming a more integral part of the agenda for many institutions and organizations, and stakeholders need to reveal, estimate, monitor, and prevent gender inequalities on individual, group, and nationwide levels [@world2012world; @GapCovid19].

The study of behavioral gender differences on a world scale is challenging. One challenge hampering progress in the field is the lack of large and homogeneous data sets across different social groups and countries. In an influential article published in the Quarterly Journal of Economics [@10.1093/qje/qjy013], a world scale data set on economic preferences, the Global Preference Survey within the Gallup World Poll 2012, was analyzed. The study focused on general questions about the distributions of economic preferences -- in particular, patience, altruism, willingness to take risks, negative and positive reciprocity, and trust -- in different countries, relating them to several variables from the Gallup World Poll, such as age, gender, education level, and others. The subsequent article [@doi:10.1126/science.aas9899] which we abbreviate in the following text as FH, used the same data set but focused explicitly on the gender differences highlighted in the previous study and reported evidence for the relationships of gender differences in economic preferences with economic development and gender equality. 

Following the approach described in FH and analyzing the same data set, we were able to replicate their work and found very similar results in terms of the magnitude and significance of the regression coefficients, as described below. Although statistically significant and socially relevant, FH's findings raise additional questions that the authors gave only a cursory treatment and that we focus on in our extended analysis in this paper.

The first relevant issue we address is the robustness of empirical findings to various indexes for gender equality, as several indexes have been used in FH study. In this regard, one point of concern is FH’s introduction of a customized index with insufficient justification and limited interpretability. In our analysis, we provide a list of possible shortcomings in this custom aggregated index and some of its components. We then restricted our analysis exclusively to those indexes widely used by academic, governmental, and other institutions [@WEF_report; @GGGreport2015].

A second issue is that FH’s main focus was hypothesis testing on the aggregated gender differences by using dimensionality-reduction techniques to combine the results into one single variable. However, investigating in detail these gender differences, specifically by examining individual preference measures rather than combined ones, enables the identification of potential significant factors contributing to these differences in relation to economic development and gender equality. Moreover, from the perspective of policy-making and follow-up studies, it is more informative to measure the magnitude of the differences [@fe72ed72-1164-372d-8510-e97ae443a587] rather than just conducting hypothesis discrimination. The present study aims to fill this gap.

The article is structured as follows: Section 2 presents the summary of FH's original article, while Section 3 contains our replication of FH's main findings. The first part of Section 4 is dedicated to the issues related to measuring gender inequality –- particularly the custom index FH built for this purpose –- while the second part reports the magnitude of the effects of gender differences on aggregated and separate preferences. Finally, in the Discussion and Conclusions (Section 5), we evaluate the relevance of our results for further studies and practical use in various areas.

The code used to perform the analysis, the input, and the output data are publicly available (or referenced to be downloaded) at https://github.com/scerioli/Global-Preferences-Survey.


# 2. Summary of the Original Article

In this section, we summarize the analysis and main findings of the original article [@doi:10.1126/science.aas9899]. The authors used the Gallup World Poll 2012 Global Preference Survey to measure gender differences in economic preferences across 76 countries, representing nearly 90% of the world population, with a total of almost 80,000 people surveyed and each country having around 1,000 participants. 

Survey participants were asked to answer qualitative and quantitative questions, and their score on each preference was assigned based on a weighted mean of the answers given [for more details, we refer to @FH_SM, section "Extended Materials and Methods"]. Therefore, for each person in the data set, each of the six economic preferences was scored. Additional individual-level variables indicating age, sex, education level, subjective math skills (as a proxy for cognitive skills), and household income quintile were collected.

The authors proposed two competing hypotheses to be tested [@doi:10.1126/science.aas9899, p. 1]:

1. Social role hypothesis: “Following social role theory, one may hypothesize that gender differences in preferences attenuate in more developed, gender-egalitarian countries [...]. As a consequence, according to the social role hypothesis, higher economic development and gender equality (and the associated dissolution of traditional gender roles) should lead to a narrowing of gender differences in preferences."

2. Resource hypothesis: "In contrast [to hypothesis 1], there is reason to expect that gender differences in preferences expand with economic development and gender equality [...]. In sum, greater availability of material and social resources to both women and men may facilitate the independent development and expression of gender-specific preferences, and hence may lead to an expansion of gender differences in more developed and gender-egalitarian countries."

To test these hypotheses, the authors first performed an ordinary least-squares regression using the preferences as predictor variable and the gender indicator as independent variable, controlling for other effects such age, age squared, sex, education level, subjective math skills, and household income quintile. From it, they performed the dimensionality-reduction technique of principal component analysis [@PCAbible], also known as PCA, on the gender coefficients. The first component of the PCA was then used as a summary index for gender differences in economic preferences. The logarithm of GDP per capita (Log GDP p/c) was used as a proxy for the economic development of the countries under study, while for gender equality, FH constructed a customized gender equality index, which they called the Gender Equality Index. This index was built using the first component of a PCA applied to four different indexes for gender equality: the World Economic Forum Gender Global Gap Index (WEF GGGI), the United Nations Development Programme Gender Inequality Index (UNDP GII), the ratio of female to male labor force participation (F/M LFP), taken from the World Bank database, and the Time Since Women's Suffrage (TSWS), from the Inter-Parliamentary Union Website.

The study reported a positive, large, and statistically significant correlation between gender differences in economic preferences and Log GDP p/c (r = 0.67, p-value < 0.0001), and between gender differences in economic preferences and the custom Gender Equality Index proposed by the authors (r = 0.56, p-value < 0.0001), when performing a simple linear regression between variables. The authors also conducted a conditional analysis to isolate the impact of economic development and gender equality. In this instance, they reported the regression coefficient being large and statistically significant (slope coefficient = 0.53, p-value < 0.0001) when gender differences were related to Log GDP p/c conditioned by Gender Equality Index, while moderately weak and statistically significant (slope coefficient = 0.32, p-value = 0.003) when relating to Gender Equality Index and controlling for Log GDP p/c.

Based on this evidence, the authors concluded that higher levels of economic development and gender equality favor the manifestation of gender differences in preferences across countries, “highlighting the critical role of availability of material and social resources, as well as gender-equal access to these resources, in facilitating the independent formation and expression of gender-specific preferences.” [@doi:10.1126/science.aas9899].


# 3. Replication of the Original Analysis

In this section, we describe the methodology used to replicate the analysis in FH, and we compare our results to theirs. Additionally, we make use of robust linear regression on the same data to take into account the non-normality of the data set.

## 3.1. Data

To conduct the replication, we downloaded the Gallup World Poll 2012 Global Preferences Survey data set from the [briq - Institute on Behavior & Inequality](https://www.briq-institute.org/global-preferences/home) website. The full data set is under restricted access, and education level and household income quintile are not available in the open-access version on the individual level (for more information, see Supplementary Material "Data Collection, Cleaning, and Standardization"). In @FH_SM, FH provide a complementary analysis where all the independent variables (except for gender) are dropped, and the results are coherent with what was found in their main analysis. Therefore, we decided to continue the replication study without having access to education level and income quintile.

## 3.2. Methods and Results

Following the analysis conducted by FH, we built a multilinear regression model to assess the relationship between each of the six economic preferences, standardized at the global level to exhibit a mean of 0 and a standard deviation of 1, and the independent variables associated to the individuals across countries:

\begin{equation}
\textrm{preference}^c_i = \beta_1^c \textrm{female}_i + \beta_2^c \textrm{age}_i + \beta_3^c \textrm{age}^2_i + \beta_4^c \textrm{subjectiveMathSkills}_i + \epsilon_i
\end{equation}

The subscript $i$ is the index of a survey participant and $c$ is the index for a country. This results in six models – one for each economic preference – with four coefficients. The coefficient for the dummy variable *female*, $\beta_1^c$, is used as a measure for gender difference, and it illustrates the extent to which men and women differ in terms of a specific economic preference in a particular country, measured in standard deviations.

We performed PCA on the six coefficients for gender differences of the separate preference measures and used the first component to obtain a single measure for gender differences. FH referred to this summarized index as "average gender differences". We find this nomenclature potentially confusing, therefore we refer to it as "aggregated index", rather than "average". The PCA technique has also been applied to the four gender equality indexes to get the joint index (Gender Equality Index) already described in Section 2 of this paper.

The competing hypotheses proposed by FH described in Section 2 can be formally written using the following multilinear model:

\begin{equation}
\textrm{Aggregated Gender Diff} = \beta_{Econ Develop} \ \textrm{Econ Develop} + \beta_{Gender Equality} + \ \textrm{Gender Equality} + \epsilon
\end{equation}

Where the variable $Econ \ Develop$ is always Log GDP p/c, while $Gender \ Equality$ can be either the Gender Equality Index or one of its sub-indexes (WEF GGGI, UNDP GII, F/M LFP, and TSWS). All the variables were standardized at the global level to show a mean of 0 and a standard deviation of 1. After standardization, $Aggregated \ Gender \ Diff$ shows how many standard deviations away is a certain country from the global average gender difference.

From the equation above, we would expect that:

1. If the social role hypothesis is correct, the model above will result in negative coefficients for economic development and gender equality.

2. If the resource hypothesis is correct, then we will have positive coefficients for economic development and gender equality.

Any other scenario (for example, when one coefficient in the model is positive and the other is negative) is left out of FH’s original research design and would require the formulation of additional hypotheses and further studies. 

Since the correlation between economic development and gender equality has been previously documented [@10.2307/23644911; @GGGreport2015], we checked the correlation between their proxies, regressing Log GDP p/c on the Gender Equality Index built by FH. The correlation found is moderately strong (r = 0.54) and statistically significant (p-value < 0.0001), as one can see in our Supplementary Material, Figure 3. The multilinear regression takes into account this correlation, and the theorem from Frisch–Waugh–Lovell [@10.2307/1907330; @doi:10.1080/01621459.1963.10480682] guarantees that the coefficients found are the same as those found in the residual analysis, as performed in FH.

In Table 1, we summarize the comparison of our results to those presented by FH in Figures 2 A-F. The results found are all in agreement with those of the original study (although with some differences in p-values), except for the coefficient found for TSWS. The difference is not surprising, as TSWS was one of the most difficult indicators to replicate because of a lack of clear instructions in FH (see also our Supplementary Material, "Data Collection, Cleaning, and Standardization"). Note also that the coefficients for economic development conditional on the four single indexes for gender equality are not provided in FH’s original analysis.


## 3.3. Robust Linear Regression

Within the Global Preference Survey, economic preferences were measured with both qualitative and quantitative responses. For all the economic preferences, a qualitative question based on a Likert scale between 0 and 10 was used, while a quantitative measurement was performed for every preference, excluding trust [@FH_SM]. This mixed approach of semi-continuous and ordered categorical variables has led us to the question of the appropriateness of the OLS method for the data analysis.

A diagnostic test on the data for each preference and each country, carried out using a Shapiro-Wilk test, indicated the presence of non-normality for all the measured economic preferences. 

Based on this outcome, we ran the previous analysis with robust linear regression [@fox2015applied] instead of ordinary linear regression to mitigate potential biases introduced by outliers. The results obtained with the robust linear regression did not differ significantly from the original and the replication analysis (see Table 1 below).


Table: **Comparison of the conditional analysis results from FH study (where OLS was used) and our replication using the OLS and the RLR**. Reported are the coefficients of the linear regressions and the corresponding p-values. In parenthesis, we indicate the standard error of the coefficient. Note that the errors related to FH study are missing because they were not reported in the article. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

| Coefficient | Regression on | Conditional on | FH (OLS) | Replication (OLS) | Replication (RLR) |
--- | --- | --- | --- | --- | --- |
| $\beta_{Econ Develop}$ | Log GDP p/c | GEI     | 0.53***  | 0.50 (0.09)***   | 0.49 (0.10)*** | 
| $\beta_{Econ Develop}$ | Log GDP p/c | WEF GGGI| -          | 0.62 (0.09)***   | 0.63 (0.09)*** | 
| $\beta_{Econ Develop}$ | Log GDP p/c | UNDP GII| -          | 0.40 (0.20)*     | 0.42 (0.20)*   | 
| $\beta_{Econ Develop}$ | Log GDP p/c | F/M LFP | -          | 0.66 (0.08)***   | 0.65 (0.09)*** |
| $\beta_{Econ Develop}$ | Log GDP p/c | TSWS    | -          | 0.64 (0.09)***   | 0.63 (0.09)*** | 
| $\beta_{Gender Equality}$ | GEI      | Log GDP p/c | 0.32** | 0.34 (0.09)*** | 0.34 (0.10)**  |
| $\beta_{Gender Equality}$ | WEF GGGI | Log GDP p/c | 0.23** | 0.22 (0.09)*   | 0.21 (0.09)*   | 
| $\beta_{Gender Equality}$ | UNDP GII | Log GDP p/c | 0.29   | 0.32 (0.16)    | 0.30 (0.20)    | 
| $\beta_{Gender Equality}$ | F/M LFP  | Log GDP p/c | 0.25*  | 0.22 (0.08)**  | 0.20 (0.09)*   | 
| $\beta_{Gender Equality}$ | TSWS     | Log GDP p/c | 0.30** | 0.19 (0.09)*   | 0.19 (0.10)*   |



# 4. Additional Analysis of Established Gender Equality Indexes and Separate Preference Measures

This section brings attention to various unresolved concerns regarding the Gender Equality Index built by FH, especially the lack of interpretability associated with this index. We then extend the analysis to state-of-the-art indexes such as WEF GGGI, UNDP GII, and UNDP Gender Development Index (GDI). We also delve deeper into the relationship between the separate preference measures and gender equality to better understand the source of the largest differences. Doing so further illuminates the associations found and renders new research questions.

## 4.1. Gender Equality Indexes and Potential Issues

In this subsection, we discuss potential issues related to the gender equality indexes that we considered worthy of analyzing further.

One concern is the way FH built their Gender Equality Index and why they propose it as a measure of gender equality. The justification for using this custom index rather than internationally recognized, studied, adopted, and already available indexes was omitted in FH’s study. To characterize the structure of the Gender Equality Index, we visualized its composition with the diagram shown in Figure 1. We briefly summarize the main issues found below.


![**The custom Gender Equality Index decomposed into its sub-indexes, as built by FH.** The repeated indexes and sub-indexes are highlighted with different colors (*ratio of female to male labor force participation* in purple, *share of seats in parliament* in green, and *enrollment into secondary education* in blue). In the index "Time since Women's Suffrage", there are missing observations that have been taken from another source, WEF Global Gender Gap Report 2006, following the approach used in FH study. Note that for each sub-index WEF GGGI calculates a weight to balance its impact on the overall index, while UNDP GII treats the sub-indexes without extra weighting. See also the technical notes of the @GGGreport2015 and of @UNDP2021.](figures/GenderEqualityIndex.png){width=80%}


As seen in Figure 1, the components of the Gender Equality Index used in FH contain repetitions. The two indexes, WEF GGGI and UNDP GII, share three sub-indexes, indicated here with different colors: *ratio of female to male labor force participation* (purple), the *share of seats in parliament* (green), and *enrollment into secondary education* (blue). As a third variable to construct the Gender Equality Index, FH used the *ratio of female to male labor force participation*, already included in the previous two indexes, as a weighted sub-index. While the PCA technique in some cases permits the aggregation of variables even in the presence of large correlations among the inputs, in the present case, such a procedure may lead to an imbalance in favor of these specific repetitive indexes (especially female and male labor force participation) over other factors, which were already balanced in the design of WEF GGGI and UNDP GII indexes.

Another critical point for the use of PCA is the interpretability of the index. This is a central question for measuring differences in society without losing descriptive power and is crucial for identifying effective policies for closing the gender gap [@GGGreport2015]. 

The TSWS indicator, introduced by FH, is used as a proxy to track the long-lasting effects of the right to vote. The use of this proxy is based on the assumption that, over time, development has a monotonic effect and its magnitude is proportional to the time since women’s suffrage was established. The data on the year of suffrage is available on a global scale but provides a rough estimate of gender disparities in politics [@GIS1820]. Indeed, even after the right to vote has been granted, many discriminatory laws may still be present and enforced by the executive branch of the government. Elimination of discrimination takes more time –- despite gaining the right to vote, there may not be an improvement in gender equality in other areas [@Yang], such as suppression of the right to work. As an example, married women in Western Germany needed permission of their husbands to work until 1977 [@RecoPolicyGer], although their right to vote was granted in 1918. The assumption that suffrage played a long-lasting effect on the balance of gender equality sounds reasonable but requires further investigation to be used as a robust estimator. 

For all these reasons, we decided to discontinue the use of the FH custom index, exclude the F/M LFP and the TSWS indicators from further analysis, and instead carry on only with the established and internally recognized indexes, WEF GGGI and UNDP GII. Although these indexes are widely used by many researchers and policymakers, they also have their weaknesses. The UNDP GII has been criticized by several authors [@Klasen2017UNDP; @18350; @Permanyer], as being highly correlated with economic development and including reproductive health indicators that can penalize less-developed countries. Moreover, this index measures welfare loss associated with inequality based on a calculated gender equality measure, which is not documented publicly. 

The power and limitations of WEF GGGI are discussed in @RePEc:spr:soinre:v:144:y:2019:i:3:d:10.1007_s11205-019-02080-5, @10.1080/13545701.2010.530607, as well as @WorsdaleWright. One of the main critics is that this index is truncated in such way that it does not allow any country to be more favorable for women than for men. Another weak point highlighted by our investigation (Figure 1) is the inclusion of a subjective measure called "wage equality between men and women for similar work", representing a substantial part (~30%) of one of the indicators composing the GGGI. This indicator is the result of the World Economic Forum's Executive Opinion Survey, where business leaders who are judged to be in a good position to assess the environment in which they operate are asked to give their estimation about wage inequality [@WEF_OS]. Additionally, although the WEF GGGI index is thought to be the least dependent on economic development since it measures the gap between male and female access to resources and opportunities [@GGGreport2015], this dependence exists and is not negligible (see Supplementary Material, Figure 3). 

We conducted extensive research of the literature to identify and understand the current options available for evaluating gender equality. In addition to the two above-mentioned indexes, we found that the Gender Development Index added from 2014 to the UNDP report is a good candidate for this kind of evaluation. This index is defined as the ratio of the Human Development Index for females to males, and it captures three dimensions in terms of health, knowledge, and living standards, separately for males and females. Life expectancy, the expected years of schooling and mean years of schooling, and GNI per capita are calculated within these dimensions. This index is praised by @Klasen2017UNDP for its clarity in interpretability and focus on gender equality (rather than female relative achievements). Therefore, we included this index in our extended analysis, along with WEF GGGI and UNDP GII.

## 4.2. Conditional Analysis of Gender Differences in Economic Preferences and Their Relationship to Economic Development and Gender Equality

In this section, we first explore the relationship between the aggregated gender differences in economic preferences with economic development and gender equality, using the gender equality indexes referred to above (WEF GGGI, UNDP GII, and UNDP GDI). We run the same robust linear regression using the model in Eq. 2 on these indexes and present the results in Figure 2. One can see that gender differences in economic preferences have a strong, positive, and statistically significant correlation with economic development when the conditional analysis is performed on the individual gender equality indexes. Conversely, the correlation between gender differences in economic preferences and gender equality, conditioned on economic development, is only statistically significant for WEF GGGI (r = 0.28, p-value = 0.0241), while for UNDP GII and GDI, the correlation is weak to null, with no statistical significance at the 5% confidence level. 

<!--
Thus far, our analysis, employing FH approach, has been performed by standardizing the *Summarized Gender Diff* variable as per Section 3.2, Eq. 2. This imparts slope coefficients with the meaning of indicating a specific country's deviation from the global average gender difference, measured in standard deviations. To assess the actual magnitude of gender differences in each country, it is essential to remove the standardization applied to *Summarized Gender Diff*, yielding a measurement that expresses the extent to which men and women differ in terms of standard deviations. We reported these results in Table 2 and continued the analysis using such an approach.
-->

![**Correlation and slope coefficients between aggregated gender differences in economic preferences and economic development, and between aggregated gender differences in economic preferences and gender equality indexes, using the residuals plots**. On the left, gender differences are regressed on economic development conditioned on gender equality for the different indexes (WEF GGGI, UNDP GGI, and GDI). On the right, the corresponding values of gender differences are regressed on gender equality indexes conditioned on economic development. We also report the corresponding p-values.](figures/Fig2_new.png){width=100%}

<!--
Table: Slope coefficients of the linear regression between gender differences in economic preferences and economic development, and between gender differences in economic preferences and gender equality indexes, their standard errors in brackets and significance levels  $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*) are reported. RLR method is used.


| Coefficient | Regression on | Conditional on | Result |
--- | --- | --- | --- |
| $\beta_{Econ Develop}$ | Log GDP p/c | WEF GGGI | 0.12 (0.02)*** | 
| $\beta_{Econ Develop}$ | Log GDP p/c | UNDP GII | 0.08 (0.03)*   | 
| $\beta_{Econ Develop}$ | Log GDP p/c | UNDP GDI | 0.13 (0.02)*** | 
| $\beta_{Gender Equality}$ | WEF GGGI | Log GDP p/c | 0.04 (0.02)*   | 
| $\beta_{Gender Equality}$ | UNDP GII | Log GDP p/c | 0.06 (0.03)    | 
| $\beta_{Gender Equality}$ | UNDP GDI | Log GDP p/c | 0.01 (0.02)   | 
-->

To next investigate the role of economic development and gender equality on the separate preference measures, we used a multilinear regression model for each preference, similar to the multilinear regression using the aggregated gender differences described earlier in Eq. 2:

\begin{equation}
\textrm{Gender Diff}^{p} = \beta_{Econ Develop}^{p} \ \textrm{Econ Develop} + \beta_{Gender Equality}^{p} \ \textrm{Gender Equality} + \epsilon
\end{equation}

where the index $p$ indicates one of six economic preferences (patience, altruism, willingness to take risks, negative and positive reciprocity, and trust), $Gender \ Diff^{p}$ indicates gender differences in the original six economic preferences, and $Gender \ Equality$ indicates the three individual indexes (WEF GGGI, UNDP GII, and UNDP GDI) for gender equality. As done in Eq. 2, all the variables were standardized at the global level to show a mean of 0 and a standard deviation of 1. After standardization, $Gender \ Diff^p$ shows how many standard deviations away is a certain country from the global average gender difference for a certain preference. Given that we perform each analysis of the six separate preference measures for three different measures of gender inequality, we obtain 18 coefficients.

As one can see in Table 2, the regression coefficient related to economic development (written as $\beta^p_{LogGDPpc}$) is in most cases positive and statistically significant. On the other hand, when we look at the coefficients related to the gender equality index ($\beta^p_{GenderEquality}$ of Table 3), we see that in 16 of the 18 regressor-regressee pairs, no statistically significant coefficients were observed. Only in two cases statistically significant coefficients were found: Between the pairs WEF GGG-Altruism and UNDP GII-Risk Taking.

This analysis suggests that the association between gender differences in separate preference measures and economic development still holds (Table 2). Regression coefficients for separate economic measures show an increase in gender differences with respect to the global average in the range between 0.22 and 0.55 standard deviations for one standard deviation change in Log GDP p/c, when conditioning on gender equality.

However, the results do not support an association between gender differences in separate preference measures and gender equality indexes for the absolute majority of the preferences (Table 3). Together with the results of the aggregated gender differences, as seen in Figure 2, this absence of consistency leads us to the conclusion that either there is an association but it is weak, or that such association does not exist at all. In the latter case, the set of hypotheses should not be limited to the two alternatives that were proposed as the main hypotheses in FH.

It is important to highlight that FH also explored the separate preference measures by conducting a conditional analysis on Log GDP p/c and their custom Gender Equality Index. They found a statistically significant correlation between the Gender Equality Index and only three of the six preferences, while all the preferences were correlated with Log GDP p/c conditional on the Gender Equality Index [Figures S5 and S6 in @FH_SM]. To compare these results with ours, we presented the correlation coefficients in the Supplementary Material (Tables 3 and 4). Note that the corresponding slope coefficients were not reported in FH article.


Table: **Slope coefficients for economic development from the eighteen multilinear regression models for separate economic preferences and three distinct choices of gender equality indexes (WEF GGGI, UNDP GII, UNDP GDI)**. As in FH, the symbols (+)/($-$) indicate the general direction of the difference. (+) indicates that women exhibited higher levels of the respective preference compared to men, ($-$) indicates that men on average exhibited higher levels of the respective preference. The regression coefficients, their standard errors in brackets, and significance levels $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*) are reported. RLR method is used.

| Preference  |  $\beta^p_{LogGDPpc}$ (WEF GGGI) | $\beta^p_{LogGDPpc}$ (UNDP GII) | $\beta^p_{LogGDPpc}$ (UNDP GDI) |
--- | ---|  --- |  ---  |
| Trust (+)       |  0.51 (0.11)$^{***}$ |  0.28 (0.19)          |  0.57 (0.12)$^{***}$   |
| Altruism (+)    |  0.55 (0.10)$^{***}$ |  0.66 (0.19)$^{***}$  |  0.53 (0.12)$^{***}$   |
| Pos. Recip. (+) |  0.22 (0.10)$^{*}$   |  0.25 (0.17)          |  0.15 (0.10)           |
| Neg. Recip. ($-$) |  0.36 (0.11)$^{**}$  |  0.10 (0.19)        |  0.43 (0.12)$^{***}$   |
| Risk Taking ($-$) |  0.33 (0.11)$^{**}$  |  0.04 (0.19)        |  0.39 (0.12)$^{**}$   |
| Patience ($-$)    |  0.29 (0.09)$^{**}$  |  0.15 (0.16)        |  0.33 (0.10)$^{**}$   |

Table: **Slope coefficients for gender equality from the same eighteen multilinear regression models for separate economic preferences and three distinct choices of gender equality indexes (WEF GGGI, UNDP GII, UNDP GDI)**. As in FH, the symbols (+)/($-$) indicate the general direction of the difference. (+) indicates that women exhibited higher levels of the respective preference compared to men, ($-$) indicates that men on average exhibited higher levels of the respective preference. The regression coefficients, their standard errors in brackets, and significance levels $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*) are reported. RLR method is used. 

|  Preference  | $\beta^p_{GenderEq}$ (WEF GGGI) | $\beta^p_{GenderEq}$ (UNDP GII) |  $\beta^p_{GenderEq}$ (UNDP GDI) |
--- | --- | ---| --- |
|  Trust (+)       | 0.11 (0.11)         | 0.36 (0.19)       | 0.04 (0.12)     |
|  Altruism (+)    | 0.27 (0.10)$^{**}$  | $-0.11$ (0.19)    | 0.11 (0.11)     |
|  Pos. Recip. (+) | 0.04 (0.09)         | $-0.02$ (0.17)    | 0.18 (0.10)     |
|  Neg. Recip. ($-$) | 0.14 (0.11)       | 0.32 (0.19)       | $-0.10$ (0.12)  |
|  Risk Taking ($-$) | 0.08 (0.11)       | 0.40 (0.19)$^{*}$ | $-0.10$ (0.12)  |
|  Patience ($-$)    | 0.16 (0.09)       | 0.25 (0.16)       | 0.06 (0.10)     |


# 5. Discussion and Conclusions

In this article, we replicated and extended the results of the work by @doi:10.1126/science.aas9899 which relates gender differences in economic preferences to economic development and gender equality. 

First, as a benchmark, we performed a nearly exact replication of FH’s analysis, obtaining the data from the Gallup World Poll 2012 Global Preference Survey and using the same methodology as FH. Unfortunately, the data set is publicly available only in a pre-processed form which is partially restricted. Nevertheless, we were able to replicate the analysis and obtained results similar to those in FH’s original article. In addition, we ran the same analysis using robust linear regression instead of ordinary linear regression to correct for the non-normality and outliers observed in the data. However, no significant changes in the results were observed.

We then investigated the indexes used to estimate gender equality and their relationship with economic development. We analyzed the Gender Equality Index built by FH and its components. Some methodological issues were identified, and we concluded that FH's use of this custom index over more established, balanced indexes lacks justification. Therefore, we conducted further analyses based on separate, widely accepted indexes of gender equality used in FH’s original article (WEF GGGI and UNDP GII), as well as an additional index –- the UNDP GDI.

We examined gender differences in economic preferences and their relationship with economic development and gender equality using the above-mentioned indexes. Performing a conditional analysis, we found a positive, strong, and statistically significant correlation between the aggregated gender differences in economic preferences and economic development when we controlled for WEF GGGI and UNDP GDI; controlling for UNDP GII yielded a somewhat milder correlation. However, when controlling for economic development, no correlation between UNDP GII or UNDP GDI and the aggregated gender differences in economic preferences was found. We did find a statistically significant but weak correlation between aggregated gender differences in economic preferences and WEF GGGI. Therefore, the dependency of gender differences in economic preferences on gender equality cannot be consistently supported when only established, commonly recognized indexes are used. This lack of consistency in the results leads us to the conclusion that either there is a weak correlation between gender differences in economic preferences and gender equality or that the correlation does not exist at all. In the latter case, the set of hypotheses should not be limited to the two alternatives that were proposed as the main hypotheses in FH.

We additionally analyzed how gender differences in separate preference measures are related to economic development and gender equality. Interestingly, we observed contrasting patterns in the regression coefficients between gender differences in each separate economic preference and both Log GDP p/c and gender equality indexes. Specifically, we found positive and statistically significant coefficients when examining the relationship between gender differences in separate preference measures and Log GDP p/c, when controlling for WEF GGGI and UNDP GDI. When controlling for UNDP GII, only one economic preference (altruism) shows a statistically significant coefficient, while for the other preferences the coefficients are not statistically significant. Meanwhile, among the six economic preferences studied in relationship with gender equality indexes, the only statistically significant coefficients were for altruism (which exhibited an association with WEF GGGI) and risk-taking (with an association with UNDP GII).

These findings align with our results obtained from the aggregated gender differences. However, the dependencies of gender differences in economic preferences on economic development and gender equality became more nuanced once analyzed for separate economic measures, with a more differentiated picture emerging. This differentiation becomes particularly important in the realms of decision-making and policy formulation.

Meanwhile, the impact of economic development on the manifestation of gender differences in preferences should also be further investigated. It might be worth researching the origins of these gender differences, considering hypotheses encompassing economic development and other potential country-level variables not considered in FH that could explain the disparities observed. For instance, one may speculate that at the higher level of economic development, the market expands and diversifies its offerings to cater to a wider range of consumers, exploiting status quo gender stereotypes as a starting point for the promotion of goods. In this case, a potential accentuation of gender differences by reinforcing gender stereotypical behaviors may occur.


# References


