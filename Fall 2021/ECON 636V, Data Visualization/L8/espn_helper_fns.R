#### Below are the two functions I presented in class
#### These are crude, undocumented, and mostly based on 
#### the fine espnscrapeR package by Thoman Mock. The 
#### original source code can be found on his github
#### at https://github.com/jthomasmock/espnscrapeR.
####
#### I make no reps or warrants about the functions' use.

################  Function 1  #####################
# get intragame win probabilities, as modeled by espn
# game_id is a valid character string


my_get_espn_win_prob <- function(game_id){
    
    raw_url <- glue::glue("https://sports.core.api.espn.com/v2/sports/football/leagues/college-football/events/{game_id}/competitions/{game_id}/probabilities?limit=1000")
    
    extract_play_text <- function(text_in) {
        text_in %>%
            str_remove("\\?lang=en&region=us") %>%
            str_remove("http://sports.core.api.espn.com/v2/sports/football/leagues/college-football/events/[:digit:]+/competitions/[:digit:]+/probabilities/")
        
    }
    
    extract_team_text <- function(text_in){
        text_in %>%
            str_remove("http://sports.core.api.espn.com/v2/sports/football/leagues/college-football/seasons/[:digit:]+/teams/") %>%
            str_remove("\\?lang=en&region=us")
    }
    
    raw_get <- httr::GET(raw_url)
    
    httr::stop_for_status(raw_get)
    
    raw_json <- httr::content(raw_get)
    
    raw_json
    
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


################  Function 2  #####################
# get play by play data
# game_id is a valid character string

my_get_college_pbp <- function(game_id){
    
    raw_url <- glue::glue("https://sports.core.api.espn.com/v2/sports/football/leagues/college-football/events/{game_id}/competitions/{game_id}/plays?limit=1000")
    
    #Example
    # https://sports.core.api.espn.com/v2/sports/football/leagues/college-football/events/401282057/competitions/401282057/plays?limit=1000
    
    raw_get <- httr::GET(raw_url)
    
    httr::stop_for_status(raw_get)
    
    raw_json <- httr::content(raw_get)
    
    raw_json
    
    raw_df <- raw_json[["items"]] %>%
        enframe() %>%
        unnest_wider(value) %>%
        rename(row_id = name, play_url_ref = `$ref`) %>%
        select(play_id = id, 
               sequence_number = sequenceNumber, 
               play_text = alternativeText, 
               awayScore, 
               homeScore, 
               scoringPlay, 
               scoreValue, 
               modified, 
               team, 
               probability, 
               start, 
               end,
               clock,
               wallclock) %>%
        hoist(start, play_start_yds_to_ez = "yardsToEndzone") %>% 
        hoist(end, play_end_yds_to_ez = "yardsToEndzone") %>% 
        hoist(start, play_start_possess = "possessionText") %>%
        hoist(end, play_end_possess = "possessionText") %>%
        hoist(start, down = "down") %>%
        hoist(start, down_yards = "shortDownDistanceText") %>%
        hoist(clock, qtr_seconds_remaining = "value") %>%
        mutate(play_start_possess = stringr::str_sub(play_start_possess, 1, 3),
               play_end_possess = stringr::str_sub(play_end_possess, 1, 3)) %>%
        select(-end, -start, -team, -probability, -clock) %>%
        janitor::clean_names()
    
    raw_df
    
}
