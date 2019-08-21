# This is code aimed at answering Programming Assignment 3 as      #
# part of Week 4 R programming course by John Hopkins University.  #
# Credit to Roger D. Peng (Github: rdpeng) for the assignment.     #
#                                                                  #
# Author: Robert Muwanga                                           #
# Original Creation Date: 21 August 2019                           #
#                                                                  #
# Filename: rankall                                                #
# Description: Returns the hospitals in all states by a given rank #
# and mortality outcome.                                           #
#                                                                  #
# Dependency scripts: setup.R                                      #
####################################################################

# Function to load setup data

setup <- function(x) {
    
    # Set global defaults
    parentDir <- getwd()
    downloadDir <- 'data'
    downloadURL <- 'https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2FProgAssignment3-data.zip'
    filename <- 'rprog_data_ProgAssignment3-data.zip'
    destURI <- file.path(downloadDir, filename)
    
    # Download and unzip files
    
    if(!dir.exists(downloadDir)) {
        dir.create(downloadDir)
        download.file(downloadURL, destURI)
    }
    
    # Change working directory to downloaded file.
    setwd(downloadDir)
    unzip(filename, overwrite = TRUE)
    
    outcome_of_care <- read.csv('outcome-of-care-measures.csv', colClasses = 'character')
    # hospital_data <<- read.csv('hospital-data.csv', stringsAsFactors = F)
    
    # Resets the working directory to the parent directory
    setwd(parentDir)
    
    # Return loaded dataset
    outcome_of_care
}

# Define defaults
outcomes_of_interest <- list(
    "heart attack" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",                       
    "heart failure" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
    "pneumonia" = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
)

rankall <- function(outcome, num = 'best') {
    
    # Read outcome data
    outcome_of_care <- setup()
    
    # Define the unique states
    states <- unique(outcome_of_care$State)
    
    # Check that outcome is valid
    if(!(outcome %in% attr(x = outcomes_of_interest, which = 'names')))
        stop('invalid outcome')
    
    # Get the column name of the interested mortality outcome, and the indexes of columns of interest
    interested_outcome <- outcomes_of_interest[[outcome]]
    indexes <- which(names(outcome_of_care) %in% c('Hospital.Name', 'State', interested_outcome))
    
    # Select columns of interest and set interested_outcome as numeric
    best_outcome <- outcome_of_care[, indexes]
    suppressWarnings( # Suppressing warnings on NA conversions.
        best_outcome[, interested_outcome] <- as.numeric(best_outcome[, interested_outcome]))
    
    # Align column names to final output expectation (i.e. Hospital.Name == hospital and State == state)
    names(best_outcome) <- c('hospital', 'state', 'mortality_rate')
    
    # For each state, find all the hospitals of a given rank
    hospital_df <- do.call(rbind, lapply(states, function(state) { 
        
        # Filter out hospitals by state, sort hospitals and take only hospital and state columns
        best_state_outcome <- best_outcome[best_outcome$state == state, ]
        best_state_outcome <- 
            best_state_outcome[
                order(best_state_outcome$mortality_rate, best_state_outcome$hospital), ]
        
        # Check for 'best' or 'worst' and assign accordingly.
        if(num == 'best') num <- 1
        else if(num == 'worst') num <- nrow(best_outcome)
        else num <- as.integer(num)
        
        # Return hospital by rank. If there is no hospital in state, return with NA mortality_rate
        if(nrow(best_state_outcome) < num){
            best_state_outcome <- data.frame('hospital' = NA, 'state' = state, 'mortality_rate' = NA)
        }
        else {
            best_state_outcome <- best_state_outcome[num, ]
        }
        
        # Return final outcome
        best_state_outcome
    }))
    
    # Set row names to states and return the hospital listing with only the hospital and state columns
    rownames(hospital_df) <- hospital_df$state
    hospital_df[order(hospital_df$state), 1:2]
}
