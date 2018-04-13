library(data.table)  


Animals <- c("giraffes", "orangutans", "monkeys")
SF_Zoo <- c(20, 14, 23)
LA_Zoo <- c(12, 18, 29)

data <- data.frame(Animals, SF_Zoo, LA_Zoo)
data.m <- data.table::melt(data, id.vars='Animals') 
data.m
