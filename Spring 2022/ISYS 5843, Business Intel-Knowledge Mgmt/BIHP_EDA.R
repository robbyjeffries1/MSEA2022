# BI Housing Project (BIHP)
# EDA
# Written by: Robby Jeffries
# Written on: 02-12-2022

library(tidyverse)

# Set working directory
setwd("~/MSEA2022/Spring 2022/ISYS 5843, Business Intel-Knowledge Mgmt/Data")
getwd()

# Import data
df <- read.csv("bc_train_032521.csv")

# Get a feel for the data
glimpse(df)

# Identify the unique school districts in the data
schools <- unique(df$school_district)
schools

# Identify the unique subdivisions in the data
sub <- unique(df$subdivision)
sub

# List of cities
city <- unique(df$city)
city

# Median values 
df$total_acres %>% summary()
df$sale_price %>% summary()
df$land_value %>% summary()

summary(df$land_value)
