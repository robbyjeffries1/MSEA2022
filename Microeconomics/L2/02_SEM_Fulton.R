

#-------------------------------------------------------------------------------------------------------------------
#
#  SIMULTANEOUS ESTIMATING DEMAND AND SUPPLY:  THE FULTON FISH MARKET
#
#  With SEMs identification is an issue--strong exogenous variables are a key to getting good estimates
#
#-------------------------------------------------------------------------------------------------------------------

# Clean up and load libraries

  rm(list=ls()) #Removes all items in Environment!

  # install.packages("systemfit")
  library(systemfit)  # Estimates simultaneous equations models (SEMs)
  library(broom)      # For `glance(`) and `tidy()`
  library(knitr)      # For kable()

# Load the data

  library(readr)
  fultonfish <- read_csv("~/R/fultonfish.csv")

  View(fultonfish)

  
# Estimate reduced form equations
  
  fishQ.ols <- lm(lquan ~ mon + tue + wed + thu + stormy, data=fultonfish)
  
  kable(tidy(fishQ.ols), digits = 4,     
        caption="Reduced 'Q' equation for the fultonfish example")
  
        # kable() is a very simple table maker
  

  fishP.ols <- lm(lprice ~ mon + tue + wed + thu + stormy, data = fultonfish)
  
  kable(tidy(fishP.ols), digits = 4,
        caption="Reduced 'P' equation for the fultonfish example")


# 2SLS estimates of the demand and supply (structural) equations
  
  fish.D <- lquan ~ lprice + mon + tue + wed + thu  # Demand equation
  fish.S <- lquan ~ lprice + stormy                 # Supply equation
  fish.eqs <- list(fish.D, fish.S)
  fish.ivs <- ~ mon + tue + wed + thu + stormy      # Instrumental variables
  fish.sys <- systemfit(fish.eqs, method="2SLS", 
                        inst = fish.ivs, data = fultonfish)  # Estimate the D and S system with 2SLS
  summary(fish.sys)




