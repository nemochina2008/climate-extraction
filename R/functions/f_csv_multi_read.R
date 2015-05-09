## READ IN MULTIPLE CSV's FROM A SINGLE FOLDER
## Ryan Peek
## 2013-Aug-19

## -----------------------------------------------------------------------
## Requires full path to the folder
## If you want each csv split out as an individual dataframe in workspace,
## use "split=TRUE", outputs to workspace
## -----------------------------------------------------------------------

csv.multi.read<-function(path,split=FALSE){
  ## Make a file list from a folder with full path
  filenames <- list.files(file.path(path),full.names=T, pattern=".csv")
  require(stringr)
  nameslist <-str_sub(basename(filenames),start=1,end=-5) # remove '.csv'
  if(split){
    cat('Split out dataframes...\n')
    filelist <- lapply(filenames, function(x) read.csv(x,stringsAsFactors=FALSE))
    names(filelist) <- nameslist # assign names to list of dataframes
    invisible(lapply(names(filelist), function(x) assign(x,filelist[[x]],envir=.GlobalEnv)))
    cat('All csvs now in workspace as dataframes!\n\n')
  }else{
    filelist <- lapply(filenames, function(x) read.csv(x,stringsAsFactors=FALSE)) # or use sapply with USE.NAMES=TRUE
    names(filelist) <- nameslist # assign names to list of dataframes
    assign("dflist",filelist,envir = .GlobalEnv)
    cat('All finished!\n ')
  }
}
# 
# # Make a named list 
# namedList <- function(vec, names=vec) {
#   l <- as.list(vec)
#   names(l) <- names
#   l
# }



## USE THE FUNCTION
# csv.multi.read("C:/Users/rapeek/Dropbox/R/PROJECTS/CEC_Yuba/data/base/Regulated2/Streamflow/ccsm4.1.rcp45",split=T)
# path<-file.path(getwd(),"data/base/Regulated2/Streamflow/ccsm4.1.rcp45")
# csv.multi.read(path)
# csv.multi.read(path,split=T)

## VIEW THE OUTPUT
# h(dflist[[1]]) # pull out single dataframe from list