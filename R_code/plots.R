require(ggplot2)
relative_times <- as.data.frame(t(readRDS("relative_times.rds")))

n = as.numeric(row.names(relative_times))

g = ggplot(data = relative_times, aes(x = n))
g1 = g + geom_line(aes(y = dotprod, color = "dotprod"))+ geom_line(aes(y = eucdist_C, color = "eucdist_C"))
g2 = g1 + geom_line(aes(y = dist, color = "dist")) + geom_line(aes(y = eucdist_R, color = "eucdist_R"))
g3 <- g2 + geom_line(aes(y = fastdist2, color = "fastdist2"))
g4 <- g3 + scale_color_manual(NULL, 
    values=c(dotprod = "green", eucdist_C = "red", dist= "black", fastdist2 = "yellow", eucdist_C = "blue", eucdist_R = "cyan")) 
