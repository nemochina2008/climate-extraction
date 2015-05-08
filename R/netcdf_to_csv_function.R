## CONVERT NETCDF file to csv
## RYAN PEEK 2013-10-03 modified by ERIC HOLMES 5/4/15

### USING CMIP5 data, read in and export as CSV for any projection or time span, 
### Data downloaded from http://gdo-dcp.ucllnl.org/downscaled_cmip_projections/

# netcdf2csv(fold = "C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Data/Netcdf/hydro5/",
#            file = "Extraction_pr.nc",
#            variable = "pr",
#            zones = "C:/Users/ejholmes/Documents/CWS/Freshwater_Conservation/data/GIS/CA_HUC8_and_all_Region18.shp",
#            projection = "+proj=longlat +datum=NAD83",
#            outname = "_1950-2099_",
#            outfolder = "C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Output/",
#            compressed = FALSE,
#            model = 1)

# library(doParallel)
# library(foreach)
# cores = 2
# 
# registerDoParallel(cores = cores)

#foreach(i = 1:4)%dopar%{
for(i in c(2:12)){
  netcdf2csv(fold = "X:/common_geodata/CMIP5/Netcdf/hydro5/",
             file = "Extraction_tasmax.nc",
             variable = "tasmax",
             zones = "X:/common_geodata/CMIP5/Shapes/CA_HUC8_and_all_Region18.shp",
             projection = "+proj=longlat +datum=NAD83",
             outname = "_1950-2099_",
             outfolder = "X:/common_geodata/CMIP5/csv/",
             compressed = FALSE,
             model = i)
}

