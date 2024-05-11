#install tidyverse if not already on machine

library(tidyverse)

rolling_stone <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-05-07/rolling_stone.csv')

#Drop albums by 'various artists'
  #Only want to work with albums by a single artist/group
rolling_stone <- rolling_stone[!grepl('Various Artists', rolling_stone$clean_name),]

#genre, member_count, gender, release_year, age_at_top_500 and maybe more columns have NA values
  #gotta figure out what to do with them (For full list use colSums(is.na(df))])

#Look for typos and such (example, one entry has genre Blues/ROck)

# Create 'is_debut' Boolean variable: True if years_between = 0
#Assumes there's no edge case where an artist released another album the same year as their debut

rolling_stone$is_debut <- ifelse(rolling_stone$years_between == 0, 1, 0)

View(rolling_stone)
