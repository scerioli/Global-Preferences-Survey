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

Gender differences concerning the economic behaviors, such as happiness [@SPSU], competition [@CG; @GLL; @KPS], or work preferences [@BG] have been studied in sociology, psychology and economics for many decades. Any scientific knowledge about gender differences and their relation to gender inequality is used nowadays as arguments and counter-arguments for decision and policy-making. Yet, despite the research effort and large body of literature on the topic [REFs], the theoretical understanding of these relations is far from complete. 

Gender-related issues such as gender inequality are becoming an integral part of the agenda for many public and private institutions and organizations. Therefore, it is essential for the stakeholders to reveal, estimate, monitor, and prevent gender inequalities on individual, group and country levels. 

The study of gender differences on a world scale per se is challenging. One of the challenges that hampers the progress is the lack of large and heterogeneous datasets across different social groups and countries. The Gallup World Poll 2012 included a Global Preference Survey conducted on almost 80000 people in 76 countries all around the world that aimed to fill this gap: Covering nearly 90% of the world population representation, with each country having around 1000 participants answering questions related to their time preference (patience), altruism, will of risk-taking, negative and positive reciprocity, and trust. The dataset provides a unique insight into the economic preferences of a heterogeneous number of people. 

The original study published in the Quarterly Journal of Economics [@QJE_Falk, 133 (4) pp. 1645-1692] focused on more general questions about the economic preferences distributions in different countries, trying to explore several covariates from the Gallup World Poll. While, the subsequent article [@FH], replicated in this work, focused explicitly on the gender differences arising from the previous study and reported the evidence for the relationship between gender differences in economic preferences, economic development, and gender equality across many countries. The authors propose two hypotheses to be tested: The first one is that the gender differences will decrease for more economically developed and gender-equal countries, because social roles related to gender are attenuated. The second hypothesis is that, on the contrary, for more economically developed and gender-equal countries, the gender differences will increase because the gender-neutral goal of subsistence is removed and thus people can pursue their real preferences.

The data reveals a positive correlation of gender differences in preferences with GDP p/c and with the gender equality of the countries, thus favoring the hypothesis that predicts the increase of the differences as women and men obtain sufficient access to the resources to develop and express their intrinsic preferences independently.

Our analysis starts with questioning the fact that, throughout the study, the authors construct and use a joint measure of gender equality of different countries, coming from different sources (see also the Supplementary Material), providing little to no discussion about the reason in doing so. This is seen as a critical point, since some of the indicators used, such as WEF Global Gender Gap and UNDP Gender Inequality Index are far from being a complete representation of gender inequality, and were heavily criticized by many authors [@SK; @AS; @Permanyer]. To summarise some of the main critics to them: The Gender Inequality Index from the UNDP is very highly related to the economic development, as it includes reproductive health indicators that can penalize less-developed countries, and it has a "inexistent" measure of welfare loss of inequality, because it is based on a calculated gender equality measure that is reported nowhere. The WEF Global Gender Gap has a total of fourteen sub-indexes (some of them being the same as for the UNDP GII) where a cap to 1 is applied for those countries where the ratio is higher than 1. This means that countries treating equally men and women are ranked the same as countries disfavoring men. 

In this work, we first replicated the article analysis step by step, challenged by the fact that most of the data were either not available anymore, or could not be provided for free (see Supplementary Material, Section 2, "Data Collection, Cleaning, and Standardization"). We found similar results to the original article, even though some differences have been found of which the source is not clearly understood. 

We then extended the replication with two different approaches:

1. We questioned the normality of the data and thus, after a check on the individual-level data, we applied a robust linear regression instead of the OLS used by the original authors;

2. We questioned the gender equality indicator(s) used in the original article and proposed a different one, the Gender Development Index, proposed by @SK in his research and recently introduced by the UNDP. This index is simply the ratio of the Human Development Index calculated for female divided by the one calculated for male. We added the analysis of this index in the same way as we analysed the other singular indexes.


