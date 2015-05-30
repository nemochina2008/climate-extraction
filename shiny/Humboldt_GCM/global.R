# load(file = "./data/processed/CNA_near_mid_far_MSY.RData")

# Libraries
#library(maptools)
#library(leaflet)
#library(rgdal)
library(markdown)
library(knitr)

# for BIOCLIM
load(file = "bioclim_50_70.RData")
vars1<-names(dff50)[c(2:20)]
vars2<-sub(pattern = "_mean",replacement = "",vars1)
varLookupBC <- data.frame("variable.short" = vars2,"variable.long" = bioclimnames, stringsAsFactors = F)
varLookupBC$variable.mean <- paste(varLookupBC$variable.short, "_mean", sep = "")
varLookupBC$variable.se <- paste(varLookupBC$variable.short, "_se", sep = "")
varLookupBC



# FOR CLIMATE NA ----------------------------------------------------------

load(file = "CNA_near_mid_far_MSY.RData")

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
