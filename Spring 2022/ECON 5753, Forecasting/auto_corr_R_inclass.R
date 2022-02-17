rm(list = ls(all.names = TRUE))
setwd("~/MSEA2022/Spring 2022/ECON 5753, Forecasting/Data")

data <- read.csv("auto_corr_raw.csv")

is.ts(data$Y_t)
yt<-ts(data$Y_t,start=1,frequency = 1)
is.ts(yt)

rho<-acf(yt)
rho
Box.test(yt,lag=2, type = "Ljung-Box")

v1=rnorm(100,mean = 0,sd=2)
rho1=acf(v1)

gdp <- read.csv("GDPA.csv")
y<-ts(gdp$VALUE, start=1,frequency = 1)

rhoy<-acf(y)
rhoy

Box.test(y,lag=2,type = "Ljung-Box")

regressor=lm(formula=y~1,data = data)
summary(regressor)
uhat<- residuals(regressor)
rhou<-acf(uhat)

