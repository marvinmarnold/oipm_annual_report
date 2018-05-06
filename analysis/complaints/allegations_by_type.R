check.vars(c("year", "allegations.for.year"))
title <- "Allegations by type"

########################################################################################################
########################################################################################################

allegations.by.type.disposition <- allegations.for.year %>% group_by(Allegation, Allegation.Finding.OIPM)
count.by.type.disposition <- summarize(allegations.by.type.disposition, num.allegations = n())

p.allegation.by.type.disposition <- plot_ly(count.by.type.disposition, 
                         x = ~Allegation.Finding.OIPM, y = ~num.allegations, 
                         type = 'bar',  name = ~Allegation, 
                         color = ~Allegation) %>%
  
  layout(xaxis = list(title = "Type of allegation", 
                      showgrid = F), 
         yaxis = list(title = 'Number allegations'), 
         barmode = 'stack',
         hovermode = 'compare')

p.allegation.by.type.disposition

########################################################################################################
########################################################################################################

allegations.by.type.disposition <- allegations.for.year %>% group_by(Allegation, Allegation.Finding.OIPM)
count.by.type.disposition <- summarize(allegations.by.type.disposition, num.allegations = n())

p.allegation.by.type.disposition <- plot_ly(count.by.type.disposition, 
                                            x = ~Allegation.Finding.OIPM, y = ~num.allegations, 
                                            type = 'bar',  name = ~Allegation, 
                                            color = ~Allegation) %>%
  
  layout(xaxis = list(title = "Type of allegation", 
                      showgrid = F), 
         yaxis = list(title = 'Number allegations'), 
         barmode = 'stack',
         hovermode = 'compare')

p.allegation.by.type.disposition