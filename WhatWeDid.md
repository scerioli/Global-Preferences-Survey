# Global Preferences Survey

## 1. Reproduce the results of the article

### 1.1 Data Collection
To do


1.X Distributions for preferences



### 1.2 Create the Models

#### Linear Model on Each Country for Each Preference
Starting from the complete dataset (meaning with removed NA rows), we wanted to reproduce the data plotted in Fig. S2. regarding the gender differences and economic development by preference and by country.

We realized that a part of the data to reproduce the article is missing and it can be accessed only after payment of a subscription fee to the Gallup World Poll. We decided therefore to continue the analysis without using 2 of the variables used in the model (education level and household income quintile).

We created a linear model for each country using an expression from the article, omitting the 2 missing variables:

preference ~ gender + age + age_2 + subj_math_skills

This resulted in 6 different models (one for each preference measure), having an intercept and 4 weights, each of the weight being related to the variable in the formula above. 

The weigth for dummy variable "gender" is used as measure of the coutry level gender difference. 

Therefore, in total we have 6 weigths that represent the preference difference related to the gender for 76 countries.

We plot the logarithm of the average GDP per capita versus the preference differences, for the 6 different preference measurements. When plotting this, we use a linear model to fit, and extract the correlation and the p-value.

Results

#### Principal Component Analysis#### 

To summarise the average gender difference among these preferences, we performed -- as the authors -- a principal component analysis on the gender preference differences from the linear model and use the first component the summary index of average gender differences in preferences. And then we plotted it against the logarithmic average of the GDP per capita for each country.

We performed a linear regression on the data points, extracting the correlation and p-value of the average gender difference in preferences versus the logarithm of the average GDP per capita. The variables on y-axis were additionaly trasformed as (y-y_min)/(y_max-y_min).

### 1.3 Discussion On This First Step

We assume that the article continues using the gender coefficient because this is the coefficient with the major weight. 
The PCA is meant to uncorrelate those variables which are correlated, using the rotation of a multi-dimensional plane to extract the vectors where it exists the most variance of each variable. 
In our case, the variables are the preferences, and we want to extract the information about their principal component to use it as a measure for the average difference in the gender preferences. Therefore, after performing the PCA on our data
