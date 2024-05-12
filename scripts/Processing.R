#install tidyverse if not already on machine

library(tidyverse)

rolling_stone <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-05-07/rolling_stone.csv')

#Drop albums by 'various artists'
  #Only want to work with albums by a single artist/group
rolling_stone <- rolling_stone[!grepl('Various Artists', rolling_stone$clean_name),]

#Look for typos and such (example, one entry has genre Blues/ROck)
rolling_stone$genre <- str_replace(rolling_stone$genre, "Blues/Blues ROck", "Blues/Blues Rock")

# Create 'is_debut' Boolean variable: True if years_between = 0
#Assumes there's no edge case where an artist released another album the same year as their debut

rolling_stone$is_debut <- ifelse(rolling_stone$years_between == 0, 1, 0)

# Create 'decade' variable, decade of album release, rounds the release variable down to the nearest 10
rolling_stone$release_decade <- rolling_stone$release_year - (rolling_stone$release_year %% 10)

View(rolling_stone)

#If album didn't appear on billboard top 200, peak position is set to 201

#Columns with NA, spotify columns, genre, rank columns and weeks on billboard

#To use member_count as categorical data, need to convert to factor
  #Before I do that, is there any reason I would want them as numbers?
    #Could also use a temp value if I just want to convert for plots

#Truthfully, I'm not sure what the spotify popularity column even is,
  #Its not a ranking, it's not monthly listeners in millions

genre_change_df <- rolling_stone %>%
  group_by(genre) %>%
  summarise(
    genre_ave_2003 = mean(rank_2003, na.rm = TRUE),
    genre_ave_2012 = mean(rank_2012, na.rm = TRUE),
    genre_ave_2020 = mean(rank_2020, na.rm = TRUE),
    amount_of_genre = n()
  ) %>%
  ungroup()

View(genre_change_df)
