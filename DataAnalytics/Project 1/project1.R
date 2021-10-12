### Data Analytics
### Project 1
### Written by: Robby Jeffries
### 09-13-2021

# import library
library(tidyverse)

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

# place all count variables in a single tibble
count <- tibble(email_count, network_count, paper_films_count, electronic_medical_record_count, other_count, laptop_count, desktop_count)
count

# How many times is "ransom" mentioned in the prc data?
ransom_count <- str_count(prc$Description.of.incident, "ransomware") %>% sum()
ransom_count

# Find the number of rows from Arkansas in each data set
ar_count_prc <- str_count(prc$State, "Arkansas") %>% sum()
ar_count_prc
ar_count_breach <- str_count(breach$State, "AR") %>% sum()
ar_count_breach


breach %>% arrange(Individuals.Affected) %>% View()

