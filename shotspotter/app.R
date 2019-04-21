#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)
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
library(shiny)
library(gifski)
library(png)

shotspotter_sf_plot <- read_rds(path = "~/Desktop/Gov 1005 Projects/shotspotter/shotspotter_sf.rds")
sf_shape_files <- read_rds(path = "~/Desktop/Gov 1005 Projects/shotspotter/shape_files.rds")

# Define UI for application that draws a histogram
ui <- fluidPage(
  
   # Application title
   titlePanel("San Francisco, CA ShotSpotter Data Mapped"),
   
   #fluidRow(
    # column(12, includeMarkdown("shotspotterMD.Rmd"))
   #),
   
   mainPanel(
     imageOutput("plot1")
   ),
   
   shotspotter_sf_plot <- read_rds(path = "~/Desktop/Gov 1005 Projects/shotspotter/shotspotter_sf.rds"),
   sf_shape_files <- read_rds(path = "~/Desktop/Gov 1005 Projects/shotspotter/shape_files.rds")
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$plot1 <- renderImage({
     outfile <- tempfile(fileext='.gif')
     
     p = ggplot(data = sf_shape_files) + geom_sf() + 
       geom_sf(data = shotspotter_sf_plot, aes(size = Rnds), show.legend = FALSE) + coord_sf(xlim = c(-122.52, -122.35), ylim = c(37.7, 37.82)) + xlab("Longitude") + ylab("Latitude") +
       ggtitle("ShotSpotter SF Data Collected at {closest_state}", subtitle = "Size: # of Rounds Fired") + labs(size = "Rounds Fired", color = "Hour of the Day", caption = "Source: Justice Tech Lab") +
       guides(size=guide_legend(title=NULL), color=guide_legend(title=NULL)) +
       theme_map() + theme_tufte() + transition_states(Time, state_length = 10, transition_length = 5)
     
     anim_save("outfile.gif", animate(p))
     
     list(src = "outfile.gif",
          contentType = 'image/gif')}, deleteFile = TRUE)}

     
  

# Run the application 
shinyApp(ui = ui, server = server)

