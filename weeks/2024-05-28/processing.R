library(tidyverse)
library(igraph)
library(ggraph)

# Graphs are too confusing right now, might come back to this later

planting <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-05-28/planting_2021.csv')
planting <- planting |>
  select(one_of('vegetable', 'variety', 'number_seeds_planted'))

mygraph <- graph_from_data_frame(planting)

ggraph(mygraph, layout = 'circlepack') + 
  geom_node_circle(aes(fill = depth)) +
  theme_void()
