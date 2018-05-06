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

########################################################################################################
########################################################################################################
title <- "Reason for exhibiting firearm"

firearm.by.reason <- uof.for.year %>% filter(Force.type == "Firearm Exhibited") %>% group_by(Reason.for.force)
count.by.firearm.reason <- summarise(firearm.by.reason, count = n())

p.firearm.by.reason <- plot_ly(count.by.firearm.reason,  type = 'pie', name = title,
                           labels = ~Reason.for.force, 
                           values = ~count,
                           textposition = 'inside',
                           textinfo = 'label+value+percent',
                           insidetextfont = list(color = '#FFFFFF'))
p.firearm.by.reason

########################################################################################################
########################################################################################################
title <- "What preceeded force"

uof.by.service.type <- uof.for.year %>% group_by(Service.type)
count.by.service.type <- summarise(uof.by.service.type, count = n())

p.uof.by.service.type <- plot_ly(count.by.service.type,  type = 'pie', name = title,
                           labels = ~Service.type, 
                           values = ~count,
                           textposition = 'inside',
                           textinfo = 'label+value+percent',
                           insidetextfont = list(color = '#FFFFFF'))
p.uof.by.service.type

