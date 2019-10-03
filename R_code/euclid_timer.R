 source("R_code/functions.R")


set.seed(1)
require('rbenchmark')
sink("small_inputs.txt", append = TRUE)
# the test is done with a 2 coloumn matrix( vectors in 2 dim  ensions )
nrows = c(5, 10, 25, 50, 75, 100, 200, 250, 500) 
# nrows = c(10000)

funcs <- c("dist", "dotprod", "eucdist_C", "eucdist_R", "fastdist2")
l <- length(funcs)
Srelative_times <- data.frame(row.names = funcs)
col_index = 1 # for indexing the columns of the relative time dataframe
cat("This records the average times for 25 executions of each function\n")
for(i in nrows){
    cat(i, "by", 2, "\n")
    M <- matrix(rnorm(i*2, 10, 10), ncol = 2)
    #print(M)
    timer <- benchmark(
                dotprod(M),
                eucdist_R(M),
                dist(M),
                fastdist2(M),
                eucdist_C(M),
                columns = c("test", "elapsed"),
                replications = 25
        )
    
    t_base = timer$elapsed[1] # time for dist(M), the base R function
    
    Srelative_now <- numeric(l) # vector to contain the relative time for each iteration
    for(rows in 1:l){
        relative_now[rows] <- round(t_base/timer$elapsed[rows], 4)     
    }
    Srelative_times[col_index] <- relative_now
    col_index <- col_index + 1
    timer$relative <- relative_now 
    print(timer)
    cat("\n", paste(rep("*", 100), collapse = ""), "\n")
}
names(Srelative_times) <- nrows
saveRDS(Srelative_times, file = "Srelative_times.rds")
sink()



sink("large_inputs.txt", append = TRUE)
# the test is done with a 2 coloumn matrix( vectors in 2 dim  ensions )
# nrows = c(1000, 2500, 3000, 5000, 10000)

# nrows = c(2500, 3000, 5000, 4000)

nrows = c(750, 4000)


funcs <- c("dist", "dotprod", "eucdist_C", "eucdist_R", "fastdist2")
l <- length(funcs)
Lrelative_times <- data.frame(row.names = funcs)
col_index = 1 # for indexing the columns of the relative time dataframe
# cat("This records the average times for 10 executions of each function\n")
for(i in nrows){
    cat(i, "by", 2, "\n")
    M <- matrix(rnorm(i*2, 10, 10), ncol = 2)
    #print(M)
    timer <- benchmark(
                dotprod(M),
                eucdist_R(M),
                dist(M),
                fastdist2(M),
                eucdist_C(M),
                columns = c("test", "elapsed"),
                replications = 10
            )
    
    t_base = timer$elapsed[1] # time for dist(M), the base R function
    
    relative_now <- numeric(l) # vector to contain the relative time for each iteration
    for(rows in 1:l){
        relative_now[rows] <- round(t_base/timer$elapsed[rows], 4)     
    }
    Lrelative_times[col_index] <- relative_now
    col_index <- col_index + 1
    timer$relative <- relative_now 
    print(timer)
    cat("\n", paste(rep("*", 100), collapse = ""), "\n")
}
names(Lrelative_times) <- nrows
saveRDS(Lrelative_times, file = "Lrelative_times.rds")
sink()


