library(tidyverse)

rolling_stone <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-05-07/rolling_stone.csv')

View(rolling_stone)

#listing rows where years_between is 0, shows all debut albums in the data
#May be an edge case where an artist released another album the same year as their debut
