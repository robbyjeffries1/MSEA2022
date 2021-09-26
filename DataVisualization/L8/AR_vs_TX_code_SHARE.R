remotes::install_github("jthomasmock/espnscrapeR")


### load libraries

library(espnscrapeR)
library(tidyverse)

source("DataVisualization/L8/espn_helper_fns.R")


### first find game id for AR vs TX

scrape_qbrs <- get_college_qbr(season = 2021, type = "weekly")

View(scrape_qbrs)


scrape_qbrs %>%
    filter(team_name == "Cardinals") %>% 
    select(name_short, opp_team_name, score, pass, run, game_id) %>%
    pluck("game_id") -> ar_game_id

## Include game_id for live game on 9/25/2021
ar_game_id <- 401282082

raw_probs <- my_get_espn_win_prob(game_id = ar_game_id)

play_history <- my_get_college_pbp(game_id = ar_game_id)


just_probs <- raw_probs %>%
    select(row_id, 
           sequence_number,
           home_win_percentage)

merged_data <- left_join(just_probs, play_history, by = "sequence_number")

### Create some interesting variables
## Also want to know seconds left in GAME

str_detect(merged_data$play_text, pattern = "End of")

merged_data <- merged_data %>% 
    mutate(qtr = cumsum(str_detect(merged_data$play_text, pattern = "End of"))+1) %>%
    filter(str_detect(merged_data$play_text, pattern = "End of") != TRUE) %>%
    mutate(D_hogs_win_pct = home_win_percentage - lag(home_win_percentage),
           game_seconds = 3600 - 900*(qtr-1) - (900 - qtr_seconds_remaining),
           helped_hogs = (D_hogs_win_pct > 0),
           score_differential = abs(home_score - away_score))

View(merged_data)

### How did probability change through the game?

ggplot(merged_data) + geom_line(aes(x = row_id, y = home_win_percentage, color = as_factor(qtr)))

### What were the most consequential plays, probability-wise

merged_data %>%
    arrange(desc(abs(D_hogs_win_pct))) %>%
    mutate() %>%
    head(30) %>%
    ggplot() + geom_col(aes(x = reorder(row_id, 
                                        D_hogs_win_pct), 
                            y = D_hogs_win_pct,
                            fill = helped_hogs),
                        alpha = .80) +
    coord_flip() +
    scale_fill_manual(values = c("#500000",   #Arkansas and Tex colors
                                 "#9D2235"), 
                      guide = FALSE) +        #note guide argument 
    theme_minimal() +
    ylab("Change in probability") +
    xlab("Play number") +
    ggtitle("Arkansas vs. Texas A&M")
    


## Question: Does score differential relate to score differential
merged_data %>%
    ggplot() + geom_point(aes(x = score_differential, 
                              y = home_win_percentage,
                              color = helped_hogs), 
                          alpha = .7) +
    scale_color_manual(values = c("#500000",   #Arkansas and Tex colors
                                 "#9D2235"), 
                       guide = FALSE) 

## in which seconds was most of the probability change concentrated?

merged_data %>%
    mutate(sec_bucket = cut_interval(game_seconds, 12)) %>% 
    ggplot(aes(x = sec_bucket, y = home_win_percentage)) + geom_boxplot() +
    geom_jitter() +
    theme(axis.text.x = element_text(angle = 45))
    
    


### Let's specify a tiny model

my_model <- lm(home_win_percentage ~ score_differential , data = merged_data)


my_model



p + geom_abline(slope = my_model$coefficients[[2]], intercept = my_model$coefficients[[1]])



p + geom_smooth(aes(x = score_differential, 
                    y = hogs_win_pct), method =  "lm") 








