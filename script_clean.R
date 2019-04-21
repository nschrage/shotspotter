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


write_rds(san_francisco, "shape_files.rds", compress = "none")

shotspotter <- shotspotter %>% 
  
  mutate(Rnds = as.numeric(Rnds)) %>%
  
  #mutate(Date = dmy(Date)) %>% 
  
 # mutate(Year = year(Date)) %>% 
  
  #filter(Year == 2015) %>% 
  
  filter(Rnds > 20) %>% 
  
  # turn locations into sf object in order to graph 
  st_as_sf(coords = c("Longitude", "Latitude"), crs = st_crs(san_francisco)) 
  
  
  
write_rds(shotspotter, "shotspotter_sf.rds", compress = "none")
