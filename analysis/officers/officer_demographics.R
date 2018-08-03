check.vars(c("officers.adp.for.year", "year"))
title <- "Officer demograthics"

# From annual report
active.officers.2016 <-1239
########################################################################################################
########################################################################################################
active.officers.2017 <- nrow(officers.adp.for.year)

p.active.officers <- plot_ly(
  x = c("2016", "2017"),
  y = c(active.officers.2016, active.officers.2017),
  name = "Number active officers",
  type = "bar"
)

p.active.officers

########################################################################################################
########################################################################################################
officers.by.sex <- officers.adp.for.year %>% group_by(Officer.sex)
count.by.sex <- summarize(officers.by.sex, num.uof = n())
count.by.sex

p.officers.by.sex <- plot_ly(count.by.sex, labels = ~Officer.sex, values = ~num.uof, type = 'pie',
                             textposition = 'inside',
                             textinfo = 'label+value+percent',
                             insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = 'compare', showlegend = TRUE, legend = list(x = 0, y = -.50))
  
p.officers.by.sex

########################################################################################################
########################################################################################################
officers.by.race <- officers.adp.for.year %>% mutate(
  Officer.race = as.character(Officer.race)
  ) %>% group_by(Officer.race)
count.by.race <- summarize(officers.by.race, num.officers = n())
count.by.race

p.officers.by.race <- plot_ly(count.by.race, labels = ~Officer.race, 
                              values = ~num.officers, 
                              type = 'pie',
                              textposition = 'inside',
                              textinfo = 'label+value+percent',
                              insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = 'compare', showlegend = TRUE, legend = list(x = 0, y = -.50))
  
p.officers.by.race
