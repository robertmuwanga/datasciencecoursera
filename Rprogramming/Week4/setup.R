# This is code aimed at answering Programming Assignment 3 as      #
# part of Week 4 R programming course by John Hopkins University.  #
# Credit to Roger D. Peng (Github: rdpeng) for the assignment.     #
#                                                                  #
# Author: Robert Muwanga                                           #
# Original Creation Date: 21 August 2019                           #
#                                                                  #
# Filename: setup.R                                                #
# Description: Sets up preliminary datasets for analysis used in   #
# other scripts.                                                   #
#                                                                  #
####################################################################

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
hospital_data <- read.csv('hospital-data.csv', stringsAsFactors = F)

# Resets the working directory to the parent directory
setwd(parentDir)