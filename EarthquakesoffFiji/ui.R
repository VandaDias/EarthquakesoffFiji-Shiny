library(shiny)
library(leaflet)

shinyUI(fluidPage(
  titlePanel("Earthquakes off Fiji"),
  sidebarLayout(
    sidebarPanel(
      h4("Earthquakes' magnitude selected:"),
      h3(textOutput("rangemag")),
      h2(" "),
      sliderInput("slider", "Select range of values", 4.0, 6.4, value = c(4.5, 5.0), 
                  step = 0.1)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Documentation", verbatimTextOutput("doc")),
        tabPanel("Map", leafletOutput("map")),
        tabPanel("Table", tableOutput("table"))
      )
    )
  )
))
