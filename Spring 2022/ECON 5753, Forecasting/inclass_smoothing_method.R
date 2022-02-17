##clear the R environment
rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
gc() #free up memrory and report the memory usage.
getwd()

#####################################################################
#install.packages("zoo")
#install.packages("lubridate")
#install.packages("tidyverse")
#install.packages("fpp2")
#install.packages("tsibble")
library(zoo)
library(lubridate)
library(tidyverse)
library(fpp2)
library(tsibble)
#####
data<- readr::read_csv("ex49.csv")%>%
  mutate(quarter=yearquarter(date)) %>%
  select(-date)

q<-data[3]
qts<-ts(q, frequency = 4,start=c(2000,1))
plot.ts(qts)

##moving average
##rollingmean in zoo package
ma<-data %>%
  select(quarter,may=sales) %>%
  mutate(may2=rollmean(may, k=2, fill=NA, align = "right"),
         may3=rollmean(may, k=3, fill=NA, align = "right"),
         may4=rollmean(may, k=4, fill=NA, align = "right"))
ma

ma %>%
  gather(metric, value, may:may4) %>%
  ggplot(aes(quarter, value, color = metric)) +
  geom_line()

##MA
library(TTR)
ma2=SMA(qts,n=2)
ma3=SMA(qts,n=3)
ma12=SMA(qts,n=12)


library(ggplot2)
ggplot() +
  geom_line(aes(x = data$t, y = qts),
            colour = 'red') +
  geom_line(aes(x = data$t, y = ma2),
            colour = 'blue') +
  geom_line(aes(x = data$t, y = ma12),
            colour = 'black')+
  ggtitle('Moving Average') +
  xlab('') +
  ylab('sales')

yt_hat_simple_exp<- HoltWinters(qts, alpha=0.1, beta=0.5, gamma=0.4)
yt_hat_simple_exp$fitted



