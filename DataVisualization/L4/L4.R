### Special Problems, Data Visualization
### L4, 09-01-2021

#### FROM L3

### analysis of student grades data set

## load necessary libraries
library(tidyverse)

# Read csv. Original command run in class: readr::read_csv("/Users/robbyjeffries/MSEA2022/DataVisualization/L3/student_grades.csv")
grades <- read_csv("/Users/robbyjeffries/MSEA2022/DataVisualization/L3/student_grades.csv")

grades2 <- pivot_longer(grades, math:speech, "subject")

grades3 <- separate(grades2, value, into = c("letter", "pct"), "/")

### two functions

## mutate: create new variables
# make all of the letter grades upper case
grades4 <- mutate(grades3, letter = toupper(letter))

###############################################################################

#### L4
library(tidyverse)

ggplot(mtcars) + 
  geom_point(aes(x = cyl, y = mpg), color = "blue") +
  xlab("Cylinders")

  
### ggplot with student toy data

# you can use |> or %>%
# dbl == double precision floating point number
grades4 <- grades4 %>% mutate(pct = as.numeric(pct))

ggplot(grades4) + geom_histogram(aes(x = pct, 
                                     fill = student), 
                                 alpha = 0.5,
                                 color = "red",
                                 binwidth = 5)

## reference: http://ggplot2.tidyverse.org/reference

# summarize the average percent grade by student
grades4 %>% 
  group_by(student) %>% 
  summarize(avg_grade = mean(pct))
  

#### NYC Flights Data
install.packages("nycflights13")

library(nycflights13)

summary(flights)

# find the number of flights per month
flights %>% 
  group_by(month) %>%
  summarize(count = n())

# what are the busiest days of the year?
flights %>% 
  group_by(month, day) %>%
  count() %>%
  #arrange(desc(n)) %>% 
  ggplot() + geom_col(aes(x = day, y = n, fill = as.factor(month)))




  
  