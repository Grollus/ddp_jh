library(ggvis)
library(dplyr)

shinyServer(function(input, output){
  
  # Apply filters
  dat <- reactive({
    
    # Year filters
    d <- data %>%
      filter(
        year >= input$year[1],
        year <= input$year[2]
      )
    
    # 'Optional' breed selection; Defaults to selecting all breeds
    ifelse(input$breed == "all", d, 
           d <- d %>% filter(primary_breed == input$breed))
    
    d <- as.data.frame(d)
    d
})
    
  # Plotting filtered data
  vis <- reactive({
    
    dat %>%
      ggvis(~year)%>%
      layer_histograms(width = 1)%>%
      add_axis("x", title = "Year")%>%
      add_axis("y", title_offset = 50,
               title = ifelse(input$breed == "all", "Number of Dogs Registered as Born",
                              paste0("Number of ", input$breed, " Registered as Born")))
  })
  
  vis %>% bind_shiny("plot")
  
})