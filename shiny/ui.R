library(shiny)
tabPanelAbout <- source("about.r")$value
headerPanel_2 <- function(title, h, windowTitle=title) {    
  tagList(
    tags$head(tags$title(windowTitle)),
    h(title)
  )
}

shinyUI(fluidPage(
  
  headerPanel_2(
    HTML(
      '<div id="stats_header">
      <a href="http://watershed.ucdavis.edu" target="_blank">
      <left>
      <img id="cws_logo" alt="CWS Logo" src="https://watershed.ucdavis.edu/files/cwsheader_0.png" />
      </left>
      </a>
      </div>'
    ), h3, NULL
    ),
  
  titlePanel("Humbolt Bay Climate NA Model Projections"),
  
  sidebarPanel(
    
    selectInput(
      inputId = "selectMod", label = "Time Frame", c("2020s", "2050s", "2080s")
      ),
    
    selectInput(
      inputId="xvar",choices=as.character(vars2),label="X Variable"),
    
    selectInput(
      inputId="yvar",choices=as.character(vars2),label="Y Variable"
      )
  ),
    
  
  mainPanel(h4(textOutput("caption")),
            tabsetPanel(
              tabPanel(
                "Plots", plotOutput("Mod"),width = 8,height = 20
              ),
              tabPanel(
                "Data Summary", verbatimTextOutput("summary"),dataTableOutput("mytable1")
              ),
#               tabPanel(
#                 "Metric Definitions", verbatimTextOutput("metrics"),
#                 column(4, includeMarkdown("include.md"))
#               ),
              
              tabPanel(
                "Refuge Location",leafletOutput("refugemap"),
                h5("Climate NA points and Polygon Extent")
#                 br(),
#                 img(src = "HumboldtBayWaterTrailsMap.png")
              ),
              tabPanelAbout()
            ))
))
          