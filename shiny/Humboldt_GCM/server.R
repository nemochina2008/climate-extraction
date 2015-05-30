library(shiny)
library(ggplot2)
#library(gridExtra)


shinyServer(function(input,output) { 
  
  output$modPlot <- renderPlot({
    
    if(input$gcm == "bioclim"){
      # BIOCLIM
      datsBIOCLIM <- reactive({
        if(input$selectBIO == "2050s"){dats <- dff50}
        else {
          if(input$selectBIO == "2070s"){dats <- dff70}
        }
      })
      
      xvarmean <- varLookupBC[varLookupBC$variable.long == input$xvar, 3]
      yvarmean <- varLookupBC[varLookupBC$variable.long == input$yvar, 3]
      xvarse <- varLookupBC[varLookupBC$variable.long == input$xvar, 4]
      yvarse <- varLookupBC[varLookupBC$variable.long == input$yvar, 4]
        
      pBIO <- ggplot(datsBIOCLIM(), aes_string(x = xvarmean, y = yvarmean, color = "GCM")) +
        geom_point(size = 4) +
        geom_errorbarh(aes_string(xmax = paste(xvarmean, "+", xvarse), 
                                  xmin = paste(xvarmean, "-", xvarse)), 
                       height = .02, alpha = .5) +
        geom_errorbar(aes_string(ymax = paste(yvarmean,"+", yvarse), 
                                 ymin = paste(yvarmean, "-", yvarse)), 
                      width = .02, alpha = .5) +
        theme_bw() + labs(list(x = varLookupBC[varLookupBC$variable.long == input$xvar, 2], 
                               y = varLookupBC[varLookupBC$variable.long == input$yvar, 2])) +
        geom_vline(xintercept = mean(datsBIOCLIM()[,varLookupBC[varLookupBC$variable.long == input$xvar, 3]]), alpha = .5) + 
        geom_hline(yintercept = mean(datsBIOCLIM()[,varLookupBC[varLookupBC$variable.long == input$yvar, 3]]), alpha = .5)
      return(pBIO)
      
      } else {
        if(input$gcm== "cna"){
          # CLIMATENA
          datsCNA <- reactive({
            if(input$selectCNA == "2020s"){datsCNA <- df20.mod}
            else {
              if(input$selectCNA == "2050s"){datsCNA <- df50.mod}
              else {
                if(input$selectCNA == "2080s"){datsCNA <- df80.mod}
                else {
                  if(input$selectCNA == "Historic"){datsCNA <- dfnorms.MSY.mod}
                }
              }
            }
          })
          xvarmean2 <- paste0(input$xvar2, "_mean")
          yvarmean2 <- paste0(input$yvar2, "_mean")
          xvarse2 <- paste0(input$xvar2, "_se")
          yvarse2 <- paste0(input$yvar2, "_se")
        
          pCNA <-ggplot(datsCNA(), aes_string(x = xvarmean2, y = yvarmean2, color = "modname")) + 
            geom_point(size = 4) + geom_errorbarh(aes_string(
              xmax = paste(xvarmean2, "+", xvarse2), 
              xmin = paste(xvarmean2, "-", xvarse2)), height = .02, alpha = .5) + 
            geom_errorbar(aes_string(ymax = paste(yvarmean2,"+", yvarse2),
                                     ymin = paste(yvarmean2, "-", yvarse2)), width = .02, alpha = .5) +
            theme_bw() + labs(list(x = input$xvar2,y = input$yvar2)) +
            geom_vline(xintercept = mean(datsCNA()[,xvarmean2]), alpha = .5) +
            geom_hline(yintercept = mean(datsCNA()[,yvarmean2]), alpha = .5)
          return(pCNA)
          
          } else {
            if(input$gcm == "cmip5"){
              
              # CMIP5
              datsCMIP5 <- reactive({
                if(input$selectCMIP5 == "2020s"){
                  datsCMIP5 <- cmip5ply[cmip5ply$cuts == "2021-2050",]
                } else { 
                  if(input$selectCMIP5 == "2050s") {datsCMIP5 <- cmip5ply[cmip5ply$cuts == "2051-2080",]}
                }
              })
              
              xvarmean3 <- varLookup[varLookup$variable.long == input$xvar3, 3]
              yvarmean3 <- varLookup[varLookup$variable.long == input$yvar3, 3]
              xvarse3 <- varLookup[varLookup$variable.long == input$xvar3, 4]
              yvarse3 <- varLookup[varLookup$variable.long == input$yvar3, 4]
              
              pCMIP <- ggplot(datsCMIP5(), aes_string(x = xvarmean3, y = yvarmean3, color = "model")) + geom_point(size = 4) +
                geom_errorbarh(aes_string(xmax = paste(xvarmean3, "+", xvarse3), xmin = paste(xvarmean3, "-", xvarse3)), height = .02, alpha = .5) +
                geom_errorbar(aes_string(ymax = paste(yvarmean3,"+", yvarse3), ymin = paste(yvarmean3, "-", yvarse3)), width = .02, alpha = .5) +
                theme_bw() + labs(list(x = varLookup[varLookup$variable.long == input$xvar3, 2], y = varLookup[varLookup$variable.long == input$yvar3, 2])) +
                geom_vline(xintercept = mean(datsCMIP5()[,varLookup[varLookup$variable.long == input$xvar3, 3]]), alpha = .5) + 
                geom_hline(yintercept = mean(datsCMIP5()[,varLookup[varLookup$variable.long == input$yvar3, 3]]), alpha = .5)
              return(pCMIP)
            }
          }
        }
      })
  
  output$metrics<-renderDataTable(climatevars, options = list(paging = FALSE))
})

    
    #   output$refugemap = renderLeaflet({
    #     
    #     # make maps of Humboldt Bay
    #   
    #     # projections
    #     nad83z10<-"+proj=utm +zone=10 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"
    #     
    #     # read in some shapefiles and make spatial
    #     
    #     polygon <- readShapePoly("shps/ExtentPoly.shp", proj4string=CRS(nad83z10))
    #     polygon <- spTransform(polygon, CRS("+proj=longlat +datum=NAD83"))
    #     
    #     ptsCNA_clipped <- readShapePoints("shps/ClimateNA_humboldt_extent_only.shp", proj4string=CRS(nad83z10))
    #     ptsCNA_clipped <- spTransform(ptsCNA_clipped, CRS("+proj=longlat +datum=NAD83"))
    #     
    #     ptsCNA_bbox <- readShapePoints("shps/ClimateNA_master_pts_humboldt.shp", proj4string=CRS(nad83z10))
    #     ptsCNA_bbox <- spTransform(ptsCNA_bbox, CRS("+proj=longlat +datum=NAD83"))
    #     
    #     # polygon2 <- readShapePoly("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Data/GIS/Shapes/Humbolt_Bay_RHI.shp", proj4string=CRS("+proj=longlat +datum=NAD83"))
    #     
    #     
    #     leaflet() %>% addTiles() %>% 
    #       setView(-124.0625, 40.6875, 10) %>%
    #       #addMarkers(lat = allmods[c(1:4),1], lng = allmods[c(1:4),2]) %>%
    #       #addPolygons(data=polygon2, weight=2, color = "red") %>% 
    #       addPolygons(data=polygon, weight=2, color = "black") %>%
    #       addCircles(data=ptsCNA_clipped, weight=2, color= "blue") %>% 
    #       addCircles(data=ptsCNA_bbox, weight=1, color= "yellow")
    #   })
  # })