library(shiny)
library(leaflet)

navbarPage(
  "Location of Blood Banks",
  id = "main",
  tabPanel("Map", leafletOutput("plot", height = 500)),
  tabPanel("Data", DT::dataTableOutput("csvDataFrame"))
)