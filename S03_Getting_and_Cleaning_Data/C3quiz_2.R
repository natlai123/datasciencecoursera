# S3_Getting_and_Cleaning_Data
# Quiz 2
# Week 2
# Nathaniel Lai

# To start:
# https://github.com/lgreski/datasciencectacontent/blob/master/markdown/cleaningData-readingFiles.md


# Q1 (Working with Github API)

# Register an application with the Github API here https://github.com/settings/applications. 
# Access the API to get information on your instructors repositories (hint: this is the url 
# you want "https://api.github.com/users/jtleek/repos"). Use this data to find the time that 
# the datasharing repo was created. What time was it created?

require(jsonlite)
require(httpuv)
require(httr)

## An application must be registered with GitHub first to generate the client ID and secrets
# 1. Find OAuth settings for github:
?oauth_endpoints
oauth_endpoints("github")
# Returns the the authorize/access url/endpoints for some common web
# applications (GitHub, Facebook, google, etc)

# Replace your key and secret below.
?oauth_app
myapp <- oauth_app(appname = "natlai123_Coursera_R",
                   key = "378774a5973a22151826",
                   secret = "cae96ef63ceb9dbecd43e2f55da104e74ebc3992")

# Get OAuth credentials
?oauth2.0_token
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# Use API
?config
gtoken <- config(token = github_token)
?GET
req <- GET(url="https://api.github.com/users/jtleek/repos", config=gtoken)
# Take action on http error
?stop_for_status
stop_for_status(req)
warn_for_status(req)
message_for_status(req)
# status: HTTP 200 -> code is good 

# Extract content from a request
json1 = content(req)

# Convert to a data.frame
gitdf = jsonlite::fromJSON(jsonlite::toJSON(json1))
# converts data back into JSON format and then use the fromJSON function 
# from the jsonlite package to read the data into a data frame

dplyr::glimpse(gitdf)

# Subset data.frame for datasharing repo and time created
gitdf[gitdf$full_name == "jtleek/datasharing",  "created_at"] 
# Answer: 
# 2013-11-07T13:25:07Z

# Q2 

# Which of the following commands will select only the data for the probability 
# weights pwgtp1 with ages less than 50?

setwd("/Users/nathaniellai/Desktop/datasciencecoursera/S03_Getting_and_Cleaning_Data/RC3_data")

library(sqldf)
acs <- data.table::fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv")
# Answer
ans <- sqldf("select pwgtp1 from acs where AGEP < 50")
head(ans)


# Q3

# Using the same data frame you created in the previous problem, 
# what is the equivalent function to

unique(acs$AGEP)

# Answer
sqldf("select distinct AGEP from acs")


# Q4
# How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:
    
   # http://biostat.jhsph.edu/~jleek/contact.html

con1 <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(con1)
close(con1)
class(htmlCode)
# [1] "character"
length(htmlCode)
# 180

# Answer:
c(nchar(htmlCode[10]), nchar(htmlCode[20]), nchar(htmlCode[30]), nchar(htmlCode[100]))
# 45 31 7 25


# Q5 (reading a fixed-width file to R)

# Read this data set into R and report the sum of the numbers in the fourth of the nine columns.

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
data_head <- readLines(url, n = 10)

width <- c(1, 9, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3)
colNames <- c("space", "week", "space", "sstNino12", "space", "sstaNino12", 
              "space", "sstNino3", "space", "sstaNino3", "space", "sstNino34", "space", 
              "sstaNino34", "space", "sstNino4", "space", "sstaNino4")

data_sep <- read.fwf(url, width, header = FALSE, skip = 4, col.names = colNames)
class(data_sep)
d <- dplyr::tbl_df(data_sep)
lubridate::dmy(d$week) 
colnames(d)[colnames(d) == "week"] <- "date"
d$week <- NULL
d[,which(stringr::str_detect(names(d), "space"))] <- NULL
sum(d[,4])
# Answer: 
# 32426.7
