## Forecasting
## Lecture 3
## Written by: Robby Jeffries
## 01/25/2022

rm(list = ls())
# garbage collector
gc()

# Set working directory
setwd("~/MSEA2022/Spring 2022/ECON 5753, Forecasting/Data")
getwd()

##import data
data=read.csv('50_Startups.csv')
print(data)
print(data$R.D.Spend)

rd=data$R.D.Spend
print(rd)

##descriptive stat.
#mean, var, sd, min, max, median, range, quantile
sapply(data, mean,na.rm=TRUE)

## missing data
# the zero is what missing data is replaced with, the third argument means that
# if the data is not missing, let it be itself
data$R.D.Spend = ifelse(is.na(data$R.D.Spend), 
                       0, 
                       data$R.D.Spend)

## dummy / categorical variables
# replace each state name with a number
data$State = factor(data$State,
                    levels = c('New York', 'California', 'Florida'),
                    labels = c(1, 2, 3))

mean(data$State) # this doesn't work because 1, 2, & 3 are characters at the moment
staten = as.numeric(data$State) # change the characters to numerics
mean(staten)

## Regression
# Profit is dependent var, R.D.Spend is independent var. See Notability for eq.
reg1 = lm(formula = Profit~R.D.Spend, data = data)
summary(reg1)

## Predicting
y_hat = predict(reg1, newdata = data)

## Plot data
# install.packages('ggplot2')
library(ggplot2)

ggplot() + 
  geom_point(aes(x = data$R.D.Spend, y = data$Profit), colour = 'red') +
  geom_line(aes(x = data$R.D.Spend, y = y_hat), colour = 'blue') +
  ggtitle('Profit vs. R.D. Spend') +
  xlab('R.D.Spend') +
  ylab('Profit')

## Quiz
df <- data %>% 
  mutate(r.d.spend2 = r.d.spend^2)

reg2 <- lm(formula=profit~r.d.spend+r.d.spend2, data=df)

y_hat2 <-  predict(reg2, newdata=df)

df %>% 
  ggplot(aes())+
  geom_point(aes(y=profit, x=r.d.spend))+
  geom_line(aes(x=r.d.spend, y=y_hat2), colour='red')+
  ggtitle('Profit vs R&D Spending')+
  xlab('R&D Spending')+
  ylab('Prodit')
