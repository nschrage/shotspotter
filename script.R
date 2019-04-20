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
  
  mutate(Month = fct_recode(Month, "January" = 1, "February" = 2, "March" = 3, "April" = 4,
                            "May" = 5, "June" = 6, "July" = 7, "August" = 8, "September" = 9, 
                            "October" = 10, "November" = 11, "December" = 12)) %>% 
  
  filter(Latitude > 37.71) %>% 
  
  filter(Rnds < 100) %>% 

  # turn locations into sf object in order to graph 
  st_as_sf(coords = c("Longitude", "Latitude"), crs = st_crs(san_francisco))


# set up plot

ggplot(data = san_francisco) + 
  
  # setting up san francisco backdrop
  
  geom_sf(fill = "cornsilk") + 
  
  # putting in layer with shop
  
  geom_sf(data = shotspotter, aes(size = Rnds, color = Hours)) +
  
  scale_color_viridis() + 
  
  #scale_size_continuous() +
  
  # formatting graph, by scaling and setting limits.
  
  coord_sf(xlim = c(-122.52, -122.35), ylim = c(37.7, 37.85)) +
  
  scale_x_continuous(limits = c(-122.52, -122.35)) +
  
  scale_y_continuous(limits = c(37.7, 37.85)) +
  
  xlab("Longitude") + ylab("Latitude") +
  
  ggtitle("Shotspotter SF", subtitle = "Hour: {frame_time}") +
    
  labs(size = "Rounds Fired", color = "Hour of the Day", caption = "Source: Justice Tech Lab") +

  theme_map() + 
  
  theme_tufte() #+ 
  
  #transition_states(Hours, transition_length = 24) + 

  #ease_aes()


  
  
  
  #labs(
   # title = "working",
 #   subtitle = "working",
 #   caption = "working"
#  ) +
  

  
 
  
  #scale_fill_viridis() +
  

  

  
  #transition_time(date)
  
 
 


# what story do I want to tell. 

  # plot by month 
  # color by time of day?
  # size = rnds?

# scale_fill_brewer(palette="Blues",
#labels = c("0-10", "10-50", "50-100", "100-500",
#           "500-1,000", "1,000-5,000", ">5,000")



# How to Push to Shiny App

# General organization is to any/all time consuming work (or work that depends
# on other websites --- like that the Shotspotter site is up) here, write out a
# final shots.rds file to the Shotspotter directory, and then access that data
# from the Shiny code.


# Now we can try a few plots to make sure things are working. At this point,
# there are two ways we could go. First, we could make the plot (or animation)
# we want, save it, and then just stick the saved object into the Shotspotter
# directory. Second, we could put the raw data into that directory and then do
# the plotting in the Shiny App.


#shapes <- urban_areas(class = "sf") 

#san_francisco <- shapes %>% 

#filter(str_detect(NAME10, "San Francisco--Oakland, CA"))



