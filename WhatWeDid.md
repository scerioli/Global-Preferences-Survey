# Global Preferences Survey

## 1. Reproduce the results of the article

### Data Collection


### Create the Models
Starting from the complete dataset (complete meaning with removed NA rows), we wanted to reproduce the data plotted in Fig. S2. regarding the gender differences and economic development by preference and by country.

In doing this, we realized that a part of the data to realize the article is missing and it can be accessed only after payment of a subscription fee to the Gallup World Poll. We decided therefore to continue the analysis without using 2 of the variables used in the model (education level and household income quintile).

We created a linear model using the formula:

preference ~ gender + age + age_2 + subj_math_skills