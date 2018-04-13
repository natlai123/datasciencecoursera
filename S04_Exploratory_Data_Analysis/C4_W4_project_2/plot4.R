
# S04_Exploratory_Data_Analysis
# Project 
# Week 4
# Nathaniel Lai

####################################################################################################

# This R script creates plot4.R which uses ggplot2 library to see how have emissions from coal 
# combustion-related sources have changed across the United States from 1999–2008. 

####################################################################################################


#### Set working directory (IMPORTANT)
setwd("~/Desktop/datasciencecoursera/S04_Exploratory_Data_Analysis/C4_W4_project_2")
list.files()


#### Import Packages 
library(tidyverse)
path <- getwd()


#### Download PM2.5 Emissions Data
if(!file.exists("exdata%2Fdata%2FNEI_data.zip") | !file.exists("exdata%2Fdata%2FNEI_data")){
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url, file.path(path, "exdata%2Fdata%2FNEI_data.zip"))
    unzip(zipfile = "exdata%2Fdata%2FNEI_data.zip")
}
dir()

#### Import Data to R (This first line will likely take a few seconds. Be patient!)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#### Generate plot4.R
SCC$SCC <- as.character(SCC$SCC)
NEI_SCC <- left_join(NEI, SCC, by = c("SCC"))


