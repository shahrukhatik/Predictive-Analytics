# Introduction

Let's say are given a set of data. You dont know what each of the columns mean. However, you do know that the objective of the model is to be able to predict Y. You are given that Y is the result of a person who either defaulted on a loan or did not. This project is data that is given by a local insurance company for analysis. The data can be found in the data folder.

# Loading Packages & Cleaning Data

The first chunk of code that is seen is to load the neccessary packages for analysis. It will detect packages that are not installed on any of the machine and install the neccessary libraries from CRAN. 

```{r}

set.seed(112233)

########Detect Packages in System and Install if not found########

list.of.packages <- c("dplyr", "ggplot2","stringr","nortest","caret","mlbench","robustHD","MASS","gridExtra","glmnet","doParallel","parglm","corrplot")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

########Loading Libraries########
library(ggplot2)
library(plyr)
library(stringr)
library(nortest)
library(dplyr)
library(caret)
library(mlbench)
library(robustHD)
library(MASS)
library(glmnet) ## this requires R 3.6
library(gridExtra)
library(doParallel)
library(parglm)
library(corrplot)
````
After exploring the dataset and observing the summaries, it was found that there are many records in the data that are missing. 
Categorical data that are missing will be removed from the dataset(accounts for less that 0.5% of all data) and numerical data will be imputed based on normality. Mean is imputed for random variables which are normally distributed, median otherwise for robustness. Normality allows for a Best linear unbiased estimator (BLUP), which is important for modeling tasks. In this scenario the Maximum Likelihood Estimate (MLE) = Ordinary Least Squares (OLS) estimate. The functions below clean the data, impute for missing values and scale the data, prepping it for modeling. The assumption remains that if test/holdout data follows a similar distribution as our train/valid data, a good model constructed on the training/validation sets should perform similar. To assess normality, an anderson darling test was carried out across all numeric columns of the data. The null hypothesis of this test (H0) is that the data follows the normal distribution while the alternate (H1) is that data do not follow the normal distribution. Based on the normality, as mentioned before, mean or median is computed for their respective column. In addition, a few categorical variables were prone to human error. For example x41 seemed like a financial accounting metric, and therefore '$' was removed and the column was transformed into a numeric column. Weekday/Month columns were also concatenated into similar entries, for example, "Fri" to "Fridays" instead of having both "Fri" and "Fridays". The functions below carry out all of these tasks, and the only parameter it takes is the respective data.

````{r}
CleanTrain_Process <- function(D) {
  D <- stringr::str_c(D)
  getwd()
  ##Importing the data
  setwd("/Users/shahrukhkhan/Desktop/Statefarm/") ##Set this to where the data is on your personal system
  Ddata <- read.csv(D)
  ##Observing the data
  # str(Ddata, list.len=ncol(Ddata))
  # summary(Ddata) 
  
  ##x41 seemes like a financial accounting metric, removing '$' and turning column into numeric.
  Ddata$x41 <- gsub('\\$', '',Ddata$x41)
  Ddata$x41 <- as.numeric(Ddata$x41)
  
  ## Setting up data for Anderson-Darling Test
  ##H0: The data follows the normal distribution
  ##H1: The data do not follow the normal distribution
  
  Ddata$y <- as.factor(Ddata$y)
  Ddata_numeric <- select_if(Ddata, is.numeric)
  numeric_vnames <- colnames(Ddata_numeric) 
  Ddata_factor <- select_if(Ddata, is.factor)
  
  ## Following carries out a Anderson Darling test for each of our random variables and reports back in a table
  ## with respective t-values and the decision to reject/fail to reject null.
  options(scipen=999)
  l=1
  alpha <- 0.05
  comparison <- c()
  decision <- c()
  ander.test <- c()
  options(warn=-1)
  for(l in 1:ncol(Ddata_numeric)) {
    ander.test[l] <- ad.test(Ddata_numeric[,l])[2]
    comparison[l] <- cbind(ander.test[l],alpha)
    decision[l] <- ifelse(ander.test[l] > alpha,"R","FTR")
    normality_test <- cbind(numeric_vnames,ander.test,decision)
    normality_test <- as.data.frame(normality_test)
    normality_test$ander.test <- round(as.numeric(normality_test$ander.test), digits =3)
    normality_test
  }
  ##Making a dataframe
  normality_test <- as.data.frame(normality_test)
  
  ## Depending on the results from the AD test, impute missing values by either mean or median.
  ## Mean for normal distribution, Median for any other distributions for robustness
  for(i in 1:nrow(normality_test)){
    Ddata_numeric[is.na(Ddata_numeric[,i]), i] <- ifelse(normality_test[i,1] == colnames(Ddata_numeric)[1] & normality_test[i,3] == "R",mean(Ddata_numeric[,i], na.rm = TRUE),median(Ddata_numeric[,i], na.rm = TRUE))
    Ddata_numeric
  }
  
  ##Scaling the data
  Ddata_numeric <- scale(Ddata_numeric)
  Ddata <- cbind(Ddata_numeric,Ddata_factor)
  ## No NA's for categorical variables. No need to remove. Typo's for categoric variables. Fixing those.
  Ddata <- Ddata %>% mutate(x35 = str_replace(x35, "fri\\b", "friday")) %>% mutate(x35 = str_replace(x35, "wed\\b", "wednesday")) %>% mutate(x35 = str_replace(x35, "thur\\b", "thursday"))%>% mutate(x35 = str_replace(x35, "thurday\\b", "thursday")) %>% mutate(x35 = str_replace(x35, "thurday\\b", "thursday")) %>% mutate(x45 = str_replace(x45, "-0.0%", "0.0%"))
  Ddata <- Ddata[-which(Ddata$x34==""),]
  Ddata <- Ddata[-which(Ddata$x35==""),]
  Ddata <- Ddata[-which(Ddata$x45==""),]
  Ddata <- Ddata[-which(Ddata$x68==""),]
  ########Preparing for Feature Selection / Model Building ########
  
  Ddata_matrix <- model.matrix(y~.,data=Ddata)
  Ddata_matrix <- Ddata_matrix[,-1]
  Ddata_matrix <- as.data.frame(Ddata_matrix)
  Ddata_matrix <- cbind(Ddata$y,Ddata_matrix)
  colnames(Ddata_matrix)[1] <- "Y"
  Ddata_matrix <- as.data.frame(Ddata_matrix)
  index_cols <- grep("%", colnames(Ddata_matrix))
  colnames(Ddata_matrix)[index_cols[1]] <- "x45n001"
  colnames(Ddata_matrix)[index_cols[2]] <- "x45n002"
  colnames(Ddata_matrix)[index_cols[3]] <- "x45n003"
  colnames(Ddata_matrix)[index_cols[4]] <- "x45n004"
  colnames(Ddata_matrix)[index_cols[5]] <- "x45p000"
  colnames(Ddata_matrix)[index_cols[6]] <- "x45p001"
  colnames(Ddata_matrix)[index_cols[7]] <- "x45p002"
  colnames(Ddata_matrix)[index_cols[8]] <- "x45p003"
  colnames(Ddata_matrix)[index_cols[9]] <- "x45p004"
  Dsample <- Ddata_matrix[sample(nrow(Ddata_matrix), 5000), ]
  X <- model.matrix(~.,data=Ddata_matrix)
  X <- X[,-(1:2)]
  Y <- Ddata$y
  return(list(Ddata_matrix,Ddata,X,Y))
}
CleanTest_Process <- function(D) {
  ##Importing the data
  setwd("/Users/shahrukhkhan/Desktop/Statefarm/") ##Set this to where the data is on your personal system
  Ddata <- read.csv(D)
  ##Observing the data
  # str(Ddata, list.len=ncol(Ddata))
  # summary(Ddata) 
  
  ##x41 seemes like a financial accounting metric, removing '$' and turning column into numeric.
  Ddata$x41 <- gsub('\\$', '',Ddata$x41)
  Ddata$x41 <- as.numeric(Ddata$x41)
  
  ## Setting up data for Anderson-Darling Test
  ##H0: The data follows the normal distribution
  ##H1: The data do not follow the normal distribution
  
  Ddata_numeric <- select_if(Ddata, is.numeric)
  numeric_vnames <- colnames(Ddata_numeric) 
  Ddata_factor <- select_if(Ddata, is.factor)
  
  ## Following carries out a Anderson Darling test for each of our random variables and reports back in a table
  ## with respective t-values and the decision to reject/fail to reject null.
  options(scipen=999)
  l=1
  alpha <- 0.05
  comparison <- c()
  decision <- c()
  ander.test <- c()
  options(warn=-1)
  for(l in 1:ncol(Ddata_numeric)) {
    ander.test[l] <- ad.test(Ddata_numeric[,l])[2]
    comparison[l] <- cbind(ander.test[l],alpha)
    decision[l] <- ifelse(ander.test[l] > alpha,"R","FTR")
    normality_test <- cbind(numeric_vnames,ander.test,decision)
    normality_test <- as.data.frame(normality_test)
    normality_test$ander.test <- round(as.numeric(normality_test$ander.test), digits =3)
    normality_test
  }
  ##Making a dataframe
  normality_test <- as.data.frame(normality_test)
  
  ## No NA's for categorical variables. No need to remove. Typo's for categoric variables.
  ## Depending on the results from the AD test, impute missing values by either mean or median.
  ## Mean for normal distribution, Median for any other distributions for robustness
  for(i in 1:nrow(normality_test)){
    Ddata_numeric[is.na(Ddata_numeric[,i]), i] <- ifelse(normality_test[i,1] == colnames(Ddata_numeric)[1] & normality_test[i,3] == "R",mean(Ddata_numeric[,i], na.rm = TRUE),median(Ddata_numeric[,i], na.rm = TRUE))
    Ddata_numeric
  }
  
  ##Scaling the data
  Ddata_numeric <- scale(Ddata_numeric)
  Ddata <- cbind(Ddata_numeric,Ddata_factor)
  Ddata <- Ddata %>% mutate(x35 = str_replace(x35, "fri\\b", "friday")) %>% mutate(x35 = str_replace(x35, "wed\\b", "wednesday")) %>% mutate(x35 = str_replace(x35, "thur\\b", "thursday"))%>% mutate(x45 = str_replace(x45, "-0.0%", "0.0%")) %>% mutate(x35 = str_replace(x35, "thurday\\b", "thursday"))
  Ddata <- Ddata[-which(Ddata$x34==""),]
  Ddata$x35 <- as.factor(Ddata$x35)
  Ddata$x45 <- as.factor(Ddata$x45)
  Ddata <- Ddata[-which(Ddata$x93==""),]
  ########Preparing for Feature Selection / Model Building ########
  Ddata_matrix <- model.matrix(~.,data=Ddata)
  Ddata_matrix <- Ddata_matrix[,-1]
  Ddata_matrix <- as.data.frame(Ddata_matrix)
  Ddata_matrix <- cbind(Ddata_matrix)
  Ddata_matrix <- as.data.frame(Ddata_matrix)
  index_cols <- grep("%", colnames(Ddata_matrix))
  colnames(Ddata_matrix)[index_cols[1]] <- "x45n001"
  colnames(Ddata_matrix)[index_cols[2]] <- "x45n002"
  colnames(Ddata_matrix)[index_cols[3]] <- "x45n003"
  colnames(Ddata_matrix)[index_cols[4]] <- "x45n004"
  colnames(Ddata_matrix)[index_cols[5]] <- "x45p000"
  colnames(Ddata_matrix)[index_cols[6]] <- "x45p001"
  colnames(Ddata_matrix)[index_cols[7]] <- "x45p002"
  colnames(Ddata_matrix)[index_cols[8]] <- "x45p003"
  colnames(Ddata_matrix)[index_cols[9]] <- "x45p004"
  Dsample <- Ddata_matrix[sample(nrow(Ddata_matrix), 5000), ]
  X <- model.matrix(~.,data=Ddata_matrix)
  X <- X[,-(1)]
  return(list(Ddata_matrix,Ddata,X))
}

train_set <- CleanTrain_Process("train.csv")
traindata_matrix <- train_set[[1]]
traindata <- train_set[[2]]
X <- train_set[[3]]
Y <- train_set[[4]]

holdout_set <- CleanTest_Process("test.csv")
houldoutdata_matrix <- holdout_set[[1]]
houldoutdata <- holdout_set[[2]]
HX <- holdout_set[[3]]
````


# Exploratory Analysis

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/corrplot.png?raw=true" width="250" title="hover text">


<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/response.png?raw=true" width="250" title="hover text">
<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/carcategory.png?raw=true" width="250" title="hover text">
  </p>
  
<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/day.png?raw=true" width="250" title="hover text">
<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/month.png?raw=true" width="250" title="hover text">
   </p> 
  
<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/location.png?raw=true" width="250" title="hover text">
  

