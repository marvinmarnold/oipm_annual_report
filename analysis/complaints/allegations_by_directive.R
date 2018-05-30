check.vars(c("allegations.for.year"))

########################################################################################################
########################################################################################################
head(allegations.for.year)
title <- "Allegations by directive for neglect"

# Neglect of duty
alleg.by.directive <- allegations.for.year %>% 
  filter(Allegation.short == "NEGLECT OF DUTY") %>% 
  group_by(Allegation.directive)

count.by.directive <- alleg.by.directive %>% summarise(count = n()) 

p.directives.for.neglect <- plot_ly(count.by.directive,  type = 'pie', name = title,
                       labels = ~Allegation.directive, 
                       values = ~count,
                       textposition = 'inside',
                       textinfo = 'label+value+percent',
                       insidetextfont = list(color = '#FFFFFF'))
p.directives.for.neglect

write.csv(count.by.directive, file = "directives_neglectOfDuty.csv")

# Adherence to law
alleg.by.directive <- allegations.for.year %>% 
  filter(Allegation.short == "ADHERENCE TO LAW") %>% 
  group_by(Allegation.directive)

count.by.directive <- alleg.by.directive %>% summarise(count = n()) 

write.csv(count.by.directive, file = "directives_adherenceToLaw.csv")

# INSTRUCTIONS FROM AUTHORITATIVE SOURCE
alleg.by.directive <- allegations.for.year %>% 
  filter(Allegation.short == "INSTRUCTIONS FROM AUTHORITATIVE SOURCE") %>% 
  group_by(Allegation.directive)

count.by.directive <- alleg.by.directive %>% summarise(count = n()) 

write.csv(count.by.directive, file = "directives_instructionsFromAuthoritative.csv")