[How PCA correlates with other components? Table for components? Plot PCA?  PC1 explained variance 0.4, "Tools for Composite Indicators Building ", "Handbook on Constructing Composite Indicators". Check linearity. "The Use of Discrete Data in PCA: Theory, Simulations, and Applications to Socioeconomic Indices". PCA on descrete data, PCA ordinal data]
[What are the first and the second component?]
[One of the integral components of the WEF index is the ratio of avarage income for man and women. [check 40000 $]. Another indicator "fairness of the salary" is not a subjective assessment from the World Economic Forum from the executives. Information summary on time since women suffrage: the table does not contain links on the related sources.]


# 2. Replication study and extended analysis

Comparing the results of our analysis to the one from the original paper, starting with the summarised gender preferences to the economic development and the gender equality, we see that our analysis brings us to very similar results in terms of correlation coefficients (see Table 1). The p-values are all indicating a statistically significant correlation, as in the original paper, and when calculating the z-scores thanks to Fisher’s r to z transformation, we see that each one is below 2 (which is usually taken as threshold to be statistically significant). This means that our correlations were not statistically significantly different from the ones in the original article. Very similar results appear also from the robust linear regression used in the extended analysis. We do the same for the Gender Development Index, and also here we find a positive, statistically significant correlation, even if slightly less large than the one found for the Gender Equality Index.

#### Table 1: Correlation between PCA-summarised gender differences in economic preferences vs log GDP p/c, aggregated Gender Equality Index, and Gender Development Index. The agreement between this study and the original is quantified as *z-score*.

|  | | Log GDP p/c | Gender Equality Index | Gender Development Index |
--- | --- | --- | --- | --- | 
| Original | | 0.6685*** | 0.5580*** | -- |
| Replication | | 0.7119*** | 0.5852*** | -- |
| | *z-score* | -0.484 |  -0.234 | -- |
| Extended | | 0.7032*** | 0.5754*** | 0.3718** |
| | *z-score* | -0.382 |  -0.148 | -- |

In Table 2, we summarise the results of the correlation of single preferences to the gender equality of the countries. We can see very different results in terms of linear dependency for some of the preferences when comparing the correlation coming from the Gender Equality Index and the one coming from the Gender Development Index. Note that for the Gender Equality Index, we used the results obtain by this replication study, in order to have a more consistent comparison (additionally, we have already seen that there are no substantial differences from this study and the original article, see again Table 1).

#### Table 2: Comparison of the correlations between Gender Equality Index vs Gender Development Index, and country-level gender differences in economic preferences

|Variable | Gender Equality Index (Replication) | Gender Development Index |
--- | --- | -- |
|Altruism |0.51***  | 0.44*** |
|Trust    |0.48***  | 0.26** |
|Positive Reciprocity |0.22  | 0.37*** |
|Negative Reciprocity |0.35**  | 0.16 |
|Risk Taking | 0.31** | 0.13 |
|Patience |0.44***  | 0.19 |


Lastly, in Table 3, we summarise the results of the conditional analysis. For the two main country-level variables, we see that the values tend to agree and be on the same direction (similar slope coefficients and significant p-value). But when we start to check for the single indexes, we see that there are some differences which are worthy to discuss. 

The first thing to say is that we had to make choices on how to impute data and also how to handle the missing data (see discussion above in paragraph "Methods"). The main imputation on missing data has been done on the "time since women’s suffrage" dataset, that is where we see a substantial difference in the results. Other datasets, on the other hand, has not been treated for missing data but still they present some difference. For instance, the dataset "F/M in Labor Force Participation" in our analysis has a non-statistically significant correlation, while in the original paper they found a correlation with p-value less than 0.05.

A first thought was that this might be the result of using a different dataset for the GDP (the 2010 USD instead of 2005), but in our opinion this can’t be an explanation but rather a check about how robust the results are. So this question about the differences that were found is kept open.

The most interesting part of the analysis arises from the use of the Gender Development Index in place of the Gender Equality index built by the authors. When the variable conditioning analysis regressing on the Log GDP p/c is done, the correlation between gender differences and GDI vanishes (correlation = 0.0027, p-value = 0.982).

#### Table 3: Conditional analysis to separate the impacts of economic development and gender equality on gender differences in economic preferences. Reported are the slopes of the linear regressions.

