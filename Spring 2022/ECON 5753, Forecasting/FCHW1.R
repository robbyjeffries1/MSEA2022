## ECON 5753, Forecasting
## Homework 1
## Written by: Robby Jeffries
## 01/26/2022

## Set working directory
setwd("~/MSEA2022/Spring 2022/ECON 5753, Forecasting/Data")
getwd()

## Install packages
# install.packages("pastecs")
library(tidyverse)
library(caTools)
library(pastecs)
library(ggplot2)

## 1) Import data
df = read.csv("50_Startups.csv")

## 2) Show descriptive statistics
options(scipen = 100)
options(digits = 2)
pastecs::stat.desc(df)

## 3) Replace missing data with the mean of each variable
# the zero is what missing data is replaced with, the third argument means that
# if the data is not missing, let it be itself
df$R.D.Spend = ifelse(is.na(df$R.D.Spend), 
                      mean(df$R.D.Spend, na.rm=TRUE), 
                        df$R.D.Spend)

df$Marketing.Spend = ifelse(is.na(df$Marketing.Spend), 
                      mean(df$Marketing.Spend, na.rm=TRUE), 
                      df$Marketing.Spend)

## 4) Simple Linear Regression: Dep. variable-Profit, Ind. variable-R&D Spend
reg = lm(formula = Profit ~ R.D.Spend, data = df)
summary(reg)
y_hat = predict(reg, newdata = df)

## 5) Visualize the data
ggplot() + 
  geom_point(aes(x = df$R.D.Spend, 
                 y = df$Profit), 
             colour = 'red') +
  geom_line(aes(x = df$R.D.Spend, 
                y = y_hat), 
            colour = 'blue') +
  ggtitle('Figure 1: Profit vs. R.D. Spend') +
  xlab('R.D.Spend') +
  ylab('Profit')

## 6) Generate quadratic form of ind. variable R&D Spend
quadraticModel = lm(formula = Profit ~ df$R.D.Spend + I(df$R.D.Spend^2), data = df)

## 7) Print out the quadratic regression result
summary(quadraticModel)

y_hat2 = predict(quadraticModel, newdata = df)

## 8) Visualize the data
ggplot(df, aes(R.D.Spend, Profit)) + 
  geom_point(aes(x = R.D.Spend, 
                 y = Profit), 
             colour = 'firebrick') +
  geom_line(aes(x = R.D.Spend, 
                y = y_hat), 
            colour = 'gray30', 
            size = 1) +
  geom_smooth(method = lm, 
              formula = y ~ x + I(x^2), 
              se = FALSE, 
              colour = 'seagreen', 
              size = 1) +
  ggtitle('Figure 2: Profit vs. R.D. Spend') +
  xlab('R.D.Spend') +
  ylab('Profit')






