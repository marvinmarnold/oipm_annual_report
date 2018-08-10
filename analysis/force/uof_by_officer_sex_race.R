check.vars(c("uof.for.year"))
title <- "Force by officer sex and race"

########################################################################################################
########################################################################################################
uof.by.sex <- uof.for.year %>% group_by(Officer.sex, Officer.race)
count.by.sex.race <- summarize(uof.by.sex, num.uof = n())
count.by.sex.race

p.uof.by.officer.sex.race <- plot_ly(count.by.sex.race, 
                         x = ~Officer.sex, y = ~num.uof, 
                         type = 'bar',  
                         name = ~Officer.race, 
                         color = ~Officer.race) %>%
  
  layout(xaxis = list(showgrid = F), 
         yaxis = list(title = 'Number UOF'), 
         barmode = 'stack',
         legend = list(x = 0, y = -.50),
         hovermode = 'compare')

p.uof.by.officer.sex.race

########################################################################################################
########################################################################################################

count.by.female.race <- count.by.sex.race %>% filter(Officer.sex == 'F')

# Construct pie chart
title <- "UOF by female officer race"
p.uof.by.female.officer.race <- plot_ly(count.by.female.race,  type = 'pie',
        labels = ~Officer.race, 
        values = ~num.uof,
        textposition = 'inside',
        textinfo = 'label+value+percent',
        insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", showlegend = FALSE)

p.uof.by.female.officer.race

########################################################################################################
########################################################################################################

count.by.male.race <- count.by.sex.race %>% filter(Officer.sex == 'M')

# Construct pie chart
title <- "UOF by male officer race"
p.uof.by.male.officer.race <- plot_ly(count.by.male.race,  type = 'pie',
                                       labels = ~Officer.race, 
                                       values = ~num.uof,
                                       textposition = 'inside',
                                       textinfo = 'label+value+percent',
                                       insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", showlegend = FALSE)

p.uof.by.male.officer.race

########################################################################################################
########################################################################################################

# Female officer UOF by type and race
uof.for.sex <- uof.for.year %>% filter(Officer.sex == 'F')
uof.by.type <- group_by(uof.for.sex, Force.type, Officer.race) 

# make a simple summary of uof count by type
uof.count.by.type <- summarise(uof.by.type, count = n())
uof.count.by.type

p.female.uof.by.type <- plot_ly(uof.count.by.type, 
                         x = ~Force.type, y = ~count, 
                         type = 'bar',  name = ~Officer.race, 
                         color = ~Officer.race) %>%
  
  layout(xaxis = list(showgrid = F), 
         yaxis = list(title = 'Number UOF'), 
         barmode = 'stack',
         hovermode = 'compare',
         margin = list(b = 150))

p.female.uof.by.type

########################################################################################################
########################################################################################################

# Male officer UOF by type and race
uof.for.sex <- uof.for.year %>% filter(Officer.sex == 'M')
uof.by.type <- group_by(uof.for.sex, Force.type, Officer.race) 

# make a simple summary of uof count by type
uof.count.by.type <- summarise(uof.by.type, count = n())
uof.count.by.type

p.male.uof.by.type <- plot_ly(uof.count.by.type, 
                                x = ~Force.type, y = ~count, 
                                type = 'bar',  name = ~Officer.race, 
                                color = ~Officer.race) %>%
  
  layout(xaxis = list(showgrid = F), 
         yaxis = list(title = 'Number UOF'), 
         barmode = 'stack',
         hovermode = 'compare',
         margin = list(b = 150))

p.male.uof.by.type
