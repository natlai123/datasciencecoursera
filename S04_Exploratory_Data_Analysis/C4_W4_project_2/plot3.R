
# S04_Exploratory_Data_Analysis
# Project 2 
# Week 4
# Nathaniel Lai

####################################################################################################

# This R script creates plot3.R by using ggplot2 library to see which of the four sources 
# (point, nonpoint, onroad, nonroad) have seen decreases in emissions from 1999–2008 for Baltimore 
# City and which of the four have seen increases in emissions from 1999–2008

####################################################################################################


#### Set working directory (IMPORTANT)
setwd("~/Desktop/datasciencecoursera/S04_Exploratory_Data_Analysis/C4_W4_project_2")
list.files()


#### Import Packages 
library(tidyverse)
path <- getwd()


#### Download PM2.5 Emissions Data
if(!file.exists("exdata%2Fdata%2FNEI_data.zip")){
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(url, file.path(path, "exdata%2Fdata%2FNEI_data.zip"))
    unzip(zipfile = "exdata%2Fdata%2FNEI_data.zip")
}
dir()


#### Import Data to R (The first line takes a few seconds.)
NEI <- readRDS(file = "summarySCC_PM25.rds")
SCC <- readRDS(file = "Source_Classification_Code.rds")


#### Generate plot3.R
Baltimore <- NEI %>% 
    filter(fips == "24510") %>% 
    select(Emissions, year, type) %>% 
    group_by(type, year) %>% 
    summarise(Emissions_year = sum(Emissions))

ggplot(data = Baltimore) + 
    geom_bar(mapping = aes(x=year, fill=factor(year), weight=Emissions_year), width = 1.5) + 
    geom_line(mapping = aes(x=year, y=Emissions_year)) + 
    geom_point(mapping = aes(x=year, y=Emissions_year)) +
    facet_grid(.~type) + 
    scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) + 
    scale_y_continuous(breaks = seq(0, 2500, by=  250)) + 
    #scale_fill_discrete(name = "year") + 
    scale_fill_discrete(guide = FALSE) + 
    labs(x="year", 
         y=expression("PM"[2.5]*" Emission (Tons)"), 
         title=expression("PM"[2.5]*" Emissions in Baltimore City")) + 
    theme_bw()

## Line Chart
# ggplot(Baltimore, aes(year, Emissions_year, color = type)) + 
#   geom_line() + 
#   xlab("year") + 
#   ylab(expression('Total PM'[2.5]*" Emissions")) + 
#   ggtitle('Total Emissions in Baltimore City, Maryland (fips == "24510") from 1999 to 2008') 
# 

#### Save plot 3
ggsave("plot3.png", width=6, height=4)

# three souces, nonpoint, onroad, nonroad, have seen similar decreases in emissions from 1999–2008 
# for Baltimore City and only point has seen an increase in emissions from 1999–2008.