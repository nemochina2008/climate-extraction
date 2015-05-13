# make plot of Humboldt Bay


# get csv of polygon ClimateNA pts
#CNApts<-read.csv("./data/ClimateNA_humboldt_extent.txt",header = T, stringsAsFactors = F)
CNApts<-read.csv("./data/processed/CNA_humboldt.csv",header = T, stringsAsFactors = F)
h(CNApts)
str(CNApts)
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
humboldt.df = plyr::join(humboldt.points, humboldt@data, by="Id")


ggplot() + 
  geom_polygon(data=humboldt.points,
               aes(long,lat,group=group), alpha=0.5,fill="navyblue") +
  geom_path(color="white") +
  coord_equal() + theme_bw() + gg
# 
#  geom_point(data=CNApts, aes(x=X, y=Y),pch=21,color="black",size=2)
  

# GGMAPS ------------------------------------------------------------------

library(ggmap)
library(ggplot2)

ca <- get_map(location=c(lon=-124.215,lat=40.754),
              zoom=9,crop=T,scale="auto", 
              color="color", maptype="satellite") # can change to terrain

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
