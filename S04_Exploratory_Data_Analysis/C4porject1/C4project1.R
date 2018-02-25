# S04_Getting_and_Cleaning_Data
# Project 1 
# Week 1
# Nathaniel Lai

####################################################################################################

# This R script (unorderedly)


####################################################################################################


#### Set working directory (IMPORTANT)
setwd("/Users/nathaniellai/Desktop/datasciencecoursera/S04_Exploratory_Data_Analysis/C4porject1")
list.files()


#### Import packages 
purrr::map_lgl(c("data.table", "stringr", "dplyr"), require, character.only=TRUE, quietly=TRUE)
path <- getwd()


#### Download UCI Electric power consumption dataset
if(!file.exists("getdata_dataset.zip") | !file.exists("UCI HAR Dataset")){
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, file.path(path, "dataFiles.zip"))
  unzip(zipfile = "dataFiles.zip")
}
list.files()
