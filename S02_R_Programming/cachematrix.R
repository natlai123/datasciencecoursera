# S2_R_Programming 
# Programming Assignment 
# Week 3 

# Read https://github.com/lgreski/datasciencectacontent/blob/master/markdown/rprog-breakingDownMakeVector.md first !!!

# Matrix inversion is usually a costly computation and there may be some benefit
# to caching the inverse of a matrix rather than compute it repeatedly. This 
# exercise consists of a pair of functions that cache the inverse of a matrix.

# makeCacheMatrix() builds four functions and returns them within a list in the 
# makeCacheMatrix() environment (recall also that each function has its own 
# environment). It also contains two data objects (x and m). Specifically, it
# 1. set the value of the matrix
# 2. get the value of the matrix
# 3. set the value of inverse of the matrix
# 4. get the value of inverse of the matrix

makeCacheMatrix <- function(x = matrix()){
    # x is set with a default value to generate NaN instead of an error message
# 0. initialize objects. Without this step, an error occurs.   
    inv <- NULL
# 1. set the value of the matrix
    set <- function(matrix){
        x <<- matrix
        inv <<- NULL
    }
    # set()
    # Assigns the input argument to the x object in the parent environment, and
    # Assigns the value of NULL to the inv object in the parent environment.
    # This line of code clears any value of inv that had been cached by a prior 
    # execution of cacheSolve().    
# 2. get the value of the matrix    
    get <- function() x 
    # Since the symbol x is not defined within get(), R retrieves it from the 
    # parent environment of makeCacheMatrix().    
# 3. set the value of inverse of the matrix    
    setinverse <- function(inv_matrix) inv <<- inv_matrix
# 4. get the value of inverse of the matrix    
    getinverse  <- function() inv
    # R takes advantage of lexical scoping to find the correct symbol inv in the 
    # parent environment to retrieve its value.
# 5. return a list of methods    
    list(set=set, 
         get=get, 
         setinverse=setinverse, 
         getinverse=getinverse)
}    
    
# cacheSolve() requires an argument that is returned by makeCacheMatrix to retrieve 
# the inverse from the cached value that is stored in the makeCacheMatrix()'s environment.
# 1. checks to see if the inverse has already been calculated. 
# 2. if so, gets the inverse from makeCachMatrix and skips the computation. 
# 3. otherwise, calculates the inverse and sets the value of the inverse in the cache. 

cacheSolve <- function(x, ...) {
    inv <- x$getinverse()
# 1. checks to see if the inverse has already been calculated. 
# 2. if so, gets the inverse from makeCachMatrix and skips the computation.
    if(!is.null(inv)) {
        message("getting cached data")
        return(inv)
    }
# 3. otherwise, get the matrix
    matrix <- x$get()
# calculates the inverse
    inv <- solve(matrix, ...)
# sets the value of the inverse in the cache    
    x$setinverse(inv)
# return the value of the inverse to the parent environment    
    inv
}


# Examples using the two functions
m <- makeCacheMatrix(rbind(c(1, -1/2), c(-1/2, 1))) 
cacheSolve(m)
cacheSolve(m)

# Sidenotes 

# A cache is a way to store objects in memory to accelerate later access to that object. 

# solve() is used to calculate the inverse of an invertible matrix.

# Referring to sub-functions, "getters" are program modules that retrieve data within an object.
# "setters" are program modules that set (mutate) the data values within an object.

# The <<- operator is used to assigns the value on the right side of the operator to an object 
# in the parent environment named by the object on the left side of the operator.

# cacheSolve() requires an input argument of type makeCacheMatrix(). 
# If one passes a matrix to the function, as in
#   aResult <- cacheSolve(rbind(c(1, -1/4), c(-1/4, 1))) 
# the function call will fail with an error explaining that cacheSolve() 
# was unable to access $getmatrix() on the input argument because $ does 
# not work with atomic vectors. This is accurate, because a primitive 
# vector is not a list, nor does it contain a $getmatrix() function.

# To use set(),
# m <- makeCacheMatrix(rbind(c(1, -1/2), c(-1/2, 1))) 
# cacheSolve(m)
# cacheSolve(m)
# m$set(rbind(c(4, 2), c(7, 6)))
# cacheSolve(m)
# cacheSolve(m)
