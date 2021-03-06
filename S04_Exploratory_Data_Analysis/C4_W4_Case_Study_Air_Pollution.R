## Case Study: Fine Particle Pollution in the U.S. from 1999 to 2012

# Has fine particle pollution in the U.S. decreased from 1999 to
## 2012?

## Read in data from 1999
setwd("/Users/nathaniellai/Desktop/datasciencecoursera/S04_Exploratory_Data_Analysis/pm25_data")

pm0 <- read.table("RD_501_88101_1999-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "")
dim(pm0)
head(pm0)
cnames <- readLines("RD_501_88101_1999-0.txt", 1)
print(cnames)
cnames <- strsplit(cnames, "|", fixed = TRUE)
print(cnames)
names(pm0) <- make.names(cnames[[1]]) # "makes syntactically valid names"
head(pm0)
x0 <- pm0$Sample.Value
class(x0)
str(x0)
summary(x0)
mean(is.na(x0))  ## Are missing values important here? Around 11%

## Read in data from 2012

pm1 <- read.table("RD_501_88101_2012-0.txt", comment.char = "#", header = FALSE, sep = "|", na.strings = "", nrow = 1304290)
names(pm1) <- make.names(cnames[[1]])
head(pm1)
dim(pm1)
x1 <- pm1$Sample.Value
class(x1)

## Five number summaries for both periods
summary(x1)
summary(x0)
mean(is.na(x1))  ## Are missing values important here? Around 5%
# Both the median and the mean of measured particulate matter have declined from 1999 to 2012. In
# fact, all of the measurements, except for the maximum and missing values (Max and NA's), have decreased.

## Make a boxplot of both 1999 and 2012
boxplot(x0, x1)
boxplot(log10(x0), log10(x1))

## Check negative values in 'x1'
summary(x1)
negative <- x1 < 0
sum(negative, na.rm = T)
mean(negative, na.rm = T)
dates <- pm1$Date
str(dates)
dates <- as.Date(as.character(dates), "%Y%m%d")
str(dates)
hist(dates, "month")  ## Check what's going on in months 1--6
hist(dates[negative], "month") 

# We see the bulk of the negative measurements were taken in the winter months, with a spike in May. Not many
# of these negative measurements occurred in summer months. We can take a guess that because particulate
# measures tend to be low in winter and high in summer, coupled with the fact that higher densities are easier
# to measure, that measurement errors occurred when the values were low. For now we'll attribute these
# negative measurements to errors. Also, since they account for only 2% of the 2012 data, we'll ignore them.



## Plot a subset for one monitor at both times

## Find a monitor for New York State that exists in both datasets
site0 <- unique(subset(pm0, State.Code == 36, c(County.Code, Site.ID)))
site1 <- unique(subset(pm1, State.Code == 36, c(County.Code, Site.ID)))
site0 <- paste(site0[,1], site0[,2], sep = ".")
site1 <- paste(site1[,1], site1[,2], sep = ".")
str(site0)
str(site1)
both <- intersect(site0, site1)
print(both)

## Find how many observations available at each monitor
pm0$county.site <- with(pm0, paste(County.Code, Site.ID, sep = "."))
pm1$county.site <- with(pm1, paste(County.Code, Site.ID, sep = "."))
cnt0 <- subset(pm0, State.Code == 36 & county.site %in% both)
cnt1 <- subset(pm1, State.Code == 36 & county.site %in% both)
sapply(split(cnt0, cnt0$county.site), nrow)
sapply(split(cnt1, cnt1$county.site), nrow)

## Choose county 63 and side ID 2008
pm1sub <- subset(pm1, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
pm0sub <- subset(pm0, State.Code == 36 & County.Code == 63 & Site.ID == 2008)
dim(pm1sub)
dim(pm0sub)

## Plot data for 2012
dates1 <- pm1sub$Date
x1sub <- pm1sub$Sample.Value
plot(dates1, x1sub)
dates1 <- as.Date(as.character(dates1), "%Y%m%d")
str(dates1)
plot(dates1, x1sub)

## Plot data for 1999
dates0 <- pm0sub$Date
dates0 <- as.Date(as.character(dates0), "%Y%m%d")
x0sub <- pm0sub$Sample.Value
plot(dates0, x0sub)

## Plot data for both years in same panel
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
plot(dates0, x0sub, pch = 20)
abline(h = median(x0sub, na.rm = T))
plot(dates1, x1sub, pch = 20)  ## Whoa! Different ranges
abline(h = median(x1sub, na.rm = T)) 
# 1999 median is larger 

## Find global range
rng <- range(x0sub, x1sub, na.rm = T)
rng
par(mfrow = c(1, 2), mar = c(4, 4, 2, 1))
plot(dates0, x0sub, pch = 20, ylim = rng)
abline(h = median(x0sub, na.rm = T))
plot(dates1, x1sub, pch = 20, ylim = rng)
abline(h = median(x1sub, na.rm = T))

## Show state-wide means and make a plot showing trend
head(pm0)
mn0 <- with(pm0, tapply(Sample.Value, State.Code, mean, na.rm = T))
str(mn0)
summary(mn0)
# Why 53 if there are only 50 states? As it happens, pm25 measurements for the District of 
# Columbia (Washington D.C), the Virgin Islands, and Puerto Rico are included in this data. 
# They are coded as 11, 72, and 78 respectively.
mn1 <- with(pm1, tapply(Sample.Value, State.Code, mean, na.rm = T))
str(mn1)
# 52 entries because there are no entries for the Virgin Islands in 2012.
summary(mn1)

## Make separate data frames for states / years
d0 <- data.frame(state = names(mn0), mean = mn0)
d1 <- data.frame(state = names(mn1), mean = mn1)
mrg <- merge(d0, d1, by = "state")
dim(mrg)
head(mrg)

## Connect lines
par(mfrow = c(1, 1))
with(mrg, plot(rep(1999, 52), mrg[, 2], xlim = c(1998, 2013)), ylim = c(0, 20),
     main = "PM2.5 Pollution Level by State for 1999 & 2012",
     xlab = "", ylab = "State-wide Mean PM")
with(mrg, points(rep(2012, 52), mrg[, 3], ylim = c(0, 20)))
segments(rep(1999, 52), mrg[, 2], rep(2012, 52), mrg[, 3]) # Connect dots 


# plot the pollution levels data points for 1999
with(mrg, plot(rep(1999, 52), mrg[, 2], xlim = c(1998, 2013), ylim = c(3, 20),
               main = "PM2.5 Pollution Level by State for 1999 & 2012",
               xlab = "", ylab = "State-wide Mean PM"))
# plot the pollution levels data points for 2012
with(mrg, points(rep(2012, 52), mrg[, 3]))
# connected the dots
segments(rep(1999, 52), mrg[, 2], rep(2012, 52), mrg[, 3]) # Connect Dots

# The vast majority of states have indeed improved their particulate matter counts so 
# the general trend is downward. There are a few exceptions. (The topmost point in the 
# 1999 column is actually two points that had very close measurements.)

# 4 states had higher means in 2012 than in 1999
mrg[mrg$mean.x < mrg$mean.y, ]

