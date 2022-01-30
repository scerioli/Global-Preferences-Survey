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
  This study attempts to replicate and extend the results of the article of @FH measuring the gender differences economic preferences relating them to economic development and to gender equality of the countries. In the original paper, the authors use data from the Gallup World Poll 2012, which included a Global Preference Survey conducted on almost 80000 people in 76 countries all around the world. The dataset covers almost 90% of the world population representation, with each country having around 1000 participants answering questions related to their time preference (patience), altruism, will of risk taking, negative and positive reciprocity, and trust. The dataset is available in its integrity only with a license to be paid. The free version has only partial data that can also be used for this purpose because, according to the study, the gender differences can be studied also only taking in consideration a smaller number of predictors (according to the supplementary material, see [@FH_SM]). In this replication study, therefore, we use only a subset of predictors that are made publicly available to check whether the results can still be reproduced and are consistent. The outcome of the replication is that we see similar results as the ones obtained by the original authors for the relationship of gender differences and the economic development, but with differences (some times minor, some times significantly large) regarding the gender equality, especially when comparing the results of the single indexes building the general Gender Equality Index. Beyond the replication, we have extended the analysis using a robust linear regression instead of the OLS used by the authors, finding that the results are not robust under this change of model. Moreover, using a different measurement for the gender equality of the countries, the Gender Development Index from the UN Human Development reports, the correlation between gender differences and Gender Development of the country disappears, when a conditional analysis on the Economic Development is performed.
---

**JEL:**  D010 - Microeconomic Behavior: Underlying Principles, D630 - Equity, Justice, Inequality, and Other Normative Criteria and Measurement, D810 - Criteria for Decision-Making under Risk and Uncertainty, D910 - Micro-Based Behavioral Economics: Role and Effects of Psychological, Emotional, Social, and Cognitive Factors on Decision Making, F000 International Economics: General

**Keywords:** replication study, gender differences, economic preferences

**Data availability:** The code used for this analysis (replication and extended) can be found on GitHub at https://github.com/scerioli/Global-Preferences-Survey


# 1. Introduction

Gender differences concerning the economic behaviors, such as happiness [@SPSU], competition [@CG; @GLL; @KPS], or work preferences [@BG] have been studied in sociology, psychology and economics for many decades. Any scientific knowledge about gender differences and their relation to gender inequality is used nowadays as arguments and counter-arguments for decision and policy-making. Gender-related issues such as gender inequality are becoming an integral part of the agenda for many public and private institutions and organizations. Therefore, it is essential for the stakeholders to reveal, estimate, monitor, and prevent gender inequalities on individual, group and country levels. 

The study of gender differences on a world scale per se is challenging. One of the challenges that hampers the progress is the lack of large and heterogeneous datasets across different social groups and countries. The Gallup World Poll 2012 included a Global Preference Survey conducted on almost 80000 people in 76 countries all around the world that aimed to fill this gap: Covering nearly 90% of the world population representation, with each country having around 1000 participants answering questions related to their time preference (patience), altruism, will of risk-taking, negative and positive reciprocity, and trust. The dataset provides a unique insight into the economic preferences of a heterogeneous number of people. 

The original study published in the Quarterly Journal of Economics [@QJE_Falk] focused on more general questions about the economic preferences distributions in different countries, trying to explore several covariates from the Gallup World Poll. While, the subsequent article [@FH], replicated in this work, focused explicitly on the gender differences arising from the previous study and reported the evidence for the relationship between gender differences in economic preferences, economic development, and gender equality across many countries. The authors propose two hypotheses to be tested: The first one is that the gender differences will decrease for more economically developed and gender-equal countries, because social roles related to gender are attenuated. The second hypothesis is that, on the contrary, for more economically developed and gender-equal countries, the gender differences will increase because the gender-neutral goal of subsistence is removed and thus people can pursue their real preferences. The data reveals a positive correlation of gender differences in preferences with GDP p/c and with the gender equality of the countries, thus favoring the hypothesis that predicts the increase of the differences as women and men obtain sufficient access to the resources to develop and express their intrinsic preferences independently.

Throughout the study, the authors construct and use a joint measure of gender equality of different countries, coming from different sources (see also the Appendix), providing little to no discussion about the reason in doing so. This is seen as a critical point, since some of the indicators used, such as WEF Global Gender Gap and UNDP Gender Inequality Index are far from being a complete representation of gender inequality, and were heavily criticized by several authors [@SK; @AS; @Permanyer]. 

