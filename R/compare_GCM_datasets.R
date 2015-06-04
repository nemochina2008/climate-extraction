## Look at all three climate sets in one plot
# R Peek 2015
# 
# PLOT METRICS SHARED BY ALL GCMs INCLUDING
  # Mean Annual Temperature (MAT, Bio-1)
  # Mean or Max Temperature of Warmest Month/Qtr (Tmax, Bio-5 or Bio-10)
  # Mean Annual Precipitation (MAP, Bio-12)
  # Annual Heat Moisture Index (MAT + 10 / (MAP/1000)) (AHM, could do quarterly) 
  # Mean Diurnal Range (Bio-2, TD)
  # Mean or Max Precip of Wettest Month
  # Seasonality?


# LOAD BIOCLIM ------------------------------------------------------------

load(file = "data/processed/bioclim_50_70.RData")
vars1<-names(dff50)[c(2:20)]
vars2<-sub(pattern = "_mean",replacement = "",vars1)
varLookupBC <- data.frame("variable.short" = vars2,"variable.long" = bioclimnames, stringsAsFactors = F)
varLookupBC$variable.mean <- paste(varLookupBC$variable.short, "_mean", sep = "")
varLookupBC$variable.se <- paste(varLookupBC$variable.short, "_se", sep = "")
varLookupBC


# LOAD CLIMATE NA ---------------------------------------------------------

load(file = "data/processed/CNA_near_mid_far_MSY.RData")
varsNA1<-names(df20.mod)[c(2:80)]
varsNA2<-sub(pattern = "_mean",replacement = "",varsNA1)
h(df20.mod)

# LOAD CMIP5 --------------------------------------------------------------

library(plyr)

# cmip5 <- read.csv("C:/Users/ejholmes/Desktop/Test_apps/Humbolt_Bay/Data/Allmods_dbasin_vars.csv", header = T)
cmip5 <- read.csv("data/processed/Allmods_dbasin_vars.csv", header = T, stringsAsFactors = F)

cmip5$cuts <- cut(cmip5$yr,breaks = c(1950,2020,2050,2080,2099), include.lowest=TRUE, labels= c("1950-2020", "2021-2050", "2051-2080", ">2081"))

cmip5$model <- cmip5$mod

cmip5ply <- ddply(cmip5, .(cuts, model), summarize, 
                  MATmean = mean(MAT), MATse = sd(MAT)/sqrt(length(MAT)), 
                  MWMTmean = mean(MWMT), MWMTse = sd(MWMT)/sqrt(length(MWMT)),
                  MCMTmean = mean(MCMT), MCMTse = sd(MCMT)/sqrt(length(MCMT)),
                  MAPmean = mean(MAP), MAPse = sd(MAP)/sqrt(length(MAP)),
                  MWMPmean = mean(MWMP), MWMPse = sd(MWMP)/sqrt(length(MWMP)),
                  MDMPmean = mean(MDMP), MDMPse = sd(MDMP)/sqrt(length(MDMP)),
                  TMAX_WTmean = mean(TMAX_WT), TMAX_WTse = sd(TMAX_WT)/sqrt(length(TMAX_WT)),
                  PPT_WTmean = mean(PPT_WT), PPT_WTse = sd(PPT_WT)/sqrt(length(PPT_WT)),
                  PPT_SMmean = mean(PPT_SM), PPT_SMse = sd(PPT_SM)/sqrt(length(PPT_SM)),
                  AHMmean = mean(AHM), AHMse = sd(AHM)/sqrt(length(AHM)),
                  SHMmean = mean(SHM), SHMse = sd(SHM)/sqrt(length(SHM))                  
)

##

varLookup <- data.frame(
  "variable.short" = c("MAT", "MWMT", "MAP", "MWMP", "MDMP", "TMAX_WT", "PPT_WT",
                       "PPT_SM", "AHM", "SHM"), 
  "variable.long" = c("Mean Maximum Annual Temp", "Mean Warmest Month Temp", 
                      "Mean Annual Precip", "Mean Wettest Month Precip",
                      "Mean Driest Month Precip", "Winter Months Mean Max Temp", 
                      "Winter Months Mean Precip","Summer Months Mean Precip", 
                      "Annual Heat Moisture Index", "Summer Heat Moisture Index"), 
  stringsAsFactors = F)

varLookup$variable.mean <- paste(varLookup$variable.short, "mean", sep = "")
varLookup$variable.se <- paste(varLookup$variable.short, "se", sep = "")


# PLOT --------------------------------------------------------------------

library(ggplot2)

varLookupBC
varLookup

# MEAN ANNUAL PRECIP VS MAX TEMP OF WARMEST MONTH (BIO_12 vs. BIO_5)

# bioclim
plot(dff50$BIO_12_mean/100, dff50$BIO_5_mean, pch=21, col="gray20", bg="cyan3", xlab="Mean Annual Precip (cm)", ylab="Max Temp of Warmest Month (C)", ylim=c(20, 33), cex=1.5, xlim=c(9,19))

# cmip5
with(cmip5ply[cmip5ply$cuts=="2051-2080",], points(MAPmean/10, MWMTmean, pch=21, col="gray10", bg="red2", cex=1))

# climateNA
with(df50.mod, points(MAP_mean/100, MWMT_mean, pch=24, col="gray10", bg="gray80", cex=1))



# MEAN ANNUAL PRECIP VS Mean Annual Temp (BIO_12 vs. BIO_1)

# bioclim
plot(dff50$BIO_12_mean/100, dff50$BIO_1_mean, pch=21, col="gray20", bg="cyan3", xlab="Mean Annual Precip (cm)", ylab="Mean Annual Temp (C)", cex=1.5)

# cmip5
with(cmip5ply[cmip5ply$cuts=="2051-2080",], points(MAPmean/10, MWMTmean, pch=21, col="gray10", bg="red2", cex=1))

# climateNA
with(df50.mod, points(MAP_mean/100, MWMT_mean, pch=24, col="gray10", bg="gray80", cex=1))




## PLOT AGAINST ONE ANOTHER:
# plot(dff50$BIO_12_mean/100, df50.mod$MAP_mean/100 , pch=21, col="gray20", bg="cyan3", xlab="Mean Annual Precip (BIOCLIM)", ylab="Mean Annual Precip (CNA)", cex=1.5)

# can't plot againts cmip b/c differnt number of rows