<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/IntroCrime.png?raw=true" width="650" title="hover text">

# Introduction

In 1991, crime rate’s in the United States of America reached it’s peak before eventually falling into it’s lasting decreasing trend into the 21st century. It is important to understand
the reasons for crime and the factors associated with it. Previous research suggests that increases in crime rates may be a prediction of the three most influential ecological theories
of crime: Becker’s economic theory of crime[1], Merton’s strain theory[2], and the social disorganization theory of Shaw and McKay[3].

The ecological theories attempt to explain variations in crime rates through the lens of differing incentives, pressures, and deterrents that individuals come across in different
environments. Economic theory of crime suggests that poorer individuals situated in area’s of high income inequality have a greater payoff from time allocated to criminal activity.
Strain theory argues that unsuccessful individuals feel a greater frustration around them when they are placed in a situation where there is success of others around them. The larger
the gap in inequality, the higher this strain - and hence the greater the incentive for low-status individuals to commit a crime. Social disorganization theory argues that crime occurs when
mechanisms of social control are weakened. Mechanisms of social control include regulation of poverty, racial heterogeneity, residential mobility, and family instability.
Previously, Michael A.Redmond[7] attempted predict the number of violent crimes using K nearest neighbor approach combined with a 10-fold cross validation methodology. Another
study by Buczak and Gifford[4] conducted exploratory analysis of the non-normalized dataset. The focus of this research is to understand the underlying attributes to what constitutes an
overall decrease in ”violent” crime rates in the United States. Particularly, we want to expand existing research and attempt to focus on the influence of socioeconomic, racial and
]spatial relationships in explaining the variance of crime rates in the United States.

# Data Exploration
## Data Description

The data combines socio-economic data from the 1990 US Census, law enforcement data from the 1990 US LEMAS survey, and crime data from the 1995 FBI UCR. The data can
be found in University of California, Irvine’s machine learning repository under the heading ”Communities and Crime”. This data set includes a total of 1994 records and 128 attributes.
As our research question is to understand the variance in violent crimes, we will collect a list of variables that include geographic and demographic data from the dataset. Examples
of some these variables are: state, county, median income, percent age (based on groups), percent white (and other race’s), percent of population using public transport, and much
more. Out of 128 attributes, 53 variables were collected based on Becker, Shaw and Mckay and Merton’s theories of crime. As one of the objectives of this study was to understand if there was regional variations
of crime, a population and regional attribute were created. A brief description can be seen in table 1. In addition, 93 observations were removed as these observations were missing
completely at random (MCR). Hence, the dimensions for the final dataset that will be used to explain variation in crime has a total of 55 attributes and 1901 records. Our variable of
interest(response variable) is Violent Crimes Per Population.

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/T2Crime.png?raw=true" width="500" title="hover text">

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/F1Crime.png?raw=true" width="500" title="hover text">

## Exploratory Analysis

Exploratory analysis was performed to view the general trends of the data and to view where the highest number of responses were coming from. Demonstrated from Figure 1,
most data is reported from relatively smaller populated areas (Large Towns and Towns, which have populations less than 100000). From table 2, it can be seen that in the 1990’s
the highest average violent crimes per population were reported in District of Columbia followed by Maryland and Louisiana. Our initial exploratory analysis supported our final
findings which may be viewed in the appendix (Model 7, Final Findings). Population density and region both attributed to explain variations of crime rates.

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/T1Crime.png?raw=true" width="500" title="hover text">

# Methodology 
## Variable Selection and Transform Methodology
Our research question stands to try and achieve the best possible fit in trying to explain
the variation of crime throughout the United States. This section goes through a variety of
techniques used as well the criterion for the final model selected. The entirety of the research
was conducted using the statistical programming language, R.

### Sequential Procedures:
Backward, Forward and Stepwise[8] procedures were used to find a group of variables that
were significant in explaining the response. Forward sequential procedure starts with no
variables in the model and continually adds the largest significant partial F until no other
variables are significant or all the variables are included in the model. Backward sequential
procedure starts with every variable and removes variables with the smallest significant
partial F. It will continue removing variables until all remaining variables are significant or
all the variables have been removed. Stepwise regression starts with no predictors in the
model and then at each step along the way either enter or remove a predictor based on the
partial F-tests. The procedure stops when no more predictors can be justifiably entered or
removed from the model, thereby leading to a ”final model.”

