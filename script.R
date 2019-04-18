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

# Get Shape Files

shapes <- urban_areas(class = "sf") 

san_francisco <- shapes %>% 
  
  filter(str_detect(NAME10, "San Francisco--Oakland, CA"))
  
 
shot_locations <- st_as_sf(shotspotter, coords = c("Longitude", "Latitude"), crs = 4326)

# st_crs(shot_locations) --> Not sure what this is doing

ggplot(data = san_francisco) +
  
  geom_sf() +
  
  geom_sf(data = shot_locations) +
  
  theme_map()
 
# st_as_sf() %>%
# st_crs()



# How to Push to Shiny App

# I prefer to use tigris directly. The class = "sf" argument is often handy . .
# . as is urban_areas() . . . st_as_sf() . . . st_crs()


