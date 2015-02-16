
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Ngn2 Induced Neuron Spanning Tree"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(

      selectInput("colorBy",
                label = h3("Color Parameter"),
                choices=list("State" = 1,
                            "Day" = 2
                            ),
                selected = 1
                  ),

      textInput("geneList",
                label = h3("Marker Gene List"),
                value = "Comma separated gene names..."
                ),
      p("Comma separated list of HUGO gene names. Case-sensitive.")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Spanning Tree",plotOutput("spanningTree",height=1000,width=1000)),
        tabPanel("Jitter",plotOutput("Jitter",height=1000,width=1000)),
        tabPanel("Pseudotime",plotOutput("Pseudotime",height=1000,width=1000)),
        tabPanel("Branched Pseudotime",plotOutput("BranchedPseudotime",height=1000,width=1000))
      )
    )
  )
))
