# Load the libraries
library(tidyverse) 
library(dplyr)
library(ggplot2)
library(scales) 
library(ggpubr)

# Read the dataset
dataset <- read.csv("/Users/macos/Documents/R Studio/Local_Repo/myrepo/Cleaned_Spotify_Dataset.csv")

# Take a look at the data
summary(dataset)
head(dataset)

## 1. Data Cleaning and Wrangling  

# Rename the columns
dataset <- dataset %>%
  rename(artist_name = artist.s._name,
         dance_ability = danceability_.,
         valence = valence_.,
         energy = energy_.,
         acousticness = acousticness_.,
         instrumentalness = instrumentalness_.,
         liveness = liveness_.,
         speechiness = speechiness_.)

# Convert blank value to NA
dataset[dataset == ""] <- NA

# Check the NA values
colSums(is.na(dataset), na.rm = TRUE) # number of NA value is small, hence can ignore

# Remove error record in streams value
dataset <- dataset %>%
  filter(!grepl("^BPM", streams))

# Combine released date
dataset$released_date <- as.Date(paste(dataset$released_year, 
                                       dataset$released_month, 
                                       dataset$released_day, sep = "-")) 
dataset <- subset(dataset, select = -c(released_month, released_day, released_year))

# Convert into right type
dataset <- dataset %>%
  mutate(artist_count=as.numeric(artist_count),
         in_spotify_playlists=as.numeric(in_spotify_playlists),
         in_spotify_charts=as.numeric(in_spotify_charts),
         streams=as.numeric(streams),
         in_apple_playlists=as.numeric(in_apple_playlists),
         in_apple_charts=as.numeric(in_apple_charts),
         in_deezer_playlists=as.numeric(in_deezer_playlists),
         in_deezer_charts=as.numeric(in_deezer_charts),
         in_shazam_charts=as.numeric(in_shazam_charts),
         bpm=as.numeric(bpm),
         key=as.factor(key), mode=as.factor(mode),
         dance_ability=as.numeric(dance_ability),
         valence=as.numeric(valence),
         energy=as.numeric(energy),
         acousticness=as.numeric(acousticness),
         instrumentalness=as.numeric(instrumentalness),
         liveness=as.numeric(liveness),
         speechiness=as.numeric(speechiness)
  )

## 2. Data Visualization

# 2.1 Songs Released by Month

# Extract the month from the release date
dataset <- dataset %>%
  mutate(month_name = format(released_date, "%B"))

# Count the number of songs released each month
monthly_releases <- dataset %>%
  group_by(month_name) %>%
  summarise(song_count = n()) %>%
  ungroup()

# Create a factor for month_name to maintain the correct order
monthly_releases <- monthly_releases %>%
  mutate(month_name = factor(month_name, levels = month.name))

# Calculate the mean number of songs released per month
mean_songs_per_month <- mean(monthly_releases$song_count)

# Create a new column to indicate color based on the mean
monthly_releases <- monthly_releases %>%
  mutate(color = ifelse(song_count >= mean_songs_per_month, "#1ED760", "black"))

# Create a bar plot
ggplot(monthly_releases, aes(x = month_name, y = song_count, fill = color)) +
  geom_bar(stat = "identity") +
  scale_fill_identity() +
  geom_hline(yintercept = mean_songs_per_month, linetype = "dashed", color = "red") +
  annotate("text", x = Inf, y = mean_songs_per_month, vjust = -2, hjust = 1.01, 
           label = paste("Avg monthly songs released:", round(mean_songs_per_month, 0)), 
           color = "red") +
  labs(title = "Song Release Trend by Month", x = "Month", y = "Number of Songs Released") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_x_discrete(labels = function(x) gsub("([0-9]{4})\\.", "\\1 ", x))



# 2.2. Attributes in top 100 songs

# Top 100 streamed songs
top_100_songs <- dataset %>%
  arrange(desc(streams)) %>%
  head(100)


# Summarize attribute in top 100 song
attribute_song <- top_100_songs %>%
  group_by(track_name) %>%
  summarise(
    bpm = mean(bpm, na.rm = TRUE),
    dance_ability = mean(dance_ability, na.rm = TRUE),
    valence = mean(valence, na.rm = TRUE),
    energy = mean(energy, na.rm = TRUE),
    acousticness = mean(acousticness, na.rm = TRUE),
    instrumentalness = mean(instrumentalness, na.rm = TRUE),
    liveness = mean(liveness, na.rm = TRUE),
    speechiness = mean(speechiness, na.rm = TRUE)
  )

# Reshape the data for plotting
attribute_song_long <- tidyr::pivot_longer(attribute_song, 
                                           cols = c(bpm, dance_ability, valence, energy, 
                                                    acousticness, instrumentalness, 
                                                    liveness, speechiness), 
                                           names_to = "Attribute", 
                                           values_to = "Value")

# Plotting box plots
ggplot(attribute_song_long, aes(x = Attribute, y = Value)) +
  geom_boxplot(fill = "#1ED760", color = "black") + 
  stat_summary(fun = median, geom = "text", aes(label = round(..y.., digits = 2)), 
               vjust = -0.3, color = "red", position = position_dodge(width = 0.5)) +
  labs(title = "Distribution of Music Attributes in Top 100 Songs",
       x = "Attribute",
       y = "Value") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 2.3. Relationship between playlist or charts and total streams
