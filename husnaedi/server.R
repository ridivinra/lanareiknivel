#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(tidyverse)
library(shiny)
library(shinydashboard)
library(plotly)
library(kableExtra)
source("loanFun.R")
source("ui.R")
server <- function(input, output, session) { 
  
  #reset
  observeEvent(input$reset, {
    updateSelectInput(session, 'loanType')
    updateNumericInput(session, 'loanAmount', value = 30)
    updateNumericInput(session, 'timi', value = 30)
    updateNumericInput(session, 'vextir', value = 5)
    updateNumericInput(session, 'innborgun', value = 100)
  })
  
  
  pred <- eventReactive(input$go, {
    res <- calcLoan(input)
    return(list(
      plot = ggplotly(
        ggplot(res, aes(t,HofudstollEftir)) + 
          geom_line() + 
          theme_bw()),
      table = 
        head(res) %>% 
          kable(format = "html", col.names = c("Höfuðstóll", "Greiðsla", 
                                               "Vextir", "Afborgun", "Greiðsla Nr.")) %>% 
          kable_styling(full_width = F, bootstrap_options = c("hover", "striped")))
      )
  }, ignoreNULL = FALSE)
  
  output$lanaPlot <- renderPlotly(pred()$plot)
  output$lanaTafla <- function(){
    pred()$table
  }
}