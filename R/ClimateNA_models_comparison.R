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

filelist<-list.files(fold,full.names=F)
filelist

filenames<-str_sub(filelist,start = 14, end=-5)
filenames
