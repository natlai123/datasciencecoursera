# S3_Getting_and_Cleaning_Data
# Quiz 2
# Week 2

# To kick start:
# https://github.com/lgreski/datasciencectacontent/blob/master/markdown/cleaningData-readingFiles.md


# Q1 (Working with Github API)

# Register an application with the Github API here https://github.com/settings/applications. 
# Access the API to get information on your instructors repositories (hint: this is the url 
# you want "https://api.github.com/users/jtleek/repos"). Use this data to find the time that 
# the datasharing repo was created. What time was it created?

# require(jsonlite)
# require(httpuv)
# require(httr)

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
