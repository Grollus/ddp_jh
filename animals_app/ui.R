library(shiny)
library(ggvis)
shinyUI(fluidPage(
  titlePanel("Visualization of Pet Ownership in Louisville"),
  fluidRow(
    column(4,
           wellPanel(
             helpText("Adjust the slider to display the selected range of years"),
             sliderInput("year", "Years",
                         min = 1980, max = 2015, value = c(1980, 2015), step = 1),
             conditionalPanel(
               condition = 'input.breed == "all"',
               checkboxInput("compare", "Compare Cat vs Dog",
                             value = FALSE)
             ),
             conditionalPanel(
               condition = 'input.compare == false',
               selectInput("breed", "Select a Breed", multiple = FALSE,
                           choices = breeds, selected = 'all')
             ),
             helpText("This is a simple Shiny application depicting the popularity of 
                      various dog and cat breeds in Louisville, KY."),
             helpText("Instructions: To get started, just select a breed and adjust 
                      the slider to the range of years you would like to see displayed."),
             helpText("Or you can see how cats and dogs have compared through the years
                      by selecting the 'Compare Cat vs Dog' box."),
             tags$small("Note: Breed must be set to 'all' to compare cats and dogs.")
                      
           )),
  mainPanel(
      ggvisOutput("plot")
    )
  )
))
