check.vars(c("year", "misconduct.alleg.act"))
title <- "Force by disposition and race of officer"

########################################################################################################
########################################################################################################

misconduct.disposition.race <- misconduct.alleg.act %>% group_by(Disposition.OIPM, Race)
count.by.disposition.race <- summarise(misconduct.disposition.race, num.dispositions = n())



dispositions <- unique(misconduct.disposition.race$Disposition.OIPM)
xform <- list(categoryorder = "array",
              categoryarray = dispositions,
              title = "Age range", 
              showgrid = T)

p <- plot_ly(count.by.disposition.race) %>% 
  
  add_trace(x = ~Disposition.OIPM, y = ~num.dispositions, type = 'bar',  
             name = ~Race, color = ~Race) %>%
  
  add_trace(x = c("Sustained"), y = 1, name = 'Allegations by race', type = 'scatter',
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid'), mode = 'lines+markers') %>%

  layout(xaxis = xform, yaxis = list(title = 'Num complaints resulting in disposition'), barmode = 'stack')
  
p 
api_create(p, filename=title, sharing = "public")
