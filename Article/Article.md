---
title: |
  **Gender differences in economic preferences and gender equality are yet unrelated: evidence from the replication of Falk and Hermle, 2018**
author:
- Sara Cerioli
- Andrey Formozov
bibliography: bibliography.bibtex
output:
  pdf_document: default
  bibliography: bibliography.bibtex
csl: bib_style/./mee.csl
abstract: |
This study replicates and extends the article of Falk and Hermle published in *Science* (2018), where the gender differences in economic preferences were related to economic development and to gender equality of the countries. In the original paper, the authors use the data from the Gallup World Poll 2012, which included a Global Preference Survey conducted on almost 80000 people in 76 countries all around the world. The dataset covers almost 90% of the world population representation, with each country having around 1000 participants and answering questions related to their time preference (patience), altruism, willingness to risk-taking, negative and positive reciprocity, and trust. We successfully replicated the distribution of gender differences in economic preferences. However, during the replication, several methodological flaws in the original study regarding the relation of gender differences to economic development and gender equality were identified and further investigated by us. In particular, first, we revealed a strong and statistically significant correlation of gender equality indexes with economic development, expressed in Log GDP p/c. We argue that this correlation diminishes the role of the strong correlation between economic preferences and gender equality if the relation is not controlled on economic development, thus highlighting the role of conditional analysis as the only way to separate contributions of economic development and gender equality. Second, the joint gender equality index proposed by the authors was found to have an architecture that leads to the disbalance of the factors that quantify the level of gender equality without justification and involve unvalidated and previously not reported indicators. Thus, it manifests no proof that the joint gender equality index performs no worse than any of the other existing indicators. Third, we further conducted the conditional analysis with WEF, UNDP, and GDI gender equality indexes. The analysis confirmed the strong and statistically significant association of gender differences with economic development conditioned on gender equality. However, the evidence for the association of gender differences with gender equality was found to be poor. A more detailed investigation of single preferences further confirmed such a conclusion, demonstrating mild and statistically significant association for only two preferences out of 18 preference-gender equality index combinations. Our results suggest the absence of evidence of a strong and statistically significant association between economic preferences and gender equality given the data available in the abovementioned datasets, current methodology, and indexes to measure gender equality. We also highlight and reveal the importance of the validation and investigation of indexes used as a proxy for gender equality estimation for the scientific discourse on the fundamental theories of the socio-economic organization and policy-makers and advisors.

---

**JEL:**  D010 - Microeconomic Behavior: Underlying Principles, D630 - Equity, Justice, Inequality, and Other Normative Criteria and Measurement, D810 - Criteria for Decision-Making under Risk and Uncertainty, D910 - Micro-Based Behavioral Economics: Role and Effects of Psychological, Emotional, Social, and Cognitive Factors on Decision Making, F000 International Economics: General

**Keywords:** replication study, gender differences, economic preferences

**Data availability:** The code used for this analysis (replication and extended) can be found on GitHub at https://github.com/scerioli/Global-Preferences-Survey


# 1. Introduction

Gender differences in the economic behaviors, such as happiness [@SPSU], competition [@CG; @GLL; @KPS], or work preferences [@BG] have been studied in sociology, psychology and economics for many decades. Any scientific knowledge in this regard and its relation to gender inequality is used nowadays as arguments and counter-arguments for decision and policy-making. Gender inequality topics are becoming an integral part of the agenda for many public and private institutions and organizations, and it is essential for the stakeholders to reveal, estimate, monitor, and prevent gender inequalities on individual, group and country levels. 

The study of gender differences on a world scale per se is challenging. One of the challenges that hampers the progress is the lack of large and heterogeneous datasets across different social groups and countries. The Gallup World Poll 2012 included a Global Preference Survey conducted on almost 80000 people in 76 countries all around the world that aimed to fill this gap: Covering nearly 90% of the world population representation, with each country having around 1000 participants answering questions related to their time preference (patience), altruism, will of risk-taking, negative and positive reciprocity, and trust. The dataset provides a unique insight into the economic preferences of a heterogeneous number of people. 