In this work, we first analyse the gender equality index that was used by the original authors and the sub-indexes involved into the study, highlighting its problematic. Second, we conduct a pure replication of the article in R language, challenged by the fact that most of the data were either not available anymore, or could not be provided for free (see Appendix, Section 2, "Data Collection, Cleaning, and Standardization"). Third, we extended the original article using a robust linear regression to address the non-normality of the data. Fourth, we demonstrate that the fundamental finding is not stable when trying to replace the gender equality index introduced by the authors with the Gender Development index proposed by @SK and recently introduced by the UNDP. 

<!-- Finally, we conclude with the discussion on the gender equality indexes and the importance of accessing its measure on a global level to provide a proof for theories. -->


# 2. Results

## A composed Gender equality Index and related problematics

The authors in the original article compose a joint measure of gender equality that they denoted as Gender Equality Index (GEI). We visualized its composition using a diagram shown in Figure 1. Four measurables were used to compose this joint measure: Two of them are indexes officially approved by world organizations, the Global Gender Gap from the [World Economic Forum Global Gender Gap Report 2015](http://reports.weforum.org/), and the Gender Inequality Index from the UNDP [Human Development Report 2015](http://hdr.undp.org/sites/default/files/hdr_2016_statistical_annex.pdf); one widely used measurable, the [ratio of female and male labor force participation](http://data.worldbank.org/indicator/SL.TLF.CACT.FM.ZS), taken from the World Bank database; and lastly, a measurable newly constructed by the authors, the time since woman suffrage, taken from the [Inter-Parliamentary Union Website](http://www.ipu.org/wmn-e/suffrage.htm#Note1), presumably to track low-term influences of the guaranteed right to vote as a proxy of gender equality. The WEF Global Gender Gap has a total of fourteen sub-indexes, grouped and weighted into four categories: economic participation and opportunity, political empowerment, educational attainment, health and survival. UNDP Gender Inequality Index follows a similar logic to cover the same categories describing different aspects of the human life, but using only five sub-indexes in total, that are two for health and reproduction-related issues, and three others for the remaining categories. 

![Gender Equality Index decomposed in its sub-indexes.](figures/GenderEqualityIndex.pdf)

<!--
Similar plots for other indexes are kindly requested importnatly for GDI and WEF
-->

Both indexes were criticized by several authors [@SK; @AS; @Permanyer]. To summarise some of the main critics to them: The Gender Inequality Index from the UNDP is said to be very highly related to the economic development, as it includes reproductive health indicators that can penalize less-developed countries, and it has a "inexistent" measure of welfare loss of inequality, because it is based on a calculated gender equality measure that is reported nowhere. One of the coefficients that has a highest priority (~30 % of the sub-index) in calculation of the economic participation and opportunity, "wage equality between men and women for similar work" sub-index (that indicates how much women receive more with respect to man for the same work) is a based on a best experts' guess, not corrected on the difference in occupation [@halkos2021economies]. 

The WEF Global Gender Gap has a total of fourteen sub-indexes (some of them being the same as for the UNDP GII) where a cap to 1 is applied for those countries where the ratio is higher than 1. This means that countries treating equally men and women are ranked the same as countries disfavoring men. TO DO: Literature about it!!

The ratio of female and male labor force participation counts as the overall labor participation rate, and thus, once approaching 100% as a characteristic of developed countries [@tasseven2017relationship], the gender gap is automatically reduced. This measure does not take into account on the part-time jobs occupation as in case of the reduction , including involuntary part time job occupation in developed countries [@pech2021part; @rosenfeld1990cross].

Lastly, the "time since women suffrage" index was introduced by authors to track long-lasting effects of the right to vote. This is based on the assumption that during the course of the time development has always a positive effect and its magnitude is proportional to the time since women suffrage was established. Moreover, it can be argued that, even after the right to vote, many discriminating laws were still in presence and the alignment of law together with executive branch of the government and elimination of discrimination -- for example, despite to the right to vote, the right to work can be suppressed for several decades. Worthy to mention also the question about suffrage and race, that are in many cases strongly connected [@Yang; @NBERw20864]. Thus, that the *assumption* that suffrage played a long lasting effect on the balance in gender equality sounds reasonable but requires further investigation to be used as a robust estimator.

Another important aspect is that the comparison of the four indexes used to build the Gender Equality Index shows many repetitions in the datasets used, as one can see in Figure. 1. For instance, the two indexes from WEF and UNDP share three sub-indexes here indicated with different colors: ratio of female and male labor force participation (yellow), share of seats in parliament (green) and enrollment into secondary education (blue). As a third variable to construct their Gender Equality Index, the authors also used the ratio of female and male labor force participation, already included into the previous two indexes. Such a procedure leads to the imbalance and prioritization of these indexes over other factors that needs to be justified. 

In conclusion, we argue that the Gender Equality Index is not a good indicator for the measure that the original authors wanted to provide, and so are the ratio of female and male labor force participation and the time since women suffrage. We will therefore show the next results only for the WEF GGG Index, the UNDP GII, and the newly introduced Gender Development Index to be analysed further in their relationship to the gender differences and the economic development.

<!--
"part time jobs and gender gap"; The gap in involuntary part-time.
-->

## Pure replication and extended analysis

Since the correlation between economic development and gender equality in the countries is not negligible (see Figure. 2), we can't ignore the effect of the one on the other (this sentence should be clarified!). To understand the effect of the gender differences regressed on economic development, first, we perform a regression conditioning on the gender quality indicators (WEF GGG Index, UNDP GII and Gender Development Index), and then conditioning on economic development (Log GDP p/c). The theorem from Frisch–Waugh–Lovell [@10.2307/1907330][@Lovell] guarantees us that the coefficients found from this conditional analysis are the same as the ones found for a regression of the gender differences on both economic development and gender equality index of the countries. 
<!-- According to the Frisch–Waugh–Lovell theorem, resY ~ resX1 and resY ~ resX2 are equivalent to the multilinear fit Y ~ X1 + X2 for the determination of individual coefficients.  -->

![Correlation between gender equality indicators and economic development by country.](figures/corr_equality_economicdev.pdf)

In Fig. 3, we summarise the results of the conditional analysis for the three main indicators that we want to further analyse. 


![On the top line, gender differences are regressed on the economic development conditioned on gender equality, for the different indicators (WEF GGG Index, UNDP GGI, and Gender Development Index). On the bottom line, the corresponding values of gender differences regressed on the gender equality indicator conditioned on economic development.](figures/conditional_analysis_all.pdf)

The gender differences are strongly and statistically significantly correlated with the economic development when the conditional analysis is performed on the single gender equality indicators, thus indicating that the economnic development of a country seems to play a key role in the measured gender differences in the economic preferences.

On the contrary, when checking for the correlation of the gender differences and the gender equality of the country, conditioned on the economic development, the results are not anymore so clear. The correlation is found to be weak for all the indicators, and the p-value is never smaller than the 5% level. In the Gender Development Index, one can affirm that no correlation is found at all, while for the case of the WEF GGG Index, there is a weak correlation with a p-value = 0.017.

When checking for the results on the single preferences, things are not getting clearer.

As one can see in Table 2, the economic development still has in most cases a strong correlation to the single preferences when regressed on the gender equality of the country. Here we report also the conditional analysis made using the Gender Equality Index of the original article (see also Fig. S5 in the @FH_SM) and of our replication, as a comparison.


| Variable  | GEI (Orig.)   | GEI (Repl.) |  WEF (Repl.) | UNDP (Repl.) | GDI (Repl.) |
 --- | --- | --- | --- | -- | --- |
| Trust | 0.4574*** | 0.4265*** |0.4953*** | 0.1777 | 0.4868*** | 
| Altruism | 0.4751*** | 0.4338*** | 0.5539*** | 0.3839*** | 0.4762***  | 
| Pos. Rec. | 0.2771* |0.2509* | 0.2948* | 0.1800 | 0.1820 | 
| Neg. Rec. |  0.2444*  |0.2111 | 0.3704** | 0.0427 | 0.3532** | 
| Risk Tak. | 0.2868* |0.2256 | 0.3485** | 0.0406 | 0.3213** |
| Patience | 0.2621* |0.2288* | 0.3684** | 0.1012 | 0.3049**  |

: **Log GDP p/c conditional on the gender equality indicators**, regressed on each single economic preference gender difference coefficient. Significance levels: $\le$ 0.0001 (\*\*\*\*), $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).


