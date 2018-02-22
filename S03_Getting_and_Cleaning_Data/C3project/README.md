# Getting and Cleaning Data Course Project

One of the most exciting areas in all of data science right now is wearable computing (see for example this [article](http://www.insideactivitytracking.com/data-science-activity-tracking-and-the-battle-for-the-worlds-top-sports-brand/)). Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. 


The [data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) linked to from the course website are collected from the accelerometers from the Samsung Galaxy S smartphone. The purpose of this project is to prepare tidy data from the above link that can be used for later analysis. The goal is to demonstrate one's ability to collect, work with, and clean a data set. 

A full description of the data is available at this [site](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) where the data was obtained.


This folder contains:

1. A markdown file called `README.md`
2. A tidy data set called `tidy_data.txt`
3. A R script named `run_analysis.R` 
4. A codebook named `CodeBook.md` 

`tidy_data.txt` contains 180 observations of 68 variables (see `CodeBook.md`  for details) distilled from the original data set. The composite primary key of `tidy_data.txt` is `activity` and `subjectNum`.

`run_analysis.R` is the R script that downloads and transforms the original data set to generate `tidy_data.txt`. Specifically, it does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. Creates a second, independent tidy data set with the average of
   each variable for each activity and each subject.   
   
`CodeBook.md` explains the R script, `run_analysis.R` by documenting the steps of cleaning and tidying the original data.  

Before proceeding, users should have installed the R software. If not one can download R for free from <https://www.r-project.org/>.

