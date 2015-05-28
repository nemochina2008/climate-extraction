# load(file = "./data/processed/CNA_near_mid_far_MSY.RData")

# Libraries
#library(maptools)
#library(leaflet)
#library(rgdal)
library(markdown)
library(knitr)

load(file = "CNA_near_mid_far_MSY.RData")
load(file = "bioclim_50_70.RData")


#vars2<-names(df20.mod)[c(58:80,216:ncol(df20.mod))]
vars1<-names(dff50)[c(2:20)]
vars2<-sub(pattern = "_mean",replacement = "",vars1)
# vars2<-vars2[c(1,12:19,2:11)]

varLookup <- data.frame("variable.short" = vars2,"variable.long" = bioclimnames, stringsAsFactors = F)
varLookup$variable.mean <- paste(varLookup$variable.short, "_mean", sep = "")
varLookup$variable.se <- paste(varLookup$variable.short, "_se", sep = "")
varLookup


# running shiny app: Update package first
# devtools::install_github('rstudio/shinyapps')
# library(shinyapps)
# shinyapps::deployApp('path/to/your/app')
# shinyapps::deployApp("./shiny/Humboldt_ClimateNA")
