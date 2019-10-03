
# require(mefa)
#ifelse(require('Rcpp'), library(Rcpp), install.packages('Rcpp'))

#setwd('~/Desktop/WD/2019/Abdul/Project_Euclid')

# (1) Dot Product 
dot_prod_dist <- function(A, B){
  # function for computing euclidean distances using dot-product
  # Arguements : A and B are vectors of the same length 
  # Outputs: The Euclidean distance between A and B
  # checking if the vectors are in the same dimension
  #if(length(A) != length(B)) stop('Invalid input(s)')
  
  u <- A - B
  return(sqrt(sum(u*u)))
}

#(2) using vectorization in R
e_dist <- function(A, B){
  # calculating the distance between vectors A and B
  #if(length(A) != length(B)) stop('Invalid Input(s)')
  
  return( sqrt(sum((A - B)^2)) )
  
}


# This function uses one of the above method to calculate distance between rows
euc_func <- function(dist_func, M){
  # takes a distance calculating function as a string (for two points)
  # function dist_func and a matrix M 
  # returns the distance between rows of matrix M
  f <- match.fun(dist_func) # as a function
  n <- nrow(M)
  l <- n*(n-1)/2
  last_element <- f(M[n,], M[n-1, ])
  distance <- numeric(l)
  distance[l] <- last_element
  k <- 1 # for indexing the distance vector
  for(i in 1:(n-1)){
    A = M[i, ]
    for(j in (i + 1):n){
      #print(j)
      B <- M[j, ]
      distance[k] <- f(A, B)
      k <- k + 1
      
    }
    
  }
  # return( vec2dist(distance, n)  ) # vect2dist formats the output
  return(distance)
  
}

dotprod <- function(M) euc_func("dot_prod_dist", M)
eucdist_R <- function(M) euc_func("e_dist", M)

# compiling the C++ function eucdist.cpp

system("R CMD SHLIB C_C++/eucdist.c")

# loading it into R

dyn.load("C_C++/eucdist.so")

# the R wrapper

eucdist_C <- function(M){
    nrows = as.integer(nrow(M))
    # M is a matrix
    out <- .C("eucdist",
        x = as.vector(t(M), "double"),
        m = nrows,
        n = as.integer(ncol(M)),
        d = as.double(vector("double", nrow(M)*(nrow(M)-1)/2))
    ) 
    # return(vec2dist(as.vector(out$d), nrows))
    return(out$d)
}

# testmat <- matrix(rnorm(10, 10, 10), ncol=2)
Rcpp::sourceCpp('C_C++/fastdist2.cpp')

# fastdist2_R <- function(M) return(vec2dist(fastdist2(M), nrow(M)))