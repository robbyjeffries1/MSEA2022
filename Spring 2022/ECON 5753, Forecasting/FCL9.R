## Forecasting
## Lecture 9
## Written by: Robby Jeffries
## 02/17/2022

library(lmtest)

# garbage collector
rm(list = ls())
gc()
getwd()

# Set working directory
setwd("~/MSEA2022/Spring 2022/ECON 5753, Forecasting/Data")

# Import data
data <- readr::read_csv("saving_inc.csv") 

# Name the second column 'y'
names(data)[2] <- "y"
# Name the third column 'x'
names(data)[3] <- "x"

# Durbin-Watson Test (DW Statistic)
lmtest::dwtest(y~x, data = data)

# Ljung-Box Q Statistic

# Step 1: run regression
reg <- lm(formula = y~x, data = data)

# Step 2: take out the residual and run test
# Null hypothesis: no serial corr up to order three.
Box.test(residuals(reg), lag = 3, type = "Ljung-Box") # if small p-value, reject null hypothesis

# Breusch and Godfrey LM test
bgtest(y~x, order = 3, data = data) # if small p-value, reject null hypothesis
