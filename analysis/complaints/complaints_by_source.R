check.vars(c("complaints.for.year"))
title <- "Complaints by source"

########################################################################################################
########################################################################################################

complaints.by.source <- complaints.for.year %>% group_by(Source)
count.by.source <- summarise(complaints.by.source, count = n())

p.complaints.by.source <- plot_ly(count.by.source,  type = 'pie', name = title,
                             labels = ~Source, 
                             values = ~count,
                             textposition = 'inside',
                             textinfo = 'label+value+percent',
                             insidetextfont = list(color = '#FFFFFF'))
p.complaints.by.source
chart_link = api_create(p.complaints.by.source, filename=title)
chart_link
