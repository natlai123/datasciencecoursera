# S2_R_Programming 
# Programming Assignment 
# Week 4 

# Finding the best hospital in a state

# best() takes two arguments: the 2-character abbreviated name of a state and an
# outcome name. The function reads the outcome-of-care-measures.csv and returns a character vector
# with the name of the hospital that has the best (i.e. lowest) 30-day mortality for the specied outcome
# in that state. The hospital name is the name provided in the Hospital.Name variable. The outcomes can
# be one of "heart attack", "heart failure", or "pneumonia". Hospitals that do not have data on a particular
# outcome should be excluded from the set of hospitals when deciding the rankings.

setwd("/Users/nathaniellai/Desktop/datasciencecoursera/S02_R_Programming/rprog%2Fdata%2FProgAssignment3-data")

# Method 1: Base R 
best <- function(state, outcome) {
    # Read outcome data
    out_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        # Because we originally read the data in as character (by specifying 
        # colClasses = "character" we need to coerce the column to be numeric. 
        # You may get a warning about NAs being introduced but that is okay.
    out_data[, 11] <- as.numeric(out_data[, 11]) 
    # Shorten variables names for look-up
    colnames(out_data)[11] <- "heart_attack"
    colnames(out_data)[17] <- "heart_failure"
    colnames(out_data)[23] <- "pneumonia"
    # Check that state and outcome are valid
    if(!state %in% unique(out_data$State)) stop("invalid state")
    if(!outcome %in% c("heart attack", "heart failure", "pneumonia")) stop("invalid outcome")
    outcome <- gsub(" ", "_", outcome)
    # Return hospital name in that state with lowest 30-day deth rate
    sub_out_data <- subset(out_data, out_data$State==state)
    
    # I thought about using dplyr to solve the problem but could not figure out how to directly pass 
    # the input, outcome, which is character, to the min() function in arrange() or summarise()
    # Will come back to this maybe. best() still works when uncomment the following code: 
    # require(dplyr)
    # sub_out_data <- out_data %>%
    #     filter(State==state) %>%
    #     select(Hospital.Name, outcome)
    
    idx <- which.min(as.numeric(sub_out_data[,outcome]))
    return(sub_out_data$Hospital.Name[idx]) 
}

# Testing
options(warn=-1)
options(error=dump.frames)

best("TX", "heart attack")
# "CYPRESS FAIRBANKS MEDICAL CENTER"
best("TX", "heart failure")
# [1] "FORT DUNCAN MEDICAL CENTER"
best("MD", "heart attack")
# [1] "JOHNS HOPKINS HOSPITAL, THE"
best("MD", "pneumonia")
# [1] "GREATER BALTIMORE MEDICAL CENTER"
best("BB", "heart attack")
# Error in best("BB", "heart attack") : invalid state
best("NY", "hert attack")
# Error in best("NY", "hert attack") : invalid outcome


# Method 2: data.table, which is way faster than Method 1
best <- function(state, outcome) {
    # Read outcome data
    require(data.table)
    out_data <- fread("outcome-of-care-measures.csv")
    # Shorten variables names for look-up
    setnames(out_data, c(2, 11, 17, 23), c("hospital_name", "heart_attack", "heart_failure", "pneumonia")) 
    # Check that state and outcome are valid
    if(!state %in% unique(out_data$State)) stop("invalid state")
    if(!outcome %in% c("heart attack", "heart failure", "pneumonia")) stop("invalid outcome")
    outcome <- gsub(" ", "_", outcome)
    # Return hospital name in that state with lowest 30-day deth rate
        # Filter State and select hospital_name and outcome
    sub_out_data <- out_data[State==state, .SD, .SDcol=c("hospital_name", outcome)]
        # transform outcome form character to numeric
    sub_out_data[,outcome] <- sub_out_data[, as.numeric(get(outcome))]
        # remove NAs
    sub_out_data <- sub_out_data[complete.cases(sub_out_data),]
        # arrange rows for final selection
    sub_out_data <- sub_out_data[order(get(outcome), `hospital_name`)]
    return(sub_out_data[1,1])
}

# Testing
options(warn=-1)
options(error=dump.frames)

best("TX", "heart attack")
# "CYPRESS FAIRBANKS MEDICAL CENTER"
best("TX", "heart failure")
# [1] "FORT DUNCAN MEDICAL CENTER"
best("MD", "heart attack")
# [1] "JOHNS HOPKINS HOSPITAL, THE"
best("MD", "pneumonia")
# [1] "GREATER BALTIMORE MEDICAL CENTER"
best("BB", "heart attack")
# Error in best("BB", "heart attack") : invalid state
best("NY", "hert attack")
# Error in best("NY", "hert attack") : invalid outcome

