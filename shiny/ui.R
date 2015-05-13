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
      inputId = "selectRes", label = "Time Frame", c("2020s", "2050s", "2080s")
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
                "Plots", plotOutput("Res"),width = 8,height = 20
              ),
              tabPanel(
                "Data Summary", verbatimTextOutput("summary"),dataTableOutput("mytable1")
              ),
              tabPanel(
                "Refuge Location",
                h5("Can add leaflet map here later..."),
                br(),
                img(src = "HumboldtBayWaterTrailsMap.png")
              ),
              tabPanelAbout()
            ))
))
          