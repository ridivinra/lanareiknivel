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
    pHofudstoll <- ggplotly(
      ggplot(res, aes(t/12,HofudstollEftir/1000000)) + 
        geom_line() + 
        scale_y_continuous(name = "Höfuðstóll [m.ISK]") + 
        scale_x_continuous(name = "Tími [Ár]", breaks = seq(0,max(res$t/12),1)) + 
        theme_bw()
      )
    pGreidslur <- ggplotly(
      ggplot(res, aes(t/12,greidsla/1000)) + 
        geom_line() + 
        scale_y_continuous(limits = c(0,NA), breaks = seq(0,1000,50),name = "Greiðsla [þ.ISK]") + 
        scale_x_continuous(name = "Tími [Ár]", breaks = seq(0,max(res$t/12),1)) + 
        theme_bw()
      )
    return(list(
      lanaPlot = pHofudstoll,
      greidsluPlot = pGreidslur,
      table = 
        head(res) %>% 
          kable(format = "html", col.names = c("Höfuðstóll", "Greiðsla", 
                                               "Vextir", "Afborgun", "Greiðsla Nr.")) %>% 
          kable_styling(full_width = F, bootstrap_options = c("hover", "striped")))
      )
  }, ignoreNULL = FALSE)
  
  output$lanaPlot <- renderPlotly(pred()$lanaPlot)
  output$greidsluPlot <- renderPlotly(pred()$greidsluPlot)
  output$lanaTafla <- function(){
    pred()$table
  }
}