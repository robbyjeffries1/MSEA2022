## How to write a function in R

squarer <- function(n) { n * n }


hypoteneuse <- function(side_a, side_b) {
    sqrt(squarer(side_a) + squarer(side_b))
}


## install any packages we need

install.packages("tidyverse")

library("tidyverse")

install.packages("datasets")

### Import data file

grades <- read_csv("/Users/robbyjeffries/MSEA2022/DataVisualization/L3/student_grades.csv")

## tidy it up

z <- tidyr::pivot_longer(grades, math:speech, "subject")

?pivot_longer

## divide coumn into two

zz <- separate(z, value, into = c("letter", "pct"), sep = "/")

## consistent formatting

zzz <- mutate(zz, letter = toupper(letter))

### the starwars data

mutate()

filter()






