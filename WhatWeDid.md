# Global Preferences Survey

## 1. Reproduce the results of the article
*Reference article:* https://science.sciencemag.org/content/362/6412/eaas9899

*DOI:* 10.1126/science.aas9899


### 1.1 Data Collection

#### GDP per capita

#### Gender Equality Index
The Gender Equality Index is composed by 4 main datasets.
- *Time since women’s suffrage:* Taken from the Inter-Parliamentary Union Website (http://www.ipu.org/wmn-e/suffrage.htm#Note1).
We cleaned the data keeping as a date the first complete date (vote + stand for election, with no other restrictions commented), regardless of whether the country was a colony or not (so Kazakhstan is kept to have the first date, because nothing changed from Soviet Union to independence). South Africa is not easy to clean because its history shows the racism part very entangled with the women's rights. We kept the latest date when also Black women could vote. For Nigeria, considered the distinctions between North and South, we decided to keep only the North data because, again, it was showing the completeness of the country and it was the last date. Note: USa data doesn't take into account that also up to 1964 black women couldn't vote (in general, Blacks couldn't vote up to that year). Still needed to check for other countries with such a racialized history.
- *UN Gender Inequality Index:* Taken from the Human Development Report 2015 (http://hdr.undp.org/en/composite/GII). We kept only the first table, that seemed to be more general
- *WEF Gloabl Gender Gap: WEF Global Gender Gap Index:* Taken from the World Economic Forum Global Gender Gap Report 2015 (http://reports.weforum.org/global-gender-gap-report-2015/rankings/). For countries where data were missing data were added from the World Economic Forum Global Gender Gap Report 2006 (http://www3.weforum.org/docs/WEF_GenderGap_Report_2006.pdf). We modified some of the country names directly on the csv file
- *Ratio of female and male labor force participation:* Values inverted to create an index of equality. Average International Labour Organization estimates from 2003 to 2012 taken from the World Bank database (http://data.worldbank.org/indicator/SL.TLF.CACT.FM.ZS). We took the years between 2004 and 2013 and calculated the mean


### 1.2 Create the Models

#### Linear Model on Each Country for Each Preference
Starting from the complete dataset (meaning with removed NA rows), we wanted to reproduce the data plotted in Fig. S2. regarding the gender differences and economic development by preference and by country.

We realized that a part of the data to reproduce the article is missing and it can be accessed only after payment of a subscription fee to the Gallup World Poll. We decided therefore to continue the analysis without using 2 of the variables used in the model (education level and household income quintile).

We created a linear model for each country using an expression from the article, omitting the 2 missing variables:

preference ~ gender + age + age_2 + subj_math_skills

This resulted in 6 different models (one for each preference measure), having an intercept and 4 weights, each of the weight being related to the variable in the formula above. 

The weigth for dummy variable "gender" is used as measure of the coutry level gender difference. Note that, changing the dummy variable of the male from "0" to "2" doesn't change anything in the results.

Therefore, in total we have 6 weigths that represent the preference difference related to the gender for 76 countries.

We plot the logarithm of the average GDP per capita versus the preference differences, for the 6 different preference measurements. When plotting this, we use a linear model to fit, and extract the correlation and the p-value.


### 1.3 Principal Component Analysis

To summarise the average gender difference among these preferences, we performed -- as the authors -- a principal component analysis on the gender preference differences from the linear model and use the first component the summary index of average gender differences in preferences. And then we plotted it against the logarithmic average of the GDP per capita for each country.

We performed a linear regression on the data points, extracting the correlation and p-value of the average gender difference in preferences versus the logarithm of the average GDP per capita. The variables on y-axis were additionaly trasformed as (y-y_min)/(y_max-y_min).

We performed a PCA also on the four values obtained for the gender equality, to extract a more general gender equality index based on them. We then used this Gender Equality Index for plotting the same average gender differences as a function of this index, performing a linear regression to calculate the p-value and the correlation value.

### Note on the Principal Component Analysis
The PCA is meant to uncorrelate those variables which are correlated, using the rotation of a multi-dimensional plane to extract the vectors where it exists the most variance of each variable. In our case, the variables are the preferences, and we want to extract the information about their principal component to use it as a measure for the average difference in the gender preferences. Therefore, after performing the PCA on our data.
One wants to highlight which basis maximise the differences.

### 1.4 Residualization of the variables

We followed the approach of Prof. McElreath in his lectures "Statistical Rethinking" (see https://github.com/rmcelreath/stat_rethinking_2020) and used a multivariate model to explore the connection between the logGDP and the Gender Equality Index. Using this approach, the residualization on the logGDp of the Gender Equality Index is telling us that the information brought by this variable on the average gender differences is not really adding much with respect to what the logGDP is telling us. 

The approach of the authors of the paper is slightly different, bringing them to a different result (that is, the Gender Equality Index has a value per se). What they do is to residualize the average gender differences on the same variable used for the residualization of the independent variable. 


### 1.4 Discussion On This First Step and Future Analysis

In the article, they see that the gender is the major variable among the ones used in the linear regression, but they use age and other variables as control variables. Why? And how do the other variables influence the regression? (To understand deeply why they used exactly this formula plus control variables with no meaning, check the article "Global Evidence on Economic Preferences", https://doi.org/10.1093/qje/qjy013)

How to make use of other information of the data, as for instance the age group, in a meaningful way? We think that the age plays a role in gender differences, meaning that the gender differences are higher in the older age group, and also that those countries with higher GDP tend to have more people from elder age. Some effect coming from some countries where deep social changes are happening among generations (think about Russia and all the ex-Soviet countries, living a crisis of huge dimensions just 30 years ago) might be hidden if we don't take this layer into account in the analysis. If such a link exists, as a first look at the data seemed to suggest, one can check the relationship between GDP and average age of countries. Similarly to the Gender Equality Index, this link would give us a hint toward the model proposed above.

Another important source of information can be the historical/cultural background of groups of countries: Those that are sharing a long history not only of colonization but of exchanges, and a similar economic system and religion, might have an impact in this model if we try out some cross-validation excluding those countries that share this background. As a matter of fact, if excluding some block of countries changes completely the correlation, it might well mean that we are not seeing an important parameter that is able to have a deeper influence than the gender itself.


### TO BE DISCUSSED MORE

I tried to use the formula preference ~ gender * age (which means that the preference is a function of gender, age, and their interaction), and the results are that the average gender difference is less correlated to logGDP (0.38, with p-value = 0.0007), and also less correllated to the Gender Equality Index (which is also changed, btw) as 0.27 and a p-value of 0.023.


## 2. Additional Information

### 2.1 Data Collection

#### World Ages
- The excel files and the csv coming from it: United Nations, Department of Economic and Social Affairs, Population Division (2019). World Population Prospects 2019, Online Edition. Rev. 1.
- The csv file *average_ages.csv*: https://www.worlddata.info/average-age.php (using the function WebScrapingAverageAgePerCountry)