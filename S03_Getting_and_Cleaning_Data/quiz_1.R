# S2_Getting_and_Cleaning_Data
# Quiz 1
# Week 1

# A few links to start:
# https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-week-1/
# https://www.coursera.org/learn/data-cleaning/discussions/forums/h8cjA78DEeWtFA5RrsHG3Q/threads/g7wrg25DEeasOQpiYXGJHw
# http://datasciencespecialization.github.io/getclean/    
     
    
setwd("/Users/nathaniellai/Desktop/datasciencecoursera/S03_Getting_and_Cleaning_Data/R_C3_data")
list.files()

# Example 
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
download.file(fileUrl, destfile = "./cameras.csv", method ="curl")
list.files()
              

# Q1: How many properties are worth $1,000,000 or more?

fileUrl1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl1, destfile = paste0(getwd(), '/getdata%2Fdata%2Fss06hid.csv'), method = "curl")
list.files() 

# Method 1
library(readr)
?read_csv
q1 <- read_csv(paste(getwd(),"/getdata%2Fdata%2Fss06hid.csv"))
names(q1)
# From the code book, the variable to check is "VAL" and the category is 24
sum(q1$VAL == 24, na.rm = TRUE)
# Ans: 53

# Method 2
library(data.table)
q1_dt <- fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv")
q1_dt[VAL == 24, .N]
# Ans: 53


# Q2: Consider the variable FES (Family type and employment status) in the code book. 
# Which of the "tidy data" principles does this variable violate?

# Ans: Tidy data has one variable per column.


# Q3: 

fileUrl2 <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
path = paste0(getwd(), '/getdata%2Fdata%2FDATA.gov_NGAP.xlsx')
download.file(fileUrl2, destfile = path, method = "curl")
list.files() 
# if the xlsx file already exits, it will be replaced by the new line of code.

# Method 1
library(readxl)
?read_xlsx
(dat <- read_xlsx(path = path, sheet = 1, range = cellranger::cell_limits(c(18,7), c(23,15))))
sum(dat$Zip*dat$Ext,na.rm=T)
# Ans: 36534720

# ul vector specifying upper left cell of target rectangle, of the form c(ROW_MIN, COL_MIN)
# lr vector specifying lower right cell of target rectangle, of the form c(ROW_MAX, COL_MAX)

# Method 2
(dat <- xlsx::read.xlsx(file = path, sheetIndex = 1, rowIndex = 18:23, colIndex = 7:15))
sum(dat$Zip*dat$Ext,na.rm=T)
# Ans: 36534720

# Method 3
# Attention !
# Packages XLConnect and xlsx are not compatible and can not be loaded at the same time. 
# Reason is that XLConnect (with XLConnectJars) and xlsx with (xlsxjars) ship with 
# different versions of Apache POI. Depending on which package is loaded first, the other package won't work.

library(XLConnect)  
book<- loadWorkbook(path)
View(book)
str(book)
class(book)
getSheets(book) 
dat <- readWorksheet(book, sheet=1, startRow=18,startCol=7,endRow=23,endCol=15)
sum(dat$Zip*dat$Ext,na.rm=T)
# Ans: 36534720


# Q4: 

# Read the XML data on Baltimore restaurants
# How many restaurants have zipcode 21231?

library(XML)
fileUrl3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
?xmlTreeParse
# Beware of https vs http !! -> Use sub to remove the first occurance of "s" in https 
doc <- xmlTreeParse(sub("s", "", fileUrl3), useInternalNodes = TRUE)
class(doc)
rootNode <- xmlRoot(doc)

# rootNode[[1]]
rootNode[[1]][[1]]
rootNode[[1]][[1]][[2]]

# //node: Node at any level, e.g., //name finds all <name> nodes, no matter where in the document
zipcodes <- xpathSApply(rootNode, "//zipcode", xmlValue)
# M1
q4_df <- data.frame(zipcodes)
sum(q4_df=="21231")
# Ans: 127
# M2
q4_dt <- data.table::data.table(zipcode = zipcodes)
q4_dt[zipcode == "21231", .N]
# Ans: 127


# Q5: 

# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() and
# using the fread() command load the data into an R object.

DT <- data.table::fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv")
list.files() 

# broken down by sex. Using the data.table package, which will deliver the fastest user time?

# M1
Rprof(tmp <- tempfile())
for (i in 1:5000) {mean(DT$pwgtp15, by=DT$SEX)}
Rprof(NULL)
sum_time <- summaryRprof(tmp)$sampling.time

# M2
Rprof(append=TRUE)
Rprof(tmp <- tempfile())
for (i in 1:5000) {DT[,mean(pwgtp15),by=SEX]}
Rprof(NULL)
sum_time <- c(sum_time, summaryRprof(tmp)$sampling.time)

# M3
Rprof(append=TRUE)
Rprof(tmp <- tempfile())
for (i in 1:5000) {tapply(DT$pwgtp15,DT$SEX,mean)}
Rprof(NULL)
sum_time <- c(sum_time, summaryRprof(tmp)$sampling.time)

# M4
Rprof(append=TRUE)
Rprof(tmp <- tempfile())
for (i in 1:5000) {sapply(split(DT$pwgtp15,DT$SEX),mean)}
Rprof(NULL)
sum_time <- c(sum_time, summaryRprof(tmp)$sampling.time)

# M5
Rprof(append=TRUE)
Rprof(tmp <- tempfile())
for (i in 1:5000) {rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]}
Rprof(NULL)
sum_time <- c(sum_time, summaryRprof(tmp)$sampling.time)

names(sum_time) <- paste("Method", 1:5)
sum_time

# Method 1 Method 2 Method 3 Method 4 Method 5 
# 0.18     4.16     4.32     3.66     0.78 

# This question is not well designed as not all the answers even answer 
# the stated question, so even if they're fast, they're probably not correct 
# (which is rather tricky).

# Method 5 records:  Error in rowMeans(DT) : 'x' must be numeric and since it 
# does not meet the requirement of the question. It is incorrect, so are other 
# apply()-functions. Upon careful look, Method 1 syntax is wrong. A check of ?mean suggests
# there is no by= arguement. The correct solution is then Method 2: DT[,mean(pwgtp15),by=SEX]

