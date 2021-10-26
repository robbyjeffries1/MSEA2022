## Exploratory Data Analysis
## Written by: Robby Jeffries
## Date: 10/21/2021

# load necessary libraries
library(tidyverse)
# install.packages('remotes')
remotes::install_github('SafeGraphInc/SafeGraphR')


# Read csvs
visit <- read_csv("/Users/robbyjeffries/MSEA2022/Microeconometrics/Final_Project/Chick-fil-A-PATTERNS-2018_01-2021-10-21/visit_panel_summary.csv")
View(visit)

patterns <- read_csv("/Users/robbyjeffries/MSEA2022/Microeconometrics/Final_Project/Chick-fil-A-PATTERNS-2018_01-2021-10-21/patterns.csv")
patterns %>% filter(region=='AR', city %in% c('Bentonville','Rogers','Fayetteville')) %>% View()

home_panel_summary <- read_csv("/Users/robbyjeffries/MSEA2022/Microeconometrics/Final_Project/Chick-fil-A-PATTERNS-2018_01-2021-10-21/home_panel_summary.csv")
View(home_panel_summary)

normal <- read_csv("/Users/robbyjeffries/MSEA2022/Microeconometrics/Final_Project/Chick-fil-A-PATTERNS-2018_01-2021-10-21/normalization_stats.csv")
View(normal)
 
