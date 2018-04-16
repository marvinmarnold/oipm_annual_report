check.vars(c("active.officers.for.year", "year"))
title <- "Officer demograthics"

active.officers.2016 <-1239
########################################################################################################
########################################################################################################
active.officers.2017 <- nrow(active.officers.for.year)

p.active.officers <- plot_ly(
  x = c("2016", "2017"),
  y = c(active.officers.2016, active.officers.2017),
  name = "Number active officers",
  type = "bar"
)

p.active.officers

########################################################################################################
########################################################################################################
officers.by.sex <- active.officers.for.year %>% group_by(Sex)
count.by.sex <- summarize(officers.by.sex, num.uof = n())
count.by.sex

p.officers.by.sex <- plot_ly(count.by.sex, labels = ~Sex, values = ~num.uof, type = 'pie',
             textposition = 'inside',
             textinfo = 'label+value+percent',
             insidetextfont = list(color = '#FFFFFF'),
             hoverinfo = 'text') %>%
  
  layout(showlegend = FALSE)

p.officers.by.sex

########################################################################################################
########################################################################################################
officers.by.race <- active.officers.for.year %>% group_by(Race)
count.by.race <- summarize(officers.by.race, num.uof = n())
count.by.race

p.officers.by.race <- plot_ly(count.by.race, labels = ~Race, values = ~num.uof, type = 'pie',
             textposition = 'inside',
             textinfo = 'label+value+percent',
             insidetextfont = list(color = '#FFFFFF'),
             hoverinfo = 'text') %>%
  
  layout(showlegend = FALSE)

p.officers.by.race
