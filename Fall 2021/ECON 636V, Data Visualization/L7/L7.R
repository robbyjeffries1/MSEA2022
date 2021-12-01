### DV L7, Donut Charts and Web APIs
### 09-14-2021

## TEXAS vs. ARKANSAS win probability

# install.packages("lessR")
library(lessR)
library(tidyverse)

# create a dataframe
df <- tibble(teams = c("TEX", "ARK"),
             win_prob = c(.67, .33))

# create the donut chart
PieChart(teams,
         data = df,
         y = win_prob,
         fill = c("#BF5700", "#9D2235"),
         init_angle = 90,
         main = NULL)

style(panel_fill = "#000000",
      values_digits = 1,
      lab_color = "white")

## Web API (Application Programming Interface)
##
## Main HTTP Verbs:
##    GET, POST, put, delete, many others
##    'get' example: https://www.google.com/search?q=norm+macdonald
## 
## The ESPN Web API

# install.packages("remotes")
remotes::install_github("jthomasmock/espnscrapeR")
library(espnscrapeR)

scrape_qbrs <- get_college_qbr(season = 2021, type = "weekly")

scrape_qbrs %>%
  filter(team_name == "Razorbacks") %>%
  select(name_short, opp_team_name, score, pass, run, game_id) %>%
  pluck("game_id") -> ar_game_id



my_get_college_pbp <- function(game_id){
  
  raw_url <- glue::glue("https://sports.core.api.espn.com/v2/sports/football/leagues/nfl/events/{game_id}/competitions/{game_id}/probabilities?limit=1000")
  
  extract_play_text <- function(text_in) {
    text_in %>%
      str_remove("\\?lang=en&region=us") %>%
      str_remove("http://sports.core.api.espn.com/v2/sports/football/leagues/nfl/events/[:digit:]+/competitions/[:digit:]+/probabilities/")
    
  }
  
  extract_team_text <- function(text_in){
    text_in %>%
      str_remove("http://sports.core.api.espn.com/v2/sports/football/leagues/nfl/seasons/[:digit:]+/teams/") %>%
      str_remove("\\?lang=en&region=us")
  }
  
  raw_get <- httr::GET(raw_url)
  # stop the script if you get a 404 error!
  httr::stop_for_status(raw_get)
  
  raw_json <- httr::content(raw_get)
  
  raw_df <- raw_json[["items"]] %>%
    enframe() %>%
    unnest_wider(value) %>%
    rename(row_id = name, play_url_ref = `$ref`) %>%
    mutate(play_id = extract_play_text(play_url_ref)) %>%
    hoist(homeTeam, home_team_id = "$ref") %>%
    hoist(awayTeam, away_team_id = "$ref") %>%
    select(-play_url_ref, -where(is.list), -any_of(c("lastModified", "secondsLeft"))) %>%
    mutate(
      home_team_id = extract_team_text(home_team_id),
      away_team_id = extract_team_text(away_team_id)
    ) %>%
    janitor::clean_names() %>%
    mutate(game_id = game_id)
  
  raw_df
  
}




