## Forecasting
## Lecture 10
## Written by: Robby Jeffries
## 02/22/2022

library(lmtest)
library(car)
library(tseries)
library(forecast)

# garbage collector
rm(list = ls())
gc()
getwd()

# Set working directory
setwd("~/MSEA2022/Spring 2022/ECON 5753, Forecasting/Data")

# Import data
data <- readr::read_csv("hprice1.csv") 

# Model 1
m1 <- lm(formula = price~lotsize+bdrms+sqrft, data = data)
summary(m1)
res <- residuals(m1)

# FCL10, Notability 51:30, 11:59 AM
car::linearHypothesis(m1,"lotsize=bdrms") # according to p-value, we cannot reject
tseries::jarque.bera.test(residuals(m1))
lmtest::resettest(m1, power = 2:3, type = c("fitted"), data = data)
lmtest::resettest(formula = price~bdrms+llotsize+lsqrft, power = 2:3, type = c("fitted"), data = data) # reject null hypothesis

forecast::checkresiduals(m1)
