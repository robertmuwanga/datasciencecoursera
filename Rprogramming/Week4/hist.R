# This is code aimed at answering Programming Assignment 3 as      #
# part of Week 4 R programming course by John Hopkins University.  #
# Credit to Roger D. Peng (Github: rdpeng) for the assignment.     #
#                                                                  #
# Author: Robert Muwanga                                           #
# Original Creation Date: 21 August 2019                           #
#                                                                  #
# Filename: hist.R                                                 #
# Description: Draws the 30-day mortality rates for heart attacks  #
# as a histogram.                                                  #
#                                                                  #
####################################################################

# Load setup.R file to get datasets
source('setup.R')
hist(
    as.numeric(outcome_of_care[, 11])
)
