# load(file = "./data/processed/CNA_near_mid_far_MSY.RData")

# Libraries
library(maptools)
library(leaflet)
library(rgdal)
library(markdown)
#library(knitr)

load(file = "CNA_near_mid_far_MSY.RData")
#load(file = "./data/processed/CNA_near_mid_far_MSY.RData")
#load(file = "./data/processed/bioclim_50_70.RData")

#vars2<-names(df20.mod)[c(58:80,216:ncol(df20.mod))]
vars1<-names(df20.mod)[c(2:80)]
vars2<-sub(pattern = "_mean",replacement = "",vars1)

vars1

# varLookup <- data.frame("variable.short" = c("MAT", "MWMT","MCMT", "TD", "MAP", "MSP", "AHM", "SHM", "RH"),"variable.long" = c("Mean Annual Temp", "Mean Warmest Month Temp","Mean Critical Maximum Temperature","Temperature Diurnal", "Mean Annual Precip", "Mean Super Precip", "Annual Heat Moisture Index", "Summer Heat Moisture Index", "Relative Humidity"), stringsAsFactors = F)

# varLookup$variable.mean <- paste(varLookup$variable.short, "_mean", sep = "")
# varLookup$variable.se <- paste(varLookup$variable.short, "_se", sep = "")

# running shiny app: Update package first
# devtools::install_github('rstudio/shinyapps')
# library(shinyapps)
# shinyapps::deployApp('path/to/your/app')
# shinyapps::deployApp("./shiny/Humboldt_ClimateNA")
