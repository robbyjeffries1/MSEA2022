## Forecasting
## Lecture 8
## Written by: Robby Jeffries
## 02/15/2022

# Install packages
list.of.packages <- c("tidyverse", "readr", "lubridate", "fpp2", "tsibble", "TTR")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
library(tidyverse)
library(readr)
library(lubridate)
library(tidyverse)
library(fpp2)
library(tsibble)
library(TTR)

# garbage collector
rm(list = ls())
gc()
getwd()

# Set working directory
setwd("~/MSEA2022/Spring 2022/ECON 5753, Forecasting/Data")

# Import data
# Use readr to import data as a tibble, which is typically easier to work with.
# data <- readr::read_csv("ex49.csv") %>%
#   mutate(quarter=yearquarter(date)) %>%
#   select(-date)
data <- readr::read_csv("ex49.csv") 

# Set quarterly time series format
q <- data[3]
qts <- ts(q, frequency = 4, start = c(2000,1))
plot.ts(qts)

# Get 3 different moving averages
ma2 = SMA(qts, n=2)
ma3 = SMA(qts, n=3)
ma12 = SMA(qts, n=12)

# Plot
ggplot() +
  geom_line(aes(x = data$t, y = qts),
            colour = 'red') +
  geom_line(aes(x = data$t, y = ma2),
            colour = 'blue') +
  geom_line(aes(x = data$t, y = ma12),
            colour = 'black') +
  ggtitle('Moving Average') + 
  xlab('') +
  ylab('sales') 

# If beta and gamma are false, you have simple moving average
# See FC L7 slide 10 in Notability to see more on level and trend when beta = 0.5
yt_hat_simple_exp <- HoltWinters(qts, alpha=0.1, beta=0.5, gamma=0.4)
yt_hat_simple_exp$fitted

