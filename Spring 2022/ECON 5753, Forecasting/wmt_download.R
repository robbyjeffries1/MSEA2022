##clear the R environment
rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
gc() #free up memrory and report the memory usage.
getwd()

if (!require(BatchGetSymbols)) install.packages('BatchGetSymbols')

myShare<-"WMT"
myStartDate<-'2000-01-01'
myEndDate<-'2010-12-31'
freq.data<-'monthly'

l.out <- BatchGetSymbols(tickers = myShare, 
                         first.date = myStartDate,
                         last.date = myEndDate, 
                         freq.data = freq.data) 
l.out
data<-l.out$df.tickers