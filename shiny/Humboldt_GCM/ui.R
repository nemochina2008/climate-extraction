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
  
  titlePanel("Humboldt Bay GCM Climate Projections"),
  
  sidebarPanel(
    wellPanel(
      helpText("This data represents GCMs from 3 different datasets. All data has been clipped or aggregated to the Humboldt NFWR Extent."),
      
      selectInput("gcm",label = "Select a GCM Dataset",choices = c("BIOCLIM"="bioclim","ClimateNA"="cna", "CMIP5"="cmip5"))
    ),

    wellPanel(
      helpText("Pick a variable to plot (see Metric Definitions Tab for details)"),
      
      conditionalPanel(condition = "input.gcm == 'bioclim'",
                       selectInput(inputId = "selectBIO", label = "Time Period",
                                   choices = c("2050s", "2070s")),
                       selectInput(inputId="xvar",label="X Variable",
                                   choices=as.character(varLookupBC$variable.long)),
                       selectInput(inputId="yvar",label="Y Variable",
                                   choices=as.character(varLookupBC$variable.long))
      ),
      conditionalPanel(condition = "input.gcm == 'cna'",
                       selectInput(inputId = "selectCNA", label = "Time Period",
                                   choices = c("2020s", "2050s", "2080s", "Historic")),
                       selectInput(inputId="xvar2",choices=as.character(varsNA2),label="X Variable"),
                       selectInput(inputId="yvar2",choices=as.character(varsNA2),label="Y Variable")
      ),
      conditionalPanel(condition = "input.gcm =='cmip5'",
                       selectInput(inputId = "selectCMIP5", label = "Time block", 
                                   choices=c("2020s", "2050s")),
                       selectInput(inputId = "xvar3", label = "X variable", 
                                   choices = as.character(varLookup$variable.long)),
                       selectInput(inputId = "yvar3", label = "Y variable", 
                                   choices = as.character(varLookup$variable.long))
      )
    )
  ),
  
  
  mainPanel(h4(textOutput("caption")),
            tabsetPanel(
              tabPanel(title = "GCM Plot", plotOutput("modPlot"), width = 8,height = 20),
              tabPanel(title="Metric Definitions",includeMarkdown("Climate_Var_Names.md"),
                       dataTableOutput("metrics")),
              tabPanelAbout()
              )
            )
))
          