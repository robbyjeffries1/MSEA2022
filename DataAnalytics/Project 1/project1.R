### Data Analytics
### Project 1
### Written by: Robby Jeffries
### 09-13-2021

#@ If necessary, install the following packages
# install.packages("udpipe")
# install.packages("textrank")

# Access libraries
library(udpipe)
library(textrank)

prc <- read.csv(file = "/Users/robbyjeffries/MSEA2022/DataAnalytics/Project 1/PRC_Data_Breach_Chronology_2020-01-13.csv")

# deleting punctuations
prc$Description.of.incident <- gsub("[[:punct:][:blank:]]+", " ", prc$Description.of.incident)

# deleting trailing space
prc$Description.of.incident <- gsub("\\n"," ", prc$Description.of.incident)
