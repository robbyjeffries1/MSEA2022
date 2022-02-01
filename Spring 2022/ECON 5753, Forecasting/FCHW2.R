## Forecasting
## Homework 2
## Written by: Robby Jeffries
## 02/01/2022

rm(list = ls())
# garbage collector
gc()

# Set working directory
setwd("~/MSEA2022/Spring 2022/ECON 5753, Forecasting/Data")
getwd()

# Import data
data <- read.csv("tablep21_hw2.csv")

# Ask R if the data is time series or not
is.ts(data$sales)

# Change to time series data
yt <- ts(data$sales, start = 1, frequency = 1)

# Ask R if the new yt variable is time series or not
is.ts(yt)

# Autocorrelation function (figure 1)
rho <- acf(yt)
rho
