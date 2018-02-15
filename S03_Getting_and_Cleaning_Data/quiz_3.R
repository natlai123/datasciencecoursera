# S3_Getting_and_Cleaning_Data
# Quiz 3
# Week 3

setwd("/Users/nathaniellai/Desktop/datasciencecoursera/S03_Getting_and_Cleaning_Data/R_C3_data")
list.files()

# Q1 

url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
    # download.file(url1, destfile = paste0(getwd(), '/getdata%2Fdata%2Fss06hid.csv'), method = "curl")
    # list.files() 
library(data.table)
q1_dt <- fread(url1)
# ACR = Lot size 
# AGS = Sales of Agriculture Products
agricultureLogical <- q1_dt$ACR==3 & q1_dt$AGS ==6
which(agricultureLogical)
# Ans = 125  238  262


# Q2 

#install.packages('jpeg')
library(jpeg)
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url2, destfile = paste0(getwd(), '/getdata%2Fjeff.jpg'), method = "curl")
list.files() 
pic <- readJPEG(source="getdata%2Fjeff.jpg"  , native = TRUE)
quantile(pic, probs = c(0.3, 0.8))
# Ans = -15259150 -10575416


# Q3

# M1: data.table
library(data.table)
gdp_dt <- fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv", 
                skip=4, 
                nrows = 190, 
                select = c(1, 2, 4, 5), 
                col.names=c("CountryCode", "rank", "economy", "gdp2012"))
edu_dt <- fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv")
merge_dt <- merge(x=edu_dt, y=gdp_dt, by="CountryCode")
nrow(merge_dt)
# Ans = 189 matches
merge_dt[order(-rank)][i=13, j=c("CountryCode","economy")]
# Ans = 13th country is St. Kitts and Nevis

# M2: dplyr 
library(dplyr)
gdp_df <- tbl_df(gdp_dt)
edu_df <- tbl_df(edu_dt)
merge_df <- inner_join(gdp_df, edu_df, by="CountryCode")
nrow(merge_df)
merge_df %>% 
    arrange(desc(rank)) %>% 
    select(economy) %>% 
    head(13) %>% 
    tail(1)
    



