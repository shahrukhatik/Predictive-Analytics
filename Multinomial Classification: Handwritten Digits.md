# Introduction

Handwriting analysis, character recognition, and graphology are all synonyms for “the study of printed and written symbols and writing systems" [1]. These topics have numerous commercial and private applications. The most well-known application of commercial handwriting analysis, is documented within the criminal justice system as a subdivision of forensic science. However, private citizens can also employ handwriting analysis in day to day life, albeit on a more superficial scale. For example, students decoding a professor's handwritten lecture notes or an executive officer reading a message receipt provided by a secretary. Each of these scenarios, both commercial and private, rely on “the principle that no two individuals can produce exactly the same handwriting and that an individual can not exactly reproduce their own handwriting, due to natural deviations otherwise known as variation."[2]

The purpose of this project is “to construct a classifier that will predict the letter of a handwritten character based on a 56 by 56 bitmap [3]”. To do so, two data sets are given, defined as “Labeled” and “Unlabeled”. The Labeled data set contains 1,000 rows and 3,138 columns. The first column is the observation number, which will be ignored throughout the project. This is because each observation is contained within a single row, and isn’t a meaningful predictor. The second column is the character observation, denoted “Letter”. Characters are defined to be single digit alpha-numeric. The remaining 3,136 columns represent individual pixels in a 56x56 bitmap. The column values are binary, denoting “1” for shaded pixels, and “0” for non-shaded or empty pixels. The Unlabeled data set contains 10,000 rows and 3,137 columns. The first columns is the observation number, which is also ignored for the same reason stated above. The main difference between the Labeled and Unlabeled data is that, as the name suggests, there is no character observation column for each observation in the Unlabeled data set. Instead, there are only the remaining 3,136 columns to represent the individual shaded or non-shaded pixels. After reviewing the Labeled observations, it was found that of the 26 alphabetic characters assumed to be included in the data set only 25 were present, since the character “X” was omitted. 10 numeric characters were included in the Labeled data set (0-9). Figure 1 below shows the approximate distribution of the Labeled observations.

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/BarplotHW.png?raw=true" width="600" title="hover text">

# Methodology

Data Labeling Methods:
To build the final prediction model, it was determined that a sample size of only 1,000 labeled observations was quite small. To increase the number of observations used, it was important that some variation of the 10,000 unlabeled observations were included. Two methods were ultimately utilized to do this: hand labeling and modeled predictions.

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/RHW.png?raw=true" width="300" title="hover text">
  
To implement the hand labeled solution, the 10,000 unlabeled observations were divided equally amongst group members. Each row was plotted, resulting in an image resembling Figure 2. The approximate time taken was 3-4 hours per group member, and 16 hours total to label the data. Since there are time constraints on the project as a whole, and labeling the unlabeled observations was only a small part of the task, a secondary method was introduced.

The secondary method took a random sample of 4,000 observations from our hand labeled data set, and used these 4,000 hand labeled observations to predict the remaining 6,000 unlabeled observations from the Unlabeled data set, to create a total of 10,000 labeled observations from the unlabeled data set. Using an SVM model, the predictions for the 6,000 unlabeled observations were assessed by validating against the 1,000 labeled observations in the Labeled dataset. This process is best described using the Figure 3.  

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/FlowchartHW.png?raw=true" width="600" title="hover text">

It was determined that the hand labeled observations (10,000) from the unlabeled dataset had an accuracy of 90.27% while the 6,000 predicted observations had an accuracy rate of around 70%.

## Principal Compononent Analysis (PCA)

As discussed earlier, there are 3,136 pixels in the 56x56 grid of an image under study resulting in 3,136 variables in the dataset. If all the variables are to be used in building the model, it can be problematic in the sense that it would attain too much computational complexity. The other disadvantage that comes along with high dimensional data is that there would be too many pairwise correlations between the variables to consider. Principal Component Analysis can be useful in such scenario as it is a technique for feature extraction and eventually, dimensionality reduction. It combines the input variables in a specific way to create new features, after which the least important features can be dropped while still retaining the most valuable information in the data. The added benefit is that the new features generated are all orthogonal or totally uncorrelated to each other.