To further check that no correlation was found for the gender equality indicators when conditioned on economic development, we regressed the single preferences on them, and compared the results of the joint Gender Equality Index (of the original and the replicated analysis) and of the single indicators (WEF GGG Index, UNDP GI, and GDI), when regressed on Log GDP p/c (see Table 3).


| Variable  | GEI (Orig.)   | GEI (Repl.) |  WEF (Repl.) | UNDP (Repl.) | GDI (Repl.) |
 --- | --- | --- | --- | -- | --- |
| Trust | 0.2050 | 0.2472* | 0.1368 | 0.2204 | 0.0779 |
| Altruism | 0.3304** | 0.2696* | 0.3806*** | -0.0470  | 0.1523 |
| Pos. Rec. | -0.0115 | 0.0481 | 0.0272 | -0.0071 | 0.2002 |
| Neg. Rec. |  0.2788* | 0.2240* | 0.1570 | 0.1852 | -0.0769 |
| Risk Tak. | 0.1973 | 0.1863* | 0.0573 | 0.2057 |  -0.0137 |
| Patience | 0.2967* | 0.2841* | 0.2143 | 0.1633 | 0.1237 |

: **Gender equality indicators, conditional on Log GDP p/c**, regressed on each single economic preference gender difference coefficient.  Significance levels: $\le$ 0.0001 (\*\*\*\*), $\le$ 0.001 (\*\*\*), $\le$ 0.01 (\*\*), $\le$ 0.05 (\*).


