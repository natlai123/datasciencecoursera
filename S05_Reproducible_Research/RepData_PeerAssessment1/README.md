# Reproducible Research: Peer Assessment 1
## Nathaniel Lai
### 22/04/2018

The purpose of this assessment is to answer a series of questions using data collected from [FitBit](http://en.wikipedia.org/wiki/Fitbit), a personal activity monitoring device. Fitbit collects data at 5 minute intervals through out the day. The dataset consists of two months of data from an anonymous individual collected during the months of October and November, 2012 and includes the number of steps taken in 5 minute intervals each day.

The dataset for this assignment can be downloaded from the course web site:

* Dataset: [Activity monitoring data](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip) [52K]

The variables included in this dataset are:

* **steps**: Number of steps taking in a 5-minute interval (missing
    values are coded as `NA`)

* **date**: The date on which the measurement was taken in YYYY-MM-DD
    format

* **interval**: Identifier for the 5-minute interval in which
    measurement was taken

The dataset is stored in a comma-separated-value (CSV) file and there are a total of 17,568 observations in this dataset.


## Loading and preprocessing the data

#### Import Packages 

```{r, echo=TRUE, message = F}
library(tidyverse)
path <- getwd()
```

#### Download PM2.5 Emissions Data

```{r, echo=TRUE}
if(!file.exists("activity.csv") | !file.exists("activity.zip")){
    url <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip"
    download.file(url, file.path(path, "activity.zip"))
    unzip(zipfile = "activity.zip")
}
dir()
activity <- read.csv("~/Desktop/datasciencecoursera/S05_Reproducible_Research/RepData_PeerAssessment1/activity.csv")
```

## What is mean total number of steps taken per day?

```{r, echo=TRUE}
activity$date <- as.Date(activity$date)

# Calculate the total number of steps taken per day and generate histogram
total_steps_day <- activity %>% 
        group_by(date) %>% 
        summarise(sum_step_day = sum(steps))

hist(total_steps_day$sum_step_day, 
     main = paste("Total Steps Per Day"), 
     xlab="Number of Steps", 
     col = "grey", 
     breaks = 18)
rug(total_steps_day$sum_step_day)

# Calculate the mean and median of the total number of steps taken per day
mean(total_steps_day$sum_step_day, na.rm = T) # mean
median(total_steps_day$sum_step_day, na.rm = T) # median
```

![plot1](https://github.com/natlai123/datasciencecoursera/blob/master/S05_Reproducible_Research/RepData_PeerAssessment1/PA1_template_files/figure-html/unnamed-chunk-3-1.png) 

The mean and median total number of steps taken per day are 10766.19 and 10765 respectively.

## What is the average daily activity pattern?

```{r, echo=TRUE}

# Make a time series plot of the 5-minute interval and the average number of steps taken
mean_step_interval <- aggregate(steps ~ interval, activity, mean)
with(mean_step_interval, plot(steps ~ interval, 
        type = "l", 
        main = "Average Number of Steps per Day by Interval",
        xlab = "Interval",
        ylab = "Average Number of Steps per Day"))

```

![plot2](https://github.com/natlai123/datasciencecoursera/blob/master/S05_Reproducible_Research/RepData_PeerAssessment1/PA1_template_files/figure-html/unnamed-chunk-4-1.png)

```{r, echo=TRUE}
# Locate the interval that contains the maximum number of steps
mean_step_interval[which.max(mean_step_interval$steps), 1]
```

The 5-minute interval on average across all the days in the dataset contains the maximum number of steps is 835.


## Imputing missing values

```{r, echo=T, warning=F}

# Calculate the total number of missing values in the dataset
sum(is.na(activity$steps)) # 2304 missing values

### Strategy 1: Filling in the mean for the corresponding 5-minute interval
activity_imputed1 <- transform(activity, steps = ifelse(is.na(activity$steps), mean_step_interval$steps[match(activity$interval, mean_step_interval$interval)], activity$steps))

# Check if averages for each interval are unchanged
mean_step_interval_imputed1 <- aggregate(steps ~ interval, activity_imputed1, mean)
setequal(mean_step_interval_imputed1, mean_step_interval) 

```

Impute missing values by filling in the mean for that 5-minute interval (strategy 1) is intuitive and granular. Futher investigation suggests that using the mean for that 5-minute interval generates the same result as using the overal mean of steps throughout the sample period when calculating the frequency of total number of steps taken per day. This intriguing result arises from the structure of the missing values. Missing values tend to cluster together. They in fact occur 288 times in a row. Since there are 2304 missing values in the sample and 288 intervals per day, there seem to be $8$ $(= 2304/288)$ days of missing data (converting 288 groups of 5-minute interval into hours adds up to a 24 hours ($288*5/60 = 24$). Thus, using dataset with missing values replaced by the overal mean of `steps` generates the same histogram (the code is provided below but the result is not shown to avoid redundancy). 


```{r, echo=T, eval = F}

# The 5-minute interval is identical to the overall mean of steps during the sample period
identical(mean(activity$steps, na.rm = T), mean(mean_step_interval$steps[match(activity$interval, mean_step_interval$interval)]))
# TRUE

### Strategy 2: Fill in all of the missing values in the dataset with mean from all observations regardless of where the NAs fall within an interval 
activity_imputed2 <- activity
activity_imputed2$steps[is.na(activity$steps)] <- mean(activity$steps, na.rm = T)

total_steps_day_imputed2 <- activity_imputed1 %>% 
        group_by(date) %>% 
        summarise(sum_step_day = sum(steps))

# Make a histogram of the total number of steps taken each day 
ggplot(data = total_steps_day_imputed2, aes(sum_step_day)) +
    geom_histogram(bins=18, fill = "red", colour = "black") +
    geom_histogram(data = total_steps_day, aes(sum_step_day), bins=18, fill = "grey", colour = "black")

```

Returning to strategy 1 (Impute missing values by inserting the mean for that 5-minute interval), checking the total number of steps tanken each day shows that on the first day of October, 2012, the total number of steps taken is 10766 (which is the sample mean filled in). This number is probably too high given the fact that it was the first day that the particiant put on the device, Fitbit. Perhaps it makes sense that we replace the imputed mean with $0$ to alleviate this overestimation. 

```{r, echo = T, warning = F}

# Replace the imputed mean with 0 on the first day of the sample period
activity_imputed1$steps[c(1:288)] <- 0
# activity_imputed1$steps[as.character(activity_imputed1$date) == "2012-10-01"] <- 0

# Create a new dataset with the missing data filled in
total_steps_day_imputed1 <- activity_imputed1 %>% 
        group_by(date) %>% 
        summarise(sum_step_day = sum(steps))

# Make a histogram of the total number of steps taken each day 
ggplot() +
    geom_histogram(data = total_steps_day_imputed1, 
                   aes(sum_step_day), bins=18, 
                   fill = "red", 
                   colour = "black") +
    geom_histogram(data = total_steps_day, 
                   aes(sum_step_day), bins=18, 
                   fill = "grey",  
                   colour = "black") +
    labs(title = "Total Steps per day (Imputed vs. Non-imputed)", 
         x = "Number of Steps", 
         y = "Frequency") +
    theme_classic()

# Calculate the new mean and median of the total number of steps taken per day
mean(total_steps_day_imputed1$sum_step_day, na.rm = T) # mean
median(total_steps_day_imputed1$sum_step_day, na.rm = T) # median

```

![plot3](https://github.com/natlai123/datasciencecoursera/blob/master/S05_Reproducible_Research/RepData_PeerAssessment1/PA1_template_files/figure-html/unnamed-chunk-8-1.png)

After filling in the mean for the corresponding 5-minute interval and replace data on October first, 2012, the histgram remains largely the same except for higher frequency at 0 and the mean value 10766. The imputed median is 10590. And there are now more total steps taken pre day.

```{r, results = 'hide', fig.show = 'hide'}

# Using Base R plotting system
hist(total_steps_day_imputed1$sum_step_day,
     main = paste("Total Steps Per Day"),
     xlab="Number of Steps",
     col = "red",
     breaks = 18)
hist(total_steps_day$sum_step_day,
     main = paste("Total Steps Per Day"),
     xlab="Number of Steps",
     col = "grey",
     breaks = 18,
     add = T)

```

```{r, results = 'hide', eval=F}

# Comparing the imputed values to the orginal values (can be skipped)
check_diff <- c(total_steps_day_imputed1[,1], total_steps_day_imputed1[,2], total_steps_day_imputed1[,2])
check_diff <- as.data.frame(check_diff)
check_diff <- plyr::rename(check_diff,c("sum_step_day" = "sum_step_day_imp", "sum_step_day.1" = "sum_step_day_org"))
check_diff$sum_step_day_org[is.na(check_diff$sum_step_day_org)] <- 0
check_diff$diff <- check_diff$sum_step_day_imp - check_diff$sum_step_day_org

```

## Are there differences in activity patterns between weekdays and weekends?

```{r, echo=T}

# Create a factor variable with two levels, "weekday"" and "weekend" 
weekday_list <- c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday")
activity_imputed1$week_dummy = as.factor(ifelse(weekdays(activity_imputed1$date) %in% weekday_list, "weekday", "weekend"))

# Make time series plots of the 5-minute interval and the average number of steps taken
mean_steps_interval_week <- activity_imputed1 %>% 
        group_by(week_dummy, interval) %>% 
        summarise(mean_step_interval = mean(steps))

ggplot(data = mean_steps_interval_week, aes(x=interval, y = mean_step_interval)) +
    geom_line() + 
    facet_grid(week_dummy ~ .) + 
    labs(title = "Daily Averge Steps by Weektype", 
         x = "5-minute interval", 
         y = "Average Number of Steps Taken") +
    theme_bw()

```

![plot4](https://github.com/natlai123/datasciencecoursera/blob/master/S05_Reproducible_Research/RepData_PeerAssessment1/PA1_template_files/figure-html/unnamed-chunk-11-1.png)

On balance, the panel plot shows that the participant has more personal movement during weekend over weekdays. Individually, each time-series plot indicates a simlar parttern that the individual tends to move more in the morning and less at night.