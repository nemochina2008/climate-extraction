#library(plyr)
#library(dplyr)


# cmip5 <- read.csv("Data/Allmods_dbasin_vars.csv", header = T, stringsAsFactors = F)
load(file = "CNA_near_mid_far_MSY.RData")

#vars2<-names(df20.mod)[c(58:80,216:ncol(df20.mod))]
vars1<-names(df20.mod)[c(58:80)]
vars2<-sub(pattern = "_mean",replacement = "",vars1)

varLookup <- data.frame("variable.short" = c("MAT", "MWMT","MCMT", "TD", "MAP", "MSP", "AHM", "SHM", "RH"),"variable.long" = c("Mean Annual Temp", "Mean Warmest Month Temp","Mean Critical Maximum Temperature","Temperature Diurnal", "Mean Annual Precip", "Mean Super Precip", "Annual Heat Moisture Index", "Summer Heat Moisture Index", "Relative Humidity"), stringsAsFactors = F)

varLookup$variable.mean <- paste(varLookup$variable.short, "_mean", sep = "")
varLookup$variable.se <- paste(varLookup$variable.short, "_se", sep = "")