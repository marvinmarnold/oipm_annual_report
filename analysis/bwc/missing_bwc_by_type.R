check.vars(c("epr.missing.bwc"))
title -> "EPR missing corresponding BWC by type"

########################################################################################################
########################################################################################################

missing.bwc.by.signal <- epr.missing.bwc %>% group_by(Signal_Description)
count.bwc.by.signal <- summarise(missing.bwc.by.signal, num.missing = n())

p.missing.bwc.by.type <- plot_ly(count.bwc.by.signal, 
                         x = ~Signal_Description, y = ~num.missing, 
                         type = 'bar',  name = ~Signal_Description, 
                         color = ~Signal_Description) %>%
  
  layout(margin = list(b=200))

p.missing.bwc.by.type
