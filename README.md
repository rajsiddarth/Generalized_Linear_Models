# Generalized Linear Models:
## Dataset
The dataset used has the following variable descriptions.The variable names are self explainatory:

- Customer ID

- City

- NoOfChildren

- MinAgeOfChild

- MaxAgeOfChild

- Tenure

- FrquncyOfPurchase

- NoOfUnitsPurchased

- FrequencyOFPlay

- NoOfGamesPlayed

- NoOfGamesBought

- FavoriteChannelOfTransaction

- FavoriteGame

 - TotalRevenueGenerated

## Objective
 Our Objective is to predict the Total Revenue generated from a particular customer using the implementations of Ridge,Lasso and Elastic net regression which is a combination of Ridge and Lasso Regression algorithms.

## Ridge Regression
Ridge regression is for L2 normalization of the weights.The hyperparameter <a href="https://www.codecogs.com/eqnedit.php?latex=\Lambda" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\Lambda" title="\Lambda" /></a> is used for tuning the algorithm which is the cost for L2-normalization of the weights.The cost function is given below.
 ![Ridge Regression Cost function](Generalized_Linear_Models/images/ridge_cost.JPG)

## Packages used

-  glmnet in R
-  sklearn in Python 
 

 
 
