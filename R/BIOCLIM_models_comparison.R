## BIOClimate  and Plot
## R Peek 2015

# load(file = "./data/processed/CNA_near_mid_far_MSY.RData")
load(file = "./data/processed/bioclim_50_70.RData")

# LOAD LIBRARIES and LOCATIONS --------------------------------------------

library(dplyr)
library(readr)
library(stringr)
library(ggplot2)

# GET FILES AND SPLIT -----------------------------------------------------

dat = read_csv("./data/processed/HBNWR_Bioclim_10kmbuffer.csv")

h(dat)
dat$biovar<-paste0("BIO_",dat$bio)
names(dat)

# make a list of all temperature variables for converting (C x 10), precip in mm
bioclimnames<-unique(dat$bioclimname)
bioclimnames
# get temp cols
temponly<-bioclimnames[c(1:3,12,15:19)] # isothermality is a percent, seasonality prob needs/100
(temponly)

# ISOTHERMALITY: Isothermality the ratio of the mean diurnal range (Bio 2) 
# to the annual temperature range (Bio 7), and then multiplying by 100. 
# Isothermality quantifies how large the day-tonight
# temperatures oscillate relative to the summerto-winter
# (annual) oscillations. An isothermal value of
# 100 indicates the diurnal temperature range is equivalent
# to the annual temperature range, while anything
# less than 100 indicates a smaller level of temperature
# variability within an average month relative to the
# year. A species distribution may be influenced by
# larger or smaller temperature fluctuations within a
# month relative to the year and this predictor is useful
# for ascertaining such information


# divide all temperature columns by 10
dat[dat$bioclimname %in% temponly,2] <- dat[dat$bioclimname %in% temponly,2] / 10
s(dat[dat$bioclimname %in% temponly,2])
# divide all seasonality by 100 (just for scaling reasons)
dat[dat$bioclimname == "Temp Seasonality",2] <- dat[dat$bioclimname == "Temp Seasonality",2] / 100
s(dat[dat$bioclimname == "Temp Seasonality",2])

# SUMMARIZING -------------------------------------------------------------

# use dplyr magic to calc mean, and se 

bioc<-dat

# set up standard error function
se<-function(x) {sd(x)/sqrt(length(x))}

df50.mod<-bioc %>% 
  filter(yr==50) %>% 
  group_by(model, biovar, bioclimname) %>% 
  select(Value) %>% 
  summarise_each(funs(mean, se))
h(df50.mod)

df70.mod<-bioc %>% 
  filter(yr==70) %>% 
  group_by(model, biovar, bioclimname) %>% 
  select(Value) %>% 
  summarise_each(funs(mean, se))

# need to spread data and merge for plotting
library(tidyr)

# 50 Year
df50.mean<-df50.mod %>% 
  select(model, biovar, mean) %>% 
  spread(key=biovar, mean)
colnames(df50.mean)[2:20]<-paste0(colnames(df50.mean)[2:20],"_mean")
h(df50.mean)

df50.se<-df50.mod %>% 
  select(model, biovar, se) %>% 
  spread(key=biovar, se)
colnames(df50.se)[2:20]<-paste0(colnames(df50.se)[2:20],"_se")

dff50<-inner_join(df50.mean,df50.se,by="model")
dff50<-as.data.frame(dff50)
#dff501<-cbind(df50.mean,df50.se[,2:20])

dim(dff50)
h(dff50)

# 70 Year
df70.mean<-df70.mod %>% 
  select(model, biovar, mean) %>% 
  spread(key=biovar, mean)
colnames(df70.mean)[2:20]<-paste0(colnames(df70.mean)[2:20],"_mean")
h(df70.mean)

df70.se<-df70.mod %>% 
  select(model, biovar, se) %>% 
  spread(key=biovar, se)
colnames(df70.se)[2:20]<-paste0(colnames(df70.se)[2:20],"_se")

dff70<-inner_join(df70.mean,df70.se,by="model")
dff70<-as.data.frame(dff70)
dim(dff70)
h(dff70)



# PLOTTING ----------------------------------------------------------------
# 
# [1] "Annual Mean Temp"             "Mean Temp of Warmest Quarter"
# [3] "Mean Temp of Coldest Quarter" "Ann Precip"                  
# [5] "Precip of Wettest Month"      "Precip of Driest Month"      
# [7] "Precip Seasonality"           "Precip of Wettest Quarter"   
# [9] "Precip of Driest Quarter"     "Precip of Warmest Quarter"   
# [11] "Precip of Coldest Quarter"    "Mean Diurnal Range"          
# [13] "Isothermality"                "Temp Seasonality"            
# [15] "Max Temp of Warmest Month"    "Min Temp of Coldest Month"   
# [17] "Temp Annual Range"            "Mean Temp of Wettest Quarter"
# [19] "Mean Temp of Driest Quarter" 
# 


# df50
ggplot(dff70, aes(x = BIO_15_mean, y = BIO_2_mean, color = model)) + geom_point(size = 8) + 
  geom_errorbarh(aes(xmax = BIO_15_mean + BIO_15_se, 
                     xmin = BIO_15_mean - BIO_15_se), height = .1,lwd=1, alpha = .5) +
  geom_errorbar(aes(ymax = BIO_2_mean + BIO_2_se, 
                    ymin = BIO_2_mean - BIO_2_se), height=0.025, lwd=1, alpha = .5) +
  theme_bw() + labs(list(title = "BIOCLIM 2050")) +
  geom_vline(xintercept = mean(dff70$BIO_15_mean)) + geom_hline(yintercept = mean(dff70$BIO_2_mean)) 

# df80
ggplot(df80.mod, aes(x = PPT_sp_mean, y = Tmax_sp_mean, color = modname)) + geom_point(size = 8) + 
  geom_errorbarh(aes(xmax = PPT_sp_mean + PPT_sp_sd, 
                     xmin = PPT_sp_mean - PPT_sp_sd), height = .1,lwd=1, alpha = .5) +
  geom_errorbar(aes(ymax = Tmax_sp_mean + Tmax_sp_sd, 
                    ymin = Tmax_sp_mean - Tmax_sp_sd), height=0.04, lwd=1, alpha = .5) +
  theme_bw() + labs(list(x = "Mean Spring Precip (mm)", y = "Mean Spring max monthly Temp", title = "ClimateNA 2085")) +
  geom_vline(xintercept = mean(df80.mod$PPT_sp_mean)) + geom_hline(yintercept = mean(df80.mod$Tmax_sp_mean)) 

# dfNorms
ggplot(df70.mod[df70.mod$biovar=="BIO_1" | df70.mod$biovar=="BIO_2",], aes(x = biovar, y = biovar, color = model)) + geom_point(size = 6) + 
  theme_bw() 


# COMPRESS FILES ----------------------------------------------------------

save(bioc, df50.mod,df70.mod, dff50, dff70, bioclimnames,file = "./data/processed/bioclim_50_70.RData")


# DONE!!

# REMOVE FILES FROM WORKSPACE IF NECESSARY
# rm(list=ls())

