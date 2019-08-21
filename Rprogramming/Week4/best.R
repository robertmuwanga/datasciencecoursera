# This is code aimed at answering Programming Assignment 3 as      #
# part of Week 4 R programming course by John Hopkins University.  #
# Credit to Roger D. Peng (Github: rdpeng) for the assignment.     #
#                                                                  #
# Author: Robert Muwanga                                           #
# Original Creation Date: 21 August 2019                           #
#                                                                  #
# Filename: best.R                                                 #
# Description: Finds the hospital with the best (i.e. lowest)      #
# 30-day mortality rate for a specified outcome in a given state.  #
#                                                                  #
# Dependency scripts: setup.R                                      #
####################################################################

# Load setup.R file to get datasets
source('setup.R')

# Define defaults
outcomes_of_interest <- list(
    "heart attack" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",                       
    "heart failure" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
    "pneumonia" = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
)

states <- unique(outcome_of_care$State)

best <- function(state, outcome) {
    if(!(state %in% states))
        stop('invalid state')
    
    if(!(outcome %in% attr(x = outcomes_of_interest, which = 'names')))
        stop('invalid outcome')
    
    interested_outcome <- outcomes_of_interest[[outcome]]
    indexes <- which(names(outcome_of_care) %in% c('Hospital.Name', 'State', interested_outcome))
    
    # Select columns of interest, filter to only state, and set interested_outcome as numeric
    best_outcome <- outcome_of_care[outcome_of_care$State == state, indexes]
    suppressWarnings( # Suppressing warnings on NA conversions.
        best_outcome[, interested_outcome] <- as.numeric(best_outcome[, interested_outcome]))
    
    # Find state with minimum outcome
    sort( # Sort results in ascending order and select the first to manage situation of a tie.
        best_outcome$Hospital.Name[which.min(best_outcome[, interested_outcome])])[1]
}

