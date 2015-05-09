library(plyr)
library(ggplot2)

twovars <- read.csv("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Output/Distilled_data/Humbolt_bay_CMIP5_annual_ppt+tmax.csv",header = T)

#twovars$cuts <- cut(twovars$yr,breaks = c(1950,2020,2050,2080,2099), include.lowest=TRUE, labels= c("1950-2020", "2021-2050", "2051-2080", ">2081"),)
twoply <- ddply(twovars, .(cuts, model), summarize, pptmean = mean(ppt), pptse = sd(ppt)/sqrt(length(ppt)), tasmaxmean = mean(tasmax), tasmaxse = sd(tasmax)/sqrt(length(tasmax)))

modlookup <- data.frame("model" = unique(twoply$model), "ID" = str_pad(1:27, 2, pad = "0"))
twoply <- merge(twoply, modlookup, by = "model", all.x = T)
twoply$model2 <- paste(twoply$ID, twoply$model)

##Plotting

##Projected climate change

png("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Output/Figures/CMIP5_prcp_temp_mod_comparisons_%02d.png", 
    height = 9, width = 11, units = "in", res = 700, pointsize = 12, family = "serif")

twoply2021 <- twoply[twoply$cuts == "2021-2050",]

ggplot(twoply2021, aes(x = pptmean, y = tasmaxmean, color = model2)) + geom_point(size = 8) + 
  geom_errorbarh(aes(xmax = pptmean + pptse, xmin = pptmean - pptse), height = .02, alpha = .5) +
  geom_errorbar(aes(ymax = tasmaxmean + tasmaxse, ymin = tasmaxmean - tasmaxse), width = .2, alpha = .5) +
  theme_bw() + labs(list(x = "Mean Annual Precip (mm)", y = "Mean Annual max monthly Temp", title = "2021 - 2050")) +
  geom_vline(xintercept = mean(twoply2021$pptmean)) + geom_hline(yintercept = mean(twoply2021$tasmaxmean)) + 
  geom_text(aes(label = row(dfsum)), color = "white", vjust = .4, show_guide = F)

twoply2051 <- twoply[twoply$cuts == "2051-2080",]

ggplot(twoply2051, aes(x = pptmean, y = tasmaxmean, color = model2)) + geom_point(size = 8) + 
  geom_errorbarh(aes(xmax = pptmean + pptse, xmin = pptmean - pptse), height = .02, alpha = .5) +
  geom_errorbar(aes(ymax = tasmaxmean + tasmaxse, ymin = tasmaxmean - tasmaxse), width = .2, alpha = .5) +
  theme_bw() + labs(list(x = "Mean Annual Precip (mm)", y = "Mean Annual max monthly Temp", title = "2051 - 2080")) +
  geom_vline(xintercept = mean(twoply2051$pptmean)) + geom_hline(yintercept = mean(twoply2051$tasmaxmean)) +
  geom_text(aes(label = ID), color = "white", vjust = .4, show_guide = F)

dev.off()

##Time series with trend lines

png("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Output/Figures/CMIP5_models_%02d.png", 
    height = 9, width = 11, units = "in", res = 700, pointsize = 12, family = "serif")

ggplot(twovars, aes(x = yr, y = ppt)) + geom_point(aes(color = model),size = 1, alpha = .5) + 
  stat_smooth(aes(color = model), se = F) + 
  theme_bw() + theme(legend.position="none")

ggplot(twovars, aes(x = yr, y = tasmax)) + geom_point(aes(color = model),size = 1, alpha = .5) + 
  stat_smooth(aes(color = model), se = F) + 
  theme_bw() + theme(legend.position="none")

dev.off()

##30yr average plots with error bars

png("C:/Users/ejholmes/Documents/USFWS/Refuges/Humbolt_Bay/Output/Figures/CMIP5_ppt+temp_30yr_avg_%02d.png", 
    height = 9, width = 11, units = "in", res = 700, pointsize = 12, family = "serif")

ggplot(twoply[twoply$cuts %in% c("2021-2050", "2051-2080"),], aes(x = cuts, y = tasmaxmean, color = model, group = model)) + 
  geom_point(size = 2,width  =.1, position = position_dodge(width = .2)) +
  theme_bw() + theme(legend.position="none") + 
  geom_errorbar(aes(ymax = tasmaxmean + tasmaxse, ymin = tasmaxmean - tasmaxse), width  =.05, position = position_dodge(width = .2))

ggplot(twoply[twoply$cuts %in% c("2021-2050", "2051-2080"),], aes(x = cuts, y = pptmean, color = model, group = model)) + 
  geom_point(size = 2,width  =.1, position = position_dodge(width = .2)) +
  theme_bw() + theme(legend.position="none") + 
  geom_errorbar(aes(ymax = pptmean + pptse, ymin = pptmean - pptse), width  =.05, position = position_dodge(width = .2))

dev.off()