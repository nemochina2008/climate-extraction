## RUN THIS FIRST TO INSTALL PACKAGES


# STEP 1: RUN FIRST TIME ONLY

pkgs<-c("ggplot2", "shiny", "knitr", "markdown", "plyr", "dplyr")
install.packages(pkgs)

# new.packages <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
# if(length(new.packages)) install.packages(new.packages)

# STEP 2: Open the server.R or ui.R scripts in RStudio

# STEP 3: Click RunApp button on upper right of script window (green triangle icon).

