check.vars(c("uof.for.year"))
title <- "UOF by type"

lvls <- c('Not reported', 'L1', 'L2', 'L3', 'L4')

########################################################################################################
########################################################################################################

# Group UOF by type
uof.by.type <- group_by(uof.for.year, Force.level, Force.type) 

# make a simple summary of uof count by type
uof.count.by.type <- summarise(uof.by.type, count = n())

p.uof.by.type <- plot_ly(uof.count.by.type, 
                         x = ~Force.level, y = ~count, 
                         type = 'bar',  name = ~Force.type, 
                         color = ~Force.type) %>%
  
  layout(xaxis = list(categoryorder = "array",
                      categoryarray = lvls,
                      title = "Level of force", 
                      showgrid = F), 
         yaxis = list(title = 'Number UOF'), 
         barmode = 'stack',
         hovermode = 'compare')

p.uof.by.type
