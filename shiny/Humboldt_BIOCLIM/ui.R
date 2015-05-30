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
  
  titlePanel("Humboldt Bay GCM Data: Model Projections"),
  
  sidebarPanel(
    wellPanel(
      helpText("This data represents GCMs from different datasets and scales. However, all data has been clipped or 
               aggregated to the Humboldt NFWR Extent in these plots. Please select a GCM Dataset"),
      
      checkboxInput("BIOCLIM","BIOCLIM",TRUE),
      checkboxInput("ClimateNA","Climate NA",FALSE),
      checkboxInput("CMIP5", "CMIP5",FALSE)
    ),

    wellPanel(
      helpText("Pick a variable to plot (see Metric Definitions Tab for details)"),
      
      conditionalPanel(condition = "input.BIOCLIM==true",
                       selectInput(inputId = "selectBIO", label = "Time Period",
                                   choices = c("2050s", "2070s")),
                       selectInput(inputId="xvar",label="X Variable",
                                   choices=as.character(varLookupBC$variable.long)),
                       selectInput(inputId="yvar",label="Y Variable",
                                   choices=as.character(varLookupBC$variable.long))
      ),
      conditionalPanel(condition = "input.ClimateNA==true",
                       selectInput(inputId = "selectCNA", label = "Time Period",
                                   choices = c("2020s", "2050s", "2080s", "Historic")),
                       selectInput(inputId="xvar",choices=as.character(varsNA2),label="X Variable"),
                       selectInput(inputId="yvar",choices=as.character(varsNA2),label="Y Variable")
      ),
      conditionalPanel(condition = "input.CMIP5==true",
                       selectInput(inputId = "selectCMIP5", label = "Time block", 
                                   choices=c("2020s", "2050s")),
                       selectInput(inputId = "xvar", label = "X variable", 
                                   choices = as.character(varLookup$variable.long)),
                       selectInput(inputId = "yvar", label = "Y variable", 
                                   choices = as.character(varLookup$variable.long),
                                   selected = "Mean Annual Precip")
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
          