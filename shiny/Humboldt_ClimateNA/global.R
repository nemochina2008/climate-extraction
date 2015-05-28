# load(file = "./data/processed/CNA_near_mid_far_MSY.RData")

#install.packages("leaflet", lib="/home/rapeek/ShinyApps/Humboldt_ClimateNA/Rpackages/", repos="http://cran.stat.ucla.edu/")
#install.packages("sp", lib="/home/rapeek/Rpackages/", repos="http://cran.stat.ucla.edu/")

# Libraries
#library(sp,lib.loc="/home/rapeek/ShinyApps/Humboldt_ClimateNA/Rpackages/")
#library(maptools,lib.loc="/home/rapeek/ShinyApps/Humboldt_ClimateNA/Rpackages/")
#library(leaflet)
#gpclibPermit()

load(file = "CNA_near_mid_far_MSY.RData")

vars1<-names(df20.mod)[c(2:80)]
vars2<-sub(pattern = "_mean",replacement = "",vars1)

#varLookup <- data.frame("variable.short" = c("MAT", "MWMT","MCMT", "TD", "MAP", "MSP", "AHM", "SHM", "RH"),"variable.long" = c("Mean Annual Temp", "Mean Warmest Month Temp","Mean Critical Maximum Temperature","Temperature Diurnal", "Mean Annual Precip", "Mean Super Precip", "Annual Heat Moisture Index", "Summer Heat Moisture Index", "Relative Humidity"), stringsAsFactors = F)
#varLookup$variable.mean <- paste(varLookup$variable.short, "_mean", sep = "")
#varLookup$variable.se <- paste(varLookup$variable.short, "_se", sep = "")