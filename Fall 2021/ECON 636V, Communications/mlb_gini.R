# Import libraries
install.packages("ineq")
library(REAT)
library(ggplot2)
library(dplyr)
library(readxl)
library(ineq)

# Import data
mlb_data_raw <- read_excel("/Users/robbyjeffries/MSEA2022/Fall 2021/ECON 636V, Communications/mlb_data.xlsx", sheet = 2)

mlb_data_cleaned <- mlb_data_raw %>%
  group_by(team) %>%
  arrange(salary, .by_group = TRUE) %>%
  select(c(team, salary))

lapply(mlb_data_cleaned$salary, as.numeric)

as.double(unlist(mlb_data_cleaned$salary))


gini_ARI <- mlb_data_cleaned %>%
  filter(team == "ARI") %>%
  ineq(as.double(unlist(mlb_data_cleaned$salary)), type="Gini")

