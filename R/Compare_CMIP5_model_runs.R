library(foreign)
library(reshape2)
library(ggplot2)
library(plyr)
library(maptools)
library(leaflet)

## Load CMIP5 data from csv
# prcp <- read.csv("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Output/_1950-2099_.csv", header = T, stringsAsFactors =F)
# prcp <- read.table("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Output/ccsm4_1_rcp45_1950-2099_pr.csv.xz",sep=",", header=TRUE)

pattern <- "pr"

datalist <- list.files("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Output", pattern = pattern)

allmods <- data.frame()

for (i in datalist[c(4,8,12)]){
  print(i)
  temp <- read.table(paste("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Output/", i, sep = ""), sep = ",", header = T)
  
  temp <- temp[temp$HUC_12 %in% c(180101020601:180101020605),] #subset to humbolt bay hucs
  tempmelt <- melt(temp[,c(1,2,4:1804)], id.vars = c("latitude", "longitude", "HUC_12"))
  tempmelt$mod <- substr(i, 1, nchar(i) - 4)
  allmods <- rbind(allmods, tempmelt)
}

rm(temp, tempmelt)

##------------------------------------------------------------##

allmods$mon <- substr(allmods$variable, 1,3)
allmods$yr <- as.numeric(substr(allmods$variable, 4,7))

allmodsann <- ddply(allmods, .(yr, mod), summarize, mean = mean(value))

allmodsann$model <- ifelse(substr(allmodsann$mod, 1,1) == "b", "bcc-csm",
                           ifelse(substr(allmodsann$mod, 1,1) == "c","ccsm", "miroc"))

if(pattern == "tasmax"){allmodsann$emm <- substr(allmodsann$mod, nchar(allmodsann$mod) - 21, nchar(allmodsann$mod) - 17)}
if(pattern == "pr"){allmodsann$emm <- substr(allmodsann$mod, nchar(allmodsann$mod) - 17, nchar(allmodsann$mod) - 13)}

# png(paste("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Output/Figures/", pattern, "_%02d.png",sep = ""), 
#     height = 9, width = 11, units = "in", res = 700, pointsize = 12, family = "serif")

ggplot(allmodsann[allmodsann$yr > 2010,], aes(x = yr, y = mean)) + geom_point(aes(color = model),size = 1, alpha = .5) + 
  stat_smooth(aes(color = model, linetype = emm), se = F) + 
  theme_bw() + theme(legend.justification=c(1,0), legend.position=c(1,0))

# dev.off()

##------------------------------------------------------------##
##plot CMIP5 1/8 degree grid points on leaflet map

polygon <- readShapePoly("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Data/GIS/Shapes/Humbolt_Bay_RHI.shp", 
              proj4string=CRS("+proj=longlat +datum=NAD83"))

leaflet() %>% addTiles() %>% 
   setView(-124.0625, 40.6875, 10) %>%
   addMarkers(lat = allmods[c(1:4),1], lng = allmods[c(1:4),2]) %>%
   addPolygons(data=polygon, weight=2, color = "black")

##End