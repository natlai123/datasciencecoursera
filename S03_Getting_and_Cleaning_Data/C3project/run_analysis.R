
# S3_Getting_and_Cleaning_Data
# Project 
# Week 4
# Nathaniel Lai

####################################################################################################

# This R script (unorderedly)

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of
#    each variable for each activity and each subject.

####################################################################################################


#### Set working directory (IMPORTANT)
setwd("/Users/nathaniellai/Desktop/datasciencecoursera/S03_Getting_and_Cleaning_Data/C3project")
list.files()


#### Import packages 
purrr::map_lgl(c("data.table", "stringr", "dplyr"), require, character.only=TRUE, quietly=TRUE)
path <- getwd()


#### Download UCI HAR dataset
if(!file.exists("getdata_dataset.zip") | !file.exists("UCI HAR Dataset")){
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, file.path(path, "dataFiles.zip"))
    unzip(zipfile = "dataFiles.zip")
}
#list.files()


#### Import activity labels and features to R
activityLabels <- fread("UCI HAR Dataset/activity_labels.txt", col.names = c("index", "activity"))
features <- fread("UCI HAR Dataset/features.txt", col.names = c("index", "featuresName"))


#### Generate index for mean and standard deviation of each measurement for extraction
featuresIndex <- grep("(mean|std)\\(\\)", features$featuresName)
## Remember to include "()" by escaping it, see the difference between
# rebus::str_view(features$featuresName, or("mean", "std") %R% "\\(\\)", match = T)
# rebus::str_view(features$featuresName, or("mean", "std") %R% "()", match = T)
length(featuresIndex) 
# 66 measurements on the mean and standard deviation of features


##########################################################################
#### Appropriately label the data set with descriptive variable names ####
##########################################################################

## Expand abbreviations, remove "()", tidy sepereators, "-,", and correct typo
features$featuresName <- str_replace_all(features$featuresName, 
        c("^f" = "freqDomain", 
          "^t" = "timeDomain",
          "Acc" = "Accelerometer", 
          "Gyro" = "Gyroscope", 
          "Mag" = "Magnitude",
          "\\(\\)" = "",
          "[-,]" = "_",
          "BodyBody" = "Body"))

#### Generate references of mean and standard deviation of each measurement for extraction
measurements <- features$featuresName[featuresIndex]


#### Import train, test, subject datasets to R
xtrain <- fread("UCI HAR Dataset/train/X_train.txt", col.names = c(features$featuresName))
xtest <- fread("UCI HAR Dataset/test/X_test.txt",  col.names = c(features$featuresName))
ytrain <- fread("UCI HAR Dataset/train/y_train.txt", col.names = "activity")
ytest <- fread("UCI HAR Dataset/test/y_test.txt",  col.names = "activity")
subject_train <- fread("UCI HAR Dataset/train/subject_train.txt", col.names = "subjectNum")
subject_test <- fread("UCI HAR Dataset/test/subject_test.txt", col.names = "subjectNum")


################################################################
####        Merge test and train sets to one dataset        ####
################################################################

#### Merge datasets to create test and train sets
## activity and subjectNum as composite primary key

#train <- cbind(subject_train, ytrain, xtrain)
train <- bind_cols(.id= c(ytrain, subject_train), xtrain)
#test <- cbind(subject_test, ytest, xtest)
test <- bind_cols(.id = c(ytest, subject_test), xtest)
#### Merge test and train sets to one dataset
one_dataset <- bind_rows(train, test)


###############################################################################
#### Use descriptive activity names to name the activities in the data set ####
###############################################################################

one_dataset$activity <- factor(one_dataset$activity, 
            levels = activityLabels$index, 
            labels = activityLabels$activity)


###############################################################################################
#### Extract only the measurements on the mean and standard deviation for each measurement ####
###############################################################################################

data_mean_std <- one_dataset %>% select(activity, subjectNum, measurements)

#### Remove unwanted datasets and variables
rm(list = c("features", "activityLabels", "test", "train", "xtest", "ytest", "measurements", 
            "xtrain", "ytrain", "subject_test", "subject_train", "featuresIndex", "path", "url"))


##########################################################################################
#### Creates a second independent tidy data set with the average of each variable for ####
####    each activity and each subject                                                ####
##########################################################################################

data_Mean <- data_mean_std %>% 
    group_by(activity, subjectNum) %>% 
        summarise_all(.funs=mean)

# This works the same as the line above 
# data_a <- reshape2::recast(data_mean_std, subjectNum + activity~variable,
#             mean, id.var=c("subjectNum","activity"))
# data_b <- aggregate(. ~subjectNum + activity, data_mean_std, mean)
# setequal(data_a, data_b, data_Mean)


#### Creating the final dataset, tidy_data.txt    
write.table(x = data_Mean, file = "tidy_data.txt", row.name = FALSE, quote = FALSE)
# same as:
# fwrite(x = data_Mean, file = "tidy_data.txt", sep = " ", quote = FALSE) 









