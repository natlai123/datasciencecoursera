# S3_Getting_and_Cleaning_Data
# Quiz 4
# Week 4
# Nathaniel Lai

setwd("/Users/nathaniellai/Desktop/datasciencecoursera/S03_Getting_and_Cleaning_Data/RC3data")
list.files()

# Q1 

url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
# download.file(url1, destfile = paste0(getwd(), '/getdata%2Fdata%2Fss06hid.csv'), method = "curl")
# list.files() 
library(data.table)
q1_dt <- fread(url1)
var_split <- strsplit(names(q1_dt), "wgtp")
var_split[[123]]

# Ans = ""   "15"


# Q2 

library(data.table)
gdp_dt <- fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", 
                skip=4, 
                nrows = 190, 
                select = c(1, 2, 4, 5), 
                col.names=c("CountryCode", "rank", "economy", "gdp2012"))
gdp_dt[, mean(as.integer(gsub(pattern = ",", replacement = "", x = gdp_dt$gdp2012)), na.rm=TRUE)]

# Ans = 377652.4


# Q3

grep("^United", gdp_dt[, economy])

# [1]  1  6 32
# Ans: 3


# Q4 

edu_dt <- fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")
merge_dt <- merge(x=edu_dt, y=gdp_dt, by="CountryCode")
merge_dt[grep(pattern = "Fiscal year end: June 30;", merge_dt$`Special Notes`), .N]

# Ans = 13


# Q5

library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

# How many values were collected in 2012? 
nrow(amzn["20120101/20121231"])

# Ans = 250

# How many values were collected on Mondays in 2012?
sum(weekdays(index(amzn["20120101/20121231"])) == "Monday")

# Ans = 47
