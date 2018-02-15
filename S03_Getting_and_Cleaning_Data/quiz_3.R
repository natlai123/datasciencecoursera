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
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 

#install.packages('jpeg')
library(jpeg)
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url2, destfile = paste0(getwd(), '/getdata%2Fjeff.jpg'), method = "curl")
list.files() 
pic <- readJPEG(source="getdata%2Fjeff.jpg"  , native = TRUE)
quantile(pic, probs = c(0.3, 0.8))
# Ans = -15259150 -10575416


# Q3
# Match the data based on the country shortcode. How many of the IDs match? Sort the data frame 
# in descending order by GDP rank (so United States is last). What is the 13th country in the 
# resulting data frame?

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
    

# Q4
# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?

# M1: data.table
merge_dt[`Income Group` == "High income: OECD",
        lapply(.SD, mean),
        .SDcols = c("rank"),
        by = "Income Group"]

merge_dt[`Income Group` == "High income: nonOECD",
         lapply(.SD, mean),
         .SDcols = c("rank"),
         by = "Income Group"]

# M2: dlpyr
merge_df %>% 
    select(contains("Income Group"), rank) %>% 
    group_by(`Income Group`) %>% 
    summarise(mean_rank = mean(rank)) %>% 
    # To display numeric figures nicely, use the fomat function (but mean_rank becomes chr)
    mutate_if(.predicate=is.numeric, 
              .funs=format, 
              trim=TRUE,
              digits = 6)


# Q5 

# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. 
# How many countries are Lower middle income but among the 38 nations with highest GDP?

# M1 dyplr
qgp <- quantile(as.numeric(merge_df$rank), seq(0, 1, 0.2), na.rm=TRUE)
merge_df$gdpquantile <- cut(merge_df$rank, breaks = qgp)

merge_df %>% 
    group_by(`Income Group`, gdpquantile) %>% 
   #select(`Income Group`, gdpquantile) %>% 
    filter(`Income Group` == "Lower middle income") %>% 
    summarise(N = n())

#M2 data.table
qgp <- quantile(as.numeric(merge_dt$rank), seq(0, 1, 0.2), na.rm=TRUE)
merge_dt$gdpquantile <- cut(merge_dt$rank, breaks = qgp,  ordered_result = TRUE)

merge_dt[`Income Group` == "Lower middle income", 
         .N, 
         by = c("Income Group", "gdpquantile")][order(gdpquantile)]

# Ans = 5
