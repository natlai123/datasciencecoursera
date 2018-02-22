# Getting and Cleaning Data Prokect Code book 

This Code Book is best read with the R script, `run_analysis.R` in the folder `C3project` as it explains the script by documenting the steps of cleaning and tidying the original data from UCI HAR Dataset.  

Before proceeding, users should have installed the R software. If not one can download R for free from <https://www.r-project.org/>. The R packages used in `run_analysis.R` are `purrr`, `data.table`, `stringr` and  `dplyr` (the `rebus` package are used to check the regular expression in the script but not installing the package will not hinder the functioning of the script).

## The Original Dataset

The original data collected from the accelerometers from the Samsung Galaxy S smartphone is from the UCI HAR Dataset which could be download through: 

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> 

A full description of the data is available at 

<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones> 

where the data was obtained. Information on the variables details can be obtained from the `features_info.txt` contained in the downloaded `UCI HAR Dataset` folder.


## Workflow of Getting and Cleaning the Data

The major steps taken to tackle the untidy data are ordered as followed:

1. Setting working directory. For the script to run successfully, users should replace the directory to his/her choice of path at:`#### Set working directory (IMPORTANT)` `setwd("CHANGE THIS TO YOUR PATH")`

2. Downloading the UCI HAR dataset;

3. Importing `activity_labels.txt` (activity labels) and `features.txt`(features) to R;

4. Generating an index for mean and standard deviation of each measurement for later extraction. The index should be of length 66, meaning that 66 variables are to be extracted to create the independent and final dataset `tidy_data.txt`;

5. Labeling the data with descriptive variable names. This involves renaming of the variables from `features.txt` through regular expression. See section [More on Step 5](###-more-on-step-5) for detail;

6. Importing the subject, train and test datasets to R. Note that the folders `Inertial Signals` are not used throughtout;

7. Merging the subject, train and test sets to one dataset;

8. Using descriptive activity names from `activity_labels.txt` to name the activities in the merged data set. This involves setting the variable, `activity`, to a factor with  6 classes from `activity_labels.txt`;

9. Extracting only the measurements on the mean and standard deviation for each measurement;

10. Removing unwanted data and intermediate variables; 

11. Creating a second, independent tidy data set with the average of each variable for each activity and each subject.


After running `run_analysis.R`, the working environment of R should contain only three datasets, namely 

1. `data_Mean` which contains 180 observations of 68 variables. `data_Mean` corresponds to the step 11. 

2. `data_mean_std` which contains 10299 observations of 68 variables, `data_mean_std` corresponds to the step 9.

3. `one_dataset` which contains 10299 observations of 563 variables. `one_dataset` corresponds to the step 7.



### More on step 5

Step 5 involves:

a) Expanding abbreviations in variable names:

*  `f` to `freqDomain`
*  `t` to `freqDomain`
*  `Acc` to `freqDomain`
*  `Gyro` to `freqDomain`
*  `Mag` to `freqDomain`

b) Removing empty open parentheses, 

c) Transforming sepereators such as comma and hyphen to underscore, and 

d) Correcting the typo `BodyBody` to `Body` in `features.txt` (line 516 to 554).


## The Final Clean Dataset

The last line of code of `run_analysis.R` creates `tidy_data.txt`. `tidy_data.txt` is a comma delimited test file, if imported appropriately, should contains 180 observations of 68 variables. The composite primary key of `tidy_data.txt` is `activity` and `subjectNum`.




