library(tidyverse)
library(ggridges)
library(patchwork)

summer_movies <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-07-30/summer_movies.csv')

summer_movies <-  summer_movies |>
  # drops videos, I only want films
  filter(title_type != 'video')

decade_dataframe <- summer_movies |>
  # calculate a new decade column from the year
  drop_na(year) |>
  mutate(decade = (year %/% 10 * 10)) |>
  # filtering out the 1920s and 1930s, as there's too little data here
  # so it makes for bad distribution visualisation
  filter(!(decade %in% c(1920, 1930)))

genres_dataframe <- summer_movies |>
  drop_na(genres) |>
  separate_rows(genres, sep = ',') |>
  add_count(genres) |>
  filter(dense_rank(-n) < 10)

# plotting
decade_ridgeplot <- decade_dataframe |>
  ggplot(aes(x = average_rating, y = as.factor(decade), fill = as.factor(decade))) +
    geom_density_ridges(alpha = 0.5, rel_min_height=0.01) +
    theme_ridges() +
    theme(legend.position = "none",
          axis.title.x = element_blank(),
          axis.title.y = element_blank())

genres_ridgeplot <- genres_dataframe |>
  ggplot(aes(x = average_rating, y = genres, fill = genres)) +
  geom_density_ridges(alpha = 0.5, rel_min_height=0.01) +
  scale_y_discrete(position = "right") +
  theme_ridges() +
  theme(legend.position = "none",
        axis.title.x = element_blank(),
        axis.title.y = element_blank())

# stitch plots together with patchwork
(decade_ridgeplot | genres_ridgeplot) + plot_annotation("Imdb rating distributions")
