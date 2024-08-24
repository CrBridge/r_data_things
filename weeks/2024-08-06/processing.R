library(tidyverse)
library(data.table)
library(patchwork)

#Working with data.table this time, need the added speed
olympics <- fread('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-08-06/olympics.csv')

View(olympics)

olympics |> ggplot() +
  geom_bar(mapping = aes(x = .data$medal))

#There are 242 teams in the dataset with at least 1 gold medal
#   For context, there are 1184 teams in full
olympics |>
  filter(.data$medal == "Gold") |>
  count(team, sort=TRUE)

# There are 66 sports, and 765 unique events recorded
#   Worth noting, many (likely a majority) are divided by sex
olympics |>
  count(event, sort=TRUE)
# Filtering out non-medal winners would remove 85% of the data

# 196,000 men and 74,000 women 
olympics |>
  count(sex, sort=TRUE)


# To get whether an event is men's, women's or mixed
#  Not very efficient I suppose, it could really be one column instead of 3
events <- data.table(event = unique(olympics[, event]))
events[, men := grepl("Men", event)]
events[, women := grepl("Women", event)]
events[, mixed := grepl("Mixed", event)]

#Only 1, some event called Luge, seems kinda like sledding
# Apart from that, the columns account for everything
events[(men & women) | (women & mixed) | (men & mixed)]
events[!men & !women & !mixed]
# Not sure how I should treat it, so I'll just get rid of it
events <- events[event != "Luge Mixed (Men)'s Doubles"]

# frequency of each:
#   463 men's, 211 women's, and 90 mixed
events[, lapply(.SD, function(x) sum(x, na.rm = TRUE)),
       .SDcols = c("men", "women", "mixed")]
rm(events)


# Seemingly, data only goes up to 2016, so lets find how many different events
#   were held then and in the winter games previous
# It seems only 404 unique events were held in 2016 and 2014, 361 less than the
#   overall total. My estimate would be that the bulk of those 361 can be
#   explained by changing of naming conventions/incorrect entries, etc., instead
#   of events no longer being practised
olympics |>
  filter(.data$year == "2016" | .data$year == "2014") |>
  (\(x) x[, unique(event)])() |>
  length()

# Top 10 gold medal scoring countries
#   I also notice the countries 'East Germany' and 'Soviet Union'
#   This means teams are recorded as they were when it happened
#   East Germany and Soviet Union are easy fixes, but there might be
#   trickier ones
#     For example, Is a country like Austria-Hungary in here? Not sure
#     How you'd treat a country like that
olympics |>
  filter(.data$medal == "Gold") |>
  count(team, sort=TRUE) |>
  top_n(10) |>
  ggplot() +
  geom_col(aes(x = n, y = team))

#most practised sports
# Athletics seems way too broad, but could be good
# to visualize its range
olympics |>
  filter(.data$season == "Summer") |>
  count(sport, sort=TRUE) |>
  top_n(10) |>
  ggplot() +
  geom_col(aes(x = n, y = sport))

# Plan is to visualize range of heights and
# weights for different sport types (will probably facet by gender)

# This code gets the values of the top 10 summer sports
top_sports <- olympics |>
  filter(.data$season == "Summer") |>
  count(sport, sort=TRUE) |>
  top_n(10, n) |>
  pull(sport)

# We then filter the original dataset to only contain said top 10
olympics <- olympics |>
  filter(sport %in% top_sports)

# Final plot is going to be 4 plots, showing the distribution of
# Height and weight for the top 10 summer sports, separated by gender
  # height is in cm, weight is in kg

top_sports <- olympics |>
  group_by(.data$sport, .data$sex) |>
  summarise(
    avg_height = mean(height, na.rm = TRUE),
    avg_weight = mean(weight, na.rm = TRUE)
  )

heights <- olympics |>
  ggplot(aes(y = sport, x = avg_height, colour = sex)) +
  geom_segment(
    aes(y = sport, yend = sport, x = 150, xend = avg_height)
    ) +
  geom_point(
    aes(y = sport, x = avg_height)
  ) +
  facet_grid(~sex) + 
  theme_minimal() +
  labs(y = "", x = "Average Height") +
  theme(legend.position = "none")

weights <- olympics |>
  ggplot(aes(y = sport, x = avg_weight, colour = sex)) +
  geom_segment(
    aes(y = sport, yend = sport, x = 40, xend = avg_weight)
  ) +
  geom_point(
    aes(y = sport, x = avg_weight)
  ) +
  facet_grid(~sex) + 
  theme_minimal() +
  labs(y = "", x = "Average Weight") +
  theme(
    strip.text.x = element_blank(),
    legend.position = "none"
  )

(heights / weights) + plot_annotation("Average height and weight for Olympic athletes by sport and sex")
