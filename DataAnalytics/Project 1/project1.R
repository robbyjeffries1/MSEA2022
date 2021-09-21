### Data Analytics
### Project 1
### Written by: Robby Jeffries
### 09-13-2021

#@ If necessary, install the following packages
# install.packages("udpipe")
# install.packages("textrank")

# import libraries
library(udpipe)
library(textrank)
library(dplyr)
library(stringr)

# store csv's as variables
prc <- read.csv(file = "/Users/robbyjeffries/MSEA2022/DataAnalytics/Project 1/PRC_Data_Breach_Chronology_2020-01-13.csv")
breach <- read.csv(file = "/Users/robbyjeffries/MSEA2022/DataAnalytics/Project 1/breach_report.csv")

# count the number of occurrences
email_count <- str_count(breach$Location.of.Breached.Information, "Email") %>% sum()
network_count <- str_count(breach$Location.of.Breached.Information, "Network Server") %>% sum()
paper_films_count <- str_count(breach$Location.of.Breached.Information, "Paper/Films") %>% sum()
electronic_medical_record_count <- str_count(breach$Location.of.Breached.Information, "Electronic Medical Record") %>% sum()
other_count <- str_count(breach$Location.of.Breached.Information, "Other") %>% sum()
laptop_count <- str_count(breach$Location.of.Breached.Information, "Laptop") %>% sum()
desktop_count <- str_count(breach$Location.of.Breached.Information, "Desktop Computer") %>% sum()

# How many times is "ransom" mentioned in the prc data?
ransom_count <- str_count(prc$Description.of.incident, "ransomware") %>% sum()
ransom_count

max(breach$Individuals.Affected)

breach %>% arrange(Individuals.Affected)

# place all count variables in a single tibble
count <- tibble(email_count, network_count, paper_films_count, electronic_medical_record_count, other_count, laptop_count, desktop_count)
count

breach %>% group_by(Type.of.Breach) %>%
  mutate(avg = mean(Individuals.Affected))

ar_count <- str_count(prc$State, "Arkansas") %>% sum()
ar_count

ar_count2 <- str_count(breach$State, "AR") %>% sum()
ar_count2

count %>%
  ggplot() +
  geom_col(mapping=aes(x=count))

# deleting punctuations
prc$Description.of.incident <- gsub("[[:punct:][:blank:]]+", " ", prc$Description.of.incident)

# deleting trailing space
prc$Description.of.incident <- gsub("\\n"," ", prc$Description.of.incident)
