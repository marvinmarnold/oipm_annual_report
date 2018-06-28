check.vars(c("year", "allegations.for.year"))

########################################################################################################
########################################################################################################

anon.allegs <-  allegations.for.year %>% 
  distinct(Citizen.primary.key, PIB.Control.Number, .keep_all = TRUE) %>%
  filter(Is.anonymous == "Anon - Explicit") %>% 
  group_by(Is.anonymous, Disposition.OIPM.by.officer)
num.anon.allegs <- anon.allegs %>% summarise(num.allegs = n())

p.anon.allegs <- plot_ly(num.anon.allegs,
  x = ~Is.anonymous,
  y = ~num.allegs,
  name = ~Disposition.OIPM.by.officer,
  type = "bar",
  color = ~Disposition.OIPM.by.officer
) %>% 
  
  layout(xaxis = list(title = "Anonymous complaints by outcome", 
                      showgrid = F), 
         yaxis = list(title = 'Number of complaints'), 
         barmode = 'stack',
         hovermode = 'compare', 
         margin = list(r = 100, b = 100))

p.anon.allegs

#write.csv(anon.allegs %>% filter(
#  Is.anonymous != "Not anonymous"
#) %>%
#  select(
#    PIB.Control.Number,
#    Is.anonymous
#), file = "data/IAPro/anonymous_complaints.csv")
