# Global Preferences Survey

## 1. Reproduce the results of the article

### 1.1 Data Collection
To do

### 1.2 Create the Models

#### Linear Model on Each Country for Each Preference
Starting from the complete dataset (complete meaning with removed NA rows), we wanted to reproduce the data plotted in Fig. S2. regarding the gender differences and economic development by preference and by country.

In doing this, we realized that a part of the data to realize the article is missing and it can be accessed only after payment of a subscription fee to the Gallup World Poll. We decided therefore to continue the analysis without using 2 of the variables used in the model (education level and household income quintile).

We created a linear model using the formula:

$preference ~ gender + age + age_2 + subj_math_skills$

This resulted in 6 different models (one for each preference measure), having an intercept and 4 weights, each of the weight being related to the variable in the formula above. 

We assume that the article continues using the gender coefficient because this is the coefficient with the major weight. We therefore take this coefficient and plot the logarithm of the average GDP per capita versus this coefficient (one coefficient for each country), for the 6 different preference measurements. When plotting this, we use a linear model to plot the fit, the correlation, and the p-value made on the logarithm of the average GDP per capita versus the gender difference coefficients for each country, to extract relevant statistical information about the variables.

#### Principal Component Analysis
To summarise the average gender difference among these preferences, we performed -- as the authors -- a principal component analysis on the gender coefficient extracted from the linear model. The PCA is meant to uncorrelate those variables which are correlated, using the rotation of a multi-dimensional plane to extract the vectors where it exists the most variance of each variable. 

In our case, the variables are the preferences, and we want to extract the information about their principal component to use it as a measure for the average difference in the gender preferences. Therefore, after performing the PCA on our data, we selected the first component and plotted it against the logarithmic average of the GDP per capita for each country.

Again, while plotting, we performed a linear regression on the data points, plotting the fit and extracting the correlation and p-value of the average gender difference in preferences versus the logarithm of the average GDP per capita. Moroever, to replicate the results, we adapt the plot to have the minimum and the maximum corresponding to the minimum and maximum found on the y-axis.

### 1.3 Discussion On This First Step