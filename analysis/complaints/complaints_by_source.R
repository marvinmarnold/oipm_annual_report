check.vars(c("uof.for.year"))
title <- "UOF by reason"

########################################################################################################
########################################################################################################

uof.by.reason <- uof.for.year %>% group_by(Reason.for.force)
count.by.reason <- summarise(uof.by.reason, count = n())

p.uof.by.reason <- plot_ly(count.by.reason,  type = 'pie', name = title,
                           labels = ~Reason.for.force, 
                           values = ~count,
                           textposition = 'inside',
                           textinfo = 'label+value+percent',
                           insidetextfont = list(color = '#FFFFFF'))
p.uof.by.reason
