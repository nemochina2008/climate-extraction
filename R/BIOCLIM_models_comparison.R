## BIOClimate  and Plot
## R Peek 2015



# load(file = "./data/processed/CNA_near_mid_far_MSY.RData")

# LOAD LIBRARIES and LOCATIONS --------------------------------------------

library(dplyr)
library(readr)
library(stringr)
library(ggplot2)


# GET FILES AND SPLIT -----------------------------------------------------

bioc = read_csv("./data/processed/HBNWR_Bioclim_10kmbuffer.csv")

h(bioc)
bioc$biovar<-paste0("BIO_",bioc$bio)
names(bioc)

# make a list of all temperature variables for converting (C x 10), precip in mm
tempnames<-unique(df50.mod$bioclimname)
# grep for temp cols
temponly<-tempnames[c(grep("Temp",tempnames))]
temponly<-temponly[,c(4)]


# SUMMARIZING -------------------------------------------------------------


# use dplyr magic to calc mean, sd, and se 

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
  summarise_each(funs(mean, sd, se))

# need to spread data and merge for plotting
library(tidyr)

# 50 Year
df50.mean<-df50.mod %>% 
  select(model, biovar, mean) %>% 
  spread(key=biovar, mean)
colnames(df50.mean)[2:20]<-paste0(colnames(df50.mean)[2:20],"_mean")
h(df50.mean)

df50.sd<-df50.mod %>% 
  select(model, biovar, sd) %>% 
  spread(key=biovar, sd)
colnames(df50.sd)[2:20]<-paste0(colnames(df50.sd)[2:20],"_sd")

df50.se<-df50.mod %>% 
  select(model, biovar, se) %>% 
  spread(key=biovar, se)
colnames(df50.se)[2:20]<-paste0(colnames(df50.se)[2:20],"_se")

dff50<-inner_join(df50.mean,df50.se,by="model")
dff50<-as.data.frame(dff50)
dim(dff50)
h(dff50)


# 70 Year
df70.mean<-df70.mod %>% 
  select(model, biovar, mean) %>% 
  spread(key=biovar, mean)
colnames(df70.mean)[2:20]<-paste0(colnames(df70.mean)[2:20],"_mean")
h(df70.mean)

df70.sd<-df70.mod %>% 
  select(model, biovar, sd) %>% 
  spread(key=biovar, sd)
colnames(df70.sd)[2:20]<-paste0(colnames(df70.sd)[2:20],"_sd")

df70.se<-df70.mod %>% 
  select(model, biovar, se) %>% 
  spread(key=biovar, se)
colnames(df70.se)[2:20]<-paste0(colnames(df70.se)[2:20],"_se")

dff70<-inner_join(df70.mean,df70.se,by="model")
dff70<-as.data.frame(dff70)
dim(dff70)
h(dff70)

# PLOTTING ----------------------------------------------------------------

tempnames

# df50
ggplot(dff70, aes(x =  BIO_1_mean, y = BIO_2_mean, color = model)) + geom_point(size = 8) +  theme_bw()

# df50
ggplot(dff70, aes(x = BIO_1_mean, y = BIO_2_mean, color = model)) + geom_point(size = 8) + 
  geom_errorbarh(aes(xmax = BIO_1_mean + BIO_1_se, 
                     xmin = BIO_1_mean - BIO_1_se), height = .1,lwd=1, alpha = .5) +
  geom_errorbar(aes(ymax = BIO_2_mean + BIO_2_se, 
                    ymin = BIO_2_mean - BIO_2_se), height=0.025, lwd=1, alpha = .5) +
  theme_bw() +# labs(list(x = "Mean Spring Precip (mm)", y = "Mean Spring max monthly Temp", title = "ClimateNA 2055")) +
  geom_vline(xintercept = mean(dff70$BIO_1_mean)) + geom_hline(yintercept = mean(dff70$BIO_2_mean)) 

# df80
ggplot(df80.mod, aes(x = PPT_sp_mean, y = Tmax_sp_mean, color = modname)) + geom_point(size = 8) + 
  geom_errorbarh(aes(xmax = PPT_sp_mean + PPT_sp_sd, 
                     xmin = PPT_sp_mean - PPT_sp_sd), height = .1,lwd=1, alpha = .5) +
  geom_errorbar(aes(ymax = Tmax_sp_mean + Tmax_sp_sd, 
                    ymin = Tmax_sp_mean - Tmax_sp_sd), height=0.04, lwd=1, alpha = .5) +
  theme_bw() + labs(list(x = "Mean Spring Precip (mm)", y = "Mean Spring max monthly Temp", title = "ClimateNA 2085")) +
  geom_vline(xintercept = mean(df80.mod$PPT_sp_mean)) + geom_hline(yintercept = mean(df80.mod$Tmax_sp_mean)) 

# dfNorms
ggplot(dfnorms.MSY.mod, aes(x = PPT_sp_mean, y = Tmax_sp_mean, color = modname)) + geom_point(size = 6) + ylim(c(24,28))+
  geom_errorbarh(aes(xmax = PPT_sp_mean + PPT_sp_sd, 
                     xmin = PPT_sp_mean - PPT_sp_sd), height = 0.02,lwd=1, alpha = .5) +
  geom_errorbar(aes(ymax = Tmax_sp_mean + Tmax_sp_sd, 
                    ymin = Tmax_sp_mean - Tmax_sp_sd), height=0.02, lwd=1, alpha = .5) +
  theme_bw() + labs(list(x = "Mean Spring Precip (mm)", y = "Mean Spring max monthly Temp", title = "ClimateNA Norms")) +
  geom_vline(xintercept = mean(dfnorms.MSY.mod$PPT_sp_mean)) + geom_hline(yintercept = mean(dfnorms.MSY.mod$Tmax_sp_mean)) 


# COMPRESS FILES ----------------------------------------------------------

save(df20s,df20.mod, df50s,df50.mod, df80s, df80.mod, dfnorms.MSY, dfnorms.MSY.mod, climatevars,file = "./data/processed/CNA_near_mid_far_MSY.RData")


# DONE!!

# REMOVE FILES FROM WORKSPACE IF NECESSARY
# rm(list=ls())

