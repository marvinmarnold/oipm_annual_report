source("iapro/uof_ftn_master.R")
title <- "Force by victim sex"

########################################################################################################
########################################################################################################
uof.by.sex <- uof2017 %>% group_by(Citizen.sex)
count.by.sex <- summarize(uof.by.sex, num.uof = n())
count.by.sex

p <- plot_ly(count.by.sex, labels = ~Citizen.sex, values = ~num.uof, type = 'pie',
             textposition = 'inside',
             textinfo = 'label+value+percent',
             insidetextfont = list(color = '#FFFFFF'),
             hoverinfo = 'text') 
p
api_create(p, filename=title, sharing = "public")

########################################################################################################
########################################################################################################

# Group UOF by type
uof.by.sex.type <- uof.by.sex %>% group_by(Citizen.sex, Force.level) 
count.by.sex.type <- summarize(uof.by.sex.type, num.uof = n())

# Given the level, return the pct of males
male.pct <- function(lvl) {
  count.for.lvl <- count.by.sex.type %>% filter(Force.level == lvl)
  count.for.lvl.male <- count.for.lvl %>% filter(Citizen.sex == 'M')
  pt <- sum(count.for.lvl.male$num.uof) / sum(count.for.lvl$num.uof) * 100
  
  # round to two decimal places and add % like '3.45% male'
  paste(format(round(pt, 2), nsmall = 2), '% male', sep = '')
}

# lvls <- unique(count.by.sex.type$Force.level)
# pct.male.by.lvl <- sapply(lvls, male.pct)
pct.male.by.lvl <- sapply(count.by.sex.type$Force.level, male.pct)

xform <- list(title = "Level of force", 
              showgrid = T)

p <- plot_ly(count.by.sex.type, x = ~Force.level, y = ~num.uof, type = 'bar',  
             name = ~Citizen.sex, color = ~Citizen.sex, 
             text = pct.male.by.lvl, textposition = 'auto') %>%
  layout(xaxis = xform, yaxis = list(title = 'Number UOF'), barmode = 'stack')
p

api_create(p, filename=paste(title, "and force lvl"), sharing = "public")
