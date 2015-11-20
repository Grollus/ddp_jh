library(shiny)
library(ggvis)
shinyUI(fluidPage(
  titlePanel("Visualization of Pet Ownership in Louisville"),
  fluidRow(
    column(3,
           wellPanel(
             helpText("Adjust the slider to display the selected range of years"),
             sliderInput("year", "Years",
                         min = 1980, max = 2015, value = c(1980, 2015), step = 1),
             selectInput("breed", "Select a Breed to Display", multiple = FALSE,
                         choices = breeds, selected = 'all')
           )),
  mainPanel(
    ggvisOutput("plot"))
  )
))
