# load(file = "./data/processed/CNA_near_mid_far_MSY.RData")

# Libraries
#library(maptools)
#library(leaflet)
#library(rgdal)
library(markdown)
library(knitr)
library(stringr)


# the mods to keep
#unique(dff50$GCM) # BIOCLIM
biomods<-c("ACCESS1-0", "CCSM4", "CNRM-CM5", 
           "HadGEM2-ES", "HadGEM2-CC", "MIROC5")

#unique(cmip5ply$model) # CMIP5
cm5mods<-c("ACCESS1-0", "CCSM4", "CNRM-CM5", "CESM1-BGC", "CMCC-CM",
           "CANESM2", "GFDL-CM3", "HADGEM2-ES", "HADGEM2-CC", "MIROC5")

#unique(df20.mod$modname) # CNA
cnamods<-c("ACCESS1-0", "CCSM4", "CNRM-CM5", "CESM1-BGC", "CanESM2",
           "GFDL-CM3", "HadGEM2-ES", "MIROC5")

# load(file="data/processed/bioclim_50_70_wide.RData")
# bioc_wide<-filter(bioc_wide, GCM %in% biomods) # filter to specific models
# 
# load(file="data/processed/CNA_wide.RData")
# cna_wide<-filter(cna_wide, modname %in% cnamods) # filter to specific models
# 
# #cmip_wide<-filter(cmip5ply, model %in% cm5mods) # filter to specific models
# load(file="data/processed/cmip5_wide.RData")

# FOR BIOCLIM -------------------------------------------------------------

load(file = "bioclim_50_70.RData")
vars1<-names(dff50)[c(2:20)]
vars2<-sub(pattern = "_mean",replacement = "",vars1)
varLookupBC <- data.frame("variable.short" = vars2,"variable.long" = bioclimnames, stringsAsFactors = F)
varLookupBC$variable.mean <- paste(varLookupBC$variable.short, "_mean", sep = "")
varLookupBC$variable.se <- paste(varLookupBC$variable.short, "_se", sep = "")
varLookupBC

# FOR CLIMATE NA ----------------------------------------------------------

load(file = "CNA_near_mid_far_MSY.RData")
df20.mod$modname<-sub(pattern = "_rcp85_2025MSY",replacement = "",df20.mod$modname)
unique(df20.mod$modname) # CNA
df50.mod$modname<-sub(pattern = "_rcp85_2055MSY",replacement = "",df50.mod$modname)
unique(df50.mod$modname) # CNA
df80.mod$modname<-sub(pattern = "_rcp85_2085MSY",replacement = "",df80.mod$modname)
unique(df80.mod$modname) # CNA

varsNA1<-names(df20.mod)[c(2:80)]
varsNA2<-sub(pattern = "_mean",replacement = "",varsNA1)



# for CMIP5 Data ----------------------------------------------------------

library(plyr)

# cmip5 <- read.csv("C:/Users/ejholmes/Desktop/Test_apps/Humbolt_Bay/Data/Allmods_dbasin_vars.csv", header = T)
cmip5 <- read.csv("Allmods_dbasin_vars.csv", header = T, stringsAsFactors = F)

cmip5$cuts <- cut(cmip5$yr,breaks = c(1950,2020,2050,2080,2099), include.lowest=TRUE, labels= c("1950-2020", "2021-2050", "2051-2080", ">2081"))

cmip5$model <- cmip5$mod

cmip5ply <- ddply(cmip5, .(cuts, model), summarize, 
                  MATmean = mean(MAT), MATse = sd(MAT)/sqrt(length(MAT)), 
                  MWMTmean = mean(MWMT), MWMTse = sd(MWMT)/sqrt(length(MWMT)),
                  MCMTmean = mean(MCMT), MCMTse = sd(MCMT)/sqrt(length(MCMT)),
                  MAPmean = mean(MAP), MAPse = sd(MAP)/sqrt(length(MAP)),
                  MWMPmean = mean(MWMP), MWMPse = sd(MWMP)/sqrt(length(MWMP)),
                  MDMPmean = mean(MDMP), MDMPse = sd(MDMP)/sqrt(length(MDMP)),
                  TMAX_WTmean = mean(TMAX_WT), TMAX_WTse = sd(TMAX_WT)/sqrt(length(TMAX_WT)),
                  PPT_WTmean = mean(PPT_WT), PPT_WTse = sd(PPT_WT)/sqrt(length(PPT_WT)),
                  PPT_SMmean = mean(PPT_SM), PPT_SMse = sd(PPT_SM)/sqrt(length(PPT_SM)),
                  AHMmean = mean(AHM), AHMse = sd(AHM)/sqrt(length(AHM)),
                  SHMmean = mean(SHM), SHMse = sd(SHM)/sqrt(length(SHM))                  
)

cmip5ply$model<-sub(pattern = "_1_rcp85", "", cmip5ply$model)
cmip5ply$model<-str_to_upper(cmip5ply$model)

##

varLookup <- data.frame(
  "variable.short" = c("MAT", "MWMT", "MAP", "MWMP", "MDMP", "TMAX_WT", "PPT_WT",
                       "PPT_SM", "AHM", "SHM"), 
  "variable.long" = c("Mean Maximum Annual Temp", "Mean Warmest Month Temp", 
                      "Mean Annual Precip", "Mean Wettest Month Precip",
                      "Mean Driest Month Precip", "Winter Months Mean Max Temp", 
                      "Winter Months Mean Precip","Summer Months Mean Precip", 
                      "Annual Heat Moisture Index", "Summer Heat Moisture Index"), 
  stringsAsFactors = F)

varLookup$variable.mean <- paste(varLookup$variable.short, "mean", sep = "")
varLookup$variable.se <- paste(varLookup$variable.short, "se", sep = "")


# RUNNING SHINY -----------------------------------------------------------

# running shiny app: Update package first
# devtools::install_github('rstudio/shinyapps')
# library(shinyapps)
# shinyapps::deployApp('path/to/your/app')
# shinyapps::deployApp("./shiny/Humboldt_ClimateNA")