### Transformations:
In order to understand the relationships of our covariates and improve the fit and
prediction capabilities of the model; two transformations were used using the Box-Cox and
Box-Tidwell procedures[9].

#### Box-Cox Procedure:
The Box-Cox procedure performs a transformation on our response where we can model
our objective function as follows:

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/boxcox.png?raw=true" width="500" title="hover text">

#### Box-Tidwell Procedure:
Box-Tidwell has the same goal as to Box-cox. The difference is that Box-Tidwell finds a
power transformation for some or all the predictors in the data. This power transformation
on X has the following form:

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/boxtid.png?raw=true" width="150" title="hover text">

## Modeling Methodology:

### Multiple Linear Regression

To investigate the variation of violent crimes per population given a multitude of
independent variables, a multiple linear regression model[5] was employed using a OLS
estimate. Our linear model form can be written as:

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/linreg.png?raw=true" width="600" title="hover text">

### Weighted Least Squares Regression:
Weighted least squares[5] is an extension of ordinary least squares in which the errors
covariance matrix is allowed to be different to an identity matrix. Weighted least squares
occurs when all the off-diagonal entries of Ω (the correlation matrix of the residuals) are
null; the variances of the observations (along the covariance matrix diagonal) may still be
unequal (heteroscedasticity). We define a weight matrix W as:

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/wls.png?raw=true" width="500" title="hover text">
  
### Ridge Regression:
A variation of multiple linear regression, Ridge regression is an alternative but biased[10]
approach to treat multicollinearity in our data. Our objective function in ridge are as
follows:

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/ridge.png?raw=true" width="400" title="hover text">

### Principle Components Regression:
Principle component regression is yet another biased estimation procedure that can be
used to reduce the effect of collinearity. Our model becomes:

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/pcr.png?raw=true" width="150" title="hover text">

## Diagnostics and Model Selection Methodology
A number of tests were used to assess the validity of the model. A variety of tests were
used to assess the assumptions of linear regression. It is important to note that the
significance level of α is assumed to be 0.05. The tests used were as follows:

Global F-Test: The Global F-Test[11] is a test for overall significance. It validates whether
any of the regressors have any importance in explaining our response. The null hypothesis
this F test assumes all covariates from β1 = β2 = ...βk = 0 whereas the alternate hypothesis
is that there exists atleast one covariate from β1...βk where βk 6= 0.

Partial F-Test: Partial F tests[11] are used whether a single or group of variables are
significant in explaining are response. Our null hypothesis for this test assumes that β1∗ = 0
whilst are alternate being β1∗ not equal to 0 where β1* is the group of variables being tested for
significance in explaining our response. This test is the primary test used in our variable
selection procedure methods.

Wald–Wolfowitz runs test: The Wald–Wolfowitz runs test[12] is a non-parametric statistical
test that checks a randomness hypothesis for a two-valued data sequence. It can be used to
test the hypothesis that the elements of the sequence are mutually independent. The run
test is based on the null hypothesis that each element in the sequence is independently
drawn from the same distribution.

Breusch-Pagen: The Breusch-Pagen[13] tests whether the variance of the errors from a
regression is dependent on the values of the independent variables. The test statistic is
asymptotically distributed as χ2(p−1) under the null hypothesis of homoskedasticity. This test
was conducted using the package car in R.

Goldfield-Quandt Test: The Goldfeld–Quandt test[14] checks for homoscedasticity in
regression analyses. It does this by dividing a dataset into two parts or groups and
comparing variances amongst the groups. The null hypothesis for this test assumes
constant variance.

Shapiro-Wilk Test: The Shapiro–Wilk test[15] is a test of normality. The null-hypothesis of
this test is that the population is normally distributed. 

The final model selection criterion was based on adjusted R2 and MSE. MSE was also
used to compare the biased approaches to the unbiased approaches while the adjusted R2
and MSE was used in conjunction to select the best model among the best linear unbiased
estimations.

