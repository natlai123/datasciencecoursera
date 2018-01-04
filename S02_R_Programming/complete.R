# S2_R_Programming 
# Programming Assignment 
# Part 2

# https://www.coursera.org/learn/r-programming/supplement/amLgW/programming-assignment-1-instructions-air-pollution

# complete() reads a directory full of files and reports the number of 
# completely observed cases in each data file. The function returns a 
# data frame where the first column is the name of the file and the 
# second column is the number of complete cases.

# More on data.table
# https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html

complete <- function(directory, id=1:332){
    # Creating a vector of directory path for importing csv file 
    file_input <- paste0(directory, "/", formatC(id, width=3, flag="0"), ".csv")
    # Dynamically loading required csv file(s) to a meta list 
    # then collapse the list into one data.frame 
    data <- data.table::rbindlist(lapply(file_input,data.table::fread))
    return(data[complete.cases(data), .N , by=ID])
    
#Alternatively    
    # d <- lapply(lapply(file_input, data.table::fread), complete.cases)
    # data <- sapply(d, sum)
    # return(data.frame(id, data))
}

# Checking 'complete'

path = "~/Desktop/datasciencecoursera/S02_R_Programming/specdata"

complete(path, 1)
complete(path, c(2, 4, 8, 10, 12))
complete(path, 30:25)
complete(path, 3)