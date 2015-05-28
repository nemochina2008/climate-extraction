library(shiny)
library(ggplot2)
#library(gridExtra)


##------------------------------------Shiny reactive code----------------------------------------##

shinyServer(function(input,output) { 
  
  output$Res <- renderPlot({
    if(input$selectRes == "2021"){data <- cmip5ply[cmip5ply$cuts == "2021-2050",]}
    else{data <- cmip5ply[cmip5ply$cuts == "2051-2080",]}
    
    xvarmean <- varLookup[varLookup$variable.long == input$xvar, 3]
    yvarmean <- varLookup[varLookup$variable.long == input$yvar, 3]
    xvarse <- varLookup[varLookup$variable.long == input$xvar, 4]
    yvarse <- varLookup[varLookup$variable.long == input$yvar, 4]
    
    p <- ggplot(data, aes_string(x = xvarmean, y = yvarmean, color = "model")) + geom_point(size = 4) +
      geom_errorbarh(aes_string(xmax = paste(xvarmean, "+", xvarse), xmin = paste(xvarmean, "-", xvarse)), height = .02, alpha = .5) +
      geom_errorbar(aes_string(ymax = paste(yvarmean,"+", yvarse), ymin = paste(yvarmean, "-", yvarse)), width = .02, alpha = .5) +
      theme_bw() + labs(list(x = varLookup[varLookup$variable.long == input$xvar, 2], y = varLookup[varLookup$variable.long == input$yvar, 2])) +
      geom_vline(xintercept = mean(data[,varLookup[varLookup$variable.long == input$xvar, 3]]), alpha = .5) + 
      geom_hline(yintercept = mean(data[,varLookup[varLookup$variable.long == input$yvar, 3]]), alpha = .5)# + 
#       geom_text(aes(label = ID), color = "white", vjust = .4, show_guide = F)
    return(p)
  })
})