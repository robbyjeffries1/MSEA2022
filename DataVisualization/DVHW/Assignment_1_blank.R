#### Please show all your code for each step


## Step 1. Install/ load required libraries
## You'll need the packages 'tidyverse' and 'nycflights13'
## Hint: you need the install.packages() and library() commands

## Un-comment the following two lines if you need to install the packages
# install.packages("tidyverse")
# install.packages("nycflights13")

# import libraries 
library(tidyverse)
library(nycflights13)


## Note we will exclusively use the 'flights' dataset from 'nycflights13'
#
## Step 2. On March 10, 2013, how many Delta flights (carrier code "DL")
## originated at Newark ("EWR")?  Show a dataframe/ tibble.
#
## (Hint: you're going to want multiple filters)

flights %>%
  filter(month==3, 
         day==10, 
         carrier=="DL", 
         origin=="EWR")

# There are 10 Delta flights that originated at Newark on 3/10/2013


## Step 3. Generate a histogram of the departure delays for each NYC airport.

# Run summary to find the minimum and maximum dep_delay
summary(flights$dep_delay == "NA")
str(flights)

ggplot(flights) + geom_histogram(aes(x = dep_delay, 
                                     fill = origin), 
                                 alpha = 0.5,
                                 binwidth = 5)

# EWR only
flights %>%
  ggplot(subset(flights$origin == "EWR"), aes(x = dep_delay)) + geom_histogram()



delay_JFK <- flights %>% filter(origin == "JFK")

delay_LGA <- flights %>% filter(origin == "LGA")

      ########[ YOUR CODE HERE]###########


## Step 4. For flights from JFK ONLY, generate a tibble showing the average 
## flight time (time in the air), grouped by the hour of the day it took off.
## Additionally show the average number of flights occuring at that hour every day.

summary(flights)
     ########[ YOUR CODE HERE]###########


## Step 5.  Using the df from above, generate a col chart with hour of the day on the x axis, and average
## flight time on the y axis.
## (Hint, you want to use geom_col())

     ########[ YOUR CODE HERE]###########
