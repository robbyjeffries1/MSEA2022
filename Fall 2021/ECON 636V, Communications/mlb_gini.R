################################################################################

# University of Arkansas
# Walton Graduate School of Business
# ECON 636V, Communications

# Written by: Robby Jeffries
# Date: 03 December 2021

# Topic: Generate Gini coefficients and Lorenz curves (Lc) 
#        for each 2021 MLB roster

################################################################################

# Import packages and install them if necessary
list.of.packages <- c("REAT", "ggplot2", "dplyr", "readxl", "ineq")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Import data
mlb_data_raw <- read_excel("/Users/robbyjeffries/MSEA2022/Fall 2021/ECON 636V, Communications/mlb_data.xlsx", sheet = 2)

# Simplify the data to only show team name and salaries
mlb_data_cleaned <- mlb_data_raw %>%
  group_by(team) %>%
  arrange(salary, .by_group = TRUE) %>%
  select(c(team, salary))

# Start a color index so that each Lc can have a different color
color_index <- 1

# Generate a blank plot before running the for loop
plot(0, 
     type = 'n', 
     axes = TRUE, 
     ann = TRUE, 
     xlim=c(0,1), 
     ylim=c(0,1), 
     main="Lorenz Curves for 2021 MLB Teams",
     xlab="Cumulative share of players from lowest to highest salaries",
     ylab="Cumulative share of salaries earned")

# Add a diagonal line to represent perfect equality
lines(x = c(0,1), y = c(0,1))

team_name <- list()

# Use a for loop to generate gini coeff's and Lc's for each team
for (i in unique(mlb_data_cleaned$team)) {
  
  # Create a data frame for each team 
  assign(i, mlb_data_cleaned %>% filter(team == i))
  
  # Generate a gini coefficient for each team and save them to unique variables 
  team_name [i] <- assign(paste("gini", i, sep = "_"), ineq(eval(parse(text = paste(i, "$salary", sep = ""))), type = "Gini"))
  
  # Plot Lorenz Curves
  assign(paste("Lc", i, sep = "."), Lc(eval(parse(text = paste(i, "$salary", sep = "")))))
  
  lines(eval(parse(text = paste("Lc", i, sep = "."))), col=color_index)
  
  color_index <- color_index + 1
}
