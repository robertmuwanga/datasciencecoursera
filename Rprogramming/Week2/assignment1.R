library(tidyverse)

url <- 'https://d396qusza40orc.cloudfront.net/rprog%2Fdata%2Fspecdata.zip'
fn <- 'rprog_data_specdata.zip'

if(!file.exists(filename)) 
   download.file(url = url, destfile = 'rprog_data_specdata.zip')

if(!dir.exists('specdata'))
  unzip('rprog_data_specdata.zip')

getFiles <- function(directory, id = 1:332) {
  data <- lapply(
    list.files(directory)[id], function(x) { 
      read_csv(file.path('specdata', x)) %>% 
        mutate('filename' = x) }) %>% 
    bind_rows() 
  
# Consider removing filename as:
# > all(data$filename %>% str_remove(pattern = '.csv') %>% as.integer() == data$ID) //ALL IS TRUE
# You can consider making mention of this as a quick verification in your Rmarkdown file.

}

pollutantmean <- function(directory, pollutant, id = 1:332) {
  data <- getFiles(directory, id)
  
  colMeans(data[, pollutant], na.rm = T)
}

complete <- function(directory, id = 1:332) {
  data <- getFiles(directory, id)
  
  unique(data$filename) %>% 
    lapply(
      function(x) 
        filter(data, filename == x) %>% 
        summarize('id' = as.integer(str_remove(x, pattern = '.csv')), 
                  'nobs' = complete.cases(.) %>% sum)
    ) %>% bind_rows
}

corr <- function(directory, threshold = 0) {
  complete_cases <- complete(directory) %>% 
    filter(nobs >= threshold)
  
  data <- getFiles(directory, complete_cases$id)
  
  data[complete.cases(data), ] %>%
    group_by(filename) %>%
    summarize('corr' = cor(x = sulfate, y = nitrate))
}

