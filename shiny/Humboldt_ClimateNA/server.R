library(shiny)
library(ggplot2)
#library(gridExtra)


shinyServer(function(input,output) { 
  
  dats <- reactive({
    if(input$selectMod == "2020s"){dats <- df20.mod}
    else {
      if(input$selectMod == "2050s"){dats <- df50.mod}
      else {
        if(input$selectMod == "2080s"){dats <- df80.mod}
		else {
          if(input$selectMod == "Historic"){dats <- dfnorms.MSY.mod}
        }
      }
    }
  })

  output$Mod <- renderPlot({
    xvarmean <- paste0(input$xvar, "_mean")
    yvarmean <- paste0(input$yvar, "_mean")
    xvarse <- paste0(input$xvar, "_se")
    yvarse <- paste0(input$yvar, "_se")
    
    p <-ggplot(dats(), aes_string(x = xvarmean, y = yvarmean, color = "modname")) + 
      geom_point(size = 4) +
      geom_errorbarh(aes_string(
        xmax = paste(xvarmean, "+", xvarse), 
        xmin = paste(xvarmean, "-", xvarse)), height = .02, alpha = .5) +
      geom_errorbar(aes_string(ymax = paste(yvarmean,"+", yvarse), 
                               ymin = paste(yvarmean, "-", yvarse)), width = .02, alpha = .5) +
      theme_bw() + labs(list(x = input$xvar,y = input$yvar)) +
      geom_vline(xintercept = mean(dats()[,xvarmean]), alpha = .5) +
      geom_hline(yintercept = mean(dats()[,yvarmean]), alpha = .5) # +
    #       geom_text(aes(label = ID), color = "white", vjust = .4, show_guide = F)
    return(p)
  })
  
  output$metrics = renderDataTable({
    datametrics<-climatevars 
    datametrics 
  }, options=list(aLengthMenu=c(30,50),iDisplayLength=30))
  
  # a large table reactive to input
  output$mytable1 = renderDataTable({
    datatab<-dats()
    datatab
  }, options=list(aLengthMenu=c(10,50,100),iDisplayLength=10))
})