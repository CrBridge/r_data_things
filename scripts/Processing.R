#install tidyverse if not already on machine

library(tidyverse)

rolling_stone <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-05-07/rolling_stone.csv')

View(rolling_stone)

#listing rows where years_between is 0, shows all debut albums in the data
#Assumes there's no edge case where an artist released another album the same year as their debut

#genre, member_count, gender, release_year, age_at_top_500 and maybe more columns have NA values
  #gotta figure out what to do with them (For full list use colSums(is.na(df))])

#Look for typos and such (example, one entry has genre Blues/ROck)

#Remember to use $ for variables
