
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
purrr::map_lgl(c("tidyverse"), require, character.only = TRUE, quietly = TRUE)
path <- getwd()


#### Download PM2.5 Emissions Data
if(!file.exists("exdata%2Fdata%2FNEI_data.zip") | !file.exists("exdata%2Fdata%2FNEI_data")){
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(url, file.path(path, "exdata%2Fdata%2FNEI_data.zip"))
  unzip(zipfile = "exdata%2Fdata%2FNEI_data.zip")
}
dir()


#### Import Data to R (The first line takes a few seconds.)
NEI <- readRDS(file = "summarySCC_PM25.rds")
SCC <- readRDS(file = "Source_Classification_Code.rds")
# head(NEI)
# head(SCC)


#### Start png device
png(filename = "plot1.png", width = 600, height = 600, units = "px", bg = "white")


#### Generate plot1.R
NEI_total <- NEI %>% 
    select(Emissions, year) %>% 
    group_by(year) %>% 
    summarise(Emissions_year = round(sum(Emissions)/1000000, digits = 2))
par(mar=c(3.5, 3.5, 2, 1), mgp=c(2, 0.7, 0))
bar <- with(NEI_total, barplot(Emissions_year, names = year, 
            xlab = "Years", 
            ylab = expression("PM"[2.5] * " Emissions (million tonnes)"), 
            ylim = c(0, 8),
            main = expression("US Annual PM"[2.5] * " Emissions")))
with(NEI_total, text(x = bar, Emissions_year, Emissions_year, adj=c(0,-0.8)))
with(NEI_total, lines(x = bar, y=Emissions_year, lwd = 2))
with(NEI_total, points(x = bar, y=Emissions_year))

#### Save plot 1
dev.off()

# The bar charts in plot1.R demonstrates a declining trend of total PM2.5 emission 
# from all sources in years 1999, 2002, 2005, and 2008.  
