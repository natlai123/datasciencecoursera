# S2_R_Programming 
# Programming Assignment 
# Part 1 

# The function, 'pollutantmean', calculates the mean of a pollutant 
# (sulfate or nitrate) across a specified list of monitors. The function 
# takes three arguments: 'directory', 'pollutant', and 'id'. Given a vector 
# monitor ID numbers, 'pollutantmean' reads that monitors' particulate matter 
# data from the directory (folder: specdata) specified in the 'directory' 
# argument and returns the mean of the pollutant across all of the monitors, 
# ignoring any missing values coded as NA.


pollutantmean <- function(directory, pollutant, id=1:332){
    # Creating a vector of directory path for importing csv file 
    file_input <- paste0(directory, "/", formatC(id, width=3, flag="0"), ".csv")
    # Dynamically loading required csv file(s) to a meta list 
    # then collapse the list into one data.frame 
    data <- data.table::rbindlist(lapply(file_input,data.table::fread))
    if (pollutant == "sulfate"){
        return(mean(data$sulfate, na.rm = TRUE))
        }
    else if (pollutant == "nitrate"){
        return(mean(data$nitrate, na.rm = TRUE))
    }
}

# Example using 'pollutantmean'

path = "~/Desktop/datasciencecoursera/S2_R_Programming/specdata"

pollutantmean(directory = path, pollutant = "sulfate", 1:10) 

pollutantmean(directory = path, "nitrate", 70:72)

pollutantmean(directory = path, "nitrate", 23)