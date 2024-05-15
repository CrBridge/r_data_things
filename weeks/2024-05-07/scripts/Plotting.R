#Might want to separate each plot into a separate script, we'll see

#Run Processing.R to clean data beforehand
#might want to load 'ggthemes' for more customization
library(ggthemes)
library(ggtext)
# gender of artists by genre
(rolling_stone |> drop_na(genre)) |>
  ggplot(aes(y = fct_infreq(genre), fill = artist_gender)) + geom_bar()

#g + geom_bar(aes(fill = as.factor(artist_member_count)))
#ggplot(rolling_stone, aes(y = artist_gender)) + geom_bar()
#ggplot(genre_change_df, aes(x=genre_ave_billboard_weeks, y=genre_ave_billboard_ranks, label=genre)) +
 #geom_point(size = 5) # Show dots
#ggplot(rolling_stone, aes(x=peak_billboard_position, y=weeks_on_billboard)) +
  #geom_point(alpha=0.1) +
  #geom_smooth(se=FALSE)

#Introducing line width and line type causes some genres to have no lines at all
ggplot(genres_pivoted, aes(x = year, y = avg_rank)) +
  geom_line(aes(color = genre, , linetype = genre), linewidth = 1) +
  geom_point(aes(color = genre), size = 3, alpha = 0.4) +
  scale_x_continuous(breaks = c(2003, 2020))

genre_change_df$genre <- genre_change_df$genre |>
  replace_na("Genre not specified")

#lollipop chart, to show better show change over time
ggplot(genre_change_df) +
  geom_segment(aes(x = genre, xend = genre, y = genre_ave_2003, yend = genre_ave_2012)) +
  geom_segment(aes(x = genre, xend = genre, y = genre_ave_2012, yend = genre_ave_2020)) +
  geom_point(aes(x = genre, y = genre_ave_2003), color = "red", size = 2) +
  geom_point(aes(x = genre, y = genre_ave_2012), color = "green", size = 2) +
  geom_point(aes(x = genre, y = genre_ave_2020), color = "blue", size = 2) +
  coord_flip() +
  theme_excel_new() +
  labs(
    title = "Change in musical genre acclaim",
    subtitle = "Average ranking by genre on the Rolling Stone top 500 album lists
    in <b style='color:red'>2003</b>, <b style='color:green'>2012</b>, and <b style='color:blue'>2020</b>"
  ) +
  theme(
    plot.title = element_markdown(
      size = 10
    ),
    plot.subtitle = element_markdown(
      size = 7.5
    )
  )