PCA is an unsupervised learning method in that it finds patterns without reference to the prior knowledge about the dataset. It reduces data by geometrically projecting them onto lower dimensions called principal components (PCs), with the goal of finding the best summary of the data using a limited number of PCs. This transformation process is defined in such a way that the first principal component has the largest possible variance, and each succeeding component in turn has the highest variance possible under the constraint that it is orthogonal to the preceding components. For more information on detailed workings on Principal Component Analysis, please refer to Principal Component Analysis, Series [4].
For the given dataset, principal component analysis is performed and the loadings are extracted. On observing the variance explained by each principal components, it is seen that the first principal component explains 6.67% variance within the dataset while the second principal component explains 5.34% variance within the dataset and it goes on decreasing for the remaining principal components. 80 principal components explained 70% of the variance within the data which is why 80 principal components were chosen among the 3,136 principal components generated. It is interesting to see that the first 1000 principal components explain almost 96% variation within the data which means that 2136 principal components could be dropped without losing any significant amount of information in the data. Considering the time constraint and the computational limitation for this project, 1000 principal components is too many to take into account. So, being aware about the fact that the information on 30% variance within the data will be lost, 80 principal components are taken into consideration for further analysis of this project because with this chance of losing data also comes the benefit of greatly reducing the computational complexity

Once the principal component analysis is performed in the training dataset, the loadings for the training dataset, the test dataset, and the validation dataset are generated. Now, these features are ready to be fed into the model or to be predicted from the model, as per the requirement.

## Support Vector Machines:

Support vector machines are a class of supervised learning methods that can be used for classification of both linear and non-linear data. As noted above, our data contains 35 different classes of characters, ranging from both letters and numbers. SVM’s have been successfully applied to several applications ranging from face detection [5], object recognition [6] and even detection of moving vehicles [7]. We had decided to use SVM's in an attempt to classify the predictions of letters and numbers based on SVM’s ability and prior reputation to be able to distinguish more complex data.

The basic idea of the SVMs is to construct a line, plane or “hyperplane” as the decision plane, which separates classes with the largest margin. An optimal hyperplane is a hyperplane with the maximum margin of separation between the two classes, where the margin is the sum of the distances from the hyperplane to the closest data points of each of the two classes. These closest data points are referred to as Support Vectors. Although this may be seen as impractical for implications on real-scenario data, sometimes two classes are not linearly completely separable. However, a hyperplane that maximizes the margin while minimizing a quantity proportional to the misclassification errors can still be achieved by introducing positive slack variables. For more information on detailed workings on Support Vector Machines, please refer to SVM Classification in Multiclass Letter Recognition [8].

We also used 10-Fold cross-validation to test the robustness of our model. Our model averaged about 80% accuracy while attempting to predict the test set using a default value of C =1. C was the parameter chosen by us that controlled the tradeoff between the margin and the misclassification errors. A higher C means that a higher penalty to misclassification errors is assigned whereas, for tiny values of C, we should get misclassified examples. We decided to use a smaller C with a value of 0.05, as we knew that there were letters that were bound to be misclassified regardless due to their similarity in writing structure. For example, I's and 1's, 5's and S's and O's and 0's. Choosing a small value of C would more than likely maximize the linear separation between classes that are different such as A's and F's, A and O's, etc. The highest accuracy is achieved at C = 0.05 before the values tend to decrease as the value of C is higher. Our model averaged about 82.2% accuracy while attempting to predict the test set after tuning the value of C. Our model was then used to predict cases on the original 1000 letters.. For example, our model was able to perform well predicting A's, C’s and E's but had more unsatisfactory performance in differentiating between 1's and I's, D's and O's & O's and 0's. Table 1 is a summary of our top 5 lowest and highest accuracies. As we can see from these tables, although our model does extremely well in classifying particular variables, it fails to differentiate similar letters to numbers. Our overall accuracy on the original labeled dataset is around 79.9% having a 95% confidence interval at around 77.28-82.34%. An overall summary on our accuracy metrics can be seen in Table 2.  

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/SVMTableHW.png?raw=true" width="500" title="hover text">

## KNN-Process:

The k-Nearest-Neighbors (KNN) is a non-parametric classification method. By non-parametric we mean that the KNN classification method does not assume a distribution of the data. For a specific object to be classified, its “k” nearest neighbors are retrieved and based on majority voting amongst the data in the neighborhood family; the classification of the specific object is decided. Each object is classified based on an independent trial. For this project, Euclidean distance-based weighting for identifying the nearest k- neighbors was used. In order to apply the KNN method an appropriate value for k should be chosen, and the success of classification is largely dependent on this value. This is because results may change depending on how many nearest neighbors are being classified to the respective class. KNN is often used in text mining [9], finance and agriculture [10]. The decision to use KNN arose from the assumption that a single class of characters should not have a large variance across each observation. Therefore, KNN may be an ideal model for classifying objects properly into their respective character class. For more information on the KNN process, please refer to Distance Metric Learning for Large Margin Nearest Neighbor Classification [11].

