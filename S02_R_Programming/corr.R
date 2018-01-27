# S2_R_Programming 
# Programming Assignment 
# Week 2, Part 3 

# https://www.coursera.org/learn/r-programming/supplement/amLgW/programming-assignment-1-instructions-air-pollution

# corr() takes a directory of data files and a threshold for complete cases
# and calculates the correlation between sulfate and nitrate for monitor 
# locations where the number of completely observed cases (on all variables) 
# is greater than the threshold. The function should return a vector of 
# correlations for the monitors that meet the threshold requirement. 
# If no monitors meet the threshold requirement, then the function should 
# return a numeric vector of length 0


corr <- function(directory, threshold = 0){
    # Since the function checks all files in the specdata, dynamic importing 
    # (in part 1 and 2) is not needed here. To take all files into account, use
    files_input <- dir(directory, full.names = TRUE)
    dlist <- lapply(files_input, data.table::fread)
    data <- data.table::rbindlist(dlist)
    # remove NA items
    data <- data[complete.cases(data)]
    # Using data.table's feature (by=ID) to obtain obs num. and correlation within 
    # each sublist (eg 001.csv)  then chaining (imposing constraint) [N > threshold] 
    # to select only sublists that meet the threshold.  
    data <- data[, .(nobs= .N, Correlation=cor(sulfate, nitrate)), by = ID][nobs > threshold]
    return(data[, Correlation])
}

# Checking 'corr'

path = "~/Desktop/datasciencecoursera/S02_R_Programming/specdata"

cr <- corr(path, 150)
head(cr)
summary(cr)

cr <- corr(path, 400)
head(cr)
summary(cr)

cr <- corr(path, 5000)
summary(cr)
length(cr)

cr <- corr(path)
summary(cr)
length(cr)