library(tidyverse)

rolling_stone <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-05-07/rolling_stone.csv')

g <- ggplot(rolling_stone, aes(y = genre))
# Number of cars in each class:
g + geom_bar(aes(fill = artist_gender))