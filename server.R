library(shiny)
library(DT)
library(leaflet)
library(dplyr)
library(htmltools)

function(input, output) {
  csvData <- read.csv("blood-banks.csv")
  csvData <- data.frame(csvData, stringsAsFactors = FALSE)
  csvData$Longitude <- as.numeric(csvData$Longitude)
  csvData$Latitude <- as.numeric(csvData$Latitude)
  csvData <- filter(csvData, Longitude != "NA")
  csvData <- filter(csvData, Latitude != "NA")
  pal <-
    colorFactor(
      pal = c("#1b9e77", "#d95f02", "#7570b3"),
      domain = c("Charity", "Government", "Private")
    )
  
  csvData <-
    mutate(
      csvData,
      cntnt = paste0(
        '<strong>Name: </strong>',
        Blood.Bank.Name,
        '<br><strong>State:</strong> ',
        State,
        '<br><strong>Time:</strong> ',
        Service.Time,
        '<br><strong>Mobile:</strong> ',
        Mobile,
        '<br><strong>HelpLine:</strong> ',
        Helpline,
        '<br><strong>Contact1:</strong> ',
        Contact.No.1,
        '<br><strong>Email:</strong> ',
        Email,
        '<br><strong>Website:</strong> ',
        Website
      )
    )
  
  
  output$csvDataFrame <- renderDataTable(datatable(csvData[, c(-13, -29:-35)], options = list(scrollX = TRUE)))
  output$plot <- renderLeaflet({
    leaflet(csvData) %>%
      addCircleMarkers(
        lng = ~ Longitude,
        lat = ~ Latitude,
        color = ~ pal(Category),
        popup = ~ as.character(cntnt),
        radius = 2
      ) %>%
      addTiles() %>%
      addLegend(pal = pal, values = csvData$Category) %>%
      addEasyButton(easyButton(
        icon = "fa-crosshairs",
        title = "ME",
        onClick = JS("function(btn, map){ map.locate({setView: true}); }")
      ))
    
  })
}