# Reshape the data to long format
playlist_song <- top_100_songs %>%
  group_by(track_name, streams) %>%
  summarise(Spotify = in_spotify_playlists,
            Apple_Music = in_apple_playlists,
            #Shazam = in_shazam_playlists,
            Deezer = in_deezer_playlists)

playlist_song_long <- playlist_song %>%
  pivot_longer(cols = c(Spotify, Apple_Music, Deezer),
               names_to = "Platform",
               values_to = "Playlists")

# Reshape the data to long format
chart_song <- top_100_songs %>%
  group_by(track_name, streams) %>%
  summarise(Spotify = in_spotify_charts,
            Apple_Music = in_apple_charts,
            Shazam = in_shazam_charts,
            Deezer = in_deezer_charts)

chart_song_long <- chart_song %>%
  pivot_longer(cols = c(Spotify, Apple_Music, Shazam, Deezer),
               names_to = "Platform",
               values_to = "Charts")

chart_song_long <- chart_song_long %>%
  filter(Platform != "Shazam" | Charts <= 200)

platform_colors <- c("Spotify" = "#1ED760", "Apple_Music" = "#FC3C44", "Deezer" = "#A33CF9", "Shazam" = "#0088FF")

# Create the scatter plot with custom colors for each platform
plot1 <- ggplot(playlist_song_long, aes(x = Playlists, y = streams, color = Platform)) +
  geom_point(alpha = 0.3) + 
  geom_smooth(method = "lm", se = FALSE) + 
  scale_color_manual(values = platform_colors) +
  labs(title = "Relationship of Playlists and Streams",
       x = "Number of Playlists on Platform",
       y = "Number of Streams") +
  theme_minimal() +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale()))

# Create the scatter plot with custom colors for each platform
plot2 <- ggplot(chart_song_long, aes(x = Charts, y = streams, color = Platform)) +
  geom_point(alpha = 0.3) + 
  geom_smooth(method = "lm", se = FALSE) + 
  scale_color_manual(values = platform_colors) +
  labs(title = "Relationship of Charts and Streams",
       x = "Number of Charts on Platform",
       y = "Number of Streams") +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale()))+
  theme_minimal()

ggarrange(plot1 , plot2,
          ncol = 1, nrow = 2)


# 2.4. Top 10 most streamed artists and number of song released
# Identify top 10 artists based on total streams
top_10_artist <- dataset %>%
  group_by(artist_name) %>%
  summarise(
    total_streams = sum(streams, na.rm = TRUE),
    song_count = n_distinct(track_name)
  ) %>%
  arrange(desc(total_streams)) %>%
  head(10)

ggplot(top_10_artist, aes(x = reorder(artist_name, total_streams))) +
  geom_bar(aes(y = total_streams), stat = "identity", fill = "#1ED760") +
  geom_line(aes(y = song_count * (max(total_streams) / max(song_count))), color = "black", size = 1, group = 1) +
  geom_point(aes(y = song_count * (max(total_streams) / max(song_count))), color = "black", size = 3) +
  scale_y_continuous(
    name = "Total Streams",
    sec.axis = sec_axis(~ . / (max(top_10_artist$total_streams) / max(top_10_artist$song_count)), name = "Number of Songs"),
    labels = label_number(scale_cut = cut_short_scale())
  ) +
  labs(title = "Top 10 Most Streamed Artists and Songs Released",
       x = "Artist Name") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 2.5. Change in key of top 10 most streamed artists
# Calculate total streams per artist and key
artist_key_streams <- dataset %>%
  group_by(artist_name, key) %>%
  summarise(total_streams = sum(streams, na.rm = TRUE), .groups = 'drop') %>%
  ungroup()

# Identify the most used key for each artist
artist_main_key <- artist_key_streams %>%
  group_by(artist_name) %>%
  filter(total_streams == max(total_streams)) %>%
  slice_head(n = 1) %>%
  ungroup()

# Sum the total streams for the most used key per artist
top_100_artist_key <- artist_main_key %>%
  group_by(artist_name) %>%
  summarise(total_streams = sum(total_streams), main_key = first(key), .groups = 'drop') %>%
  arrange(desc(total_streams)) %>%
  slice_head(n = 100)

# Count the frequency of each key among the top 10 artists
key_distribution <- top_100_artist_key %>%
  count(main_key) %>%
  mutate(percentage = n / sum(n) * 100) %>%
  arrange(desc(percentage))

key_distribution <- key_distribution %>%
  mutate(main_key = as.character(main_key),
         main_key = ifelse(is.na(main_key), "Others", main_key),
         main_key = factor(main_key)) 

# Create a custom color palette around #1ED760
custom_palette <- c("#1ED760", "#2DCC70", "#47D884", "#61DE98", "#7BE4AC", "#95E9C0", "#95E9C0", "#00C795")

# Plot pie chart with percentages and custom palette

ggplot(key_distribution, aes(x = reorder(main_key, -percentage), y = percentage, fill = main_key)) +
  geom_bar(stat = "identity", width = 0.7) +
  scale_fill_manual(values = custom_palette) +
  labs(title = "Most Used Keys among Top 100 Streamed Artists",
       x = "Key",
       y = "Percentage") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 0, hjust = 0.5),
        legend.position = "none")
