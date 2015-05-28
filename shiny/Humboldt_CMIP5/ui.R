library(shiny)

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
    ), h3, NULL),
  titlePanel("Humbolt Bay Climate Model Projections"),
  sidebarLayout(
        sidebarPanel(
          selectInput(inputId = "selectRes", label = "Time block", c("2021", "2051")),
        
#           selectInput(inputId = "xvar", label = "X variable", choices = c("MAT", "MWMT", "MAP", "MWMP", "MDMP", "TMAX_WT", "PPT_WT", "PPT_SM", "AHM", "SHM")),
          selectInput(inputId = "xvar", label = "X variable", choices = as.character(varLookup$variable.long)),
#           selectInput(inputId = "yvar", label = "Y variable", c("MAT", "MWMT", "MCMT", "MAP", "MWMP", "MDMP", "TMAX_WT", "PPT_WT", "PPT_SM", "AHM", "SHM"),
#                       selected = "MAP")),
          selectInput(inputId = "yvar", label = "Y variable", choices = as.character(varLookup$variable.long),
                selected = "Mean Annual Precip")),
  
        mainPanel(plotOutput("Res"), width=8, height = 20)
  
)))
