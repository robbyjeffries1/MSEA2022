## Forecasting
## Lecture 2
## Written by: Robby Jeffries
## 01/20/2022

# Set working directory
setwd("~/MSEA2022/Spring 2022/ECON 5753, Forecasting/Data")
getwd()

# Install packages
# install.packages("tidyverse")
# install.packages("caTools")
library(tidyverse)
library(caTools)

# Import data
data = read.csv("50_Startups.csv")
print(data$R.D.Spend)
rd = data$R.D.Spend
print(rd)

## Descriptive Statistics
# mean, var, sd, min, max, median, range, quantile
sapply(data, mean, na.rm=TRUE)

## Quiz
# mean
sapply(data, mean, na.rm=TRUE)
# sd
sapply(data, sd, na.rm=TRUE)
# min
sapply(data, min, na.rm=TRUE)
# max
sapply(data, max, na.rm=TRUE)

summary(data)

install.packages("pastecs")
library(pastecs)
res <- stat.desc(data)
round(res, 2)




## EDA
data %>% 
  arrange(State) %>% View()

sum(data$R.D.Spend, na.rm=TRUE)

data$R.D.Spend %>% 
  drop_na() %>%
  sum()
