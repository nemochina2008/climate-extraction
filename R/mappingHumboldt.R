# make maps of Humboldt Bay

library(maptools)
library(leaflet)
library(magrittr)
library(rgdal)

# get csv of polygon ClimateNA pts
#CNApts<-read.csv("./data/ClimateNA_humboldt_extent.txt",header = T, stringsAsFactors = F)

CNApts<-read.csv("./data/processed/CNA_humboldt.csv",header = T, stringsAsFactors = F)
dfCNA<-CNApts[,c(3:4)]

lambers<-"+proj=lcc +lat_1=49 +lat_2=77 +lat_0=0 +lon_0=-95 +x_0=0 +y_0=0 +ellps=GRS80 +datum=WGS84 +units=m +no_defs"

nad83z10<-"+proj=utm +zone=10 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"

# convert to spatial 

# extent polygon
polygon <- readShapePoly(fn = "./data/shps/ExtentPoly.shp", proj4string=CRS(nad83z10))
polygon <- spTransform(polygon, CRS("+proj=longlat +datum=NAD83"))

ptsCNA_clipped <- readShapePoints("./data/shps/ClimateNA_humboldt_extent_only.shp", proj4string=CRS(nad83z10))
ptsCNA_clipped <- spTransform(ptsCNA_clipped, CRS("+proj=longlat +datum=NAD83"))

ptsCNA_bbox <- readShapePoints("./data/shps/ClimateNA_master_pts_humboldt.shp", proj4string=CRS(nad83z10))
ptsCNA_bbox <- spTransform(ptsCNA_bbox, CRS("+proj=longlat +datum=NAD83"))

# polygon2 <- readShapePoly("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Data/GIS/Shapes/Humbolt_Bay_RHI.shp", proj4string=CRS("+proj=longlat +datum=NAD83"))

leaflet() %>% addTiles() %>% 
  setView(-124.0625, 40.6875, 10) %>%
  #addMarkers(lat = allmods[c(1:4),1], lng = allmods[c(1:4),2]) %>%
  addPolygons(data=polygon, weight=2, color = "black") %>%
  addCircles(data=ptsCNA_clipped, weight=2, color= "blue") %>% 
  addCircles(data=ptsCNA_bbox, weight=1, color= "yellow")
  #addPolygons(data=polygon2, weight=2, color = "red")



# READ IN SHP -------------------------------------------------------------

library(rgdal)

# For shps: 
pathname<-"./data/shps" # 1st argument is dir location,
humboldt<-"ExtentPoly" # 2ndecond is the file name without suffix

# get file info
ogrInfo(pathname, humboldt)

## read in shapefiles
humboldt.rg <- readOGR(pathname, humboldt)

#humboldt@data$Id = rownames(humboldt@data)
humboldt.points = fortify(humboldt.rg, region="Id")
#humboldt.df = plyr::join(humboldt.points, humboldt@data, by="Id")


ggplot() + 
  geom_polygon(data=humboldt.points,
               aes(long,lat,group=group), alpha=0.5,fill="navyblue") +
  geom_path(color="white") +
  coord_equal() + theme_bw() 
 
#  geom_point(data=CNApts, aes(x=X, y=Y),pch=21,color="black",size=2)
  

# GGMAPS ------------------------------------------------------------------

library(ggmap)
library(ggplot2)

ca <- get_map(location=c(lon=-124.215,lat=40.754),
              zoom=9,crop=T,scale="auto", # or use color="bw"
              color="bw", maptype="terrain") # can change to satellite/terrain

gg <- ggmap(ca,extent="panel",padding = 0) # call the basemap

# Add points. Note plot will produce warnings for all points not
# in the lat/lon range of the base map layer.

ggCA <- gg + #geom_point(data=CNApts, aes(x=long+31,y=lat),
                        #size=4, pch=21, fill="orange")+
  ggtitle("HUMBOLDT") + geom_polygon(data=humboldt.points,
                                     aes(long,lat,group=group), alpha=0.9,fill="maroon")

print(ggCA) 



# # project to latlong
# Hbay <- spTransform(humboldt.rg, CRS("+proj=longlat +units=m +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0"))
# 
# # reproject to mercator for google
# Hbay_merc <- spTransform(humboldt.rg, CRS("+proj=merc +units=m +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0"))

# # get points dataset:
# fakepts<-data.frame("lat"=c(-110,-111,-109,-108),"lon"=c(48, 47.2, 46, 47.9))
# 
# # Convert to spatial dataframe
# coords = cbind(fakepts[[1]], fakepts[[2]])
# sp = SpatialPoints(coords)
# proj4string(sp)<-"+proj=longlat +units=m +datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0"
# 
# ## note that readOGR will read the .prj file if it exists
# print(proj4string(wildriv))
# 
# ## generate a simple map showing all three layers
# plot(lakes.rg, axes=TRUE, border="darkblue")
# lines(rivers.rg, col="blue3", lwd=0.7)
# lines(wildriv, col="purple",lwd=3)
# # add points
# points(sp, pch=21, col="black",bg="yellow",cex=1.7)
# title(main = "Rivers & Lakes of Montana")