netcdf2csv <- function(fold, file, variable, zones, projection, outname, outfolder, compressed, model){
  
  ## Load packages
  library(ncdf)
  library(lubridate)
  library(stringr)
  library(RColorBrewer)
  library(foreign)
  library(maptools)
  library(raster)
  
  # Define Model PROJECTIONS ------------------------------------------------
  ## These are the projections selected from download

#   projs <- c("bcc-csm1-1.1.rcp26", "bcc-csm1-1.1.rcp45", "bcc-csm1-1.1.rcp60", "bcc-csm1-1.1.rcp85",
#            "ccsm4.1.rcp26", "ccsm4.1.rcp45", "ccsm4.1.rcp60", "ccsm4.1.rcp85",
#            "miroc5.1.rcp26", "miroc5.1.rcp45", "miroc5.1.rcp60", "miroc5.1.rcp85")
  
  projs <- c("access1-0.1.rcp85", "bcc-csm1-1.1.rcp85", "bcc-csm1-1-m.1.rcp85", "canesm2.1.rcp85",
             "ccsm4.1.rcp85", "cesm1-bgc.1.rcp85", "cesm1-cam5.1.rcp85", "cmcc-cm.1.rcp85",
             "cnrm-cm5.1.rcp85", "csiro-mk3-6-0.1.rcp85", "fgoals-g2.1.rcp85", "fio-esm.1.rcp85",
             "gfdl-cm3.1.rcp85", "gfdl-esm2g.1.rcp85", "gfdl-esm2m.1.rcp85", "giss-e2-r.1.rcp85",
             "hadgem2-ao.1.rcp85", "hadgem2-cc.1.rcp85", "hadgem2-es.1.rcp85", "inmcm4.1.rcp85",
             "ipsl-cm5a-mr.1.rcp85", "ipsl-cm5b-lr.1.rcp85", "miroc-esm.1.rcp85", "miroc-esm-chem.1.rcp85",
             "miroc5.1.rcp85", "mpi-esm-lr.1.rcp85", "mpi-esm-mr.1.rcp85", "mri-cgcm3.1.rcp85", "noresm1-m.1.rcp85")

  # GET NETCDF --------------------------------------------------------------
  
  ## Open a netCDF file
  nc<-open.ncdf(paste0(fold,file))  # open the netcdf file
  print(nc) # view file structure
  print(summary(nc)) # view the data classes
  # str(nc$var) # more detailed view of data
  
  # GET LONG LATS OF GRID ---------------------------------------------------
  
  ## Read the long / lats of the grid system and output as a grid
  lon = get.var.ncdf(nc,'longitude', verbose=F)  #get a list of the longitudes
  nlon<-dim(lon)
  lat = get.var.ncdf(nc,'latitude', verbose=F)  #get a list of the latitudes
  nlat<-dim(lat)
  #colnames(lonlat)<-c("longitude","latitude")
  output = expand.grid(latitude=lat,longitude=lon)
  
  ##---------------overlay on HUC_12s
  points <- output
  #points$longitude <- points$longitude-360
  coordinates(points) = ~longitude+latitude 
  proj4string(points) <- "+proj=longlat +datum=NAD83"
  
  polygon<-readShapePoly(zones, proj4string=CRS(projection)) 
  head(as.data.frame(polygon))
  polygon<-polygon[,3]
  
  a<-over(points,polygon)
  a$id<- row.names(a)
  a<-na.omit(a)
  
  output$id <- row.names(output)
  #output <- output[output$id %in% unique(a$id),]
  output <- merge(output,a,by.y="id",all.y=TRUE)
  
  ## Compare with zones
  dim(output)
  
  ## col names should match
  head(output)
  
  ## Plot and compare the lat/longs
  plot(output$longitude,output$latitude, pch=21,col="darkgreen",cex=0.8)
  #points(h8$long,h8$lat, pch=16,col="gray40",cex=0.8)
  points(output$longitude,output$latitude, pch=16,col="red",cex=.8)
  
  # GET TIME FROM NETCDF ----------------------------------------------------
  
  ## get time dimension
  t = get.var.ncdf(nc,'time')  #get a list of the days/months
  nt <- dim(t)
  print(nt)
  tunits <- att.get.ncdf(nc,"time","units")
  
  ## print t and tunits
  head(t, 20)
  print(nt)
  tunits$value
  
  ## show "real" times
  start.date<-substr(tunits$value,12,21)
  start<-ymd(start.date)
  head(start)
  daterange<-start + c(0:nt)*months(1)
  summary(daterange)
  
  # dateround<-round_date(daterange,"month")
  # str(dateround)
  # decdate<-decimal_date(daterange)
  # head(decdate)
  
  ## A Function to Create list of months and yrs for use in colnames
  datelist<-data.frame()
  for(i in c(1950:2099)){ # make sure this is the same dim as 'nt' above
    mons<-c(as.character(month.abb))
    datelist.temp<-as.data.frame.character(paste(mons,i,sep=""),stringsAsFactors=F)
    datelist<-rbind(datelist,datelist.temp)
  }
  colnames(datelist)<-'date'
  rm(datelist.temp)
  str(datelist)
  dim(datelist)
  
  
  # GET THE DATA ------------------------------------------------------------
  
  var<-variable # whatever the variable of interest is (i.e., pr, tas, etc)
  
  ## get the data and attributes
  tmp.array <- get.var.ncdf(nc,var) # actual var data
  dlname <- att.get.ncdf(nc,var,"long_name")
  dunits <- att.get.ncdf(nc,var,"units")
  fillvalue <- att.get.ncdf(nc,var,"_FillValue")
  
  ## replace fillvalues with NAs
  tmp.array[tmp.array == fillvalue$value] <- NA
  dim(tmp.array)
  
  ## done with the netCDF file, so close it
  close.ncdf(nc)
  
  ## PLOT A SLICE OF THE DATA
  
  ### to pick specific month from 1950:2099, change 3rd dimension in array
  ### i.e., array[long, lat, time, proj]
  tmp.slice <- tmp.array[,,1:612,model] # 50 years, Projection 1
  
  ## Can only plot a single month and projection at a time as raster
  image(lon,lat,tmp.array[,,612,1], col=rev(brewer.pal(10,"RdYlBu")))
  
  # CONVERT TO MATRIX/CSV ---------------------------------------------------
  
  ## Create a data frame where the rows are individual grid points
  ## and the columns are the monthly variables
  
  ## convert the nlon by nlat by nt array into a nlon*lat by nt matrix
  mod1 <- tmp.array[,,1:1800,model] # projection 1
  tmp.vec.long <- as.vector(mod1) 
  length(tmp.vec.long) # very large!
  tmp.mat <- matrix(tmp.vec.long, nrow=nlon*nlat, ncol=1800) # make sure ncol matches total nt
  dim(tmp.mat)
  head(na.omit(tmp.mat[,1:20]), 20) # view data
  
  ## create a data frame from the matrix for merge
  lonlat <- expand.grid(lon,lat)
  dim(lonlat)
  head(lonlat)
  tmp.df <- data.frame(cbind(lonlat,tmp.mat)) # bind the data with the spatial matrix
  dim(tmp.df)
  head(tmp.df)
  
  names(tmp.df)[1:1802] <- c('longitude','latitude',unlist(datelist)) # rename columns by date
  names(tmp.df[1:20])
  dim(tmp.df)
  
  head(tmp.df[,c(1,2)])
  str(tmp.df[,c(1,2)])
  
  ## MERGE THE DATASET WITH zones
  dff<-merge(x=output,y=tmp.df,by= c('latitude','longitude'))
  dim(dff)
  summary(dff[1:10])
  head(dff[1:10])
  
  # WRITE THE DATA TO FILE --------------------------------------------------
  
  if(compressed == TRUE) {
    ## Because data is so large, write to a compressed file
    ## xzfiles have best compression compared with bz2 and gz extensions
    write.csv(dff,xzfile(paste(outfolder, str_replace_all(projs[model], "[[:punct:]]", "_"),outname,variable,".csv.xz",sep=""),compression=9),row.names=F)
  }
  
  else{write.csv(dff,paste(outfolder,gsub(projs[model], pattern = ".", replacement = "_", fixed = T),outname, variable, ".csv",sep=""), row.names=FALSE)}
  gc()
  
}

