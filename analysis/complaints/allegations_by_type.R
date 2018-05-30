check.vars(c("year", "allegations.for.year"))
title <- "Allegations by type"

########################################################################################################
########################################################################################################

allegations.by.type.disposition <- allegations.for.year %>% group_by(Allegation.short, Allegation.Finding.OIPM)
count.by.type.disposition <- summarize(allegations.by.type.disposition, num.allegations = n())

p.allegation.by.type.disposition <- plot_ly(count.by.type.disposition, 
                         x = ~Allegation.Finding.OIPM, y = ~num.allegations, 
                         type = 'bar',  name = ~Allegation.short, 
                         color = ~Allegation.short) %>%
  
  layout(xaxis = list(title = "Type of allegation", 
                      showgrid = F), 
         yaxis = list(title = 'Number allegations'), 
         barmode = 'stack',
         hovermode = 'compare', 
         margin = list(r = 100, b = 100))

p.allegation.by.type.disposition
