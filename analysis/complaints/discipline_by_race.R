check.vars(c("year", "allegations.for.year"))
title <- "Discipline by complainant's race"

########################################################################################################
########################################################################################################

complainant.info <- allegations.all %>% select(Citizen.race, Allegation.primary.key) %>% distinct()
detailed.actions.for.year <- merge(discipline.for.year, complainant.info, by = "Allegation.primary.key", all.x = TRUE)

discipline.by.race <- detailed.actions.for.year %>% group_by(Action.taken.OIPM, Citizen.race)
discipline.count.by.race <- summarize(discipline.by.race, num.allegations = n())

p.discipline.by.race <- plot_ly(discipline.count.by.race, 
                               x = ~Action.taken.OIPM, y = ~num.allegations, 
                               type = 'bar',  name = ~Citizen.race, 
                               color = ~Citizen.race) %>%
  
  layout(xaxis = list(title = "Type of allegation", 
                      showgrid = F), 
         yaxis = list(title = 'Number allegations'), 
         barmode = 'stack',
         hovermode = 'compare', 
         margin = list(r = 100, b = 100))

p.discipline.by.race
