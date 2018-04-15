
# S04_Exploratory_Data_Analysis
# Project 
# Week 4
# Nathaniel Lai

####################################################################################################

# This R script creates plot4.R by using ggplot2 library to see how have emissions from coal 
# combustion-related sources have changed across the United States from 1999–2008. 

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

#### Generate plot4.R
ind_combust <- str_detect(SCC$SCC.Level.One, regex("comb", ignore_case = TRUE))
ind_coal <- str_detect(SCC$SCC.Level.Four, regex("coal", ignore_case = TRUE))
# ind_combust <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
# ind_coal <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 

## Using the variable Short.Name works as well
# ind_combust1 <- str_detect(SCC$Short.Name, regex("comb", ignore_case = TRUE))
# ind_coal1 <- str_detect(SCC$SCC.Short.Name, regex("coal", ignore_case = TRUE))
# ind_combust_coal1 = ind_combust1 & ind_combust1
# setequal(ind_combust_coal1, ind_combust_coal) 
# returns TRUE

ind_combust_coal <- ind_combust & ind_combust

# Do not have to merge the two data sets 
# SCC_NEI <- inner_join(x=SCC, y=NEI)
# SCC_NEI <- merge(NEI, SCC, by="SCC")

NEI_comb_coal <- NEI[NEI$SCC %in% SCC$SCC[ind_combust_coal], ]

NEI_comb_coal <- NEI_comb_coal %>% 
    select(Emissions, year) %>% 
    group_by(year) %>% 
    summarise(Emissions_year = round(sum(Emissions/1000), digits = 2))

ggplot(data = NEI_comb_coal) + 
    geom_bar(mapping = aes(x=year, weight=Emissions_year), fill = "#66CC99", width = 1.5) + 
    geom_text(aes(x=year, y = Emissions_year, label = Emissions_year), vjust = -0.5) +
    geom_line(mapping = aes(x=year, y=Emissions_year)) + 
    geom_point(mapping = aes(x=year, y=Emissions_year)) +
    scale_x_continuous(breaks = c(1999, 2002, 2005, 2008)) +  
    scale_y_continuous(limits = c(0, 1700)) +
    scale_fill_discrete(guide = FALSE) + 
    labs(x="year", 
         y=expression("Total PM"[2.5]*" Emission (Thousand Tons)"), 
         title=expression("US Annual Coal-Combustion-Related PM"[2.5] * " Emissions")) + 
    theme_bw()

ggsave("plot4.png", width=6, height=4)

# Emissions from coal combustion-related sources have declined across the United States from 1999–2008. 

