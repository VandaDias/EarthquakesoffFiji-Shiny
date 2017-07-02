library(shiny)
library(leaflet)

earthquakes <- datasets::quakes
earthquakes$popup <- paste("Richter magnitude ", earthquakes$mag, "<br>", 
                           "Depth", earthquakes$depth, " km")
earthquakesIcon <- makeIcon(iconUrl = "earthquake_icon.png", iconWidth = 20, iconHeight = 20, 
                            iconAnchorX = 10, iconAnchorY = 10)

shinyServer(function(input, output) {
  output$doc <- renderText({
    paste("This application provides the location and magnitude of earthquakes near the Fiji islands, since 1964. It allows the user to select a group of data points based on a range of magnitude, and provides its map and data table with the location and characteristics of the group of earthquakes selected.", 
          "It is based on a data set from the datasets R package, quakes, that gives the locations of 1000 earthquakes off Fiji of magnitude higher than 4.0 (Richter scale).",
          " ",
          "Instructions:",
          "1. Select throughout the slider, the range of the earthquakes´ magnitude to be shown,",
          "2. In the main panel there are other two tabs that show the map and the data table associated with the selection,",
          "2.1 The map tab shows the location of the selected earthquakes and it pops up their characteristics as latitude, longitude, depth and magnitude,",
          "2.2 The table tab shows all the characteristics of the earthquakes selection in a data table,",
          "3. As you move the slider, the selected points change automatically.",
          sep = "\n")
  })
  output$rangemag <- renderText({
    paste(input$slider[1], " to ", input$slider[2])
  })
  output$map <- renderLeaflet({
    minmag <- input$slider[1]
    maxmag <- input$slider[2]
    selection <- earthquakes[earthquakes$mag >= minmag & 
                               earthquakes$mag <= maxmag, ]
    selection %>%
      leaflet() %>%
      addTiles() %>%
      addMarkers(lat = selection$lat, lng = selection$long,
                 icon = earthquakesIcon, popup = selection$popup,
                 clusterOptions = markerClusterOptions())
  }) 
  output$table <- renderTable({
    minmag <- input$slider[1]
    maxmag <- input$slider[2]
    earthquakes[earthquakes$mag >= minmag & 
                  earthquakes$mag <= maxmag, -6]
  })
})
