## Forecasting
## Homework 3
## Written by: Robby Jeffries
## 02/21/2022

library(lmtest)

rm(list = ls())
# garbage collector
gc()

# Set working directory
setwd("~/MSEA2022/Spring 2022/ECON 5753, Forecasting/Data")
getwd()

# Import data
data <- readr::read_csv("saving_inc.csv") 

# Name the second column 'y'
names(data)[2] <- "y"
# Name the third column 'x'
names(data)[3] <- "x"

# (a) run regression
reg <- lm(formula = y~x+WAR, data = data)
summary(reg)

# (b) Test to determine whether knowledge of the war years makes a significant 
# contribution to the prediciton of personal savings beyond that provided by
# personal income.

# ANSWER: Yes. The t-statistic for X_2 = 8.490, which means that the knowledge
# of the war years makes of significant contribution to the prediction of 
# personal savings beyond that provided by personal income.

# (c) Calculate the standard error of estimation

std_error <- sqrt(deviance(reg)/df.residual(reg))
std_error

# (d) Test the significance of the regression
# For this, I will look at the F-statistic and its associated p-value. The F-statistic
# is 46.51 and its p-value is very close to zero (1.278e-07). Therefore, I 
# conclude that the regression is statistically significant.

# (e) 
# Durbin-Watson test
lmtest::dwtest(y~x+WAR, data = data)
# Fail to reject the null hypothesis that the residuals from an ordinary least-squares regression are not autocorrelated against the alternative that the residuals follow an AR1 process. 

# Breusch and Godfrey LM test
bgtest(y~x+WAR, order = 3, data = data) # if small p-value, reject null hypothesis
# Fail to reject the null hypothesis that there is no serial correlation of any order up to 3

# (f) 