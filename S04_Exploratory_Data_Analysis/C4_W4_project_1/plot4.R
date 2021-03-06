# S04_Exploratory_Data_Analysis
# Assignment 1
# Plot 4
# Nathaniel Lai

####################################################################################################

# This R script

# Download and import the UCI Electric power consumption dataset

# Examine how household energy usage varies over a 2-day period in February, 2007

# Constructs plot 4 and save it to a PNG file with a width of 480 pixels and a height of 480 pixels.


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
powerdf$datetime <- as.POSIXct(strptime(powerdf$datetime, 
      format="%Y-%m-%d_%H:%M:%S", tz = "GMT"))
# powerdf$datetime <- lubridate::ymd_hms(powerdf$datetime)
# powerdf$datetime<- xts(powerdf$datetime)


#### Start png device
png(filename = "plot4.png", width = 480, height = 480)


#### Construct plot 4

par(mfrow = c(2,2))

## Subplot 1
plot(x = powerdf$datetime, 
     y = powerdf$Global_active_power,
     type="l",
     ylab = "Global Active Power",
     xlab = "")

## Subplot 2
with(powerdf, plot(x = datetime, 
     y = Voltage,
     type="l"))

## Subplot 3
plot(x = powerdf$datetime, 
     y = powerdf$Sub_metering_1, 
     type = "l",
     ylab = "Energy sub metering",
     xlab = "")

lines(x = powerdf$datetime, 
      y = powerdf$Sub_metering_2, 
      col = "red")

lines(x = powerdf$datetime, 
      y = powerdf$Sub_metering_3, 
      col = "blue")

legend("topright", 
       col = c("black","red","blue"), 
       c("Sub_metering_1  ", "Sub_metering_2  ", "Sub_metering_3  "), 
       lty = c(1,1), 
       bty = "n", 
       cex = 0.9) 

## Subplot 4
with(powerdf, plot(x = datetime, 
     y = Global_reactive_power,
     type="l"))


#### Save plot 4

# dev.copy(png, file="plot4.png", width = 480, height = 480)
# Caution !!! This line does not work as expected. 
# See https://www.coursera.org/learn/exploratory-data-analysis/discussions/weeks/1/threads/jeKSTY29EeaQYRKcXQcKHQ
# https://www.coursera.org/learn/exploratory-data-analysis/discussions/weeks/1/threads/0RtgW7_rEeWcswoHkJGdXQ

dev.off()

