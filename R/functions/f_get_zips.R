## IMPORT ZIPPED CSVs
## R PEEK 2013-09-03

## Import csv's from a single directory into the workspace using unzip and a simple for loop

get.zips<-function(zip, path,split=FALSE){
  fullpath<-file.path(getwd(),path)
  zfiles<-unzip(file.path(path,zip),files=list.files(pattern="*.csv",full.names=FALSE),
                list=TRUE,junkpaths=FALSE)
  znames<-zfiles[,1]
  zfiles<-as.list(zfiles[,1]) # pull just the file names
  cat("processing.../n")
  print(zfiles)
  
    if(split){
    cat('Split out dataframes...\n')
    zipfiles <- lapply(zfiles, function(x) read.csv(unzip(file.path(fullpath,zip),files=x),stringsAsFactors=FALSE))
    names(zipfiles) <- znames # assign names to list of dataframes
    invisible(lapply(names(zipfiles), function(x) assign(x,zipfiles[[x]],envir=.GlobalEnv)))
    cat("Unzipped and all csv's now in workspace as dataframes!\n\n")
  }else{
    zipfiles <- lapply(zfiles, function(x) read.csv(unzip(file.path(fullpath,zip),files=x),stringsAsFactors=FALSE))
    names(zipfiles) <- znames # assign names to list of dataframes
    assign("zips",zipfiles,envir = .GlobalEnv)
    cat('All finished!\n In workspace as a list: "zips" ')
  }
}

# Or as a loop...which is actually slightly shorter using system.time  
# system.time(txt<-for(i in seq_along(zfiles)){
#   temp<-zfiles
#   assign(temp[[i]], read.csv(unzip(file.path(fullpath,zip),files=zfiles[[i]]),
#                              stringsAsFactors=FALSE),envir = .GlobalEnv)
# })

