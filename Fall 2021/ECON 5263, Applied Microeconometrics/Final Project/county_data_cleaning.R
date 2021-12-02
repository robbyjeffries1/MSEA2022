# Required Packages
library(tidyverse)
library(lubridate)
library(here)
library(stringr)

#### County Election Data ####
# Import raw data
path1 <- "~/ECON-5783-Final/Final_Project/Up-to-date_Cleaning/countypres_2000-2020.csv"

# Save raw data to variable
county_raw <- read_csv(here(path1))

# Clean the data by adding filters and removing NA
county_cleaned <- county_raw %>%
  drop_na(state_po) %>% 
  filter(year == 2016, party == 'REPUBLICAN', 
         state != 'DISTRICT OF COLUMBIA', 
         mode == "TOTAL") %>%
  mutate(perc = candidatevotes / totalvotes)

# Counting Counties
county_cleaned[,c("county_name", "state_po")] %>% unique() %>% nrow()

# Identify duplicated rows
idx <- county_cleaned[,c("county_name", "state_po")] %>% duplicated()
county_cleaned[idx,c("county_name", "state_po")]

# Counting States
county_cleaned$state %>% unique() %>% length()

# Which States were not included
setdiff(unique(county_raw$state), unique(county_cleaned$state))

# Change the text from all caps to proper capitalization (i.e. ARKANSAS to Arkansas)
county_cleaned$county_name <- str_to_title(county_cleaned$county_name)
county_cleaned$state <- str_to_title(county_cleaned$state)

# Export the cleaned data to a csv
# write_csv(county_cleaned, "~/ECON-5783-Final/Final_Project/Up-to-date_Cleaning/county_cleaned.csv")

# Aggregating by States to get State Results
lookup <- county_cleaned %>%
  group_by(year, state) %>% 
  summarise(candidatevotes = sum(candidatevotes), 
            totalvotes = sum(totalvotes)) %>% 
  mutate(perc = candidatevotes / totalvotes,
         party = ifelse(perc >= 0.5, 'Republican', 'Democrat'))

lookup <- lookup[,c("state", "party")]

# Adding Statewide results to dataset
county_cleaned <- left_join(county_cleaned, lookup, by = "state")


#### County Covid Data ####

# Import csv with county-level covid data
path3 <- "~/ECON-5783-Final/Final_Project/Up-to-date_Cleaning/county_covid.csv"

# Save to raw variable
county_covid_raw <- read_csv(here(path3))

county_covid_raw$date <- as.Date(county_covid_raw$date, format = '%m/%d/%Y')

# Filter data down to one day
county_covid_cleaned <- county_covid_raw %>% 
  filter(date=='20-11-16',
         state != "District of Columbia")

# renaming county column
colnames(county_covid_cleaned)[2] <- "county_name"

# Count number of unique counties
county_covid_cleaned[, c("county_name", "state")] %>% unique() %>% nrow()

# Counting unique states
county_covid_cleaned$state %>% unique() %>% length()


# Which States were included in the covid dataset but not in the county one?
extra <- setdiff(unique(county_covid_cleaned$state), unique(county_cleaned$state))

# Removing extra states
county_covid_cleaned <- county_covid_cleaned %>% 
  filter(!state %in% extra)

# Join covid data with election results
merged <- inner_join(county_cleaned, county_covid_cleaned,
                     by = c('county_name', 'state'))

# write_csv(merged, "~/ECON-5783-Final/Final_Project/Up-to-date_Cleaning/county_merged.csv")

#### Cases and Deaths Plot ####
merged %>% 
  ggplot(aes(x = perc, y = cases, color = factor(state))) +
  geom_point(position = position_jitter(h = 0.1), alpha = .8) +
  scale_x_continuous(labels = scales::percent) +
  geom_vline(xintercept = 0.5)

