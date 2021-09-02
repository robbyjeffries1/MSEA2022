### Special Problems, Data Visualization
### L3, 08-31-2021

## How to write a function in R

squarer <- function(n) {
  n * n
}

hypoteneuse <- function(side_1, side_2) {
  sqrt(squarer(side_1) + squarer(side_2))
}

#### analysis of student grades data set

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

## filter(): isolate a single person
filter(grades4, student == c("eileen", "fran"))
filter(grades4, student %in% c("eileen", "fran"))
filter(grades4, student == "eileen", subject == "math")
filter(grades4, letter == "A" & subject == "math")

#### NEXT TIME

### "verbs" in dplyr

## the pipe operator
