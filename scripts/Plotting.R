#Might want to separate each plot into a separate script, we'll see

#Run Processing.R to clean data beforehand
#might want to load 'ggthemes' for more customization
library(ggthemes)
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