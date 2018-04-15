
# S04_Exploratory_Data_Analysis
# Project 
# Week 4
# Nathaniel Lai

####################################################################################################

# This R script creates plot5.R by using ggplot2 library to see how emissions from motor vehicle 
# sources have changed from 1999–2008 in Baltimore City.

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


#### Import Data to R (This first line will likely take a few seconds. Be patient!)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


#### Generate plot5.R
NEI_vehicle <- NEI %>% 
    filter(fips == "24510" & type == "ON-ROAD") %>% 
    select(Emissions, year) %>% 
    group_by(year) %>% 
    summarise(Emissions_year = round(sum(Emissions), digits = 2))

ggplot(data = NEI_vehicle) + 
    geom_bar(mapping = aes(x=year, weight=Emissions_year), fill = "#9999CC", width = 1.5) + 
    geom_text(aes(x=year, y = Emissions_year, label = Emissions_year), vjust = -0.5) +
    geom_line(mapping = aes(x=year, y=Emissions_year)) + 
    geom_point(mapping = aes(x=year, y=Emissions_year)) +
    scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) +  
    scale_y_continuous(limits = c(0, 500)) +
    scale_fill_discrete(guide = FALSE) + 
    labs(x="year", 
         y=expression("Total PM"[2.5]*" Emission (Tons)"), 
         title=expression("US Annual Motor-Vehicle-Related PM"[2.5] * " Emissions")) + 
    theme_bw()

ggsave("plot5.png", width=6, height=4)

# Emissions from motor vehicle sources have declined from 1999–2008 in Baltimore City.