merged %>% 
  ggplot(aes(x = perc, y = deaths, color = factor(state))) +
  geom_point(position = position_jitter(h = 0.1), alpha = .8) +
  scale_x_continuous(labels = scales::percent) +
  geom_vline(xintercept = 0.5)

# Maybe consider weighting by the population of each county?

#### County Census Data ####

census <- "~/ECON-5783-Final/Final_Project/Up-to-date_Cleaning/census2020.csv"

census_raw <- read_csv(here(census))

# Filtering the columns we need
census_raw <- census_raw[,c('county_name', 'state', 'POPESTIMATE2020')]

merged2 <- inner_join(merged, census_raw,
                      by = c('county_name', 'state'))

merged2 <- merged2 %>% mutate(death_rate = deaths / POPESTIMATE2020,
                              case_rate = cases / POPESTIMATE2020)

# write_csv(merged2, "~/ECON-5783-Final/Final_Project/Up-to-date_Cleaning/county_census_merged.csv")

#### Case and Death Rate Plot ####
merged2 %>% 
  ggplot(aes(x = perc, y = case_rate, color = factor(state))) +
  geom_point(position = position_jitter(h = 0.1), alpha = .8) +
  scale_x_continuous(labels = scales::percent) +
  geom_vline(xintercept = 0.5)

merged2 %>% 
  ggplot(aes(x = perc, y = death_rate, color = factor(state))) +
  geom_point(position = position_jitter(h = 0.1), alpha = .8) +
  scale_x_continuous(labels = scales::percent) +
  geom_vline(xintercept = 0.5)


#### County Vaccine Data ####
path4 <- "~/ECON-5783-Final/Final_Project/Up-to-date_Cleaning/county_vax.csv"

county_vax_raw <- read_csv(here(path4))

county_vax_cleaned <- county_vax_raw %>% filter(Date == "05/31/2021")

# write_csv(county_vax_cleaned, "~/ECON-5783-Final/Final_Project/Up-to-date_Cleaning/county_vax_cleaned.csv")

path5 <- "~/ECON-5783-Final/Final_Project/Up-to-date_Cleaning/county_vax_cleaned2.csv"
county_vax_cleaned2 <- read_csv(here(path5))

county_vax_cleaned2 <- county_vax_cleaned2[,c('date', 'county_name', 'Recip_State',
                                              'Completeness_pct',  
                                              'Administered_Dose1_Recip_18Plus', 
                                              'Administered_Dose1_Recip_18PlusPop_Pct', 
                                              'Series_Complete_18Plus', 
                                              'Series_Complete_18PlusPop_Pct_SVI', 
                                              'Series_Complete_18PlusPop_Pct')]
county_vax_cleaned2[,c('Completeness_pct',
                       'Administered_Dose1_Recip_18PlusPop_Pct',
                       'Series_Complete_18PlusPop_Pct_SVI', 
                       'Series_Complete_18PlusPop_Pct')] <- county_vax_cleaned2[,c('Completeness_pct',
                                                                                   'Administered_Dose1_Recip_18PlusPop_Pct',
                                                                                   'Series_Complete_18PlusPop_Pct_SVI', 
                                                                                   'Series_Complete_18PlusPop_Pct')] / 100

# Renaming State column
colnames(county_vax_cleaned2)[3] <- "state_po"

merged3 <- inner_join(merged2, county_vax_cleaned2,
                      by = c('county_name','state_po'))

merged3 <- merged3[,c('year', 'state', 'state_po', 'county_name', 
                      'perc', 'party.y', 'date.x', 
                      'death_rate', 'case_rate', 'date.y',
                      'Completeness_pct',
                      'Administered_Dose1_Recip_18PlusPop_Pct',
                      'Series_Complete_18PlusPop_Pct_SVI', 
                      'Series_Complete_18PlusPop_Pct')]


write_csv(merged3, "~/ECON-5783-Final/Final_Project/Up-to-date_Cleaning/county_census_vax.csv")
