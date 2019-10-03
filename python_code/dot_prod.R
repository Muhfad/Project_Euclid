
dot_prod_dist <- function(A, B){
  # function for computing euclidean distances using dot-product
  # Arguements : A and B are vectors of the same length 
  # Outputs: The Euclidean distance between A and B
  
  
  # checking if the vectors are in the same dimension
  if(length(A) != length(B)) stop('Invalid input(s)')
  
  u <- np.asarray(A - B)
  return(sqrt(sum(u*u)))
}
