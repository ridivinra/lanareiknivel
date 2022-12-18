library(shiny)
library(shinydashboard)
library(plotly)

header <- dashboardHeader(title = "Lánareiknivél")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Um lánið", tabName = "model", icon = icon("bar-chart-o"),
             numericInput("loanAmount",
                          "Höfuðstóll [m.ISK]",
                          40),
             selectInput("loanType",
                         "Óverðtryggt eða verðtryggt lán",
                         c("Óverðtryggt","Verðtryggt")),
             numericInput("timi",
                          "Tími láns [ár]",
                          20),
             numericInput("innborgun",
                          "Mánaðarleg innborgun [þ.ISK]",
                          100),
             div(style="display: inline-block;vertical-align:top; width: 100px;",
                 actionButton("go", "Reikna!")),
             div(style="display: inline-block;vertical-align:top; width: 100px;",
                 actionButton("reset", "Clear", style='padding:6px;width:80px'))
    )
  )
)

body <- dashboardBody(
           fluidRow(box(width = 12,
             fluidRow(
               column(4,
                      numericInput("loanAmount",
                                   "Höfuðstóll [m.ISK]",
                                   40)
               ),
               column(4,
                      selectInput("loanType",
                                  "Óverðtryggt eða verðtryggt lán",
                                  c("Óverðtryggt","Verðtryggt"))
               ),
               column(4,
                      selectInput("loanPayType",
                                  "Afborganir",
                                  c("Jafnar greiðslur","Jafnar afborganir")),
                      
               ),
               column(4,
                      numericInput("vextir",
                                  "Vextir [%]",
                                  5))),
             fluidRow(
               column(4,
                      numericInput("timi",
                                   "Tími láns [ár]",
                                   20)
               ),
               column(4,
                      numericInput("innborgun",
                                   "Mánaðarleg innborgun [þ.ISK]",
                                   100)
               ),
               
               column(4,div(style="display: inline-block;vertical-align:top; width: 100px;",
                            actionButton("go", "Reikna!")))
             )
           )),
           fluidRow(box(width = 6,
                        plotly::plotlyOutput("lanaPlot")),
      box(width = 6,tableOutput("lanaTafla")))
)

ui <- dashboardPage(header, 
                    dashboardSidebar(disable = T), 
                    body)
