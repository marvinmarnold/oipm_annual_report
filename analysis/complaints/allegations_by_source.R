check.vars(c("allegations.for.year"))
title <- "Allegations by source"

########################################################################################################
########################################################################################################

alleg.by.source <- allegations.for.year %>% group_by(Source)
count.by.source <- summarise(alleg.by.source, count = n())

p.alleg.by.source <- plot_ly(count.by.source,  type = 'pie', name = title,
                           labels = ~Source, 
                           values = ~count,
                           textposition = 'inside',
                           textinfo = 'label+value+percent',
                           insidetextfont = list(color = '#FFFFFF'))
p.alleg.by.source
