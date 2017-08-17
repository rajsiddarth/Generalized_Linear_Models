rm(list = ls(all=TRUE))

#Loading data
library(RCurl)
data=read.csv("https://raw.githubusercontent.com/rajsiddarth/Generalized_Linear_Models/master/CustomerData.csv",header=T)
#Checking data
str(data)
summary(data)

#Remove Cust ID
data=subset(data,select = -CustomerID)

#Convert city to factors
data$City=as.factor(data$City)

#Convert FavoriteChannelofTransaction & FavouriteGame categories to factors
#install.packages("nnet")
#library(nnet)
#temp=data.frame(cbind(class.ind(data$FavoriteChannelOfTransaction),class.ind(data$FavoriteGame)))

#Using model.matrix for categorical variables
temp=model.matrix(data$TotalRevenueGenerated ~ data$City + data$FavoriteChannelOfTransaction + data$FavoriteGame)[,-1]
head(temp)

#Final data frame
rem_variables=c("City","FavoriteChannelOfTransaction","FavoriteGame")
temp_names=setdiff(colnames(data),rem_variables)
final_Data=cbind(data[temp_names],temp)
str(final_Data)

#Split data into train and test 
rows=seq(1,nrow(data),1)
set.seed(123)
trainRows=sample(rows,(70*nrow(data))/100)
train_Data = final_Data[trainRows,]
test_Data = final_Data[-trainRows,]

#Lin reg model on train data
lin_regmodel=lm(TotalRevenueGenerated ~ .,data=train_Data)  
summary(lin_regmodel)

#Error metrics
#install.packages("DMwR")
library(DMwR)
#On train
regr.eval(train_Data$TotalRevenueGenerated, predict(lin_regmodel,train_Data))
#On test
regr.eval(test_Data$TotalRevenueGenerated, predict(lin_regmodel,test_Data))

#Regularized models
#Convert data into matrix form to input into glm models 
data2=as.matrix(subset(final_Data,select=-TotalRevenueGenerated))
target_var=data.frame('Tot_rev'=final_Data$TotalRevenueGenerated)

train_Data2 = data2[trainRows,] 
test_Data2 = data2[-trainRows,]

#Target Varaible
y_train=target_var[trainRows,]
y_test = target_var[-trainRows,]

# Lasso Regression  using glmnet - L1 norm
install.packages("glmnet")
library(glmnet)

fit_lasso=glmnet(train_Data2,y_train,alpha=1)

plot(fit_lasso,xvar="lambda",label=TRUE)
plot(fit_lasso,xvar="dev",label=TRUE)
plot(fit_lasso,xvar="norm",label=TRUE)

#Lambda Selection using cross validation

cv_lasso=cv.glmnet(train_Data2,y_train,nfolds = 10,alpha=1)
summary(cv_lasso)
plot(cv_lasso)
coef(cv_lasso)
cv_lasso$cvm
cv_lasso$lambda.min

#Lasso Model using calculate lambda min from cross validation
final_lasso=glmnet(train_Data2,y_train,alpha = 1,lambda = cv_lasso$lambda.min)

#Error metrics
regr.eval(y_train,predict(final_lasso,train_Data2))
regr.eval(y_test,predict(final_lasso,test_Data2))

# Ridge Regression  using glmnet  - L2 norm

fit_ridge=glmnet(train_Data2,y_train,alpha=0)

plot(fit_ridge,xvar="lambda",label=TRUE)
plot(fit_ridge,xvar="dev",label=TRUE)
plot(fit_ridge,xvar="norm",label=TRUE)

#Lambda Selection using cross validation
cv_ridge=cv.glmnet(train_Data2,y_train,nfolds = 10,alpha=0)
summary(cv_ridge)
plot(cv_ridge)
coef(cv_ridge)
cv_ridge$cvm
cv_ridge$lambda.min

#Ridge Model using calculate lambda min from cross validation
final_ridge=glmnet(train_Data2,y_train,alpha = 0,lambda = cv_ridge$lambda.min)

#Error metrics
regr.eval(y_train,predict(final_ridge,train_Data2))
regr.eval(y_test,predict(final_ridge,test_Data2))

