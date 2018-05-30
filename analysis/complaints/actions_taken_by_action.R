# Make a pie chart by type of force for each level of force
check.vars(c("actions.for.year"))
title <- "Actions taken by action"

########################################################################################################
########################################################################################################
relevant.actions <- actions.for.year %>% 
  filter(Action.taken.OIPM != "None", Action.taken.OIPM != "Pending Investigation") %>%
  group_by(Action.taken.OIPM)

count.by.action <- relevant.actions %>% summarise(count = n())

p.actions.taken <- plot_ly(count.by.action,  type = 'pie', 
        name = ~Action.taken.OIPM,
        labels = ~Action.taken.OIPM, 
        values = ~count,
        textposition = 'inside',
        textinfo = 'label+value+percent',
        insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", title = "Types of action taken", showlegend = FALSE)

p.actions.taken