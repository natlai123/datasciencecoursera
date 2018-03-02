# S04_Exploratory_Data_Analysis
# Assignment 1
# Plot 2
# Nathaniel Lai

####################################################################################################

# This R script

# Download and import the UCI Electric power consumption dataset

# Examine how household energy usage varies over a 2-day period in February, 2007

# Constructs plot 2 and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.


####################################################################################################


#### Set working directory (IMPORTANT)
setwd("/Users/nathaniellai/Desktop/datasciencecoursera/S04_Exploratory_Data_Analysis/C4porject1")
list.files()


#### Import packages 
library(tidyverse)
path <- getwd()


#### Download UCI Electric power consumption dataset
if(!file.exists("dataFiles.zip") | !file.exists("household_power_consumption.txt")){
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, file.path(path, "dataFiles.zip"))
  unzip(zipfile = "dataFiles.zip")
}
list.files()


#### Import UCI Electric power consumption dataset, "?" as missing values (NAs)
powerdf <- read_delim(file="household_power_consumption.txt", 
                      delim = ";", 
                      na= c("?", "NA"),
                      col_types = cols(
                        Date = col_date("%d/%m/%Y"),
                        Time = col_time(format = ""),
                        Global_active_power = col_double(),
                        Global_reactive_power = col_double(),
                        Voltage = col_double(),
                        Global_intensity = col_double(),
                        Sub_metering_1 = col_double(),
                        Sub_metering_2 = col_double(),
                        Sub_metering_3 = col_double()
                      ))

#### Filter data to focus on February, 2007
powerdf <- powerdf %>% 
    filter(Date >= "2007-02-01" & Date <= "2007-02-02")


#### Format Timstamps 
powerdf <- unite(powerdf, datetime, Date, Time)
powerdf$datetime <- lubridate::ymd_hms(powerdf$datetime)
# powerdf$datetime <- as.POSIXct(strptime(powerdf$datetime, 
#        format="%Y-%m-%d_%H:%M:%S", tz = "GMT"))
# powerdf$datetime<- xts(powerdf$datetime)


#### Start png device
png(filename = "plot2.png", width = 480, height = 480)


#### Construct plot 2
plot(x = powerdf$datetime, 
     y = powerdf$Global_active_power, 
     type="l",
     ylab = "Global Active Power (kilowatts)",
     xlab = "")


#### Save plot 2
dev.off()



