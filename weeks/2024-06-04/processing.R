library(tidyverse)
library(sf)
library(patchwork)
library(ggthemes)

cheeses <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-06-04/cheeses.csv')

#Cheeses of Italy (so I can do a cool map)

#remove non-italy rows, drop rows where region is empty, replace &/and with comma
cheeses <- cheeses |>
  filter(country == 'Italy') |>
  drop_na(region) |>
  mutate(region = gsub(" & | and ", ", ", region))

# geoJSON source: https://github.com/openpolis/geojson-italy/tree/master
my_sf <- read_sf("weeks/2024-06-04/limits_IT_regions.geojson")

#new dataframe with separated regions to use for choropleth
cheeses_geo <- cheeses |> 
  separate_rows(region, sep = ", ") |>
  mutate(
    #Replace typos, cities used where region should be, etc.,
    region = case_match(
      region,
      c("Piedmont", "Alba", "Murazzano")          ~ "Piemonte",
      c("the Veneto", "Asiago", "Treviso")        ~ "Veneto",
      c("Foggia", "Gravina in Puglia", "Murgia")  ~ "Puglia",
      c("Lodi", "Lombardy")                       ~ "Lombardia",
      c("Naples", "Paestum")                      ~ "Campania",
      c("Oristano", "Sardinia")                   ~ "Sardegna",
      c("Pienza", "Tuscany")                      ~ "Toscana",
      c("Carnia", "Friuli Venezia Giulia")        ~ "Friuli-Venezia Giulia",
      "Crotone"                                   ~ "Calabria",
      "Modena"                                    ~ "Emilia-Romagna",
      "Moliterno"                                 ~ "Basilicata",
      "Pesaro-Urbino"                             ~ "Marche",
      "Trentino"                                  ~ "Trentino-Alto Adige/Südtirol",
      .default = region
    )
  ) |>
  # Remove rows where I'm unsure of what region to use
  filter(!region %in% c("Italy", "Valpadana", "Piave Valley", "Po valley region")) |>
  count(region) |>
  #rename column so it matches with shape file for join
  rename_at('region', ~'reg_name')

sf_merge <- my_sf |>
  left_join(cheeses_geo)

ggplot(sf_merge) +
  geom_sf(aes(fill = n), linewidth = 0) +
  geom_sf_text(aes(label = n), size = 4, na.rm = TRUE, fontface = "bold") +
  theme_map() +
  scale_fill_viridis_c(
    option = "cividis",
    na.value = "white",
    trans = "log", breaks = c(1, 5, 10, 15, 20, 40),
    name = "Number of cheeses",
    guide = guide_legend(
      keyheight = unit(3, units = "mm"),
      keywidth = unit(10, units = "mm"),
      label.position = "bottom",
      title.position = "top",
      nrow = 1
    )
  ) +
  labs(
    title = "Cheese in Italy",
    subtitle = "Regions of Italy by the number of cheeses originating",
    caption = "Source: cheese.com"
  ) + theme(
    plot.title = element_text(
      size = 20
    ),
    plot.subtitle = element_text(
      size = 16
    ),
    plot.caption = element_text(
      size = 8
    )
  )
