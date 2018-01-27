# S2_R_Programming 
# Programming Assignment 
# Week 2, Part 2

# https://www.coursera.org/learn/r-programming/supplement/amLgW/programming-assignment-1-instructions-air-pollution

# complete() reads a directory full of files and reports the number of 
# completely observed cases in each data file. The function returns a 
# data frame where the first column is the name of the file and the 
# second column is the number of complete cases.

# More on data.table
# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html


complete1 <- function(directory, id=1:332){
    # Creating a vector of directory path for importing csv file 
        file_input <- paste0(directory, "/", formatC(id, width=3, flag="0"), ".csv")
    # Dynamically loading required csv file(s) to a meta list 
    # then collapse the list into one data.frame 
        data <- data.table::rbindlist(lapply(file_input, data.table::fread))
    return(data[complete.cases(data), .(nobs=.N), by=ID])
    # The problem with this approach is it collapses ID where every data point is NA 
    # such that the ID number of the NA csv file disappears.
}    

complete2 <- function(directory, id=1:332){
    # Creating a vector of directory path for importing csv file 
    #file_input <- paste0(directory, "/", formatC(id, width=3, flag="0"), ".csv")
        file_input <- paste0(directory, "/", stringr::str_pad(id, width=3, side = "left", pad = "0"), ".csv")
        data <- lapply(file_input, data.table::fread)
        data <- lapply(data, complete.cases)
        nobs <- sapply(data, sum)
    return(data.frame(id, nobs))
}

complete3 <- function(directory, id = 1:332){
    files_input <- dir(directory, full.names = TRUE)
    nobs <- c()
    for (i in id){
        data <- read.csv(files_input[i])
        data <- sum(complete.cases(data))
    # The above step avoids ommiting ID with all obs = NA
        nobs <- c(nobs, data)
    }
    return(data.frame(id, nobs))
 }



# Checking 'complete'

path = "~/Desktop/datasciencecoursera/S02_R_Programming/R_C2_data/specdata"

complete1(path, 1)
complete1(path, c(2, 4, 8, 10, 12))
complete1(path, 30:25)
complete1(path, 3)

(complete2(path, 1))
complete2(path, c(2, 4, 8, 10, 12))
complete2(path, 30:25)
complete2(path, 3)

complete3(path, 1)
complete3(path, c(2, 4, 8, 10, 12))
complete3(path, 30:25)
complete3(path, 3)

set.seed(42)
cc1 <- complete1(path, 332:1)
cc2 <- complete2(path, 332:1)
cc3 <- complete3(path, 332:1)
use <- sample(332, 10)
print(cc1[use, "nobs"])
print(cc2[use, "nobs"])
print(cc3[use, "nobs"])