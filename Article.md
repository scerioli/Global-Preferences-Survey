# Reproduce the results of the article 
# **Relationship of gender differences in preferences to economic development and gender equality**


#### Abstract

While reading the article "Relationship of gender differences in preferences to economic development and gender equality" by A. Falk and J. Hermle, we soon realized that many points were not easy to understand without starting a full reproduction of the paper using the same data as the authors used. We therefore decided to reproduce it for trying to answer the questions we had and eventually improving the model behind the study. In this publication, we want to address simply the replication of the original article, without any additional step.


## Introduction

Gender differences are nowadays extensively used as arguments and counter-arguments for decision and policy making, and these differences concerning the economic behaviors (such risk taking, patience, or altruism, for instance) are being studied both in economics and in psychology. *do we need a citation here?*
One of the problems common for many experiments in social sciences is the lack of a large and vary datasets that can be used to check for such differences reducing some of the bias induced, for example, by having students or specific sets of people interviewed.

In the Gallup World Poll 2012 there was included a Global Preference Survey conducted on almost 80000 people in 76 countries all around the world, that aimed to fill this gap: Covering almost 90% of the world population representation, with each Country having around 1000 participants answering questions related to their time preference (patience), altruism, will of risk taking, negative and positive reciprocity, and trust.

The dataset provides a unique insight in the economic preferences of a heterogeneous amount of people. The original study focussed on more general questions about the economic preferences distributions in different countries, trying to explore different covariates from the Gallup World Poll. The article we want to replicate is focussing only on the gender differences arising from the previous study.

The main question that the article wants to answer is the old one nature versus nurture: Are gender differences arising from some kind of biological differences, or from social stereotypes? The first hypothesis means that the differences could potentially be masked by the necessity of fulfilling basic needs for survival reasons, and therefore in less developed Country we would see less gender differences (because people aim for survival first), while in most developed Countries we would see more gender differences (because of the liberation of the women - and men - from basic, granted needs). On the other hand, if it is society that creates those differences, we should see less differences in the more developed Countries, where people are freed from stereotypes and can freely express themselves. The conclusion of the article is that the trends in the data shows a positive correlation of gender differences with GDP p/c of the Countries, and thus "confirming" the first hypothesis (nature is the reason).

The need of replication comes from us because we didn't believe in this simplistic perspective and wanted to have a deeper understanding of the data behind the results. While approaching the problem, we realised that it wouldn't be possible to go further without replicating the results first, since the authors didn't provide any code. 

In this work we replicate the study of Falk and Hermle without anything but the article as indications to follow for the code.

## Methods

### Overview

We replicate the results using R, version 4.0.3 *Insert all the info about the packages?*

### Data Collection, Cleaning, and Standardization

The data used by the authors is not fully available because of two reasons:

