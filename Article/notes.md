<!--

On calculation of PCA and GEI and economical preferences

On PCA (what are uncirteinties for components and projections?):
https://doi.org/10.1016/j.chemolab.2012.10.007
How PCA correlates with other components? Table for components with error estimates? Plot PCA? PC1 explained variance 0.4 (Eigenvalues, Component loadings, Bootstrap)
 [Tools for Composite Indicators Building]. "Handbook on Constructing Composite Indicators". Check linearity (input data is not gaussian, assumptions for PCA does not work). 
"The Use of Discrete Data in PCA: Theory, Simulations, and Applications to Socioeconomic Indices". PCA on descrete data, PCA ordinal data, https://www.tqmp.org/RegularArticles/vol10-1/p040/p040.pdf]. 
"The PCA is intrinsically a linear procedure, so it is non-robust, in the sense of Huber (2003), to various distributional assumptions violations. 
In particular, if the distribution of x exhibits high skewness and/or kurtosis, the weights and eigenvalues in PCA will have higher variances, and converge to their asymptotic distributions slower
(Davis 1977).".

Bootstrapping

Bootstrapping Principal Components Analysis: A Comment

Bootstrapping Principal Components Analysis: A Comment
David W. Mehlman, Ursula L. Shepherd and Douglas A. Kelt
Ecology
Vol. 76, No. 2 (Mar., 1995), pp. 640-643 (4 pages)

https://cran.r-project.org/web/packages/bootSVD/bootSVD.pdf

### Sensitivity analysis

Sensitivity analysis (SA) and uncertainty analysis (UA) are the two main tools used in exploring the uncertainty of such models.

Sensitivity analysis provides information on the relative importance of model input parameters and assumptions. It is distinct from uncertainty analysis, which addresses the question ‘How uncertain is the prediction?’ Uncertainty analysis needs to map what a model does when selected input assumptions and parameters are left free to vary over their range of existence, and this is equally true of a sensitivity analysis. Despite this, many uncertainty and sensitivity analyses still explore the input space moving along one-dimensional corridors leaving space of the input factors mostly unexplored. Our extensive systematic literature review shows that many highly cited papers (42% in the present analysis) fail the elementary requirement to properly explore the space of the input factors. The results, while discipline-dependent, point to a worrying lack of standards and recognized good practices. We end by exploring possible reasons for this problem, and suggest some guidelines for proper use of the methods.

https://www.sciencedirect.com/topics/medicine-and-dentistry/sensitivity-analysis

Why so many published sensitivity analyses are false: A systematic review of sensitivity analysis practices:
https://www.sciencedirect.com/science/article/pii/S1364815218302822
https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0085654

### Influential points

https://stats.stackexchange.com/questions/415711/individual-significance-of-data-points-in-correlation

http://qed.econ.queensu.ca/pub/faculty/mackinnon/econ850/slides/econ850-slides-h03.pdf

## Multicollenearity of the data and DAG

[Theorem used for residuals and multicollenearity]

[Spurious Regressions and Near-Multicollinearity]

[Frisch–Waugh–Lovell theorem uses inversed matrix that is going to be close to zero in case of collinearity]

[OLS Assumptions in Multiple Regression and their violation]

-->


<!--

We found a large and statistically significant association of gender equality preferences with economic development conditioning on WEF and GDI (r = 0.6253, P < 0.0001 and r = 0.6612 , P < 0.0001, respectively), while for UNDP the association was somewhat smaller and with a larger p-value (r = 0.4190, P = 0.0194). Conditioning on economic development showed no correlation for UNDP and GDI indexes. While, for WEF the correlation was moderate with a mild statistical significance (r = 0.21, P = 0.024). 

We further analysed how single gender differences are related to economic development and gender equality. As for the above-reported results on the summarised gender differences, we found large and statistically significant associations for the gender differences on the single economic preferences regressed on log GDP p/c conditioning on WEF GGGI and UNDP GDI. Interestingly, when conditioning on the indicator UNDP GII, no correlation of the gender differences to the economic development was found, except for the variable "altruism", which showed a moderate but statistically significant correlation (r = 0.3527, p-value < 0.001). 

Regarding the correlation of gender differences in single preferences and gender equality, when controlling for the economic development, among six economic preferences and three gender equality indexes, no statistically significant association was found. The two exceptions are for the preference "altruism" (r = 0.3561; p-value < 0.001) regressed on WEF GGGI, and the preference "risk taking" (r = 0.2192; p-value = 0.0455) when regressing on UNDP GII, thus showing little support of the presence of association of gender differences in economic preferences and gender equality. 