Again, we see no statistically significant correlation between the gender differences in single economic preferences and the Gender Development Index, when controlling for the economic development. We find slightly larger correlation factor using the Gender Equality Index in our replication, but only one of them (corresponding to the "patience") is statistically significant below the 5% confidence level. Interestingly, the same small correlations can be seen in the original paper (Fig. S6, @FH_SM).


# 3. Discussion and conclusions

The original study indicates that higher economic development and higher gender equality are associated with an increase in the gender differences in preferences, and therefore rules out the social-role theory over the post-materialistic one: When more resources are available to both men and women, the expression of the gender specific preferences can be seen. 

Our analysis focuses on two main points: First, we aimed to replicate the results of the original article, in order to set the methodology and prove that the datasets, even if not being the same as the ones used by the original authors, can lead to the same results. Second, we extended the analysis by introducing a new gender equality indicator and by performing the analysis using a slightly different method than the OLS, the robust linear regression. While the use of the new dataset is due to our critics to the construction of the original authors Gender Equality Index, supported by a vast literature on an ideal gender equality indicator, the robust linear regression was supported by the diagnostic made on the data fitted by an OLS and the fact that this gave signs of non-normality in the data that could potentially influence in a much stronger way than wished the results of the linear fit.

Starting from the analysis of the Gender Equality Index built by the authors, we noticed some inconsistencies with the methods used in literature to build such indicators: For instance, the preference of simplicity over complexity to help policy-makers understand the indicator, and the avoidance of inclusion of too many - or too strong -- sub-indices that relates directly to the economic development of the country [@SK; @Permanyer; @KPS; @AS]. Thus, we decided to focus only on the most complete indicators that were already available in the original article (WEF Global Gender Gap Index and UNDP Gender Inequality Index), although criticised in literature, adding a new indicator following the suggestions of @SK (the Gender Development Index).

Moreover, since a strong correlation has been found between each of the indicators used (including the Gender Equality Index built by the original authors), we focused on the gender differences regressed on economic development conditioned on each of the gender equality indicators, and vice-versa, to extract the correlation of the differences depurated of the confounding terms of economic development and gender equality of the countries.

We prove that, using a different indicator for the gender inequality in different countries, the results found by @FH are less straightforward. To summarise the main findings on this regard:

- The summarised gender differences shows a positive, strong and statistically significant dependence to the economic development of a country, when conditioned on the corresponding gender equality;

- The summarised gender differences shows a positive weak correlation to the gender equality of a country, when conditioned on their economic development. The result is not statistically significant for UNDP GII and GDI, and it is significant at the 5% level (p-value = 0.0167) for the WEF GGG Index.

- The results for the single preferences regressed on economic development, conditioned on gender equality, are far from being clear: All the preferences, except for "altruism", show different behavior and different statistical significance, while "positive reciprocity" seems to be the variable with the least correlation, according to all the indicators. The results produced conditioning on WEF and on GDI seem to be more in agreement among themselves. To be noticed, however, the very strong correlation of UNDP GII and economic development, that might be the cause for such a weak association of the preferences to the economic development, when regressed on it.

- The results for the single preferences regressed on the gender equality, conditioned on the economic development, are all in agreement with each others, displaying weak to no correlation, and no statistical significance. The only exception is for the preference "altruism" that shows a positive, moderate and statistically significant (p-value = 0.001) correlation, in disagreement with the UNDP GII and the GDI.

Looking at these results, we can deduce that, for countries having the same gender development, the gender differences are depending from the economic development of the country, meaning that richer countries have more gender differences than poorer countries, gender development being equal. On the other hand, for countries having the same economic development, the gender differences are independent from the gender development of the country, meaning that there are no gender differences arising from countries having same economics but different gender development.

From this, one could therefore assume that the economic development is the country-level indicator associated with higher changes in gender differences, rather than the gender development of a country. From such a simple analysis is therefore not possible to extract any information regarding the reason for higher gender differences in more economically developed countries. We can only see that, for countries with similar economics, those differences don't exist regardless of how gender developed that countries are. The reason behind the differences might be related to purely economical conditions, that would also make sense since the gender differences here studied are "economical preferences". Can it be that the differences arise where the economic is more developed because of marketing reasons? After all, all the economics here analysed are based on capitalistic systems, meaning that the bigger the economic, the bigger the market. It is an interesting hypothesis that would require further analysis. 


# References