The process for choosing the best “k” value, was to run the algorithm on a 10-Fold cross-validation with different k values and choose the one with the best performance. The range of values tested on KNN spanned from 3-11. As we can see, the minimum error rate occurs at k=5, and that is the value of K we had chosen. The performance of our test set yielded about 75.44%. When we had used our model to predict the accuracy of the original set of variables (validation set), our accuracy rate was about 75.8% with a confidence interval between 73.02-78.43%. Table 3 show us how well we had predicted letters individually using the K-NN algorithm. Our overall accuracy on the validation test with KNN is about 75.8% with an upper confidence interval at around 78.4% and a lower confidence interval at 73%. Tables 3 and 4 provide a summary of this information.

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/KNNTableHW.png?raw=true" width="500" title="hover text">

## Linear Discriminant Analysis:

Linear discriminant analysis (LDA) “is a well-established machine learning technique for predicting categories. Its main advantages, compared to other classification algorithms such as neural networks and random forests, are that the model is interpretable and that prediction is easy [12]”. This is partially why LDA was chosen as a applicable model for the project, because it is quickly run and easily implemented. However, the technical goal of LDA is to take a single observation and to predict the likelihood of the observation belonging to a single class, versus any other set of classes. The class that gets the highest probability is the class that is assigned or in our case “predicted” for the observation. Since the goal of this project is to correctly classify or “predict” an observation into 1 of 36 bins (36 bins would be assuming X’s are introduced in the 30,000 observations later released), it would appear that LDA is not only easily applicable, but also well suited to the task of classifying the observations as one single character over another character.

There are some important assumptions and limitations to using LDA. The first and potentially most relevant assumption is that the data is independent and normally distributed [13]. Since the data is binary, this assumption is violated. However, this does not invalidate the accuracy of the model since the data has been transformed from the original predictor variables to principal components. Additionally, there is the limitation of multicollinearity, which states that “predictive power can decrease with an increased correlation between predictor variables” [13]. Since PCA was previously performed to enhance our variable selection, multicollinearity is essentially a non-issue. Lastly, an LDAs potential to overfit depends largely on the number of predictor variables relative to the number of samples. In this case, since there are 80 principal components and approximately 10,000 samples, the model does not appear prone to overfitting.
The overall model performance is 72.12% accuracy as seen in Table 6 below.

However the accuracy rate does vary significantly by character class. The highest class performance is for characters: J,C,L,A,S. Each of these classes has an accuracy rate at or above approximately 90%. It is worth noting that these characters tend to appear more frequently in the data distributions defined previously in the project. The worst class performance is for characters: 1,5,0,9,6. The digit 6 has the highest accuracy rate at approximately 40%. The remaining digits (1,5,0,9) fall significantly below the 40% mark, ranging to the minimum accuracy of 0%. It should be noted that each of the worst performing characters are noticeably digits, so the total count of observations is low to begin with and each subsequent misclassification ultimately represents a large portion of the overall accuracy rate. Each of these character class accuracy rates can be seen in Table 7 below.

<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/LDATableHW1.png?raw=true" width="400" title="hover text">
  
<p align="center">
  <img src="https://github.com/shahrukhatik/Predictive-Analytics/blob/master/Images/LDATableHW2.png?raw=true" width="400" title="hover text">

# Conclusion:
SVM is a popular classification method and has been used in different areas, such as classifying a letter of handwritten alphanumeric character into predefined categories. Using an optimum number of components determined after applying the PCA technique, and also choosing the best candidate kernel for building the model will reduce the computation time. In addition, better results are generated as an effect of using hand labeling the unlabeled data. The results show that the proposed method has an accuracy rate of 79.99%. Comparing the results of our chosen model (SVM) with the other candidate models; KNN, and LDA shows that SVM has a higher accuracy rate for the same input. When comparing SVM (with accuracy rate of 79.99%) with KNN (with accuracy rate of 75.64%), highest accuracy of classes in both SVM and KNN are for alphabetic characters and their lowest accuracy for the numbers, but overall accuracy of the trained SVM model is higher than trained KNN model [14]. When comparing SVM with LDA, the results show that SVM as a higher accuracy compared to LDA (with accuracy rate of 72.12%). Highest accuracy of classes in both SVM and LDA are for alphabetic characters, and LDA has better accuracy rate for classifying numbers, but overall accuracy rate of the trained SVM is higher than LDA [15]. Thus the it can be concluded that SVM has a higher accuracy for classifying the handwritten alphanumeric characters and thus is a best candidate among the investigated models.

# References:
[1]: “Graphology”. Definition 3 (linguistics). https://en.oxforddictionaries.com/

[2]: https://www.robsonforensic.com/articles/forensic-handwriting-analysis-expert

