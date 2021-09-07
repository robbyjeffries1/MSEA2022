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
# install.packages("ggthemes")


# import libraries 
library(tidyverse)
library(nycflights13)
library(ggthemes)


###############################################################################


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


###############################################################################


## Step 3. Generate a histogram of the departure delays for each NYC airport.   

# Create a table that displays all flights in descending order of departure 
# delays.
delay_desc <- flights %>% 
  arrange(desc(dep_delay)) 

delay_desc

# Generate a histogram of the departure delays for each NYC airport
ggplot(flights) + 
  geom_histogram(aes(x = dep_delay), 
                 color="red",
                 fill="red3",
                 alpha = 0.3,
                 bins = 15) +
  ggtitle("Plot of All Departure Delays by Airport") +
  xlab("Departure Delay (min)") +
  ylab("Number of Flights") +
  facet_wrap(~ origin) +
  theme_stata()

# Because there are only 1311 flights with departure delays above 250 minutes,
# run the code below to generate a histogram that removes (dep_delay > 250).
# This will improve the graph's readability, though it's important to note that
# this graph will not be representing all of the data.
ggplot(flights) + 
  geom_histogram(aes(x = dep_delay), 
                 color="red",
                 fill="red3",
                 alpha = 0.3,
                 bins = 15) +
  xlim(c(-50, 251)) +
  ggtitle("Plot of Departure Delays <= 250 min. by Airport") +
  xlab("Departure Delay (min)") +
  ylab("Number of Flights") +
  facet_wrap(~ origin) +
  theme_stata()
  

###############################################################################


## Step 4. For flights from JFK ONLY, generate a tibble showing the average 
## flight time (time in the air), grouped by the hour of the day it took off.
## Additionally show the average number of flights occurring at that hour every day.

# Merge the three date columns (year, month, day) into a single date column
flights$date <- as.Date(with(flights, paste(year, month, day, sep="-")), "%Y-%m-%d")
flights$date

# Find the total number of flights from JFK. Use this to check work.
flights %>% filter(origin=="JFK") %>% arrange(hour)

# To find the average number of flights occurring at each hour every day,
# create a variable that lists the number of flights per hour for each day.
flights_per_hour <- flights %>% 
  filter(origin=="JFK") %>% 
  group_by(date, hour) %>% 
  count()
flights_per_hour

# Next, aggregate the 'flights_per_hour' data to show the average number of flights for 
# each hour across all days. I'll call this variable, 'test2'.
test2 <- aggregate(flights_per_hour$n~flights_per_hour$hour, 
                   data=test, 
                   FUN=mean)
test2

# We now have the average number of flights per hour at JFK. I will put them
# into a tibble.
avg_per_hour_every_day <- as_tibble(test2$`test$n`)
avg_per_hour_every_day

# Find the average flight time
avg_flight_time <- flights %>% 
  filter(origin=="JFK") %>%
  group_by(hour) %>%
  summarize(mean(air_time, na.rm=TRUE))
avg_flight_time

# Place hour, avg_flight_time, and avg_per_hour_every_day into a single tibble
answer <- avg_flight_time %>%
  mutate(avg_per_hour_per_day=avg_per_hour_every_day)
answer


###############################################################################


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
ggplot(answer) + geom_col(aes(x = answer$hour, y = answer$`mean(air_time, na.rm = TRUE)`), fill="dodgerblue4") +
  theme_economist() +
  ggtitle("Plot of Average Flight Time by Hour of the Day") +
  xlab("Hour of the Day") +
  ylab("Average Flight Time")
