#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(openxlsx)
library(dplyr)
library(lubridate)
library(ggplot2)

#setwd("/home/michal/DevelopingDataProducts/ddp_courseProject")

translSeverity <- function(y) {
  sapply(y, function(x)
    switch(x, "1" = "Fatal", "2" = "Serious", "3" = "Slight"))
}
translWeekday <- function(y) {
  sapply(y, function(x)
    switch(
      x,
      "1" = "Sunday",
      "2" = "Monday",
      "3" = "Tuesday",
      "4" = "Wednesday",
      "5" = "Thursday",
      "6" = "Friday",
      "7"= "Saturday"
    ))
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  ds <- read.csv("RoadSafetyData_2015/Accidents_2015.csv") %>%
    select(Longitude, Latitude, Time, Accident_Severity, Day_of_Week) %>%
    transmute(
      Longitude,
      Latitude,
      Time,
      Severity = translSeverity(Accident_Severity),
      Weekday = translWeekday(Day_of_Week)
    )
  changeSubset <- reactive({
    filter(ds, Weekday == input$weekday, Severity == input$type)
  })
  output$map <- renderLeaflet({
    ds2 <- changeSubset()
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(ds2$Longitude,
                       ds2$Latitude,
                       weight = 1,
                       radius = 2) %>%
      fitBounds(-5, 52, 1.5, 58)
  })
  
  output$histogram <- renderPlot({
    ds2 <- changeSubset()
    ggplot(data.frame(time = as.numeric(ds2$Time) / 60), aes(time)) +
      geom_histogram(bins = 24) +
      xlim(c(0, 24)) +
      ggtitle(paste("Number of",input$type,"accidents on",input$weekday))
  })
})
