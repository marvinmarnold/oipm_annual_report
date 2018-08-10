check.vars(c("uof.for.year"))
title <- "Force by victim sex and race"

########################################################################################################
########################################################################################################
uof.by.sex <- uof.for.year %>% group_by(Citizen.sex, Citizen.race)
count.by.sex.race <- summarize(uof.by.sex, num.uof = n())
count.by.sex.race

p.uof.by.victim.sex.race <- plot_ly(count.by.sex.race, 
                         x = ~Citizen.sex, y = ~num.uof, 
                         type = 'bar',  name = ~Citizen.race, 
                         color = ~Citizen.race) %>%
  
  layout(xaxis = list(showgrid = F), 
         yaxis = list(title = 'Number UOF'), 
         barmode = 'stack',
         legend = list(x = 0, y = -.50),
         hovermode = 'compare')

p.uof.by.victim.sex.race

########################################################################################################
########################################################################################################

count.by.female.race <- count.by.sex.race %>% filter(Citizen.sex == 'F')

# Construct pie chart
title <- "UOF by female victim race"
p.uof.by.female.victim.race <- plot_ly(count.by.female.race,  type = 'pie',
        labels = ~Citizen.race, 
        values = ~num.uof,
        textposition = 'inside',
        textinfo = 'label+value+percent',
        insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", showlegend = FALSE)

p.uof.by.female.victim.race

########################################################################################################
########################################################################################################

count.by.male.race <- count.by.sex.race %>% filter(Citizen.sex == 'M')

# Construct pie chart
title <- "UOF by male victim race"
p.uof.by.male.victim.race <- plot_ly(count.by.male.race,  type = 'pie',
                                       labels = ~Citizen.race, 
                                       values = ~num.uof,
                                       textposition = 'inside',
                                       textinfo = 'label+value+percent',
                                       insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", showlegend = FALSE)

p.uof.by.male.victim.race

########################################################################################################
########################################################################################################

# Female victim UOF by type and race
uof.for.sex <- uof.for.year %>% filter(Citizen.sex == 'F')
uof.by.type <- group_by(uof.for.sex, Force.type, Citizen.race) 

# make a simple summary of uof count by type
uof.count.by.type <- summarise(uof.by.type, count = n())
uof.count.by.type

p.female.victim.uof.by.type <- plot_ly(uof.count.by.type, 
                                x = ~Force.type, y = ~count, 
                                type = 'bar',  
                                name = ~Citizen.race, 
                                color = ~Citizen.race) %>%
  
  layout(xaxis = list(showgrid = F), 
         yaxis = list(title = 'Number UOF'), 
         barmode = 'stack',
         hovermode = 'compare',
         margin = list(b = 150))

p.female.victim.uof.by.type

########################################################################################################
########################################################################################################

# Male victim UOF by type and race
uof.for.sex <- uof.for.year %>% filter(Citizen.sex == 'M')
uof.by.type <- group_by(uof.for.sex, Force.type, Citizen.race) 

# make a simple summary of uof count by type
uof.count.by.type <- summarise(uof.by.type, count = n())
uof.count.by.type

p.male.victim.uof.by.type <- plot_ly(uof.count.by.type, 
                              x = ~Force.type, y = ~count, 
                              type = 'bar',  
                              name = ~Citizen.race, 
                              color = ~Citizen.race) %>%
  
  layout(xaxis = list(showgrid = F), 
         yaxis = list(title = 'Number UOF'), 
         barmode = 'stack',
         hovermode = 'compare',
         margin = list(b = 150))

p.male.victim.uof.by.type
