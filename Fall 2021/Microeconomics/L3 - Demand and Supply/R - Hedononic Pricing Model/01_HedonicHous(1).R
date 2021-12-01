

#-------------------------------------------------------------------------------------------------------------------
#
#  HEDONIC PRICING MODEL
#
#  Boston Housing Data
#
#-------------------------------------------------------------------------------------------------------------------


# Load libraries

  library(tidyverse)  
  library(broom)    # For `glance(`) and `tidy()`
  library(knitr)    # For kable(), a simple table generator
  

# Load the data

  library(readr)    # 'readr()' quickly reads large flat files

  BostHous <- read_csv("~/R/01_BostHous.csv")

  View(BostHous)  # Lists the data set


# Estimate a linear model ('lm' = OLS)
  
  Hous.ols <- lm(MEDV ~ CRIM + ZN + INDUS + CHAS + NOX + RM + AGE + DIS + RAD + TAX + PTRATIO + B + LSTAT, data = BostHous)
  
  
# kable() is a very simple table maker
  
  kable(tidy(Hous.ols), digits = 4, caption="Hedonic Pricing Model")
