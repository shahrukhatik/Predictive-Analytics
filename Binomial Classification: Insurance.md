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

As essential to any analysis, it is essential to explore the data. The first plot is a correlation plot of every variable available in the data. As the data consists of about 100 columns, a correlation plot of this magntitude serves the purpose of quickly visually identifying highly correlated variables. As we can see from the correlation plot below, there aren't many highly correlated variables. Light blue refers to positive correlation, while light red refers to negative corelation. As there are no dark colors on the correlation plot, it infers there are not many variables which are strongly correlated with eachother. The second plot shows us the count of the response variables. From this plot we can observe that the data is imbalanced, with much more 0's than 1's.

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/corrplot.png?raw=true" width="350" title="hover text">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/response.png?raw=true" width="350" alt="accessibility text">
</p>

From these plots below we can observe that Volkswagen cars are the highest frequency followed by Toyota. Asia is the highest location.

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/carcategory.png?raw=true" width="350" title="hover text">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/location.png?raw=true" width="350" alt="accessibility text">
</p>

Similarlily, seasonality seemingly exists, and and mid-late weekday counts are higher. 

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/day.png?raw=true" width="350" title="hover text">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/month.png?raw=true" width="350" alt="accessibility text">
</p>

# Unbalanced Data and how to tackle the problem

As we saw from the figure above, this dataset had a classical unbalanced data problem. As we're primarily interested in predicting 1's, having an absurd amount of 0's often creates the problem the accurately assessing the variation in predicting 1's. There are several methods of dealing with this issue, and for this particular problem, we'll be applying a sampling methodolgy. The two main approaches to randomly resampling an imbalanced dataset are to delete examples from the majority class, called undersampling, and to duplicate examples from the minority class, called oversampling. We'll be applying these techniques to balance the dataset, to train a more robust model.

# Feature Selection Procedures

Feature selection procedures are more often that not, a method to remove noise from data. Although many models such as Neural Networks are in their own way, a feature selection method, a pre-existing feature selection may provide a better prediction. It's always best to build models with both the full and the reduced model(from feature selection methods) and compare to for prediction/inference. For this project, Recursive Feature Elimination(RFE), LASSO and a stepwise procedure was used for feature selection. To keep the project uploaded on Github relatively simple, the LASSO feature selected codes will be posted. 

## Stepwise Procedure

A stepwise procedure was first used to find a group of variables that were significant in explaining the response. Stepwise variable selection starts with no predictors in the model and then at each step along the way either enter or remove a predictor based on the partial F-tests. The procedure stops when no more predictors can be justifiably entered or removed from the model, thereby leading to a ”final model.”

````
  model <- glm(Y ~., data = traindata_matrix, family = binomial,maxit=1000) %>% stepAIC(trace = FALSE)
  stepwisedata <- colnames(model$data)
  stepformu <- as.formula(paste(stepwisedata[1],'~',paste(stepwisedata[-1],collapse = '+')))
  step_glm <- glm(formula = stepformu, data = as.data.frame(traindata_matrix), family = binomial)
  step_feature_data <- step_glm$data
  ##Holdout similar like LASSO
````

## LASSO Procedure

The LASSO (Least Absolute Shrinkage and Selection Operator) is a method of automatic variable selection which can be used to select predictors X* of a target variable Y from a larger set of potential or candidate predictors X. Lasso was introduced in order to improve the prediction accuracy and interpretability of regression models by altering the model fitting process to select only a subset of the provided covariates for use in the final model rather than using all of them. Prior to lasso, the most widely used method for choosing which covariates to include was stepwise selection. Stepwise, however, can sometimes make prediction errors worse. 

```{r}
  folds=10
  trace=F
  alpha=1
  glmnet1<-cv.glmnet(X,Y,family='binomial',nfolds=folds,type.measure='class',alpha =alpha)
  co<-coef(glmnet1,s = "lambda.1se")
  inds<-which(co!=0)
  variables<-row.names(co)[inds]
  variables<-variables[!(variables %in% '(Intercept)')];
  lassresults <- c('Y',variables)
  lassformu <- as.formula(paste(lassresults[1],'~',paste(lassresults[-1],collapse = '+')))
  lass_glm <- glm(formula = lassformu, data = as.data.frame(traindata_matrix), family = binomial)
  lass_feature_data <- lass_glm$data
  lass_feature_data_holdout <- houldoutdata_matrix %>% dplyr::select(x1 ,x2 , x3 , x4 , x5 , x9 , x10 , x12 , x14 , x18 , x19, x20 , x21 , x22 , x24 , x25 , x27 , x29 , x30 , x31 , x33 , x37 , x38 , x40 , x41 , x43 , x44 , x47 , x49 , x50 , x51 , 
 x52 , x56 , x57 , x58 , x61 , x63 , x66 , x70 , x71 , x72 , x73 , x74 , x75 , x77 , x78 , x79 , x80 , x83 , x85 , x86 , 
x91 , x94 , x95 , x96 , x97 , x98 , x99 , x34chevrolet ,x35monday , x35thursday , x35tuesday , x35wednesday , x45n001 , 
x45n002 , x45n003 , x45p000 , x45p001 , x45p002 , x68Aug ,x68Dev , x68Jun , x68Mar , x68May , x68Nov , x68Oct , x68sept.)
 ```
 
## Recursive Feature Elimination

Recursive feature elimination (RFE) is a feature selection method that fits a model and removes the weakest feature (or features) until the specified number of features is reached.

```{r}
RFE_model <- rfe(x, Y,
             sizes = 10:20,
             rfeControl = rfeControl(functions = lmFuncs, 
             number = 15))
RFE_model$variables
##Holdout similar like LASSO
```

# Influential Point Detection

Our next aspect of trying to improve the fit of the model involved identifying and inspecting leverage, outlier and influential observations. A leverage value is considered large if it is more than twice the mean leverage.
Standardized residual (internally studentized) is the residual divided by estimated standard deviation. As a rule of thumb, the standardized residual greater than 3 may indicate that the point is an outlier. After identifying individuals that were both a combination of an outlier and an influential point, these observations were removed.

````
  #1. Lasso
  HighLeverage_Lasso <- cooks.distance(lass_glm) > (4/nrow(lass_feature_data))
  LargeResiduals_Lasso <- rstudent(lass_glm) > 3
  lass_feature_data_or <- lass_feature_data[!HighLeverage_Lasso & !LargeResiduals_Lasso,]
  ````
