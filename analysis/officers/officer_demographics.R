source("iapro/uof_ftn_master.R")
title <- "Officer demographics"

########################################################################################################
########################################################################################################
officers.by.sex <- officersAll %>% group_by(Sex)
count.by.sex <- summarize(officers.by.sex, num.uof = n())
count.by.sex

p <- plot_ly(count.by.sex, labels = ~Sex, values = ~num.uof, type = 'pie',
             textposition = 'inside',
             textinfo = 'label+value+percent',
             insidetextfont = list(color = '#FFFFFF'),
             hoverinfo = 'text') 
p
api_create(p, filename=paste(title, "by sex"), sharing = "public")

########################################################################################################
########################################################################################################
officers.by.race <- officersAll %>% group_by(Race)
count.by.race <- summarize(officers.by.race, num.uof = n())
count.by.race

p <- plot_ly(count.by.race, labels = ~Race, values = ~num.uof, type = 'pie',
             textposition = 'inside',
             textinfo = 'label+value+percent',
             insidetextfont = list(color = '#FFFFFF'),
             hoverinfo = 'text') 
p
api_create(p, filename=paste(title, "by race"), sharing = "public")
