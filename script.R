# Load Packages

library(tigris)
library(ggplot2)
library(purrr)
library(tidyverse)
library(fs)
library(lubridate)

# Read in Data 

shotspotter <- read_csv("http://justicetechlab.org/wp-content/uploads/2018/05/San_Francisco_ShotSpotter.csv")

# Get Shape Files



# How to Push to Shiny App

# I prefer to use tigris directly. The class = "sf" argument is often handy . .
# . as is urban_areas() . . . st_as_sf() . . . st_crs()


