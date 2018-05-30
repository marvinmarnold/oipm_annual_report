check.vars(c("year", "allegations.for.year"))
title <- "Discipline by complainant's sex"

########################################################################################################
########################################################################################################

complainant.info <- allegations.all %>% select(Citizen.race, Citizen.sex, Allegation.primary.key) %>% distinct()
detailed.actions.for.year <- merge(disci, complainant.info, by = "Allegation.primary.key", all.x = TRUE) %>% nrow

discipline.by.sex <- detailed.actions.for.year %>% group_by(Action.taken.OIPM, Se)
discipline.count.by.allegation <- summarize(discipline.by.allegation, num.allegations = n())

p.discipline.by.allegation <- plot_ly(discipline.count.by.allegation, 
                                      x = ~Action.taken.OIPM, y = ~num.allegations, 
                                      type = 'bar',  name = ~Allegation.short, 
                                      color = ~Allegation.short) %>%
  
  layout(xaxis = list(title = "Type of allegation", 
                      showgrid = F), 
         yaxis = list(title = 'Number allegations'), 
         barmode = 'stack',
         hovermode = 'compare', 
         margin = list(r = 100, b = 100))

p.discipline.by.allegation