The article that conducted the analysis of this dataset was published in the Quarterly Journal of Economics [@QJE_Falk]. It focused on general questions about the economic preferences distributions in different countries, exploring several covariates from the Gallup World Poll. The subsequent article [@FH], replicated in this work, focused explicitly on the gender differences arising from the previous study and reported the evidence for the relationship between gender differences in economic preferences, economic development, and gender equality across many countries. The authors propose two competing hypotheses to be tested: The first one is that the gender differences will decrease for more economically developed and gender-equal countries, because social roles related to gender are attenuated. The second hypothesis is that, on the contrary, for more economically developed and gender-equal countries, the gender differences will increase because the gender-neutral goal of subsistence is removed and thus people can pursue their real preferences. Their analysis shows a positive correlation of gender differences in preferences with economic development (expressed as Log GDP p/c) and with the gender equality of the countries, thus favoring the hypothesis that predicts the increase of the differences as women and men obtain sufficient access to the resources to develop and express their intrinsic preferences independently. The authors composed a joint measure of gender equality of different countries using two officially recognized indexes to measure gender equality (WEF Global Gender Gap and UNDP Gender Inequality Index), together with two other less complete indicators, providing little to no discussion about the validity and robustness of their approach, and without establishing a link to the existing literature with this regard. Besides, the power and limitations of the officially recognized indicators themselves is an open scientific question, and, even being the best estimates available on global scale, these are far from being a complete representation of gender inequality [@SK; @AS; @Permanyer]. The present work is dedicated to close this methodological flaw and rise awareness about possible implications on the results, and drawing conclusions regarding the relationship between gender differences in economic preference and gender equality in the original study. 

In this study, we first analyse the gender equality index that was used by the original authors and the sub-indexes involved into the study, highlighting its problematic. Second, we conduct a pure replication of the article in R-language. Third, we extended the original article using a robust linear regression to address the non-normality of the data. Fourth, we demonstrate that the fundamental finding is not stable when trying to replace the gender equality index introduced by the authors and discuss [last part will be improved after completion of the results section and dicussion].

<!-- 
Finally, we conclude with the discussion on the gender equality indexes and the importance of accessing its measure on a global level to provide a proof for theories. 
-->

# 2. Results

## Gender differences on economic preferences: replication
Obtain from dataset and compare with the original study
First equation to illustrate the procedure of extraction of the economic preferences
## Relation between gender differences, economic development and gender equality
Here about correlation and the interpretation of the result
Also we provide equation 2
## On joint gender equality,other indexes and related problematics
Diagram, information on other indexes
## Coniditonal analysis of gender difference and thier relation to economic development and gender equality
Here we provide analysis on PCA-gender differences and singe gender preferences

## A composed Gender Equality Index and related problematics

