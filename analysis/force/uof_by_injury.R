check.vars(c("uof.for.year"))

########################################################################################################
########################################################################################################
title <- "Officer injuries during UOF"

uof.by.officer.injury <- uof.for.year %>% group_by(Officer.injured)
count.by.officer.injury <- uof.by.officer.injury %>% summarise(count = n())

p.uof.by.officer.injury <- plot_ly(count.by.officer.injury,  type = 'pie', 
                                  labels = ~Officer.injured, 
                                  values = ~count,
                                  textposition = 'inside',
                                  textinfo = 'label+value+percent',
                                  insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", showlegend = FALSE)

p.uof.by.officer.injury
########################################################################################################
########################################################################################################
title <- "Victim injuries during UOF"

uof.by.victim.injury <- uof.for.year %>% group_by(Citizen.injured)
count.by.victim.injury <- uof.by.victim.injury %>% summarise(count = n())

p.uof.by.victim.injury <- plot_ly(count.by.victim.injury,  type = 'pie', 
                                   labels = ~Citizen.injured, 
                                   values = ~count,
                                   textposition = 'inside',
                                   textinfo = 'label+value+percent',
                                   insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", showlegend = FALSE)

p.uof.by.victim.injury
