library(tidyverse)
library(ggthemes)
library(patchwork)
library(ggtext)

coffee_survey <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2024/2024-05-14/coffee_survey.csv')

#should drop the _specify and _other columns I think
#more than half values in purchase dairy and sweetener are NA too
#_other columns seem like user input, idk about that. I could use purchase
  # for 1 or 2 visualisations, its an array so might be tough


# Drop all columns aside from ones specified
# Then remove all rows where said columns are all NA
  # solution here is a bit tacky, best I could think of without over complicating
    # Will have to change the 4 if I want more columns (assumes sub_id is never NA too)

coffee_survey <- coffee_survey |>
  select(c(submission_id, cups, favorite, additions))
  #subset(rowSums(is.na(coffee_survey)) != 4) |>

submissions <- n_distinct(coffee_survey$submission_id)

View(coffee_survey)

#segmented by cups of coffee per day
coffee_survey |>
  drop_na(additions, favorite) |>
  ggplot(aes(y = favorite, fill = cups)) +
  geom_bar(position = "dodge") +
  facet_wrap(~additions)

#additions 'cinnamon' and 'half & half' only have 1 value, drop maybe
  #What even is half & half anyway

coffee_survey |>
  ggplot(aes(y = additions)) +
  geom_bar()


(ggplot(coffee_survey, aes(y = additions)) +
geom_bar()) /
(ggplot(coffee_survey, aes(y = favorite)) +
geom_bar())

p1 <- coffee_survey |>
  separate_rows(additions, sep = ", ") |>
  #Rename 'or coffee creamer', remove 'or'
  #also the milk/dairy/creamer should all be one column, so combine them,
  #make sure the I dont add the % tho obviously.
  filter(!(additions %in% c("Half & half", "Cinnamon", "dairy alternative", "or coffee creamer"))) |>
  drop_na(additions) |>
  count(additions) |>
  mutate(
    percentage = (n / submissions) * 100,
    additions = str_replace(additions, "Milk", "Milk, dairy alternative, or coffee creamer")
    ) |>
  arrange(percentage) |>
  ggplot(aes(y = reorder(additions, percentage), x = percentage)) +
  geom_col() +
  geom_label(aes(
    label = paste(additions, ": ", round(percentage, 1), "%", sep = ""),
    x = 3, hjust = 0)) +
  labs(
    title = "Most common coffee additions"
  ) +
  theme_solid() +
  theme(
    plot.title = element_markdown(
      size = 8.5
    )
  )

p2 <- coffee_survey |>
  drop_na(favorite) |>
  count(favorite) |>
  mutate(
    percentage = (n / submissions) * 100
  ) |>
  arrange(percentage) |>
  ggplot(aes(y = reorder(favorite, percentage), x = percentage)) +
  geom_col() +
  geom_label(aes(
    label = paste(favorite, ": ", round(percentage, 1), "%", sep = ""),
    x = 3, hjust = 0)) +
  labs(
    title = "Favorite coffee drink"
  ) +
  theme_solid() +
  theme(
    plot.title = element_markdown(
      size = 10
    )
  )

p3 <- coffee_survey |>
  drop_na(cups) |>
  count(cups) |>
  mutate(
    percentage = (n / submissions) * 100
  ) |>
  arrange(percentage) |>
  ggplot(aes(
    y = factor(
    cups, levels = c("Less than 1", "1", "2", "3", "4", "More than 4")),
    x = percentage
    )) +
  geom_col() +
  geom_label(aes(
    label = paste(cups, ": ", round(percentage, 1), "%", sep = ""),
    x = 3, hjust = 0)) +
  labs(
    title = "Cups of coffee drank per day"
  ) +
  theme_solid() +
  theme(
    plot.title = element_markdown(
      size = 8.5
    )
  )

(p2 | (p1 / p3)) + plot_annotation(title = "Coffee drinking habits")
