#### Robby Jeffries
#### 09-04-2021
#### DVHW 1


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
library(ggthemes)



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

# ANSWER: There are 10 Delta flights that originated at Newark on 3/10/2013.



## Step 3. Generate a histogram of the departure delays for each NYC airport.   

# Create a table that displays all flights in descending order of departure 
# delays.

delay_desc <- flights %>% 
  arrange(desc(dep_delay)) 

delay_desc

# Generate a histogram of the departure delays for each NYC airport

ggplot(flights) + geom_histogram(aes(x = dep_delay), 
                                 fill="red3",
                                 alpha = 0.5,
                                 binwidth = 5) +
  ggtitle("Plot of Departure Delays by Airport") +
  xlab("Departure Delay (min)") +
  ylab("Number of Flights") +
  facet_wrap(~ origin) +
  theme_stata()

# Because there are only 1311 flights with departure delays above 250 minutes,
# run the code below to generate a histogram that removes (dep_delay > 250).
# This will improve the graph's readability.

ggplot(flights) + geom_histogram(aes(x = dep_delay), 
                                 fill="red3",
                                 alpha = 0.5,
                                 binwidth = 5) +
  xlim(c(-50, 250)) +
  ggtitle("Plot of Departure Delays by Airport") +
  xlab("Departure Delay (min)") +
  ylab("Number of Flights") +
  facet_wrap(~ origin) +
  theme_stata()
  


## Step 4. For flights from JFK ONLY, generate a tibble showing the average 
## flight time (time in the air), grouped by the hour of the day it took off.
## Additionally show the average number of flights occurring at that hour every day.

# Find the total number of flights from JFK. Use this to check work.

flights %>% filter(origin=="JFK")

step4 <- flights %>% 
  filter(origin=="JFK") %>%
  group_by(hour) %>% 
  summarize(avg_flight_time=mean(air_time, na.rm=TRUE), 
            avg_number_of_flights=aggregate() # fix the avg_number_of_flights! right now, it's not showing the average. it's just a count :)

step4

summary(flights)
summary(step4)
flights %>%
  group_by(hour, count=n()) %>% summarize(m = mean(count))

sum(step4$avg_number_of_flights)


flights[date == "2013-10-31"]



## Step 5.  Using the df from above, generate a col chart with hour of the day on the x axis, and average
## flight time on the y axis.
## (Hint, you want to use geom_col())

# Create a table that displays all flights in descending order of hour.
# Use this to validate the chart.

hour_desc <- flights %>% 
  filter(origin=="JFK") %>%
  arrange(desc(hour)) 

hour_desc

# Generate a column chart with hour on the x-axis and avg_flight_time on the y

ggplot(step4) + geom_col(aes(x = hour, y = avg_flight_time), fill="dodgerblue4") +
  theme_economist() +
  ggtitle("Plot of Average Flight Time by Hour of the Day") +
  xlab("Hour of the Day") +
  ylab("Average Flight Time")
