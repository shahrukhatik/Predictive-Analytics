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
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/boxtid.png?raw=true" width="200" title="hover text">

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
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/pcr.png?raw=true" width="220" title="hover text">

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


# Discussion
## Multiple Linear Regression
Our initial data had a total of 55 attributes and 1901 records. It is noted that although
some variables are on different scales in our data, our primary objective is to find the best
fit. Centering and scaling the data will not contribute to produce a better fit of our model,
and hence the data was not standardized. Our first objective was to build a multiple linear
regression using an OLS estimate. Our response variable was Number Of Violent Crimes
per population. All of the independent variables and response variables can be seen in the
appendix. Our model estimated were as follows:

Our initial results can be summarized by saying that given our 55 attributes we can
currently explain about 69 percent of the variation of crime. The p-value for our global
F-test is also significant telling us that there exists atleast one regressor that is significant
in the model, and hence regression can be carried out. Figure 2 shows us the residual plots
for the full model an we can see that we have a scattered trend in the residual index plot
indicating appropriateness to carry out regression. However, all the other plots underlay a
much bigger problem. Both residuals vs Fitted and Scale-location plots tell us that the
regression does not have a linear relationship between our independent and response and
that we do not have constant variance. We also do not have normality in our data, but this
will not be a primary concern moving forward due to having a large sample size(Box, GEP.
(1953). Individual tests support these claims as seen in Table 5. It is noted that a run’s
test was carried out for every independent variable, and all variables are independently
drawn from the same distribution.

A Box-Cox transformation was carried out on y. The transformation used was log(y) as
our optimum value of lambda was very close to 0. Similarly, a Box-Tidwell transformation
was also carried out for every independent variable. Most of the independent variables had
an MLE lambda estimate of 0, and therefore, all of the independent variables were also log
transformed. Although the transformations had an impact and solved the issue for
linearity amongst our response and independent variables, the tests for constant variance
had still failed. Therefore, a WLS approach was conducted. Below are the results after
conducting a weighted least squares approach:

As we can see from tables 6, performing a transformation on our response and covariates
contributed to a better fit. Our R2 and adjusted R2 both increased. In addition, a
weighted least squares approach had stabilized the variance in the model which can be seen
by the test results in table 7.

Our next process involved selecting the appropriate and significant variables for our final
model. A forward, backward and stepwise regression procedure was used. Following are the
comparison of the results using all three methods.

Based on the results of table 8, an improved model was built using variables selected from
the stepwise procedure. As all models had very similar R2, adjusted R2 and MSE as
comparison metrics, the most simplest model was selected (Model 5). All variables selected
can be seen in appendix.

#  Outlier, Leverage and Influential Observations

Our next aspect of trying to improve the fit of the model involved identifying and
inspecting leverage, outlier and influential observations.
The leverage value hii measures the distance between the predicted values X for subject i and the means of X values for all subjects. A leverage value is considered large if it is more than twice the mean leverage. Leverage values greater than 2p/n are considered to indicate outlying cases with regards to their X values(Kutner et.al, 2005).

Standardized residual (internally studentized) is the residual divided by estimated standard deviation. As a rule of thumb, the standardized residual less than -2 or greater than
+2 may indicate that the point is an outlier.
After identifying individuals that were both a combination of an outlier and an influential
point, these observations were examined using Cook’s Distance and DFFITS. A subject is
considered to be influential if its exclusion causes major changes in the fitted regression
model. The rule of thumb is that if the absolute DFFITS value of the ith subject is greater than 2 times square root of p/n
then that observation is considered to be influential in causing major change in
the fitted model. (Kutner et. al, 2005).

To find observation that influence all fitted values, We used the Cook’s Distance, Di given
by: Di =
where ei are the residual values, MSE is the mean square error, hii
is the leverage values and p is the number of regression parameters. It measures the influence
of ith subject on all the n fitted values. For this research, 4
n was used as a cutoff point to
identify these observations.
Based on results from Cook’s distance and DFFIT’s all influential observations that had
an impact on the fit of our regression were removed. Table 9 demonstrates the results before
and after influential observation removal.
Model 6, also maintains the assumptions tested on model 2 previously before stepwise
selection.

# Multicolinearity
One of the last diagnostics we wanted to validate was to check for multicollinearity between
the independent variables. In order to do this, a VIF test was employed along with a
construction of conditional indices. VIF values greater than 4 is an indication that
multicollinearaity may be a problem whereas values greater than 10 are an indication of
severe multicollinearity[16]. Both VIF and conditional indices reported similar results, and a
VIF table is attached to the appendix for model 6. Variables with a VIF greater than 10
were removed, followed by corresponding variables with a VIF greater than 8.
This leads us to our final model, model 7 using the standard multiple linear regression
with an OLS estimate. Biased estimation approaches such as a ridge regression and principle
component regression was also fit in order to determine if they may be a fitter fit in explaining
the variation of crime. The optimum value of λ found for our ridge estimate was 0.086, and
the optimum number of components for PCR found was 14. More information can be found
in the appendix. Using these parameters, table 10 summarizes the output from the final
models that are the top contenders for explaining crime.

# Conclusion

In our research, a variety of models were fit in order to explain the variance of crime. We find
that selecting model 7, does the best job in explaining the variance of crime. This model
does not violate the assumptions of linear regression, has a compartively larger adjusted
R2 value than models 1-5 and has a negligble decrease in performance after treating for
multicollinearity against model 6. It also has a marginally lower MSE than model 8 and
9(Ridge and PCR) counterparts, however one can argue that the prediction accuracy of Ridge
and PCR may be better. We conclude saying that according to our model, we can roughly
explain about 72.61 percent of the variation of crime given our independent variables. The
most statistically significant variables are Percentage of children born that are never married,
Number of people below poverty line, percentage racial groups present in community, number
of non-violent crimes, living in the west/south region, percentage of adults who are highly
educated and median rent. A full summary of this result can also be found in the appendix.

# Appendix

Initial Data Variables: householdsize, racepctblack, racePctWhite, racePctAsian, racePctHisp, agePct12t21, agePct12t29, agePct16t24, agePct65up, medIncome, pctWSocSec, pctWPubAsst, pctWRetire, medFamInc, perCapInc, whitePerCap , blackPerCap, IndianPerCap, AsianPerCap, OtherPerCap, HispPerCap, NumUnderPov, PctNotHSGrad, PctBSorMore,
PctUnemployed, MalePctNevMarr, TotalPctDiv, PersPerFam, PctWorkMom, PctKidsBornNeverMar, NumImmig, PctSpeakEnglOnly, PctNotSpeakEnglWell ,PctLargHouseFam, MedNumBR, PctHousOccup, PctHousOwnOcc, PctVacMore6Mos, MedRent, NumInShelters,
PctForeignBorn, PctBornSameState, PctUsePubTrans, burglaries, larcenies, autoTheft, arsons , populationCatLarge.City, populationCatLarge.Town, populationCatMetropolis ,populationCatTown, regionsNortheast, regionsSouth, regionsWest,Violent Crimes

# References

[1]Becker, Gary S., ”Crime and Punishment: An Economic Approach,” Journal of Political
Economy 76 (1968), 169-217.

[2]Merton, Robert, ”Social Structure and Anomie,” American Sociological Review 3 (1938),
672-682.

[3]Shaw, Clifford, and Henry McKay, Juvenile Delinquency and Urban Areas (Chicago:
University of Chicago Press, 1942).

[4][Buczak and Gifford 2010] Buczak, A. L. and Gifford, C. M., Fuzzy Association Rule
Mining for Community Crime Pattern Discovery. In Workshop on Intelligence and Security
Informatics at 16th Conference on Knowledge Discovery and Data Mining (ISI-KDD-2010).
Washington DC. July 2010.

[5]Rawlings, John O., Sastry G. Pantula, and David A. Dickey. Applied Regression
Analysis: A Research Tool. 2nd ed. New York: Springer, 1998.

[6](Box, GEP. (1953). Non-normality and tests on variances. Biometrika 40:318-335.)

[7][Redmond and Highley 2009] Redmond, M., and Highley, T., Empirical Analysis of
Case-Editing Approaches for Numeric Prediction. In International Joint Conference on
Computer, Information, and Systems Sciences and Engineering (CISSE) subconference
International Conference on Systems, Computing Sciences and Software Engineering
(SCSS). University of Bridgeport, CT, December 2009.

[8]Miller, A. (2002). Subset Selection in Regression Second Edition. Chapman and
Hall/CRC, Boca Raton.

[9]Box, G. E., Cox, D. R. (1964). An analysis of transformations. Journal of the Royal
Statistical Society. Series B (Methodological), 211-252.

[10]A. E. Hoerl and R. W. Kennard. Ridge regression: Applications to nonorthogonal
problems. Technometrics, 12:69–82, 1970a.

[11]Markowski, Carol A; Markowski, Edward P. (1990). ”Conditions for the Effectiveness of
a Preliminary Test of Variance”

[12]Magel, RC; Wibowo, SH (1997). ”Comparing the Powers of the Wald-Wolfowitz and
Kolmogorov-Smirnov Tests”. Biometrical Journal. 39 (6): 665–675.

[13]Breusch, T. S.; Pagan, A. R. (1979). ”A Simple Test for Heteroskedasticity and Random
Coefficient Variation”. Econometrica. 47 (5): 1287–1294.

[14]Goldfeld, Stephen M.; Quandt, R. E. (June 1965). ”Some Tests for Homoscedasticity”.
Journal of the American Statistical Association. 60 (310): 539–547.

[15]Shapiro, S. S.; Wilk, M. B. (1965). ”An analysis of variance test for normality (complete
samples)”. Biometrika. 52 (3–4): 591–611.

[16]Fox, J. and Monette, G. (1992) Generalized collinearity diagnostics. JASA, 87, 178–183
