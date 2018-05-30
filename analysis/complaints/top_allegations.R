check.vars(c("allegations.for.year"))
title <- "Allegations by source"

########################################################################################################
########################################################################################################

alleg.by.alleg <- allegations.for.year %>% group_by(Allegation.simple)
count.by.alleg <- summarise(alleg.by.alleg, count = n())

p.top.alleg <- plot_ly(count.by.alleg,  type = 'pie', name = title,
                             labels = ~Allegation.simple, 
                             values = ~count,
                             textposition = 'inside',
                             textinfo = 'label+value+percent',
                             insidetextfont = list(color = '#FFFFFF'))
p.top.alleg
