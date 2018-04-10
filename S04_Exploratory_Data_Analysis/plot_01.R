
# S04_Exploratory_Data_Analysis
# Project 2 
# Week 4
# Nathaniel Lai

####################################################################################################

# This R script creates plot1.R which uses base ploting system to show the total PM2.5 emission 
# from all sources for each of the years 1999, 2002, 2005, and 2008. It attempts to see if the  
# total emissions from PM2.5 have decreased in the United States from 1999 to 2008.

####################################################################################################


#### Set working directory (IMPORTANT)
setwd("~/Desktop/datasciencecoursera/S04_Exploratory_Data_Analysis/C4_W4_project_2")
list.files()


#### Import Packages 
purrr::map_lgl(c("data.table", "stringr", "dplyr"), require, character.only=TRUE, quietly=TRUE)
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
head(NEI)
head(SCC)


NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

totalNEI <- NEI[, lapply(.SD, sum, na.rm = TRUE), .SDcols = c("Emissions"), by = year]

with(totalNEI, plot(year, Emissions, type="l", xlim = c(1998, 2009), ylim = c(0, 8000000), xlab = "Years", ylab = "Emissions", main = "Emissions over the Years"))

barplot(totalNEI[, Emissions]
        , names = totalNEI[, year]
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions over the Years")
