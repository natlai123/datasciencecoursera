# S2_R_Programming 
# Programming Assignment 
# Week 4 

# Ranking hospitals in all states

# rankall takes two arguments: an outcome name (outcome) and a hospital ranking (num). The function reads the 
# outcome-of-care-measures.csv file and returns a 2-column data frame containing the hospital in each state that 
# has the ranking specified in num. For example the function call rankall("heart attack", "best") would return a 
# data frame containing the names of the hospitals that are the best in their respective states for 30-day heart 
# attack death rates. The function should return a value for every state (some may be NA). The first column in the 
# data frame is named hospital, which contains the hospital name, and the second column is named state, which 
# contains the 2-character abbreviation for the state name. Hospitals that do not have data on a particular 
# outcome should be excluded from the set of hospitals when deciding the rankings.

setwd("/Users/nathaniellai/Desktop/datasciencecoursera/S02_R_Programming/R_C2_data")

# Method 1: Base R (Split-Apply-Combine)
rankallb <- function(outcome, num = "best"){
    # Read outcome data
        out_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        out_data[, 11] <- as.numeric(out_data[, 11]) 
        out_data[, 17] <- as.numeric(out_data[, 17]) 
        out_data[, 23] <- as.numeric(out_data[, 23]) 
    # Shorten variables names for look-up
        colnames(out_data)[2]  <- "hospital"
        colnames(out_data)[7]  <- "state"
        colnames(out_data)[11] <- "heart_attack"
        colnames(out_data)[17] <- "heart_failure"
        colnames(out_data)[23] <- "pneumonia"
    # Check that state and outcome are valid
        # if(!outcome %in% c("heart attack", "heart failure", "pneumonia")) stop("invalid outcome")
        # if(class(num)=="character" && !num %in%  c("best", "worst")) stop("invalid num")
        # else if (class(num) != "numeric" && num <= 0) stop("invalid num")
    # Select required columns and remove NA
        outcome <- gsub(" ", "_", outcome) # For look-up 
        out_data <- out_data[,c(2, 7, 11, 17, 23)][complete.cases(out_data[,outcome]),]
    # Arrange by state, outcome, hospital
        
    out_data<- out_data[order(out_data$state, out_data[,outcome], out_data$hospital),][, c(1,2)]
    
    # Helper function to find the hospital of the given rank for each state
    select_out_df <- function(sort_df, num=num) {
        if (num == "best") {
            num <- 1
        } else if ( num == "worst") {
            num <- nrow(sort_df)
        } else {
            num
        }
    # If num > nrow(sort_df), NAs are returned under the colnames of hospital and state
        return(sort_df[num,])
    }
    
    # Split-Apply-Combine 
        # state names are preserved thanks to split() 
        out_matrix <- t(vapply(split(out_data, out_data$state), select_out_df, num, 
                FUN.VALUE = list(2,unique(out_data$state))))
        rname <- as.character(row.names(out_matrix))
        out_matrix[,2] <- rname
        row.names(out_matrix) <-NULL
    # Return a data frame with the hospital names and the (abbreviated) state name
    return(as.data.frame(out_matrix))
}

# Testing
options(warn=-1)
options(message=-1)

head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)


# Method 2: data.table, which is way faster than Method 1
rankalld <- function(outcome, num = "best"){
    # Read outcome data
        require(data.table)
        out_data <- fread("outcome-of-care-measures.csv")
    # Shorten variables names for look-up
        setnames(out_data, c(2, 7, 11, 17, 23), 
            c("hospital", "state", "heart_attack", "heart_failure", "pneumonia")) 
    # Check that num, state and outcome are valid
        if(!outcome %in% c("heart attack", "heart failure", "pneumonia")) stop("invalid outcome")
        if(class(num)=="character" && !num %in%  c("best", "worst")) stop("invalid num")
        else if (class(num) != "numeric" && num <= 0) stop("invalid num")
        outcome <- gsub(" ", "_", outcome) # For look-up
    # Select num, state and outcome, remove NA, arrange by state, outcome, hospital      
        out_data <- out_data[, .SD, .SDcol=c("hospital", "state", outcome)]
        out_data[,outcome] <- out_data[, as.numeric(get(outcome))]
        out_data <- out_data[order(state, get(outcome), hospital, na.last = NA), 1:3]
    # Flow Control to return a data frame with the hospital names and the (abbreviated) state name
        if (num == "best"){
            out_data <- out_data[, .(hospital = head(hospital, 1)), by = state]
            return(setcolorder(out_data, rev(names(out_data))))
        }
        else if (num == "worst"){
            out_data <- out_data[, .(hospital = tail(hospital, 1)), by = state]
            return(setcolorder(out_data, rev(names(out_data))))
        }
        else {
            ref<-vapply(split(out_data, out_data$state), nrow, integer(1))
            out_data <- out_data[ , tail(head(.SD, num), 1)
                , by = state, .SDcols = c("hospital")]}
        # If num is larger than the number of hospitals in that state, return NA.
            idx <- num > ref
            out_data$hospital[idx] <- NA 
        return(setcolorder(out_data, rev(names(out_data))))
} 

# Testing
options(warn=-1)
options(message=-1)

head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)


