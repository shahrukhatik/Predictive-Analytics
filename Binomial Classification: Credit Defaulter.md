# Introduction

Let's say are given a set of data. You dont know what each of the columns mean. However, you do know that the objective of the model is to be able to predict Y.
You are given that Y is the result of a person who either defaulted on a loan or did not. 


# Source Code

```{r}
#Shahrukh Khan
#Models used: Deep Neural Network, Gradient Boosting Machines
#Notes: There are more than 2 models, but 2 were submittied. There's a lot of functions used to automate process/make it easier
# for another user and implement/edit use these models for different data.

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
########Setting up parallel(WINDOWS) Use DOMC for Mac.########
````
