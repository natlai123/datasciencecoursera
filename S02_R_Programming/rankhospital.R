# S2_R_Programming 
# Programming Assignment 
# Week 4 

# Ranking hospitals by outcome in a state

# rankhospital() takes three arguments: the 2-character abbreviated name of a state (state), an outcome 
# (outcome), and the ranking of a hospital in that state for that outcome (num). The function reads the 
# outcome-of-care-measures.csv file and returns a character vector with the name of the hospital that 
# has the ranking specied by the num argument

setwd("/Users/nathaniellai/Desktop/datasciencecoursera/S02_R_Programming/R_C2_data")

# Method 1: Base R 
rankhospital <- function(state, outcome, num = "best") {
    ## Read outcome data
        out_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        out_data[, 11] <- as.numeric(out_data[, 11]) 
    # Shorten variables names for look-up
        colnames(out_data)[11] <- "heart_attack"
        colnames(out_data)[17] <- "heart_failure"
        colnames(out_data)[23] <- "pneumonia"
    # Check that num, state and outcome are valid
        if(!state %in% unique(out_data$State)) stop("invalid state")
        if(!outcome %in% c("heart attack", "heart failure", "pneumonia")) stop("invalid outcome")
        outcome <- gsub(" ", "_", outcome) # For look-up 
        if(class(num)=="character" && !num %in%  c("best", "worst")) stop("invalid num")
        else if (class(num) != "numeric" && num <= 0) stop("invalid num")
    ## Return hospital name in that state with the given rank
    # filter State to be the input, state
        sub_out_data <- subset(out_data, out_data$State==state)
    # select hospital_name and outcome, remove NA 
        sub_out_data <-as.data.frame(list(sub_out_data[,2], sub_out_data[, outcome]), 
            col.names = c('hospital_name', outcome), stringsAsFactors = FALSE)[complete.cases(sub_out_data),]
    # arrange by outcome and then by hospital_name
        # Note that class(sub_out_data[,outcome]) is "character". Need to convert outcome to type numeric
        sub_out_data[,outcome] = as.numeric(as.character(sub_out_data[,outcome]))
        sub_out_data <- sub_out_data[order(sub_out_data[,outcome], sub_out_data$hospital_name),]
    # converting num
     if(num == "best") {
        num <- 1
    } else if ( num == "worst"){
        num <- nrow(sub_out_data)
    } else if (num > nrow(sub_out_data)){
        return(NA)
    }    
    ## 30-day death rate
    return(sub_out_data[num,1]) 
}

# Testing
options(warn=-1)
options(error=dump.frames)

rankhospital("TX", "heart failure", 4)
# [1] "DETAR HOSPITAL NAVARRO"
rankhospital("MD", "heart attack", "worst")
# [1] "HARFORD MEMORIAL HOSPITAL"
rankhospital("MN", "heart attack", 5000)
# [1] NA


# Method 2: data.table, which is way faster than Method 1
<<<<<<< HEAD
rankhospital <- function(state, outcome, num = "best") {
=======
best <- function(state, outcome) {
>>>>>>> 282c306b97720c1aaff5a4926d54dd4be8677602
    # Read outcome data
        require(data.table)
        out_data <- fread("outcome-of-care-measures.csv")
    # Shorten variables names for look-up
        setnames(out_data, c(2, 11, 17, 23), c("hospital_name", "heart_attack", "heart_failure", "pneumonia")) 
    # Check that num, state and outcome are valid
        if(!state %in% unique(out_data$State)) stop("invalid state")
        if(!outcome %in% c("heart attack", "heart failure", "pneumonia")) stop("invalid outcome")
        outcome <- gsub(" ", "_", outcome) # For look-up
        if(class(num)=="character" && !num %in%  c("best", "worst")) stop("invalid num")
        else if (class(num) != "numeric" && num <= 0) stop("invalid num")
    # Return hospital name in that state with lowest 30-day deth rate
    # Filter State and select hospital_name and outcome
        sub_out_data <- out_data[State==state, .SD, .SDcol=c("hospital_name", outcome)]
    # transform outcome form character to numeric
        sub_out_data[,outcome] <- sub_out_data[, as.numeric(get(outcome))]
    # remove NAs
        sub_out_data <- sub_out_data[complete.cases(sub_out_data),]
    # converting num
    if(num == "best") {
        num <- 1
    } else if ( num == "worst"){
        num <- nrow(sub_out_data)
    } else if (num > nrow(sub_out_data)){
        return(NA)
    }
    # arrange rows for final selection
        sub_out_data <- sub_out_data[order(get(outcome), `hospital_name`)]
    return(sub_out_data[num,1])
}

# Testing
options(warn=-1)
options(error=dump.frames)

rankhospital("TX", "heart failure", 4)
# [1] "DETAR HOSPITAL NAVARRO"
rankhospital("MD", "heart attack", "worst")
# [1] "HARFORD MEMORIAL HOSPITAL"
rankhospital("MN", "heart attack", 5000)
# [1] NA