From this, one could therefore assume that the economic development is the country-level indicator associated with higher changes in gender differences, rather than the gender development of a country. From such a simple analysis is therefore not possible to extract any information regarding the reason for higher gender differences in more economically developed countries. We can only see that, for countries with similar economics, those differences don't exist regardless of how gender developed that countries are. The reason behind the differences might be related to purely economical conditions, for instance a more developed gender-oriented marketing strategy, more developed in countries with a larger economy. It is an interesting hypothesis that would require further analysis.

The regression of the economic preferences on the gender equality index should not be used as an actual measure of association due to its high correlation with economic development. Instead, the coefficient from conditional analysis should be adapted for this measure. As suggested by our conditional analysis, if a mild association between gender differences and gender equality exists for some preferences (such as Altruism and Rink-Taking), the magnitude of the correlation coefficient is at-least two-fold smaller than the association of gender differences and the economic development conditioning on gender equality indexes.
-->

<!--

The question about the origin of the gender differences remains open, along with the more general question of why the differences in economic preferences exist across countires in the first place and if there are any interconnecitons between the absolute value of a given economic preference and gender differnce in it.

[difference between ]

As an outlook, WEF index is one of the most advanced indexes up to date. Educational and Health gap is almost closed in most of the countries while the gaps in Economical and The disbalance in political domains are straking even in countries with the most progressive policies on gender equality. WEF GGG index is very sensetive to the rather-short term changes in socio-political and economical situation, while severally penalizing the countries with descriminative politics. Rvanda, Finland, Sweden. Causal inference. Sensitivity to the points and country inclusion. More countries implement measures (likely from the countires that are grouped as), increasing score and going out of GFP driven trend. In turn, economical preferences stay the same, but the actual correlation will increase. The data alone, without the detailed analysis it is vertually impossible to tell the direction of causality if any exists with regard to differences in economic preferences and gender equality. 

As the process of reinforsment and positive feedback.

From this, one could therefore assume that the economic development is the country-level indicator associated with higher changes in gender differences, rather than the gender development of a country. From such a simple analysis is therefore not possible to extract any information regarding the reason for higher gender differences in more economically developed countries. We can only see that, for countries with similar economics, those differences don't exist regardless of how gender developed that countries are. The reason behind the differences might be related to purely economical conditions, that would also make sense since the gender differences here studied are "economical preferences". Market and capital distribution, historical measures of GE, distribution of part time job, balance of power within hierachical structures and availiblility of resources, underline the important of the studies on country level.

As an outlook, WEF index is one of the most advanced indexes up to date. Educational and Health gap is almost closed in most of the countries while the gaps in Economical and The disbalance in political domains are straking even in countries with the most progressive policies on gender equality. WEF GGG index is very sensetive to the rather-short term changes in socio-political and economical situation, while severally penalizing the countries with descriminative politics. Rvanda, Finland, Sweden. Causal inference. Sensitivity to the points and country inclusion. More countries implement measures (likely from the countires that are grouped as), increasing score and going out of GFP driven trend. In turn, economical preferences stay the same, but the actual correlation will increase. The data alone, without the detailed analysis it is vertually impossible to tell the direction of causality if any exists with regard to differences in economic preferences and gender equality.  
-->


<!--

 The ratio of female and male labor force participation counts as the overall labor participatio rate, and thus, once approaching 100% as a characteristic of developed countries [@tasseven2017relationship], the gender gap is automatically reduced [this is not true, check the U-shape curve]. This measure does not take into account on the part-time jobs occupation as in case of the reduction , including involuntary part time job occupation in developed countries [@pech2021part; @rosenfeld1990cross]. [this sentenses wants to go to discussion] "part time jobs and gender gap"; The gap in involuntary part-time.

The preference of simplicity over complexity to help policy-makers understand the indicator, and the avoidance of inclusion of too many - or too strong -- sub-indixes that relates directly to the economic development of the country [@SK; @Permanyer; @KPS; @AS]. Thus, we decided to focus only on the most complete indicators that were already available in the original article, meaning the WEF Global Gender Gap Index and UNDP Gender Inequality Index, adding a new indicator following the suggestions of @SK, the Gender Development Index.

-->

<!--
Link to effect sizes in econometrics and social sciences
-->


<!--
GNI is used in Falk, plus we need to discuss this index somewhere
-->


<!--



@article{pech2021part,
  title={Part-Time by Gender, Not Choice: The Gender Gap in Involuntary Part-time Work},
  author={Pech, Corey and Klainot-Hess, Elizabeth and Norris, Davon},
  journal={Sociological Perspectives},
  volume={64},
  number={2},
  pages={280--300},
  year={2021},
  publisher={SAGE Publications Sage CA: Los Angeles, CA}
}

@article{rosenfeld1990cross,
  title={A cross-national comparison of the gender gap in income},
  author={Rosenfeld, Rachel A and Kalleberg, Arne L},
  journal={American Journal of Sociology},
  volume={96},
  number={1},
  pages={69--106},
  year={1990},
  publisher={University of Chicago Press}
}
-->