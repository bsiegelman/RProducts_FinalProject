## Load the Nile dataset
data(Nile)

## Define server logic
shinyServer(function(input, output, session) {
     ## dynamically enable second numeric input
     enable("end_year")
     observe({
          # Update value of end_year based on the value of start_year
          disable("end_year")
          req(input$start_year)
          enable("end_year")
          updateNumericInput(session, "end_year", min = input$start_year)
     })
     
     observe({
          req(input$start_year)
          if(input$start_year < 1871) {
               updateNumericInput(session, "start_year", value = 1871)
          }
     })
     
     observe({
          if(input$end_year > 1970) {
               updateNumericInput(session, "end_year", value = 1970)
          }
     })
     ## filter the Nile data based on inputs
     filtered_nile <- reactive({
          window(Nile, input$start_year, input$end_year)
     })
     ## create calculation objects and resulting table
     flow_table <- reactive({
     
          min <- min(filtered_nile())
          max <- max(filtered_nile())
          mean <- round(mean(filtered_nile()),2)
          median <- median(filtered_nile())
          slope <- (filtered_nile()[length(filtered_nile())]-filtered_nile()[1])-
               (input$end_year - input$start_year)
          ## set up table with calculations
          flow_calc <- 
               data.frame(
                    `Measure` = c("Minimum Flow During Selected Period",
                         "Maximum Flow During Selected Period",
                         "Average Flow During Selected Period", 
                         "Median Flow During Selected Period", 
                         "Average Annual Change in Flow During Selected Period"),
                    `Value (billion cubic meters)` = c(
                         min, max, mean, median, slope))
          colnames(flow_calc) <- c("Measure",
                                   "Value (billion cubic meters)")

          datatable(flow_calc, options= list(searching = FALSE, 
                                             dom='t'))
     })
     
     ## define reactive plot object
     output$ts_plot <- renderPlot({
          plot(as.ts(Nile), xlab = "Year", 
               ylab = "Annual Flow (billion cubic meters)", 
               main = "Annual Flow of the Nile River at Aswan, 1871-1970")
          points(time(filtered_nile()), filtered_nile(), col = "blue", pch = 16)
          lines(filtered_nile(), col = "blue", lwd = 3)
          axis(side = 1, at = seq(1870, 1970, by = 10))
          })
     ## define table object
     output$flow_table <- renderDT({
          flow_table()
     })
     ## define explanation text
     output$explanation <- renderText(
          "Select start and end years to explore the flow of the River Nile at Aswan Dam during various periods of history."
     )
})