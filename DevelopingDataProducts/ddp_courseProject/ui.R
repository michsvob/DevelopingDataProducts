#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  # Application title
  titlePanel("Road accidents in the UK"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      radioButtons("type", "Severity of accident", c("Fatal", "Serious", "Slight")),
      radioButtons(
        "weekday",
        "Day of the week",
        c(
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday",
          "Sunday"
        )
      )
    ),
    # Show a map
    mainPanel(tabsetPanel(
      tabPanel(
        "help",
        h3("Instructions"),
        p(
          "The application uses data about road accidents for the year 2015 from the dataset Road Safety Data provided by Brittish ministerial Department For Transport"
        ),
        a(
          href = "https://data.gov.uk/dataset/road-accidents-safety-data",
          "https://data.gov.uk/dataset/road-accidents-safety-data"
        ),
        p(
          "To use the app you have to select the weekday of interest and group of accidents based on the accident severity from the sidebar.
          Then if you select the tab labelled histogram, you should see a histogram of accident frequencies for every hour. If you select the tab map, you will see a map indicating where the accidents happened."
        )
        ),
      tabPanel("map", leafletOutput("map")),
      tabPanel("histogram", plotOutput("histogram"))
        ))
)
))