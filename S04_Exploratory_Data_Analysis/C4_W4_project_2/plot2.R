
# S04_Exploratory_Data_Analysis
# Project 2 
# Week 4
# Nathaniel Lai

####################################################################################################

# This R script creates plot2.R which uses base ploting system to show if the total emissions from 
# PM2.5 have decreased in the Baltimore City, Maryland (fips = "24510") from 1998 to 2005.

####################################################################################################


#### Set working directory (IMPORTANT)
setwd("~/Desktop/datasciencecoursera/S04_Exploratory_Data_Analysis/C4_W4_project_2")
list.files()


#### Import Packages 
library(data.table)
path <- getwd()


#### Download PM2.5 Emissions Data
if(!file.exists("exdata%2Fdata%2FNEI_data.zip") | !file.exists("exdata%2Fdata%2FNEI_data")){
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url, file.path(path, "exdata%2Fdata%2FNEI_data.zip"))
    unzip(zipfile = "exdata%2Fdata%2FNEI_data.zip")
}
dir()


#### Import Data to R (The first line takes a few seconds.)
NEI <- as.data.table(readRDS(file = "summarySCC_PM25.rds"))
SCC <- as.data.table(readRDS(file = "Source_Classification_Code.rds"))

#### Start png device
png(filename = "plot2.png", width = 600, height = 600)


#### Generate plot2.R
Baltimore <- NEI[fips=='24510', lapply(.SD, sum, na.rm = TRUE)
                , .SDcols = c("Emissions")
                , by = year]
Baltimore$Emissions <- round(Baltimore$Emissions, 2)
par(mar=c(3.5, 3.5, 2, 1), mgp=c(2, 0.7, 0))
bar <- with(Baltimore, barplot(Emissions, names = year, col = "blue",
                               xlab = "Years", 
                               ylab = expression("PM"[2.5] * " Emissions (tonnes)"), 
                               ylim = c(0, 4000),
                               main = expression("Baltimore City Annual PM"[2.5] * " Emissions")))
with(Baltimore, text(x = bar, Emissions, Emissions, adj=c(0,-0.8)))
with(Baltimore, lines(x = bar, y=Emissions, lwd = 2))
with(Baltimore, points(x = bar, y=Emissions))


#### Save plot 2
dev.off()

# From the year of 1999 to 2008, according to the bar charts in plot2.R, the PM2.5 emission 
# in Baltimore City, Maryland did decreased, although slighly. 