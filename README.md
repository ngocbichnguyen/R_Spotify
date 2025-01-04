

### README: Spotify Data Analysis with R  

#### Overview  
This project analyzes a cleaned dataset of Spotify songs to uncover trends, correlations, and key insights into song popularity, artist performance, and streaming metrics. The analysis uses various R libraries such as `tidyverse`, `dplyr`, and `ggplot2`, focusing on data cleaning, transformation, and visualization. Key objectives include understanding release trends, exploring top song attributes, analyzing relationships between playlists/charts and streams, and identifying the most popular artists and their musical characteristics.

---

#### Key Highlights  

1. **Data Cleaning and Wrangling**  
   - Renamed columns for better readability.  
   - Converted blank values to `NA` and removed erroneous records.  
   - Combined separate release date components (`year`, `month`, `day`) into a unified `released_date` field.  
   - Converted relevant columns into appropriate data types, ensuring accurate calculations and analysis.  

2. **Data Visualizations**  
   - **Monthly Song Release Trends**:  
     A bar chart illustrates the distribution of song releases across months, highlighting months with above-average releases using a distinct color.  

   - **Attributes in Top 100 Songs**:  
     Box plots display the distribution of attributes (e.g., energy, danceability, and valence) for the 100 most-streamed songs.  

   - **Playlists/Charts and Streams Correlation**:  
     Scatter plots with trendlines explore relationships between playlist/chart inclusions and total streams, segmented by platform (Spotify, Apple Music, Deezer, Shazam).  

   - **Top 10 Artists by Streams and Song Releases**:  
     A combined bar-line chart visualizes the top 10 artists based on total streams and the number of released songs.  

   - **Key Distribution of Top Artists**:  
     Identifies the primary musical key used by the top 10 artists, analyzing its impact on their streaming success.  

---

#### Key Visual Outputs  

1. **Monthly Release Trends**  
   - Averages calculated for monthly song releases.  
   - Highlights months exceeding the average with a green bar (`#1ED760`).  
   - Includes a dashed red line for the average release threshold.  
<img width="559" alt="Screenshot 2025-01-04 at 11 23 29 am" src="https://github.com/user-attachments/assets/cfa7c2ec-d58c-4b85-9728-d0b5b43b1ee0" />

2. **Top Song Attributes**  
   - Box plots for attributes such as `danceability`, `energy`, and `acousticness` among top 100 songs.  
   - Median values annotated for quick insights.
<img width="512" alt="Screenshot 2025-01-04 at 11 24 00 am" src="https://github.com/user-attachments/assets/ec79cfe4-9b36-4a7b-9b99-2b8998db44a7" />


3. **Platform Correlation**  
   - Visualizes how the number of playlists or chart inclusions correlates with total streams.  
   - Custom platform-specific color coding for clarity.
<img width="441" alt="Screenshot 2025-01-04 at 11 24 10 am" src="https://github.com/user-attachments/assets/6e54182a-759d-4ac5-b882-178f518c1312" />


4. **Top Artists Performance**  
   - Comparison of total streams and song releases by the top 10 most-streamed artists.  
   - Secondary axis aligns song count with total streams for easy comparison.  
<img width="624" alt="Screenshot 2025-01-04 at 11 24 17 am" src="https://github.com/user-attachments/assets/83b04f42-dc3e-4059-97a1-8ab8f17d1a08" />

5. **Most Used Key**
   - Visualizes the most used key of top streamed artists
<img width="627" alt="Screenshot 2025-01-04 at 11 24 23 am" src="https://github.com/user-attachments/assets/4c13c0ac-b41b-4f75-941d-06debd2ce3b4" />


---

#### Libraries and Tools  
- **`tidyverse`**: Data manipulation and visualization.  
- **`dplyr`**: Efficient data wrangling and summarization.  
- **`ggplot2`**: Creating custom visualizations.  
- **`scales`**: Enhancing axis scaling and labeling.  
- **`ggpubr`**: Arranging and combining multiple plots.  

---

#### Files  
- **Input**:  
  - `Cleaned_Spotify_Dataset.csv`: Contains Spotify song data, including attributes, playlist/chart details, and streaming metrics.  

- **Output**:  
  - Multiple visualizations saved as plots or displayed during execution.  

---

#### Running the Analysis  
1. Install the required libraries:  
   ```R
   install.packages(c("tidyverse", "ggplot2", "scales", "ggpubr"))
   ```
2. Update the file path in the script to point to `Cleaned_Spotify_Dataset.csv`.  
3. Execute the script in R or RStudio.  

---

#### Key Insights  
- Seasonal trends affect song releases, with spikes in specific months.  
- Popular songs exhibit distinct attribute patterns (e.g., higher energy and danceability).  
- Strong correlations exist between playlist/chart inclusions and streams, varying by platform.  
- Certain musical keys dominate among top-performing artists, suggesting a potential link to audience preferences.  

---

This project provides a framework for exploring music streaming data, uncovering actionable insights, and leveraging data visualization to inform decision-making in the music industry.
