# Animation #1

library(tigris)
library(ggplot2)
library(purrr)
library(tidyverse)
library(fs)
library(sf)
library(lubridate)
library(ggmap)
library(ggplot2)
library(mapproj)
library(ggthemes)
library(viridis)
library(scales)
library(gganimate)

(tigris_class = "sf")

# Read in Data 

shotspotter <- read_csv("http://justicetechlab.org/wp-content/uploads/2018/05/San_Francisco_ShotSpotter.csv", col_types = 
                          cols(
                            Type = col_character(),
                            ID = col_double(),
                            Date = col_character(),
                            Time = col_time(format = ""),
                            Rnds = col_double(),
                            Beat = col_logical(),
                            DISPO = col_logical(),
                            `returned address` = col_character(),
                            Latitude = col_double(),
                            Longitude = col_double()
                          )) %>% 
  
  # manipulated the data, turned rounds into numeric values, turned date into
  # date via lubridate and then made new columns from that
  
  mutate(Rnds = as.numeric(Rnds)) %>%
  
  mutate(Date = dmy(Date)) %>% 
  
  mutate(Hours = hour(Time)) %>%
  
  mutate(Year = year(Date)) %>% 
  
  mutate(Month = month(Date))

# Get Shape Files a Different Way via the code on Piazza 
# first look for places in ca

san_francisco <- places("ca", class = "sf", cb = TRUE) %>% 
  
  filter(NAME == "San Francisco")

shotspotter <- shotspotter %>%
  
  # turn locations into sf object in order to graph 
  st_as_sf(coords = c("Longitude", "Latitude"), crs = st_crs(san_francisco))

p1 <-  ggplot(data = san_francisco) + 
  
  # setting up san francisco backdrop
  
  geom_sf() + 
  
  # putting in layer with shop
  
  geom_sf(data = shotspotter, aes(size = Rnds, color = Month)) +
  
  scale_color_viridis() + 
  
  # formatting graph, by scaling and setting limits.
  
  coord_sf(xlim = c(-122.52, -122.35), ylim = c(37.7, 37.82)) +
  
  # titled x and y axis
  
  xlab("Longitude") + ylab("Latitude") +
  
  # added a title and subtitle
  
  ggtitle("ShotSpotter SF Data Collected at {closest_state}:00", subtitle = "Size: # of Rounds Fired") +
  
  # added caption
  
  labs(caption = "Source: Justice Tech Lab") +
  
  # turn off guide
  
  guides(size=element_blank()) +
  
  # added map and minimalist tufte theme
  
  theme_map() + 
  
  theme_tufte() + 
  
  # added animation
  
  transition_states(Hours)

p1

# saved animation to bring to shiny

anim_save("shotspotter_anim_1.gif", animation = last_animation(), path = "~/Desktop/Gov 1005 Projects/shotspotter/shotspotter/")
