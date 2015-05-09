## Climate NA Extract and Plot
## R Peek 2015

## Extract ClimateNA data from each point that falls within the Humboldt NFWR "Extent_Poly.shp"


# LOAD LIBRARIES and LOCATIONS --------------------------------------------

# library(dplyr)
# library(ggplot2)
library(stringr)

fold = "./data/processed/CNA_humboldt_mid_far/"
zones = "./data/shps/CA_HUC8_and_all_Region18.shp"
projection = "+proj=longlat +datum=NAD83"
outfolder = "./outputs/Humbolt_Bay/"


# GET FILES AND MERGE CSVS ------------------------------------------------

# get list of data csvs
filelist<-list.files(fold,full.names=F)
filelist

# clip head and tail of filename
filenames<-str_sub(filelist,start = 14, end=-5)
filenames

# get only seasonal files (ends in "S")
seasonal.files<-filenames[c(grep("S$",filenames))]
seasonal.files

# get files and merge:
datalist<- lapply(paste0(fold,"CNA_humboldt_",seasonal.files,".csv"),function(x) {read.csv(file=x, header=T)})
names(datalist) <- seasonal.files # assign names to list of dataframes

## Extract the columns of interest from each dataframe
# dfcatch<-lapply(dfilt, function(x) x[,c(LISTHERE)]) 
# names(dfcatch[[1]]) # check names
# summary(dfcatch[[2]])

# Add column with name of model
for(i in seq_along(datalist)){
  datalist[[i]]$model<-seasonal.files[i]
}

### check number of rows/cols per group
for(i in seq_along(datalist)){
  cat(names(datalist[i]), " Rows/Cols=", dim(datalist[[i]]), "\n")
}

h(datalist[[1]])

# use dplyr function to merge the csvs
df<-bind_rows(datalist)
h(df)
names(df)


# SUMMARIZING -------------------------------------------------------------

# set up standard error function
se<-function(x) {sd(x)/sqrt(length(x))}

# use dplyr magic!
dfsum<-df %>% 
  group_by(model) %>% 
  select(Elevation:RH_at) %>% 
  summarise_each(funs(mean, sd, se))

summary(dfsum)


# PLOTTING ----------------------------------------------------------------


ggplot(dfsum, aes(x = PPT_sp_mean, y = Tmax_sp_mean, color = model)) + geom_point(size = 8) + 
  geom_errorbarh(aes(xmax = PPT_sp_mean + PPT_sp_sd, xmin = PPT_sp_mean - PPT_sp_sd), height = .02, alpha = .5) +
  geom_errorbar(aes(ymax = Tmax_sp_mean + Tmax_sp_sd, ymin = Tmax_sp_mean - Tmax_sp_sd), width = .2, alpha = .5) +
  theme_bw() + labs(list(x = "Mean Spring Precip (mm)", y = "Mean Spring max monthly Temp", title = "ClimateNA")) +
  geom_vline(xintercept = mean(dfsum$PPT_sp_mean)) + geom_hline(yintercept = mean(dfsum$Tmax_sp_mean)) 
#geom_text(aes(label = row(dfsum), color = "white", vjust = .4, show_guide = F))



# COMPRESS FILES ----------------------------------------------------------

# ZIP FILES

# fullpath<-file.path("./data/processed/",rivtype)
# fullpath
# list.files(fullpath,recursive=TRUE,full.names=TRUE)
# tar(file.path(fullpath,"reg_v5_tar.tgz"),fullpath,compression='gzip')



# DONE!!

# REMOVE FILES FROM WORKSPACE IF NECESSARY
# rm(list=ls())