The authors in the original article composed a joint measure of gender equality that they denoted as Gender Equality Index (GEI). To reveal its actual structure, we visualized its composition using a diagram shown in Figure 1. Four indicators were used to compose this joint measure by employing Principle Component Analysis and taking the first component as a proxy of gender equality. Two of them are indexes officially approved by international organizations, the Global Gender Gap from the [World Economic Forum Global Gender Gap Report 2015](http://reports.weforum.org/), and the Gender Inequality Index from the UNDP [Human Development Report 2015](http://hdr.undp.org/sites/default/files/hdr_2016_statistical_annex.pdf); one widely used measurable, the [ratio of female and male labor force participation](http://data.worldbank.org/indicator/SL.TLF.CACT.FM.ZS), taken from the World Bank database; and lastly, a measurable newly constructed by the authors, the time since women suffrage, taken from the [Inter-Parliamentary Union Website](http://www.ipu.org/wmn-e/suffrage.htm#Note1), presumably to track long-term influences of the guaranteed right to vote as a proxy of gender equality. The WEF Global Gender Gap has a total of fourteen sub-indexes, grouped and weighted into four categories: economic participation and opportunity, political empowerment, educational attainment, and health and survival. The UNDP Gender Inequality Index follows a similar logic to cover the same categories describing different aspects of the human life, but using only five sub-indexes in total, that are two for health and reproduction-related issues, and three others for the remaining categories. 

![Gender Equality Index decomposed in its sub-indexes.](figures/GenderEqualityIndex.pdf)

<!--
Similar plots for other indexes are kindly requested importnatly for GDI and WEF
-->

The UNDP Gender Inequality Index has been criticized by several authors [@SK; @AS; @Permanyer]. This index is said to be very highly related to the economic development, as it includes reproductive health indicators that can penalize less-developed countries, and it has a "inexistent" measure of welfare loss of inequality, because it is based on a calculated gender equality measure that is reported nowhere. One of the coefficients that has a highest priority (~30% of the sub-index) in calculation of the economic participation and opportunity, called "wage equality between men and women for similar work" -- indicating how much women receive with respect to men for the same work -- is based on a best experts' guess, not corrected on the difference in occupation [@halkos2021economies]. 

The power and limitation of WEF Global Gender Gap index remains mostly undiscussed in the academic literature, with a few exceptions [@Nicaragua; @10.1080/13545701.2010.530607]. The index is thought to be the least dependent to the economic development of a country, since it measures the gap between male and female access to resources and opportunities [@WEF_report].

<!--
Here the part about suffrage:
Worthy to mention also the question about the connection between the suffrage and race, that for many countries is strongly connected [@Yang; @NBERw20864]. has always a positive effect and its magnitude is not always proportional to the time since women suffrage was established, and the magnitude of this effect is proportional to the time since women suffrage.  Even after the right to vote was granted, discriminating laws may still be in presence, and the alignment of law together with executive branch of the government and elimination of discrimination takes more time -- for example, despite to the right to vote, the right to work can be suppressed for several decades. 
-->

Furthermore, the "time since women suffrage" index was introduced by authors to track long-lasting effects of the right to vote. This is based on the assumption that during the course of the time development has always a positive effect and its magnitude is proportional to the time since women suffrage was established, and the magnitude of this effect is proportional to the time since women suffrage. It can be argued that, even after the right to vote, many discriminating laws were still in presence, and the alignment of law together with executive branch of the government and elimination of discrimination takes more time -- for example, despite to the right to vote, the right to work can be suppressed for several decades. This assumption that suffrage played a long lasting effect on the balance in gender equality sounds reasonable but requires further investigation to be used as a robust estimator. Worthy to mention also the question about suffrage and race, that for many countries is strongly connected [@Yang; @NBERw20864].

<!--
Times since women suffrage is custered!
-->

The question why such joint Gender Equality Index is better or at least not worse than the widely used indexes such as WEF and UNDP GII was unanswered in the original article. As one can see in Figure. 1, the components of the joint Gender Equality Index used in the original study contains repetitions. The two indexes from WEF and UNDP share three sub-indexes, here indicated with different colors: ratio of female and male labor force participation (yellow), share of seats in parliament (green) and enrollment into secondary education (blue). As a third variable to construct a joint Gender Equality Index, the authors used the ratio of female and male labor force participation, already included into the previous two indexes. It is true that PCA technique permits to aggregate the indexes even in presence of high correlations between them [REF --> *Isn't it obvious from the techniques itself?*]. However, in the present case, such a procedure leads to the imbalance and prioritization of these specific repetitive indexes (especially female and male labor force participation) over other factors, that were already balanced in the design of WEF and UNDP GII indexes. 

<!--Furthermore, the "time since women suffrage" index was introduced by the authors to track long-lasting effects of the right to vote on gender equality, yet without any supporting information. The assumption that suffrage played a long-lasting effect on the balance in gender equality sounds reasonable but requires further investigation to be used as a robust estimator. 
-->


Based on the identified methodological flaws and absence of validation and justification, we doubt the possibility to use Gender Equality Index as a reliable proxy for gender equality. Therefore, we will use GEI only to match the replication with the original analysis. The new analysis will use only established WEF GGG Index and the UNDP GII, in their relationship to the gender differences in economic preferences and the economic development.

Along with WEF GGG Index and UNDP GGI, other indexes exist, such as the [Gender Development Index](http://hdr.undp.org/en/indicators/137906), that was discussed in @SK and recently introduced in the UNDP report. It captures three dimensions in terms of health, knowledge and living standards, separately for male and female (as it is defined as the ratio of the Human Development Index for female divided by the male one). The life expectancy, expected years of schooling and mean years of schooling, and GNI per capita are calculated within these dimensions. We include this index in the analysis in the next section too.

<!--
GNI is used in Falk, plus we need to discuss this index somewhere
-->

## Extended analysis

Before showing the results of the extended analysis, we briefly describe the methodology of the original article and provide information on the pure replication, with the identification of found discrepancies. 

To conduct the replication, we requested the Gallup World Poll data. The full dataset is under restricted access: education level and household income quintile on the individual level of the participants is not available in the open access version (for more information see Appendix, Section 2, "Data Collection, Cleaning, and Standardization"). As the [@FH] article addresses the gender differences, the main focus is on that individual variables provided in the dataset (education level, income quintile, age, and subjective math skills) are taken as control variables, meaning that the presence of these may not affect the result of the correlation [@FH_SM]. Therefore in the replication study, for each country, a linear model is created using the equation:

$p_i = \beta_1^c female_i + \beta_2^c age_i + \beta_3^c age^2_i + \beta_4^c subjective \ math \ skills_i + \epsilon_i$

This results in 6 models -- one for each preference measure, $p_i$ -- having intercept and 4 coefficients, each of them being related to the variable in the formula above. The coefficient for the dummy variable "female", $\beta_1^c$, is used as a measure of the country-level gender difference. Therefore, in total, we have 6 coefficients that represent the preference differences related to the gender for 76 countries. To summarise the gender differences among the six economic preferences, a principal component analysis (PCA) is performed on the gender coefficients from the linear models. The PCA is a dimensionality-reduction technique which allows to “reshape” the 6 coefficients into other mixed components that maximizes the variance. The first component of the PCA has then been used as a summary index of average gender differences in preferences, in a similar fashion as for the Gender Equality Index described in the previous paragraph.

In addition to this, we questioned the normality of the input data and therefore of the robustness of the linear regression performed above. One way to address the problem of the long tails resulting in non-normally distributed residuals can be to choose a model with less restrictive assumptions, for instance the robust linear regression.  Thus, in the extended analysis, the models for each countries were created by using the robust linear regression, and same substitution happens for every model created using linear regression.

The correlation between economic development expressed in Log GDP and gender equality indexes in the countries is very strong (see Fig. 2) and one can be used as a rather good estimator of another. Because of this fact, the presence of strong correlation between gender differences in preference(s) and gender equality indexes is expected if only two variables are considered in the regression. To study the effect of both GDP p/c and gender equality at the same time, one should incorporate all three variables into the multiple linear regression with both factors as explanatory variables, like:

$avgGenderDiff_{country} = \alpha + \beta_1 \ logGDPpc_{country} + \beta_2 \ genderEquality_{country}$

Alternatively, to separate the contribution of the gender differences regressed on economic development, one can perform a regression conditioning on the gender quality indicators (WEF GGG Index, UNDP GII and Gender Development Index), and then conditioning on economic development (Log GDP p/c). The theorem from Frisch–Waugh–Lovell [@10.2307/1907330; @Lovell] guarantees that the coefficients found from this conditional analysis are the same as the ones found for a regression of the gender differences on both economic development and gender equality index of the countries. 

![Correlation between gender equality indicators and economic development by country.](figures/corr_equality_economicdev.pdf)

In Table 1, we compare the results obtained from our replication analysis (meaning, using the OLS method as in the original article) and the extended analysis (substituting the OLS with the robust linear regression) to the results found in @FH, Fig. 2A-F. 


Table: Comparison of the conditional analysis results for original, replicated and extended study . Reported are the **slopes** of the linear regressions and the corresponding p-value. Significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

|Variable | Residualized on | Original | Replication | Extended |
--- | --- | --- | --- | -- | 
|Log GDP p/c | Gender Equality Index | 0.5258***  | 0.5003*** | 0.4862*** |
|Gender Equality Index | Log GDP p/c | 0.3192**  | 0.3358*** | 0.3432** |
|WEF Global Gender Gap | Log GDP p/c | 0.2327**  | 0.2234* | 0.2106* |
|UN Gender Equality Index | Log GDP p/c | 0.2911  | 0.3180 | 0.3017 | 
|F/M in Labor Force Participation | Log GDP p/c | 0.2453*  | 0.2206* | 0.2034* |
|Years since Women Suffrage | Log GDP p/c | 0.2988**  | 0.1879* | 0.1929* |


Most of the time, we find very similar slope coefficient and statistical significance between the variables of our study (both replicated and extended) and the results from the original study, with only two exceptions: One is related to the indicator "WEF Global Gender Gap", and the other to the "Years since women suffrage". Regarding the last one, the differences can be explained by the imputation of the data used. The dataset from which this indicator is coming from, as a matter of fact, can be interpreted non unanimously (see the paragraph "Gender Equality Index" in the Appendix and discussion sections) and we can't draw any conclusion from it. The difference with the WEF Global Gender Gap is instead pretty mysterious, since the data were taken from the same source and no substantial change is supposed to affect it. *NOTE: I still have no clue how to conclude this sentence properly.*

<!-- We can add our attemnt for data extraction. I will need to repeat it for . We should also discuss/show the differences in the results.
-->

Reassured by the similarity of the results of our replication, we proceed to explore the correlation of the summarised gender differences to the economic development, when conditioned on the gender equality indicators indicated in the paragraph before as adequate (WEF GGG Index, UNDP GII, and GDI), the correlation of the summarised gender differences to the single gender indicators, when conditioned on economic development, and then the same but for single preferences.

In Fig. 3, we summarise the results of the conditional analysis for the three main indicators that were further analysed, that are WEF GGG Index, UNDP GII and GDI. The gender differences are strongly and statistically significantly correlated with the economic development when the conditional analysis is performed on the single gender equality indicators, thus indicating that the economic development of a country seems to play a key role in the measured gender differences in the economic preferences. On the contrary, the correlation of the gender differences to the gender equality indexes of the country, conditioned on the economic development is only statistically significant for WEF GGG Index conditioned on Log GDP p/c (p-value = 0.0241), while for UNDP GII and GDI the correlation is not statistically significant. 

![On the top line, gender differences are regressed on the economic development conditioned on gender equality, for the different indicators (WEF GGG Index, UNDP GGI, and Gender Development Index). On the bottom line, the corresponding values of gender differences regressed on the gender equality indicator conditioned on economic development.](figures/conditional_analysis_all_extended.pdf)  


To investigate the role of economic development and gender equality on single preferences, we performed the same analysis but without PCA-aggregating preferences into a single measure. As one can see in Table 2, alongside with the results of aggregated gender differences, the economic development still has in most cases a strong correlation to the single preferences when conditioned on the gender equality of the country. The only exception is the UNDP GII indicator, that showed a very strong correlation to the economic development. *How to conclude this? It is an exception and we can't ignore it*


Table: **Gender differences in economic preferences ralated to Log GDP p/c conditional on the gender equality indicators**, regressed on each single economic preference gender difference coefficient. Reported are the correlation terms and their significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

| Variable |  WEF (Extended) | UNDP (Extended) | GDI (Extended) |
 --- | --- | --- | --- |
| Trust                | 0.5174*** | 0.1930 | 0.5045*** | 
| Altruism             | 0.5255*** | 0.3527*** | 0.4477***  | 
| Positive Reciprocity | 0.2898*   | 0.2054 | 0.1870 | 
| Negative Reciprocity | 0.3974** | 0.0706 | 0.3858*** | 
| Risk Taking          | 0.3469** | 0.0262 | 0.3199** |
| Patience             | 0.3742** | 0.1046 | 0.3337**  |


Lastly, Table 3 summarizes the results of the regression of the gender differences in single economic preferences with relation to gender equality indexes conditioned on economic development. No statistically significant correlations were observed for all gender equality indexes and preferences except the single case of WEF index -Altruism combination and of the UNDP index -Risk Taking, when controlling for the economic development. Thus, no reliable association between the gender differences in economic preferences and gender equality indexes is found.

<!-- [does the PC1 contains mostly Altruism, so we see correlation when conditional on WEF  or there is a particular combination of other indexes that drives correlation? what is the structure of correlation and influential points for altruism? We should check this and other cases out.] -->

Table: **Gender differences in economic preferences ralated to gender equality indicators, conditional on Log GDP p/c**, regressed on each single economic preference gender difference coefficient. Reported are the correlation terms and their significance levels: $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).

| Variable  |  WEF (Extended) | UNDP (Extended) | GDI (Extended) |
 --- | --- | --- | --- |
| Trust                | 0.1325 | 0.2160 | 0.0794 |
| Altruism             | 0.3561** | -0.0421  | 0.1021 |
| Positive Reciprocity | 0.0396 | -0.0402 | 0.1978 |
| Negative Reciprocity | 0.1680 | 0.1742 | -0.1033 |
| Risk Taking          | 0.0349 | 0.2192* |  -0.0261 |
| Patience             | 0.2312 | 0.1705| 0.0812 |

# 3. Discussion and conclusions

<!--
Link to effect sizes in econometrics and social sciences
-->

In the present article, we replicated the results of the work by Falk&Hermle [@FH] that related gender differences in economic preferences to economic development
and gender equality. The main finding of the original article can be summarized as follows. The authors used Gallup World Poll 2012 and linked Global Preference Survey datasets to measure the gender differences in economic preferences across 76 counties. A joint index summarizing the differences in all six preferences was used. The authors used Log GDP p/c as a proxy of economic development, while for gender equality, several indexes were introduced, including the ones previously used or discussed in the literature, besides a combined joint measure for gender equality was constructed. As the main result of the study, the authors reported a large and statistically significant association of gender differences with Log GDP p/c (r = 0.67, P < 0.0001) and the joint gender equality index (r = 0.56, P < 0.0001), as it was reflected as the main finding in the *Research article summary* and graphical abstract. The authors also conducted a conditional analysis to isolate the impact of economic development and the joint gender equality index. The association was found of smaller magnitude but still rather strong and statistically significant (r = 0.53, P < 0.0001) when gender differences were related to Log GDP p/c conditioned on joint gender equality index and moderate and statistically significant (r = 0.32, P = 0.003) when relating with joint gender equality index and conditioning on Log GDP p/c. The authors concluded that the evidence indicates that higher levels of economic development and gender equality favor the manifestation of gender differences in preferences across countries, *highlighting the critical role of availability of material and social resources, as well as gender-equal access to these resources, in facilitating the independent formation and expression of gender-specific preferences.*

Given the importance of these findings and their impact, and the impressive size and complexity of the entire analysis, it is of high value to conduct a detailed reconstruction of the methodology and analysis, checking the robustness of assumptions and inferences. As the first milestone, we conducted a pure replication obtaining the gender differences in economic preferences from the Gallup World Poll 2012 and Global Preference Survey dataset, using the same methodology as the authors. Unfortunately, the datasets are publicly available only in preprocessed (qualitative and quantitative items of the questionary were already mixed and standardized) and, alas, in a partially restricted form (two control variables are missing). It, to some extent, hampered the replication's comparison with the original findings. Nevertheless, the extracted gender differences were close to the ones from the original article. In addition, we ran the same analysis using robust regression instead of ordinary linear regression as the data revealed signs of non-normality and outliers: no significant changes in the distribution of gender differences in economic preferences were observed.  

As the next step, we investigated the indexes used to estimate economic development and gender equality and their relation. First, we reveal a very strong association between Log GDP p/c and joint gender equality index (r = , P < ) and indexes approved by international organizations such as WEF, UNDP and GDI (r = , P < ; r = , P < ; r = , P < , respectively). This association was previously highlighted by other authors [REFs] but did not receive attention in the original manuscript. In the light of this strong relation and correlation between gender differences and Log GDP p/c reported by authors, the second main reported finding of strong and statistically significant association of gender differences with joint gender equality index became trivial as Log GDP p/c is a good predictor for gender equality indexes and vise versa. Only the conditional regression with control on Log GDP p/c may uncover the separate role of gender equality on gender differences. 

Further, throughout the replication, we analyzed the joint gender equality index composition composed by authors and investigated its single components. Several methodological flaws were identified, questioning the validity of this procedure. The joint gender equality indicator was composed of four other indicators, two widely used WEF and UNDP indicators (which in turn are built from 14 and 5 subindicators, respectively), the ratio of female-to-male labor force participation, and also constructed a new type of the indicator "times since women suffrage".

Our analysis revealed that both WEF and UNDP already contain the ratio of female-to-male labor force participation and share subindicators related to the share seats in parliament and secondary education. The additional use of the female-to-male labor force participation as a third component of the joint gender equality index remains unclear, as it prioritizes this factor over all other factors included in indexes that lead to their disbalance. In addition, the index constructed by authors by standardization of the years since women's suffrage lacks justification and validation. Based on these findings and the absence of clear procedures in the original article, we concluded that there is no evidence that the joint equality measure performs no worse than existing indexes and is free of biases due to the inclusion of unvalidated indexes such as "time since women suffrage." 
We agrue that the use of *ad hoc* unvalidated indicators such as joint gender equality index in gender equality studies leads to virtually no possibility to compare the resutls of such studies with other research in doimain conducted on global and local scales. Thus, in further analysis, we focused on the existing and widely accepted measures of gender equality.  

The gender equality indexes such as WEF, UNDP, and GDI themself have certain limitations and were discussed by several authors [@SK; @Permanyer; @KPS; @AS; @Nicaragua; @10.1080/13545701.2010.530607], though the literature that debates the power and limitations of one of the most developed indexes WEF is very sparse and limited, and the most of the relevant information can be found only in the regular reports of the authors of the index itself. Despite possible drawbacks, these indexes are the best estimates for the state of gender equality on a global scale in a regular, standardized, and systematic way. We proceeded with examining the gender differences in their relation to economic development and gender equality using these indexes and conditional analysis.

We found a large and statistically significant association of gender equality preferences with economic development conditioning on WEF and GDI (r = 0.6253, P < 0.0001 and r = 0.6612 , P < 0.0001, respectively), while for UNDP the association was somewhat smaller and with a larger p-value (r = 0.4190, P = 0.0194). Conditioning on economic development showed no correlation for UNDP and GDI indexes. While, for WEF the correlation was moderate with a mild statistical significance (r = 0.21, P = 0.024). We further analyzed how single-gender differences are related to economic development and gender equality. Along with the previous analysis, large and statistically significant associations were demonstrated only when we related gender differences with Log GDP p/c conditioning on WEF and GDI. Interestingly, no preferences except Altruism demonstrated any relation with Log GDP p/c when conditioning on UNDP. Among six economic preferences and three gender equality indexes, no statistically significant association between economic preferences and Log GDP conditioning on the gender equality index was found, except for Altruism (r = 0.3561; P ) conditioning on WEF and Risk-Taking (r = 0.2192; P ) when conditioning on UNDP, demonstrating little support of the presence of association of single-gender differences in economic preferences and gender equality. 

Given these results of the reproduction analysis, we conclude that the evidence is not sufficient to support an association between economic preferences and the level of gender equality. The regression of the economic preferences on the gender equality index should not be used as an actual measure of association due to its high correlation with economic development. Instead, the coefficient from conditional analysis should be adapted for this measure. As suggested by our conditional analysis, if a mild association between gender differences and gender equality exists for some preferences (such as Altruism and Rink-Taking), the magnitude of the correlation coefficient is at-least two-fold smaller than the association of gender differences and the economic development conditioning on gender equality indexes.


<!--

The question about the origin of the gender differences remains open, alnog with the question of why the difference in economic preferences exist across countires for the entier populations.  

Market and capital distribution, historical measures of GE, distribution of part time job, balance of power within hierachical structes and availiblility of resources, underline the important of the studies on country level. 
As an outlook, WEF index is one of the most advanced indexes up to date. Educational and Health gap is almost closed in most of the countries while the gaps in Economical and Political domains are straking even in countries with the most progressive polisies on gender equality. WEF is very sensetive to the acute changes in socio-political and economical situation, while severally penalizing the countries with descriminative politics (see Figure ). Rvanda, Finland, Sweden. Causal inference. Sensitivity to the points and country inclusion. More countries implement measures (likely from the countires that are grouped as), increasing score and going out of GFP driven trend. In turn, economical preferences stay the same, but the actual correlation will increase. The data alone, without the detailed analysis it is vertually impossible to tell the direction of causality if any exists with regard to differences in economic preferences and gender equality.  
-->


<!--

 The ratio of female and male labor force participation counts as the overall labor participation rate, and thus, once approaching 100% as a characteristic of developed countries [@tasseven2017relationship], the gender gap is automatically reduced [this is not true, check the U-shape curve]. This measure does not take into account on the part-time jobs occupation as in case of the reduction , including involuntary part time job occupation in developed countries [@pech2021part; @rosenfeld1990cross]. [this sentenses wants to go to discussion] "part time jobs and gender gap"; The gap in involuntary part-time.


Moreover, since a strong correlation has been found between each of the indicators used (including the Gender Equality Index built by the original authors), we focused on the gender differences regressed on economic development conditioned on each of the gender equality indicators, and vice-versa, to extract the correlation of the differences depurated of the confounding terms of economic development and gender equality of the countries.

 While the use of the new dataset is due to our critics to the construction of the original authors Gender Equality Index, supported by a vast literature on an ideal gender equality indicator [@SK; @Permanyer; @KPS; @AS; @Nicaragua; @10.1080/13545701.2010.530607], 

We prove that, using a different indicator for the gender inequality in different countries, the results found by @FH are less straightforward. To summarise the main findings on this regard:

- The summarised gender differences shows a positive, strong and statistically significant dependence to the economic development of a country, when conditioned on the corresponding gender equality;

- The summarised gender differences shows a positive weak correlation to the gender equality of a country, when conditioned on their economic development. The result is not statistically significant for UNDP GII and GDI, and it is significant at the 5% level (p-value = 0.0241) for the WEF GGG Index.

- The results for the single preferences regressed on economic development, conditioned on gender equality, are far from being clear: All the preferences, except for "altruism", show different behavior and different statistical significance, while "positive reciprocity" seems to be the variable with the least correlation, according to all the indicators. The results produced conditioning on WEF and on GDI seem to be more in agreement among themselves. To be noticed, however, the very strong correlation of UNDP GII and economic development, that might be the cause for such a weak association of the preferences to the economic development, when regressed on it.

- The results for the single preferences regressed on the gender equality, conditioned on the economic development, are all in agreement with each others, displaying weak to no correlation, and no statistical significance. The only two exceptions are for the preference "altruism" that shows a positive, moderate and statistically significant (p-value = 0.006) correlation with the WEF GGG Index, in disagreement with the UNDP GII and the GDI; and the preference "risk taking" showing a positive, weak, and statistically significant at 5% level correlation with the UNDP GII, also this in disagreement with the other two indixes.

Looking at these results, we can deduce that, for countries having the same gender development, the gender differences are depending from the economic development of the country, meaning that richer countries have more gender differences than poorer countries, gender development being equal. On the other hand, for countries having the same economic development, the gender differences are independent from the gender development of the country, meaning that there are no gender differences arising from countries having same economics but different gender development.

From this, one could therefore assume that the economic development is the country-level indicator associated with higher changes in gender differences, rather than the gender development of a country. From such a simple analysis is therefore not possible to extract any information regarding the reason for higher gender differences in more economically developed countries. We can only see that, for countries with similar economics, those differences don't exist regardless of how gender developed that countries are. The reason behind the differences might be related to purely economical conditions, that would also make sense since the gender differences here studied are "economical preferences". Can it be that the differences arise where the economic is more developed because of marketing reasons? After all, all the economics here analysed are based on capitalistic systems, meaning that the bigger the economic, the bigger the market. It is an interesting hypothesis that would require further analysis. 
-->

# References

