
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
purrr::map_lgl(c("data.table"), require, character.only = TRUE, quietly = TRUE)
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
# head(NEI)
# head(SCC)


#### Start png device
# png(filename = "plot2.png", width = 480, height = 480)


#### Generate plot2.R

Baltimore  <- NEI %>% 
    select(Emissions, year) %>% 
    group_by(year) %>% 
    summarise(Emissions_year = sum(Emissions))
par(mar=c(3.5, 3.5, 2, 1), mgp=c(2.4, 0.8, 0));
bar <- with(NEI_total, barplot(Emissions_year, names = year, 
                               xlab = "Years", 
                               ylab = "Emissions", 
                               ylim = c(0, 8000000),
                               main = "Emissions over the Years"))
with(NEI_total, lines(x=bar, Emissions_year))
with(NEI_total, points(x=bar, Emissions_year))

#### Save plot 2
dev.off()

# The bar charts in plot2.R demonstrates a declining trend of total PM2.5 emission 
# from all sources in years 1999, 2002, 2005, and 2008.  
