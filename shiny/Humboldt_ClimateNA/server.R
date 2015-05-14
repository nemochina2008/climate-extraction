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
      geom_hline(yintercept = mean(dats()[,xvarmean]), alpha = .5) # +
    #       geom_text(aes(label = ID), color = "white", vjust = .4, show_guide = F)
    return(p)
  })
  
  # a large table reactive to input
  output$mytable1 = renderDataTable({
    datatab<-dats()
    datatab
  }, options=list(aLengthMenu=c(10,50,100),iDisplayLength=10))
  
  
  output$metrics = renderDataTable({
    datametrics<-dats() # need to change this
    datametrics # need to add
  }, options=list(aLengthMenu=c(10,50,100),iDisplayLength=10))
  
  
  output$refugemap = renderLeaflet({
    
    # make maps of Humboldt Bay
  
    # projections
    nad83z10<-"+proj=utm +zone=10 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"
    
    # read in some shapefiles and make spatial
    
    polygon <- readShapePoly("shps/ExtentPoly.shp", proj4string=CRS(nad83z10))
    polygon <- spTransform(polygon, CRS("+proj=longlat +datum=NAD83"))
    
    ptsCNA_clipped <- readShapePoints("shps/ClimateNA_humboldt_extent_only.shp", proj4string=CRS(nad83z10))
    ptsCNA_clipped <- spTransform(ptsCNA_clipped, CRS("+proj=longlat +datum=NAD83"))
    
    ptsCNA_bbox <- readShapePoints("shps/ClimateNA_master_pts_humboldt.shp", proj4string=CRS(nad83z10))
    ptsCNA_bbox <- spTransform(ptsCNA_bbox, CRS("+proj=longlat +datum=NAD83"))
    
    # polygon2 <- readShapePoly("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Data/GIS/Shapes/Humbolt_Bay_RHI.shp", proj4string=CRS("+proj=longlat +datum=NAD83"))
    
    
    leaflet() %>% addTiles() %>% 
      setView(-124.0625, 40.6875, 10) %>%
      #addMarkers(lat = allmods[c(1:4),1], lng = allmods[c(1:4),2]) %>%
      #addPolygons(data=polygon2, weight=2, color = "red") %>% 
      addPolygons(data=polygon, weight=2, color = "black") %>%
      addCircles(data=ptsCNA_clipped, weight=2, color= "blue") %>% 
      addCircles(data=ptsCNA_bbox, weight=1, color= "yellow")
  })
})