require(rbenchmark); require(ggplot2); require(ggrepel); require(data.table)

# contain the code for the function
source("R_code/functions.R")


set.seed(1)
m = 10; n = 2; g = 3;
M <- matrix(rnorm(m*n, 10, 10), ncol = n)


# group_vec <- sample(1:g, m, replace = TRUE)


eucdist <- function(M, group_vec=NULL, format_output=FALSE, FUN = "eucdist_C"){
    f = match.fun(FUN)
    ifelse(is.null(group_vec), ifelse(format_output, return(mefa::vec2dist(f(M), nrow(M))), return(f(M))), "")
    
    unique_groups <- sort(unique(group_vec)) # all unique groups
    for_one_group <- function(group_used){
        row_index <- group_vec==group_used
        if(sum(row_index) <=1) return(NULL)
        # print(row_index)
        # if(length(row_index)==1) return()
        output = f(M[row_index, ])
        if(format_output) return(mefa::vec2dist(output, sum(row_index)))
        
        return(output)
    }
    names(unique_groups) <- unique_groups
    sapply(unique_groups, for_one_group, simplify = "array")
    

}




# Using data.table

eucdist_DT <- function(M, group_vec, func="eucdist_C"){
    f = match.fun(func)
    M <- data.table(M, group_vec)
    output <- M[, f(.SD), by=group_vec][order(group_vec)]
    return(output)

}



# Using C with looping in C
system("R CMD SHLIB Group/eucdist_group.c")


# loading it into R
dyn.load("Group/eucdist_group.so")

eucdist_group_C <- function(M, group_vec, format_output = FALSE) {
    unique_group = sort(unique(group_vec))
    tt = as.integer(table(group_vec))
    tot_length = vapply(tt, function(n) n*(n-1)/2, 0)
    l = length(unique_group)
    ifelse(is.integer(group_vec), group_vec_int <- group_vec, group_vec_int <- as.numeric(as.factor(group_vec)))
    nn <- 1:l
    out <-.C("eucdist_group",
        x = as.vector(t(M), "double"),
        m = as.integer(nrow(M)),
        n = as.integer(ncol(M)),
        d = vector("double", sum(tot_length)),
        unique_group = as.integer(nn),
        l = as.integer(l),
        group_vec = as.integer(group_vec_int),
        lg = tt
    )
    output = split( out$d, rep(unique_group, tot_length) )
    Nm <- names(output)
    if(format_output){

         f = function(i){
                j <- which(Nm == i)
                k <- which(unique_group == i)
                mefa::vec2dist(output[[j]], tt[k])
            } 
        return(sapply(Nm, f, simplify = "array"))

    }
    return(output)
    # FORMAT THE OUTPUT IF NEEDED
}

group_vec <- sample(c("one", "seven", "ten"), 10, T)
# TIMINGS GROUPED

# m = 50000; n = 2; ng=50
set.seed(1)
require('rbenchmark')
if(file.exists("group_times.txt")) system("rm group_times.txt")
sink("group_times.txt", append = TRUE)

nrows = sort(c(500, 1000, 2000, 3000, 5000, 7000, 10000, 15000, 20000, 25000, 30000, 40000))

# nrows = sort(c(40000, 50000))


funcs <- c("dist", "dotprod", "eucdist_C", "eucdist_R", "fastdist2", "eucdist_DT", "eucdist_c_loop")
time_base <- numeric(length(funcs)); j = 1
# l <- length(funcs)
Grelative_times <- data.frame(row.names = sort(funcs))
col_index = 1 # for indexing the columns of the relative time dataframe
cat("This records the average times for 25 executions of each function\n")
for(i in nrows){
    cat(i, "by", 2, "\n")
    M <- matrix(rnorm(i*2, 2, 10), ncol = 2)
    group_vec <- sample(1:50, i, T)
    #print(M)
    timer <- benchmark(
                dotprod = eucdist(M, group_vec, FUN = "dotprod"),
                eucdist_R = eucdist(M, group_vec, FUN = "eucdist_R"),
                dist = eucdist(M, group_vec, FUN = "dist"),
                fastdist2 = eucdist(M, group_vec, FUN = "fastdist2"),
                eucdist_C = eucdist(M, group_vec, FUN = "eucdist_C"),
                eucdist_c_loop = eucdist_group_C(M, group_vec),
                eucdist_DT = eucdist_DT(M, group_vec),
                columns = c("test", "elapsed"),
                replications = 25
        )
    
    t_base = timer$elapsed[1] # time for dist(M), the base R function
    time_base[j] = t_base; j <- j + 1
    relative_now <- round(t_base/timer$elapsed, 4)
    Grelative_times[col_index] <- relative_now 
    col_index <- col_index + 1
    timer$relative <- relative_now
    # row.names(timer) <- funcs 
    print(timer)
    cat("\n", paste(rep("*", 100), collapse = ""), "\n")
}
names(Grelative_times) <- nrows
row.names(Grelative_times) <- sort(funcs)
saveRDS(Grelative_times, file = "Group_times.rds")
sink()
saveRDS(time_base, "BaseR_times.rds")



group_time <- as.data.frame((readRDS("Group_times.rds")))
time_base <- readRDS("BaseR_times.rds")
n <- as.numeric(row.names(group_time))
g <- ggplot(data = group_time, aes(x=n))
g1 = g + geom_line(aes(y = dotprod, color = "dotprod"))+ geom_line(aes(y = eucdist_C, color = "eucdist_C"))
g2 = g1 + geom_line(aes(y = dist, color = "dist")) + geom_line(aes(y = eucdist_R, color = "eucdist_R")) + geom_line(aes(y = eucdist_c_loop, color = "eucdist_c_loop"))
g3 <- g2 + geom_line(aes(y = fastdist2, color = "fastdist2")) + geom_line(aes(y = eucdist_DT, color="eucdist_DT"))
g4 <- g3 + scale_color_manual(NULL, 
            values=c(dotprod = "green", eucdist_R = "cyan", dist= "black", 
            fastdist2 = "darkblue", eucdist_C = "red", eucdist_c_loop = "orange", eucdist_DT = "yellow")) +  
            theme(legend.text = element_text(size=18)) + labs(y ="Times", x = "Nrows") + annotate("point", x = n, y = 1, color = "blue", size=3) + geom_text_repel(aes(x = n, y = 1, label = round(time_base, 4)))
        
saveRDS(g4, "g4.rds") 




file = ""

allSampleImpute <- scan(file = file, what = "list")
N <- NROW(allSampleImpute)


allSampleImputeN <- lapply(allSampleImpute, strsplit, collapse = "", sep = " ")

data_sample <- matrix(unlist(lapply(allSampleImputeN, function(X) as.numeric(X[4:length(X)]))), ncol = N)

eucdist(data_sample)
