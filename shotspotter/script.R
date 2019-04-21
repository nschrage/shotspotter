# Load Packages

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
)) 


# Get Shape Files a Different Way via the code on Piazza 
# first look for places in ca

san_francisco <- places("ca", class = "sf", cb = TRUE) %>% 
  filter(NAME == "San Francisco")

shotspotter <- shotspotter %>% 
  
  mutate(Rnds = as.numeric(Rnds)) %>%
  
  mutate(Hours = hour(Time)) %>% 
  
  mutate(Date = dmy(Date)) %>% 
  
  mutate(Month = month(Date)) %>% 
  
  mutate(Week = week(Date)) %>% 
  
  mutate(Year = year(Date)) %>% 
  
  filter(Year == 2015) %>% 
  
  filter(Latitude > 37.71) %>% 
  
  filter(Rnds < 100) %>% 
  
  group_by(Week) %>% 

  # turn locations into sf object in order to graph 
  st_as_sf(coords = c("Longitude", "Latitude"), crs = st_crs(san_francisco))


# set up plot

ggplot(data = san_francisco) + 
  
  # setting up san francisco backdrop
  
  geom_sf(fill = "cornsilk") + 
  
  # putting in layer with shop
  
  geom_sf(data = shotspotter, aes(size = Rnds, color = Week), show.legend = FALSE) +
  
  scale_color_viridis() + 
  
  # formatting graph, by scaling and setting limits.
  
  coord_sf(xlim = c(-122.52, -122.35), ylim = c(37.7, 37.82)) +
  
  #scale_x_continuous(limits = c(-122.52, -122.35)) +
  
  #scale_y_continuous(limits = c(37.7, 37.85)) +
  
  xlab("Longitude") + ylab("Latitude") +
  
  ggtitle("ShotSpotter SF Data Collected in {closest_state}, 2015", subtitle = "Size: # of Rounds Fired, Color by Time of Day") +
    
  labs(caption = "Source: Justice Tech Lab") +
  
  guides(size=guide_legend(title=NULL), color=guide_legend(title=NULL)) +

  theme_map() + 
  
  theme_tufte() #+ 

  #transition_states(Month) 








