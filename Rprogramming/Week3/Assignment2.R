# This is code aimed at answering Assignment 2: Lexical Scoping as #
# part of Week 3 R programming course by John Hopkins University.  #
# Credit to Roger D. Peng (Github: rdpeng) for the assignment.     #
#                                                                  #
# Author: Robert Muwanga                                           #
# Original Creation Date: 18 August 2019                           #
####################################################################


## makeCacheMatrix : Makes a special object that caches a matrix 
# object and has functions to create and cache its inverse.

makeCacheMatrix <- function(x = matrix()) {
  inverse <- NULL
  
  set <- function(y = matrix()) {
    x <<- y
    inverse <<- NULL
  }
  
  get <- function() x
  
  setinverse <- function(iv) 
    inverse <<- iv
 
   getinverse <- function() inverse
  
  list(set = set, get = get,
       setinverse = setinverse,
       getinverse = getinverse)
}


## cacheSolve : Invokes functions held an object crated by the 
# makeCacheMatrix to create the inverse or pull the inverse from 
# cache.

cacheSolve <- function(x, ...) {
  ## Return a matrix that is the inverse of 'x'
  
  i <- x$getinverse()
  
  if(!is.null(i)) {
    message("getting cached data")
    return(i)
  }
  
  data <- x$get()
  inverse <- solve(data, ...)
  x$setinverse(inverse)
  
  inverse
}