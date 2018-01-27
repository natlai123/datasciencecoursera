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
rankall <- function(outcome, num = "best"){
    # Read outcome data
        out_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
        out_data[, 11] <- as.numeric(out_data[, 11]) 
    # Shorten variables names for look-up
        colnames(out_data)[2]  <- "hospital"
        colnames(out_data)[7]  <- "state"
        colnames(out_data)[11] <- "heart_attack"
        colnames(out_data)[17] <- "heart_failure"
        colnames(out_data)[23] <- "pneumonia"
    # Check that state and outcome are valid
        if(!outcome %in% c("heart attack", "heart failure", "pneumonia")) stop("invalid outcome")
        if(class(num)=="character" && !num %in%  c("best", "worst")) stop("invalid num")
        else if (class(num) != "numeric" && num <= 0) stop("invalid num")
    # Select required columns and remove NA
        outcome <- gsub(" ", "_", outcome) # For look-up 
        out_data <- out_data[c(2, 7, 11, 17, 23)][complete.cases(out_data[,outcome]),]
    # Arrange by state, outcome, hospital_name 
    out_data<- out_data[order(out_data$state, out_data[, outcome], out_data$hospital),][, c(1,2)]
    
    # Helper function to find the hospital of the given rank for each state
    select_out_df <- function(sort_df, num=num) {
        if (num == "best") {
            num <- 1
        } else if ( num == "worst") {
            num <- nrow(sort_df)
        } else {
            num
        }
        return(sort_df[num,])
    }
    
    # Split-Apply-Combine 
        out_matrix <- t(sapply(split(out_data, out_data$state),select_out_df,num))
        rname <- as.character(row.names(out_matrix))
        out_matrix[,2] <- rname
        row.names(out_matrix) <-NULL
    # Return a data frame with the hospital names and the (abbreviated) state name
    return(as.data.frame(out_matrix))
}

# Testing

head(rankall("heart attack", 20), 10)
tail(rankall("pneumonia", "worst"), 3)
tail(rankall("heart failure"), 10)



