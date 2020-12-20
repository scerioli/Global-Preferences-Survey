# Global Preferences Survey

## 1. Reproduce the results of the article

### 1.1 Data Collection
To do: GDP

#### Gender Equality Index
The Gender Equality Index is composed by 4 main datasets.
- Time Since Women's Suffrage: I am cleaning the data keeping as a date the first complete date (vote + stand for election, with no other restrictions commented), regardless of whether the country was a colony or not (so Kazakhstan is kept to have the first date, because nothing changed from Soviet Union to independence). South Africa is not cleaned because its history shows the racism part very entangled with the women's rights. I kept the latest date when also Black women could vote. For Nigeria, considered the distinctions between North and South, I decided to keep only the North data because, again, it was showing the completeness of the country and it was the last date.
- UN Gender Inequality Index: I kept only the first table, that seemed to be more general
- WEF Gloabl Gender Gap: I modified some of the country names directly
- Ratio Labor Male Female: I took the years between 2004 and 2013 and calculated the mean


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

#### Principal Component Analysis

To summarise the average gender difference among these preferences, we performed -- as the authors -- a principal component analysis on the gender preference differences from the linear model and use the first component the summary index of average gender differences in preferences. And then we plotted it against the logarithmic average of the GDP per capita for each country.

We performed a linear regression on the data points, extracting the correlation and p-value of the average gender difference in preferences versus the logarithm of the average GDP per capita. The variables on y-axis were additionaly trasformed as (y-y_min)/(y_max-y_min).


### 1.3 Discussion On This First Step

The main question is: Do they choose the gender coefficient because it is the biggest weight over the others (but how do they choose the others?), or because they really wanted to focus on the gender differences (but again, why to use the other variables?)?
In the article, they assume gender to be the major variable, but they use age and other variables as control variables.
The PCA is meant to uncorrelate those variables which are correlated, using the rotation of a multi-dimensional plane to extract the vectors where it exists the most variance of each variable. 
In our case, the variables are the preferences, and we want to extract the information about their principal component to use it as a measure for the average difference in the gender preferences. Therefore, after performing the PCA on our data.
One wants to highlight which basis maximise the differences.

