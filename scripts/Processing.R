#install tidyverse if not already on machine

library(tidyverse)

rolling_stone <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-05-07/rolling_stone.csv')

#Drop albums by 'various artists'
  #Only want to work with albums by a single artist/group
rolling_stone <- rolling_stone[!grepl('Various Artists', rolling_stone$clean_name),]

#Replace values of 201 in peak billboard position (which represents not being on there, I believe) with NA
  #Replace so it doesn't possibly mess with calculations down the line
rolling_stone$peak_billboard_position[rolling_stone$peak_billboard_position == 201] <- NA

#Look for typos and such (example, one entry has genre Blues/ROck)
rolling_stone$genre <- str_replace(rolling_stone$genre, "Blues/Blues ROck", "Blues/Blues Rock")

#Create 'is_debut' Boolean variable: True if years_between = 0
  #Assumes there's no edge case where an artist released another album the same year as their debut
rolling_stone$is_debut <- ifelse(rolling_stone$years_between == 0, 1, 0)

# Create 'decade' variable, decade of album release, rounds the release variable down to the nearest 10
rolling_stone$release_decade <- rolling_stone$release_year - (rolling_stone$release_year %% 10)

View(rolling_stone)

#Columns with NA, spotify columns, genre, rank columns and weeks on billboard

#To use member_count as categorical data, need to convert to factor
  #Before I do that, is there any reason I would want them as numbers?
    #Could also use a temp value if I just want to convert for plots

#Truthfully, I'm not sure what the spotify popularity column even is,
  #Its not a ranking, it's not monthly listeners in millions

genre_change_df <- rolling_stone |>
  group_by(genre) |>
  summarise(
    genre_ave_2003 = mean(rank_2003, na.rm = TRUE),
    genre_ave_2012 = mean(rank_2012, na.rm = TRUE),
    genre_ave_2020 = mean(rank_2020, na.rm = TRUE),
    genre_ave_billboard_weeks = mean(weeks_on_billboard, na.rm = TRUE),
    genre_ave_billboard_ranks = mean(peak_billboard_position, na.rm = TRUE),
    amount_of_genre = n()
  ) |>
  ungroup()

genre_change_df$genre_ave_all =rowMeans(genre_change_df[, c("genre_ave_2003", "genre_ave_2012", "genre_ave_2020")])

View(genre_change_df)

#Lengthen genre_change data (figure out how to drop the NA genre)
genres_pivoted <- genre_change_df |>
  drop_na(genre) |>
  pivot_longer(
    cols = starts_with("genre_ave_2"),
    names_to = "year",
    values_to = "avg_rank",
    values_drop_na = TRUE
    ) |>
  mutate(
    year = parse_number(year)
  )

View(genres_pivoted)
