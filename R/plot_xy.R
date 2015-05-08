## PLOT XYs

plot.cmip<-function(data,maptype,zoom,size,title, ...)
  ## DIFFERENT MAPTYPES:
  # (terrain, satellite, hybrid, roadmap) or (watercolor, toner) for source=stamen
{
  require(ggmap)
  library(ggplot2)
  #data<-as.data.frame(data)
  bbox<- make_bbox(lon, lat, data = data, f = 0.1)
  basemap<- get_map(location=bbox,zoom=zoom,maptype=maptype,source='google')
  cmip.xy<-ggmap(basemap) + geom_point(aes_string(x='lon', y='lat'),data=data,
                                        alpha=0.8,fill='gray40',shape=21,size=size) +
    labs(title=title) + theme(legend.position="none") + ...
  print(cmip.xy)
}

#plot.cmip(output,'terrain',7,3,"CMIP5 lat-lon")
# group.xy+scale_colour_gradientn(colours=topo.colors(31))
# group.xy+scale_colour_gradient(low = "green", high = "blue")