library(tidyverse)
unzip('rprog_data_specdata.zip')

getFiles <- function(directory, id = 1:332) {
  data <- lapply(
    list.files(directory)[id], function(x) { 
      read_csv(file.path('specdata', x)) %>% 
        mutate('filename' = x) }) %>% 
    bind_rows() 
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