|Variable | Residualized on | Original | Replication| Extended|
--- | --- | --- | --- | -- | 
|Log GDP p/c | Gender Equality Index | 0.5258***  | 0.5628*** | 0.5544*** |
|Gender Equality Index | Log GDP p/c | 0.3192***  | 0.2991* | 0.2870* |
|WEF Global Gender Gap | Log GDP p/c | 0.2327***  | 0.2634* | 0.2438* |
|UN Gender Equality Index | Log GDP p/c | 0.2911  | 0.1684 | 0.1714$^a$ | 
|F/M in Labor Force Participation | Log GDP p/c | 0.2453*  | 0.2123 | 0.1949$^b$ |
|Years since Women Suffrage | Log GDP p/c | 0.2988**  | 0.1901 | 0.1990$^c$ |
|Log GDP p/c | Gender Development Index | -- | -- | 0.6439*** |
|Gender Development Index | Log GDP p/c | --  | -- | 0.0027 |

\begingroup
\fontfamily{ppl}\fontsize{8}{8}\selectfont
$^a$Likely due to update on the webpage \
$^b$Not understood \
$^c$Arbitrary retreavement of the data (check also Supplementary Material)
\endgroup

\vskip 20pt

Looking at the results of the two last entries in Table 3, we can deduce that:

1. For countries having the same gender development, the gender differences are depending from the economic development of the country, meaning that richer countries have more gender differences than poorer countries, gender development being equal;

2. For countries having the same economic development, the gender differences are independent from the gender development of the country, meaning that there are no gender differences arising from countries having same economics but different gender development.

From this, one could therefore assume that the economic development is the country-level indicator associated with higher changes in gender differences, rather than the gender development of a country. From such a simple analysis is therefore not possible to extract any information regarding the reason for higher gender differences in more economically developed countries. We can only see that, for countries with similar economics, those differences don't exist regardless of how gender developed that countries are. The reason behind the differences might be related to purely economical conditions, that would also make sense since the gender differences here studied are "economical preferences". Can it be that the differences arise where the economic is more developed because of marketing reasons? After all, all the economics here analysed are based on capitalistic systems, meaning that the bigger the economic, the bigger the market. It is an interesting hypothesis that would require further analysis. 


# 3. Conclusions

The original study indicates that higher economic development and higher gender equality are associated with an increase in the gender differences in preferences, and therefore rules out the social-role theory over the post-materialistic one: When more resources are available to both men and women, the expression of the gender specific preferences can be seen. Our replication leads to the same conclusions, but we have some open questions regarding unexplained differences that lead to further checks on the results’ robustness. Moreover, we prove that, using a different indicator for the gender inequality in different countries, the result found by @FH does not hold anymore. 

We decided to focus on two main checks for the robustness: The first was to change the model to have a more "relaxed" assumption for the linear regression, and the choice went to robust linear regression. The results are similar to the ones from the replication analysis, meaning that the model is robust enough.

The second check has been the introduction of a different gender equality indicator, the Gender Development Index (from the UNDP). We performed the same analysis done so far, and we could see some differences rising from it:

- The correlations of the GDI and the gender differences at the single preference level differ quite a lot from the ones obtained using the Gender Equality Index (see Table 2). Half of the gender difference preferences are not correlated significantly anymore to the gender indicator, in one case the correlation is a half of the original one, in another case it starts to be significant (while in the original it wasn't). Only for the "altruism" we see the same behavior. This leads to questioning the stability of the measures performed using the Gender Equality Index, because it strongly depends on the way this indicator is built, making it hard for the researchers to claim which ones could be the best for the study that one wants to address;

- The correlation between GDI and gender differences is positive and statistically significant, although the strength of the correlation is somewhat less than the one for the GEI used by the authors;

- Lastly, the most important figure to look at is the variable conditioning for the whole analysis, because the gender index is very often intertwined to it, and because in general one can immediately get an answer to the question "how much variance is explained by the variable chosen, independently by the country economic development". The result of this analysis is that the gender differences residualised on the economic develooment do not show a dependency on the GDI (also residualised on economic development), while the vice-versa applies (meaning, there is a strong and statistically significant correlation between gender differences and economic development, both residualised on the GDI). This result arises many questions that are beyond the scope of this analysis.


# References

