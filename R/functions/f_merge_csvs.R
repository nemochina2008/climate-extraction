## MERGE AND PLOT 
## -----------------------------------------------------------------------
## Requires full path to the folder
## If you want each csv split out as an individual dataframe in workspace,
## use "split=TRUE", outputs to workspace
## -----------------------------------------------------------------------

csv.merge<-function(path,split=FALSE){
  ## Make a file list from a folder with full path
  filenames <- list.files(file.path(path),full.names=T, pattern=".csv")
  require(stringr)
  nameslist <-str_sub(basename(filenames),start=1,end=-5) # remove '.csv'
  if(split){
    cat('Split out dataframes...\n')
    filelist <- lapply(filenames, read.csv)
    names(filelist) <- nameslist # assign names to list of dataframes
    merged<-
    #invisible(lapply(names(filelist), function(x) assign(x,filelist[[x]],envir=.GlobalEnv)))
    cat('All csvs now in workspace as dataframes!\n\n')
  }else{
    filelist <- lapply(filenames, read.csv) # or use sapply with USE.NAMES=TRUE
    names(filelist) <- nameslist # assign names to list of dataframes
    merged<-merge(filelist)
    assign("merged",merged,envir = .GlobalEnv)
    cat('All finished!\n ')
  }
}

## USE THE FUNCTION
# csv.multi.read("C:/Users/rapeek/Dropbox/R/PROJECTS/CEC_Yuba/data/base/Regulated2/Streamflow/ccsm4.1.rcp45",split=T)
path<-file.path(getwd(),"data/base/Regulated2/Streamflow/ccsm4.1.rcp45")
