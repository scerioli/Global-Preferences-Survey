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

## Multicollenearity of the data and DAG

[Theorem used for residuals and multicollenearity]

[Spurious Regressions and Near-Multicollinearity]

[Frisch–Waugh–Lovell theorem uses inversed matrix that is going to be close to zero in case of collinearity]

[OLS Assumptions in Multiple Regression and their violation]

-->