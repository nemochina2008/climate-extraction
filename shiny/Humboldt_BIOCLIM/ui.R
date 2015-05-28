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
  
  titlePanel("Humboldt Bay BIOCLIM Model Projections"),
  
  sidebarPanel(
    helpText("BIOCLIM data is 4 km? data. This is clipped to the Humboldt NFWR Extent for these plots"),
    selectInput(
      inputId = "selectMod", label = "Time Period", c("2050s", "2070s")
      ),
    br(),
    helpText("Pick a variable to plot (see Metric Definitions Tab for details)"),
    selectInput(
      inputId="xvar",choices=as.character(varLookup$variable.long),label="X Variable"),
    
    selectInput(
      inputId="yvar",choices=as.character(varLookup$variable.long),label="Y Variable"
      )
  ),
    
  
  mainPanel(h4(textOutput("caption")),
            tabsetPanel(
              tabPanel(
                "Plots", plotOutput("Mod"),width = 8,height = 20
              ),
#               tabPanel(
#                 "Data Summary", verbatimTextOutput("summary"),dataTableOutput("mytable1")
              # ),
              tabPanel(
                "Metric Definitions",includeMarkdown("Climate_Var_Names.md"), 
                dataTableOutput("metrics")
              ),
              
#               tabPanel(
#                 "Refuge Location",leafletOutput("refugemap"),
#                 h5("Climate NA points and Polygon Extent")
#                 br(),
#                 img(src = "HumboldtBayWaterTrailsMap.png")
#              ),
              tabPanelAbout()
            ))
))
          