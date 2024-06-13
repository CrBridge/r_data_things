library(tidyverse)
library(treemapify)

emissions <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-05-21/emissions.csv')

emissions <- emissions |>
  mutate(
    parent_type = str_replace(parent_type, "State-owned Entity", "State/state owned"),
    parent_type = str_replace(parent_type, "Nation State", "State/state owned"),
    parent_entity = str_replace(parent_entity, "China \\(Cement\\)", "China"),
    parent_entity = str_replace(parent_entity, "China \\(Coal\\)", "China"),
    commodity = case_when(
      str_detect(commodity, "Coal") ~ "Coal",
      TRUE ~ commodity
    )
  ) |>
  filter(year == 2022) |>
  group_by(parent_entity, parent_type, year) |>
  summarize(total_emissions_MtCO2e = sum(total_emissions_MtCO2e, na.rm = TRUE), .groups = 'drop')

ggplot(emissions, aes(
  area = total_emissions_MtCO2e,
  subgroup = parent_type,
  label = parent_entity)) +
  geom_treemap(fill = "#A03232") + 
  geom_treemap_subgroup_border(color = "white") +
  geom_treemap_subgroup_text(place = "bottom",
                             color = "white") +
  geom_treemap_text(place = "topleft",
                    color = "white") +
  labs(
    title = "largest emmiters of carbon dioxide in 2022",
    subtitle = "measured by amount of emissions traced to"
  ) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5)
  )