1. **Data paywall:** Some sociodemographic variables (for instance, education level or income quintile) are not part of the Global Preference Survey, but of the Gallup World Poll dataset. Check the website of the [briq - Institute on Behavior & Inequality](https://www.briq-institute.org/global-preferences/home) for more information on it. 

2. **Data used in study is not available online:** This is what happened for the LogGDP p/c calculated in 2005 US dollars (which is not directly available online). We decided to calculate the LogGDP p/c in 2010 US dollars because it was easily available, which should not change the main findings of the article. 

An additional issue that we faced while trying to reproduce the results of the article has been the missing data. We will treat this specific issue later on because it requires a bit of background.

The procedure for cleaning is described for each dataset in the corresponding section below. After manually cleaning the dataset, we standardized the names of the countries and merged the datasets into one within the function [PrepareData.r](https://github.com/scerioli/Global_Preferences_Survey/blob/master/functions/PrepareData.r).


#### Global Preferences Survey

This data is protected by copyright and can't be given to third parties.

To download the GPS dataset, go to the website of the Global Preferences Survey in the section "downloads". There, choose the "Dataset" form and after filling it, we can download the dataset. 

*Hint: The organisation can be also "private".*


#### GDP per capita

From the [website of the World Bank](https://data.worldbank.org/indicator/), one can access the data about the GDP per capita on a certain set of years. We took the GDP per capita (constant 2010 US$), made an average of the data from 2003 until 2012 for all the available countries, and matched the names of the countries with the ones from the GPS dataset.


#### Gender Equality Index

The Gender Equality Index is composed of four main datasets. Here below we describe where to get them (as originally sourced by the authors) and how we treated the data within them, if needed.

- **Time since women’s suffrage:** Taken from the [Inter-Parliamentary Union Website](http://www.ipu.org/wmn-e/suffrage.htm#Note1). We prepared the data in the following way. For several countries more than one date where provided (for example, the right to be elected and the right to vote). We use the last date when both vote and stand for election right were granted, with no other restrictions commented. Some countries were colonies or within union of the countries (for instance, Kazakhstan in Soviet Union). For these countries, the rights to vote and be elected might be technically granted two times within union and as independent state. In this case we kept the first date. 
It was difficult to decide on South Africa because its history shows the racism part very entangled with women's rights. We kept the latest date when also Black women could vote. For Nigeria, considered the distinctions between North and South, we decided to keep only the North data because, again, it was showing the completeness of the country and it was the last date. 
Note: USA data doesn't take into account that also up to 1964 black women couldn't vote (in general, Blacks couldn't vote up to that year). We didn’t keep this date, because it was not explicitly mentioned in the original dataset. This can be seen as in contrast with other choices made.

- **UN Gender Inequality Index:** Taken from the [Human Development Report 2015](http://hdr.undp.org/sites/default/files/hdr_2016_statistical_annex.pdf). We kept only the table called "Gender Inequality Index".

- **WEF Global Gender Gap:** WEF Global Gender Gap Index Taken from the [World Economic Forum Global Gender Gap Report 2015](http://reports.weforum.org/). For countries where data was missing, data was added from the World Economic Forum Global Gender Gap Report 2006. NOTE: We modified some of the country names directly on the csv file, that is why we provide this as an input file.

- **Ratio of female and male labour force participation:** Average International Labour Organization estimates from 2003 to 2012 taken from the World Bank database (http://data.worldbank.org/indicator/SL.TLF.CACT.FM.ZS). Values were inverted to create an index of equality. We took the average for the period between 2004 and 2013.


### About Missing Data

#### Main issue

During the reproduction of the article, we found that the authors didn't write in details how they handled missing data in the indicators.

They mention on page 14 of the Supplementary Material, that (quoting): "For countries where data were missing data were added from the World Economic Forum Global Gender Gap Report 2006 (http://www3.weforum.org/docs/WEF_GenderGap_Report_2006.pdf)."

However, there are two problems here:

- Regarding the year when women received the right to vote in a specific country. The missing values here are the ones coming from the United Arab Emirates and Saudi Arabia, that neither in 2006 (when the WEF Global Gender Gap Report that the authors quote as a reference for the missing values) nor now (in 2021) have guaranteed yet the right to vote for women.

- There are missing data also in the other sources that the authors quote. So a quick search for the missing countries of the WEF report of 2015, shows us that these countries can’t be found in the report of 2006 either. 

These two unclear points, even though in our understanding not crucial for the replication of the analysis, are not desirable, but couldn't be further clarified with the authors.


## Research Article

The article uses several methods for extracting the results.

### Creation of the Models

#### Linear Model on Each Country for Each Preference

Starting from the complete dataset (meaning with removed NA rows), we wanted to reproduce the data plotted in Fig. S2. regarding the gender differences and economic development by preference and by country.

As already mentioned in the previous paragraph, part of the data to reproduce the article is missing and it can be accessed only after payment of a subscription fee to the Gallup World Poll. We decided, therefore, to continue the analysis without using two of the variables used in the model (education level and household income quintile).

We created a linear model for each country using an expression from the article, omitting the 2 missing variables:

```preference ~ gender + age + age_2 + subj_math_skills ```

This resulted in 6 different models (one for each preference measure), having intercept and 4 weights, each of the weight being related to the variable in the formula above. The weight for the dummy variable "gender" is used as a measure of the country-level gender difference. Therefore, in total, we have 6 weights that represent the preference difference related to the gender for 76 countries.

We plotted the logarithm of the average GDP per capita versus the preference differences, for the 6 different preference measurements. When plotting this, we used a linear model to fit and extract the correlation and the p-value.


#### Principal Component Analysis

To summarise the average gender difference among these preferences, we performed a principal component analysis on the gender preference differences from the linear model and used the first component as a summary index of average gender differences in preferences. 

We then performed a linear regression on the data points, extracting the correlation and p-value of the average gender difference in preferences versus the logarithm of the average GDP per capita. The variables on y-axis were additionally transformed as (y-y_min)/(y_max-y_min) (see Fig. 1B).

We performed a PCA also on the four datasets used for Gender Equality, to extract a more general Gender Equality Index based on them. We then used this Gender-Equality Index for plotting the same average gender differences as a function of this index, performing a linear regression to calculate the p-value and the correlation value (see Fig. 1D). Note that here also the Gender Equality Index is transformed to be on a scale between 0 and 1.


#### Variable Conditioning

For the plots in Fig. 2, a conditional analysis was performed. To plot the variables x and y residualised using the variable z:

1. We performed a linear regression of x on z, and then a linear regression of y on z.

2. We calculated the residuals of the variable x, meaning that we take the points on the x-axis and calculate the difference between these and the projection of these points on the model created from the linear regression of x on z; the same for y.

3. We plot the residuals on the corresponding axis.

This has been done for the economic development, for the Gender Equality Index, and for each of the four indicators building the Gender Equality Index. The variable used on the y-axis is, therefore, the first Principal Component of the PCA made on the gender differences on the six preferences.

### Comparing the Results

#### Tables and z-scores

#### Plots