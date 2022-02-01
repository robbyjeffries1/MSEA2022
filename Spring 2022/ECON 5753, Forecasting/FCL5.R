## Forecasting
## Lecture 5
## Written by: Robby Jeffries
## 02/01/2022

rm(list = ls())
# garbage collector
gc()

# Set working directory
setwd("~/MSEA2022/Spring 2022/ECON 5753, Forecasting/Data")
getwd()

# Import data
data <- read.csv("auto_corr_raw.csv")

# Ask R if the data is time series or not
is.ts(data$Y_t)

# Change to time series data
yt <- ts(data$Y_t, start = 1, frequency = 1)

# Ask R if the new yt variable is time series or not
is.ts(yt)

# Autocorrelation function
rho <- acf(yt)
rho

# Generate a random normal distribution with 100 obs.
v1 = rnorm(100, mean = 0, sd = 2)
rho2 <- acf(v1)
rho2
