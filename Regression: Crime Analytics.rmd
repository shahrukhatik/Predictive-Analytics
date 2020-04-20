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

## Exploratory Analysis

Exploratory analysis was performed to view the general trends of the data and to view where the highest number of responses were coming from. Demonstrated from Figure 1,
most data is reported from relatively smaller populated areas (Large Towns and Towns, which have populations less than 100000). From table 2, it can be seen that in the 1990’s
the highest average violent crimes per population were reported in District of Columbia followed by Maryland and Louisiana. Our initial exploratory analysis supported our final
findings which may be viewed in the appendix (Model 7, Final Findings). Population density and region both attributed to explain variations of crime rates.