[3]: D2L - Letter recognition.pdf
This was the original source given with the problem statement.

[4]: Jolliffe I.T. Principal Component Analysis, Series: Springer Series in Statistics, 2nd ed., Springer, NY, 2002, XXIX, 487 p. 28 illus. ISBN 978-0-387-95442-4

[5]: K. Jonsson, J. Kittler, and Y.P. Matas, Support vector machines for face authentication, Journal of Image and Vision Computing, vol. 20. pp. 369-375, (2002).

[6]: F. Seraldi and J. Bigun, Retinal vision applied to facial features detection and face authentication, Pattern Recognition Letters, vol. 23, pp. 463-475, (2002).

[7]: D. Gao, J. Zhou, and Leping Xin, SVM-based detection of moving vehicles for automatic traffic monitoring, IEEE Intelligent Transportation System, pp. 745- 749, (2001).

[8]: Kaushik, Aarti, et al. SVM Classification in Multiclass Letter Recognition System. Global Journal of Computer Science and Technology Software & Data Engineering(2013).

[9]: Baoli, L., Shiwen, Y. & Qin, L. (2003) "An Improved k-Nearest Neighbor Algorithm for Text Categorization, ArXiv Computer Science e-prints.

[10]: Bauer, M.E., Burk, T.E., Ek, A.R., Coppin, P.R. Lime, S.D., Walsh, T.A., Walters, D.K., Befort, W. & Heinzen, D.F. (1994) "Satellite Inventory of Minnesota’s Forest Resources", Photogrammetric Engineering and Remote Sensing, 60(3): 287–298.

[11]: K.Q. Weinberger and L.K. Saul. Distance metric learning for large margin nearest neighbor classification. Journal of Machine Learning Research, 10(Feb):207–244, 2009.

[12]: https://www.r-bloggers.com/linear-discriminant-analysis-in-r-an-introduction/

[13]: https://en.wikipedia.org/wiki/Linear_discriminant_analysis

[14]: https://www.ijraset.com/fileserve.php?FID=11852

[15] https://stats.stackexchange.com/questions/243932/what-is-the-difference-between-svm-and-lda

# Source Code

