library(shiny)
library(shinyjs)
library(DT)
library(datasets)

fluidPage(
     ##
     useShinyjs(),
     ##App Title
     titlePanel("Select the Bounding Years"),
     sidebarLayout(
          ##Sidebar Panel
          sidebarPanel(
               ## instruction text
               textOutput("explanation"),
               br(),
               ## Create inputs for start and end years
               sliderInput("start_year", "Choose a Starting Year", 1871, 1970, 
                           1871, 1, ticks=FALSE, sep=""),
               sliderInput("end_year", "Choose an Ending Year", 1871, 1970, 1970,
                           1, ticks=FALSE, sep=""),
          ),
          ## Main Panel
          mainPanel(
               plotOutput("ts_plot"),
               DTOutput("flow_table")
          )
     )
)