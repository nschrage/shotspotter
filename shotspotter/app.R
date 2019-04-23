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


# Define UI for application that draws a histogram
ui <- fluidPage(
  
   # Application title
   titlePanel("San Francisco, CA ShotSpotter Data Mapped"),
   
   fluidRow(
    column(12, includeMarkdown("shotspotterMD.Rmd"))
   ),
   
   mainPanel(
     imageOutput("plot1"),
     
     imageOutput("plot2")
   
     )
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$plot1 <- renderImage({
     outfile <- tempfile(fileext='.gif')

     list(src = "shotspotter_anim_1.gif",
          contentType = 'image/gif')}, deleteFile = FALSE)
   
   output$plot2 <- renderImage({
     outfile <- tempfile(fileext='.gif')
     
     list(src = "shotspotter_anim_2.gif",
          contentType = 'image/gif')}, deleteFile = FALSE)
   
   }

     
  

# Run the application 
shinyApp(ui = ui, server = server)