```{r}
###############################################################################################
#################################### "Handwritten Data Project"###################################
###############################################################################################

##Clear the R environment, if required
rm(list = ls())


#####################################################################################
#####################Install the libraries, if required##############################
#####################################################################################

if(!require(ggplot2))install.packages("ggplot2")
if(!require(gridExtra))install.packages("gridExtra")
if(!require(ggfortify))install.packages("ggfortify")
if(!require(caret))install.packages("caret")
if(!require(plyr))install.packages("plyr")


###########################################################################################
###################Read the datasets and split into training and test sets#################
###########################################################################################

##Set the working directory
setwd("C:/Users/Santosh Chapagain/OneDrive/SDSU Courses/SDSU SP 2019/Modern Applied Statistics II/Final Project/Final Project")

###The labeled data given to us was used to build models and the unlabled data was predicted from those models
###The test accuracy was itself not good, so, we had to find other ways to label the unlabeled data
###Complete the description
###Define what labeled data is and what validation data is for us

##Read the labeled dataset
labeledletters<-read.csv("Labels_1_to_10000V3.csv",
                         header=TRUE,
                         sep=",")

##Read the validation Dataset
validationset <- read.csv("original.letters.labeled.csv",
                          header=TRUE,
                          sep=",")

#Ignore the rownames if there is any
rownames(validationset) <- NULL

#Omit the rows with missing values
labeledletters <- na.omit(labeledletters)

#Convert the letter into lower cases if it is otherwise, for the sake of consistency
labeledletters$Letter <- tolower(labeledletters$Letter)

#Convert the class of the lable to factor
labeledletters$Letter <- as.factor(labeledletters$Letter)

###Splitting from train
set.seed(123)

##create a sample size
smp_size <- floor(0.70 * nrow(labeledletters))

#Create the train indices
train_ind <- sample(seq_len(nrow(labeledletters)), 
                    size = smp_size)

#Create the train and test datasets
train <- (labeledletters)[train_ind, ]
test <- (labeledletters)[-train_ind, ]

#Observe the distribution of the labels in the original data, the train data and test data
plot1<- ggplot(labeledletters, 
               aes(x = Letter, 
                   y = (..count..)/sum(..count..))) + 
        geom_bar(fill="red") + 
        theme_bw() +
        labs(y = "Relative frequency", 
             title = "Unlabeled dataset") + 
        scale_y_continuous(labels=scales::percent, 
                           limits = c(0 , 0.15)) +
        geom_text(stat = "count", 
                  aes(label = scales:: percent((..count..)/sum(..count..)), 
                      vjust = -1), 
                  size=3)+
        theme(axis.text=element_text(size=12),
              axis.title = element_text(size=12, face="bold"),
              plot.title = element_text(hjust = 0.5, size = 14, face="bold"))

plot2<- ggplot(train, 
               aes(x = Letter, 
                   y = (..count..)/sum(..count..))) + 
        geom_bar(fill="navyblue") +
        theme_bw() +
        labs(y = "Relative frequency", 
             title = "Train dataset for unlabeled data") + 
        scale_y_continuous(labels=scales::percent, 
                           limits = c(0 , 0.15)) +
        geom_text(stat = "count", 
                  aes(label = scales:: percent((..count..)/sum(..count..)), 
                      vjust = -1), 
                  size=3)+
        theme(axis.text=element_text(size=12),
        axis.title = element_text(size=12, face="bold"),
        plot.title = element_text(hjust = 0.5, size = 14, face="bold"))

plot3<- ggplot(test, 
               aes(x = Letter, 
                   y = (..count..)/sum(..count..))) + 
        geom_bar(fill="purple") + 
        theme_bw() +
        labs(y = "Relative frequency", 
             title = "Test dataset for unlabeled data") + 
        scale_y_continuous(labels=scales::percent, 
                           limits = c(0 , 0.15)) +
        geom_text(stat = "count", 
                  aes(label = scales:: percent((..count..)/sum(..count..)), 
                      vjust = -1), size=3)+
        theme(axis.text=element_text(size=12),
        axis.title = element_text(size=12, face="bold"),
        plot.title = element_text(hjust = 0.5, size = 14, face="bold"))


plot4 <- ggplot(validationset, 
                aes(x = Letter, 
                    y = (..count..)/sum(..count..))) + 
  geom_bar(fill="forest green") + 
  theme_bw() +
  labs(y = "Relative frequency", 
       title = "Labeled dataset") + 
  scale_y_continuous(labels=scales::percent, 
                     limits = c(0 , 0.15)) +
  geom_text(stat = "count", 
            aes(label = scales:: percent((..count..)/sum(..count..)), 
                vjust = -1), size=3)+
  theme(axis.text=element_text(size=12),
        axis.title = element_text(size=12, face="bold"),
        plot.title = element_text(hjust = 0.5, size = 14, face="bold"))



#Plot the above 3 plots together
grid.arrange(plot4,plot1, plot2, plot3, nrow=4)


############################################################################################################
######################################### Exploratory Analysis################################
############################################################################################################

#checking accuracy of hand labeling
labeled2 <- validationset
setwd("/Data/")
cvletters<-read.csv("manual1000.csv",header=TRUE,sep=",")
#dim(cvletters)


combo <- cbind(cvletters,labeled2)
#dim(combo)

#tail(combo)
#levels(combo$obs)==levels(combo$Letter)
combo$match <- ifelse(combo$Letter == combo$obs, 0, 1)

#length(levels(combo$obs))
#length(levels(combo$Letter))

accuracyofhlon1000 <- (1-((sum(combo$match==1))/nrow(combo)))*100
accuracyofhlon1000

#checking accuracy of each class

improperlylabeled <- subset(combo, match==1)
properlylabeled <- subset(combo, match==0)

a = count(combo, 'Letter')

y = count(improperlylabeled, 'Letter')
newy<- merge(x=y,y=a,by=c("Letter"))
colnames(newy) <- c("Letter", "No.C", "Total")
z = count(properlylabeled, 'Letter')
newz<- merge(x=z,y=a,by=c("Letter"))
colnames(newz) <- c("Letter", "No.C", "Total")

#Claculating misclassification and correct classification percantage
newy$misclass <- round((newy$No.C/newy$Total)*100,2)
newz$class <- round((newz$No.C/newz$Total)*100,2)

newy
newz

#Number of properly labeled versus improperly labeled
ma=count(combo,'match')
ma

ggplot(newy, aes(x=Letter,y=No.C))+geom_col()+labs(title="Graph for Incorrectly Labeled Observations (by %)", x="Alpha-Numeric Class", y="Number of Misclassified")

ggplot(newy, aes(x=Letter,y=misclass))+geom_col()+labs(title="Graph for Incorrectly Labeled Observations (by %)", x="Alpha-Numeric Class", y="Number of Misclassified by %")


ggplot(newz, aes(x=Letter,y=No.C))+geom_col()+labs(title="Graph for Correctly Labeled Observations (count)", x="Alpha-Numeric Class", y="Number of Misclassified")

ggplot(newy, aes(x=Letter,y=No.C))+geom_col(colour = "black",fill="red")+labs(title="Graph for Incorrectly Labeled Observations (count)", x="Alpha-Numeric Class", y="Number of Misclassified")

ggplot(newy, aes(x=Letter,y=misclass))+geom_col(colour = "black",fill="red")+labs(title="Graph for Incorrectly Labeled Observations (by %)", x="Alpha-Numeric Class", y="Number of Misclassified by %")


ggplot(newz, aes(x=Letter,y=No.C))+geom_col(colour = "black", fill="light blue")+labs(title="Graph for Correctly Labeled Observations (count)", x="Alpha-Numeric Class", y="Number of Classified")


ggplot(data.frame(newz), aes(x=Letter, y=class)) + geom_col(colour = "black", fill="light blue")+labs(title="Graph for Correctly Labeled Observations %", x="Alpha-Numeric Class", y="% Classified")



####################################################################################
##############################Dimension Reduction::PCA##############################
####################################################################################

# conduct PCA on training dataset
X <- train[,-1]
Y <- train[,1]

#Reducing Train using PCA
train_reduced <- X
pcaX <- prcomp(train_reduced)

#Plot the first two Principal Components, and see if they make any sense
##Library ggfortify does the job. Plots the first two PCs
autoplot(pcaX, data=train, colour='Letter', title="Principal component Score Plot")  

# Creating a datatable to store and plot the No of Principal Components vs Cumulative Variance Explained
vexplained <- as.data.frame(pcaX$sdev^2/sum(pcaX$sdev^2))
vexplained <- cbind(c(1:3136),vexplained,cumsum(vexplained[,1]))
colnames(vexplained) <- c("No_of_Principal_Components",
                          "Individual_Variance_Explained",
                          "Cumulative_Variance_Explained")

#Plotting the curve using the datatable obtained
plot(vexplained$No_of_Principal_Components,
     vexplained$Cumulative_Variance_Explained*100, 
     xlim = c(0,3000),type='b',pch=16,
     xlab = "Principal Components",
     ylab = "Cumulative Variance Explained (%)",
     main = 'Principal Components vs Cumulative Variance Explained')
abline(h=vexplained$Cumulative_Variance_Explained[80]*100, 
       v = vexplained$No_of_Principal_Components[80],
       col='red',lwd=2,lty=5)


#define where to stop plotting PCs
cut <- 2000
#Plot the Cum. variance explained by the 'cut' number of PCs
plot(vexplained$No_of_Principal_Components[1:cut],
     vexplained$Cumulative_Variance_Explained[1:cut], 
     xlim = c(0,cut),type='b',pch=16,
     xlab = "Principal Componets",
     ylab = "Cumulative Variance Explained",
     main = 'Principal Components vs Cumulative Variance Explained')
abline(h=vexplained$Cumulative_Variance_Explained[80], 
       v = vexplained$No_of_Principal_Components[80],
       col='red',lwd=2,lty=5)

#Datatable to store the summary of the datatable obtained
vexplainedsummary <- vexplained[seq(0,100,10),]
vexplainedsummary <- vexplainedsummary[-2] #Drop the second column

##Create a PCA matrix for the train data
train_PCA_matrix <- as.matrix(train_reduced) %*% pcaX$rotation[,1:80]
##convert the matrix to dataframe
train_PCA <- data.frame(train_PCA_matrix)
##Append the classes to the trainPCA data
train_PCA$Letter <- train[,1]

#Remove the classes from the test data
test_reduced <- test[,-1]
#Create a PCA matrix for the test data
test_PCA_matrix <- as.matrix(test_reduced) %*% pcaX$rotation[,1:80]
#Convert the matrix to a dataframe
test_PCA <- data.frame(test_PCA_matrix)
#Append the classes to the testPCA data
test_PCA$Letter <- test[,1]

#Same approach as above for the validation dataset
validationset_reduced <- validationset[,-1]
validationset_PCA_matrix <- as.matrix(validationset_reduced) %*% pcaX$rotation[,1:80]
validationset_PCA <- data.frame(validationset_PCA_matrix)
validationset_PCA$Letter <- validationset[,1]


#####################################################################################################
##################################### MODEL DEVELOPMENT #############################################
#####################################################################################################


#####################################################################################################
##################################### MODEL 1: SVM with Linear Kernel################################
#####################################################################################################


## Support Vector Machines with Linear Basis Function Kernel
#Let's call the number of classes N. The samples of your data-set is called M.
###NC35
# Say you have 35 classes. The OVO ensemble will be composed of 595 (= 35 * (34) / 2) binary classifiers. 
#The first will discriminante A from B, the second A from C, and the third B from C.. etc. 
#Now, if x is to be classified, x is presented to each binary classifier of the ensemble to create a vector of individual classifications, e.g. (A, B, B). 
#The final step to assign a label to x is the majority voting. In this example, x would belong to class B.


#The cost was optimized to 0.05. Optimization is performed below.
Linear_grid <- expand.grid(C = c(0.05))

#10-fold Cross-validation
trctrl <- trainControl(method = "cv", number = 10)

#SVM with linear kernel
svm_Linear <- train(Letter ~., 
                    data = train_PCA, 
                    method = "svmLinear",
                    trControl=trctrl,
                    tuneGrid = Linear_grid)


#SVM with linear kernel
svm_Linear <- train(Letter ~., 
                    data = train, 
                    method = "svmLinear",
                    trControl=trctrl,
                    tuneGrid = Linear_grid,
                    preProcess=c('pca','center','scale'))


#Linear grid to optimize the Cost
# Linear_grid_test <- expand.grid(C = c(0.01,0.025,0.05,0.75,1))



#Optimize the SVM with Linear Kernel
# svm_Linear_test <- train(Letter ~., 
#                          data = train_PCA, 
#                          method = "svmLinear",
#                          trControl=trctrl,
#                          tuneGrid = Linear_grid_test)


#plot(svm_Linear_test)


#Predict the test data using SVM model with Linear Kernel
test_pred_Linear <- predict(svm_Linear, newdata = test_PCA)

#Predict the Validation data using SVM model with Linear Kernel
test_pred_Linear2 <- predict(svm_Linear, newdata = validationset_PCA)

#Build a Confusion Matrix for the test result
cf_matrix_linear <- confusionMatrix(test_pred_Linear,test_PCA$Letter)

#Build a Confusion Matrix for the Validation result
cf_matrix_linear2 <- confusionMatrix(test_pred_Linear2,validationset_PCA$Letter)


#Function to Plot Confusion Matrix in GGPLOT
plotConfusionMatrix <- function(cf_matrix){
  cmf <- as.data.frame(cf_matrix$table)
  colnames(cmf)<- c("Reference","Prediction","Freq")
  cm.gg <- ggplot(cmf)+
    geom_tile(aes(x=Prediction,y=Reference, fill=Freq))+
    scale_x_discrete(name="Reference (Actual)", position="top")+
    scale_y_discrete(name="Predicted", limits=rev(levels(cmf$Prediction)))+
    geom_text(aes(x=Prediction,y=Reference,label=Freq),color="white",size=4.5)
    print(cm.gg)+
    ggtitle("Confusion Matrix")+
    theme(plot.title = element_text(size=18, face="bold", hjust = 0.5),
            axis.text = element_text(size=16),
            axis.title = element_text(size=16))
}

#Plot the confusion matrix for test data set predicted with SVM Linear Kernel
plotConfusionMatrix(cf_matrix_linear)
###Overall accuracy obtained is ________%

##Overall Accuracy for the test dataset
cf_matrix_linear$overall


#Plot the confusion matrix for Validation data set predicted with SVM Linear Kernel
plotConfusionMatrix(cf_matrix_linear2)
###Overall accuracy obtained is ________%

##Overall Accuracy for the validation dataset
cf_matrix_linear2$overall


#Function to find out the class based accuracy
class_accuracy <- function(cf_object){
  class_acc<- vector("list",35)
  for( i in 1:35){
    
    class_acc[[i]] <- round(cf_object$table[i,i]/sum(cf_object$table[,i])*100,2)
    
    #print(class_acc)
    
  }
  class_acc <- data.frame(as.matrix(class_acc))
  class_acc <- cbind(unique(as.data.frame(cf_object$table)$Prediction),class_acc)
  colnames(class_acc) <- c("Class","Accuracy")
  rownames(class_acc) <- NULL
  class_acc
}


#Find the class-based accuracy for the test data predicted using SVM Linear Kernel
class_accuracy(cf_matrix_linear)

#Find the class-based accuracy for the validation data predicted using SVM Linear Kernel
class_accuracy(cf_matrix_linear2)


# test_pred_Linear2 <- predict(svm_Linear, newdata = validationset_PCA)
##78.79147 10 FOLD
# SvmLinear_AccRate2
##79.69984 10 FOLD

# ##############################################################################################
# ############################## Model 2: SVM with Radial Kernel ###############################
# ##############################################################################################
# 
# 
# ####svmRadial tunes over cost and uses a single value of sigma based on kern lab's sigest function. 
# ###For grid search, tuneLength is the number of cost values to test and for random search it is the total number of (cost, sigma) pairs to evaluate.
# 
# grid_radial <- expand.grid(sigma = c(0.006760242),C = c(4))
# 
# svm_Radial <- train(Letter ~., data = train_PCA, method = "svmRadial",trControl=trctrl,tuneGrid=grid_radial)
# trctrl <- trainControl(method = "cv", number = 2)
# # svm_Radial_test <- train(Letter ~., data = train_PCA, method = "svmRadial",trControl=trctrl,tuneLength=10)
# test_pred_Radial <- predict(svm_Radial, newdata = test_PCA)
# test_pred_Radial2 <- predict(svm_Radial, newdata = validationset_PCA)
# cf_matrix_radial <- confusionMatrix(test_pred_Radial,test_PCA$Letter)
# cf_matrix_radial2 <- confusionMatrix(test_pred_Radial2,validationset_PCA$Letter)
# # plot(svm_Radial_test)
# 
# #Plot the confusion matrix for test data set predicted with SVM Radial Kernel
# plotConfusionMatrix(cf_matrix_radial)
# ###Overall accuracy obtained is ________%
# 
# ##Overall Accuracy for the test dataset
# cf_matrix_radial$overall
# 
# 
# #Plot the confusion matrix for Validation data set predicted with SVM Radial Kernel
# plotConfusionMatrix(cf_matrix_radial2)
# ###Overall accuracy obtained is ________%
# 
# ##Overall Accuracy for the validation dataset
# cf_matrix_radial2$overall
# 
# 
# #Find the class-based accuracy for the test data predicted using SVM Radial Kernel
# class_accuracy(cf_matrix_radial)
# 
# #Find the class-based accuracy for the validation data predicted using SVM Linear Kernel
# class_accuracy(cf_matrix_radial2)


#####################################################################################################
############################## Model3: Linear Discriminant Analysis #########################################
#####################################################################################################

trctrl <- trainControl(method = "cv", number = 10)
LDA_Model <- train(Letter ~., data = train_PCA, method = "lda",trControl=trctrl)
LDA_Predict <- predict(LDA_Model, newdata = test_PCA)
LDA_Matches <- LDA_Predict == test_PCA$Letter
LDA_AccRate<- (sum(LDA_Matches, na.rm = TRUE) / nrow(test_PCA)) * 100
LDA_AccRate
LDA_Predict2 <- predict(LDA_Model, newdata = validationset_PCA)

cf_matrix_lda <- confusionMatrix(LDA_Predict, test_PCA$Letter)
cf_matrix_lda2 <- confusionMatrix(LDA_Predict2, validationset_PCA$Letter)

class_accuracy(cf_matrix_lda)
class_accuracy(cf_matrix_lda2)

plotConfusionMatrix(cf_matrix_lda)

plotConfusionMatrix(cf_matrix_lda2)

######################################################################################################
############################################### Model4: KNN ##########################################
######################################################################################################

trctrl <- trainControl(method = "cv", number = 10)
grid_knn <- expand.grid(k = c(5))
KNN_Model <- train(Letter ~ ., data = train_PCA, method = "knn",tuneGrid = grid_knn,trControl=trctrl)
KNN_Predict <- predict(KNN_Model, newdata = test_PCA)
KNN_Predict2 <- predict(KNN_Model, newdata = validationset_PCA)
cf_matrix_knn <- confusionMatrix(KNN_Predict,test_PCA$Letter)
cf_matrix_knn2 <- confusionMatrix(KNN_Predict2,validationset_PCA$Letter)
# trctrl <- trainControl(method = "cv", number = 2)
# grid_knn_test <- expand.grid(k = c(3,5,7,9,11))
# KNN_Model_test <- train(Letter ~ ., data = train_PCA, method = "knn",tuneGrid = grid_knn_test,trControl=trctrl)
# plot(KNN_Model_test)

#Plot the confusion matrix for test data set predicted with KNN
plotConfusionMatrix(cf_matrix_knn)
###Overall accuracy obtained is ________%

##Overall Accuracy for the test dataset
cf_matrix_knn$overall


#Plot the confusion matrix for Validation data set predicted with KNN
plotConfusionMatrix(cf_matrix_knn2)
###Overall accuracy obtained is ________%

##Overall Accuracy for the validation dataset
cf_matrix_knn2$overall


#Find the class-based accuracy for the test data predicted using KNN
class_accuracy(cf_matrix_knn)

#Find the class-based accuracy for the validation data predicted using KNN
class_accuracy(cf_matrix_knn2)
```

# Contributors

Shahrukh Khan, Samantha Nystrom, Santosh Chapagain
