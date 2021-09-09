# DV L6
# 09-09-2021

# Comment blocks of code with CTRL + SHIFT + C

library(tidyverse)

diamonds

ggplot(diamonds) +
  geom_histogram(aes(x = carat),
                 color="red",
                 fill="red3",
                 alpha = 0.3,
                 bins = 15) +
  ggtitle("Carat vs. Number of Diamonds") +
  xlab("Carat") +
  ylab("Number of Diamonds") +
  theme_stata()

# Change a string version o date into an actual date
lubridate::mdy("07/29/1999") 

# Check how long it takes to run a function with system.time()
sample(1:10, 1e7, replace = TRUE) %>% system.time()

# Find the biggest streak in the dice rolling problem
?rle
rle(diamonds$carat)
hist(rle(diamonds$carat)$lengths)
