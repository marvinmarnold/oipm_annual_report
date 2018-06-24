check.vars(c("allegations.for.year"))


########################################################################################################
########################################################################################################
title <- "Top allegations"

alleg.by.alleg <- allegations.for.year %>% group_by(Allegation.simple)
count.by.alleg <- summarise(alleg.by.alleg, alleg.count = n())

p.top.alleg <- plot_ly(count.by.alleg,  type = 'pie', name = title,
                             labels = ~Allegation.simple, 
                             values = ~alleg.count,
                             textposition = 'inside',
                             textinfo = 'label+value+percent',
                             insidetextfont = list(color = '#FFFFFF'))
p.top.alleg

########################################################################################################
########################################################################################################
title <- "Top sustained"

sustained.alleg.by.alleg <- allegations.for.year %>% filter(Disposition.OIPM.by.officer == "Sustained") %>% group_by(Allegation.simple)
sustained.count.by.alleg <- summarise(sustained.alleg.by.alleg, count = n())

p.top.sustained.alleg <- plot_ly(sustained.count.by.alleg,  type = 'pie', name = title,
                       labels = ~Allegation.simple, 
                       values = ~count,
                       textposition = 'inside',
                       textinfo = 'label+value+percent',
                       insidetextfont = list(color = '#FFFFFF'))
p.top.sustained.alleg

########################################################################################################
########################################################################################################
title <- "Top DI2"

di2.alleg.by.alleg <- allegations.for.year %>% filter(Disposition.OIPM.by.officer == "DI-2") %>% group_by(Allegation.simple)
di2.count.by.alleg <- summarise(di2.alleg.by.alleg, count = n())

p.top.di2.alleg <- plot_ly(di2.count.by.alleg,  type = 'pie', name = title,
                                 labels = ~Allegation.simple, 
                                 values = ~count,
                                 textposition = 'inside',
                                 textinfo = 'label+value+percent',
                                 insidetextfont = list(color = '#FFFFFF'))
p.top.di2.alleg

