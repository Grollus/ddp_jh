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
    
    if(input$compare == FALSE){
      dat %>%
        ggvis(~year)%>%
        layer_bars(width = 1, fill := 'steelblue')%>%
        add_axis("x", title = "Year")%>%
        add_axis("y", title_offset = 50,
                 title = ifelse(input$breed == "all", "# of Cats and Dogs Born",
                                paste0("# of ", input$breed, " Born")))
    }else{
      dat %>%
        group_by(year, animal_type)%>%
        summarise(count = n())%>%
        filter(year >= input$year[1],
               year <= input$year[2])%>%
        ggvis(~year,~count, stroke = ~animal_type)%>%
        layer_lines()%>%
        add_axis("x", title = "Year")%>%
        add_axis("y", title_offset = 50,
                 title = "# of Animals Born")
    }
    
  })
  
  vis %>% bind_shiny("plot")
  
})