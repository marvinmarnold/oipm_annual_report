check.vars(c("year", "complaints.for.year"))

########################################################################################################
########################################################################################################
# total number of rank vs citizen and sustained
count.by.rank.disposition <- complaints.for.year %>% mutate(
  disposition.simple = case_when(
    Disposition.OIPM == "Sustained" ~ "Sustained",
    Disposition.OIPM == "DI-2" ~ "DI-2",
    TRUE ~ "Not sustained"
  )
) %>%
  group_by(Incident.type, disposition.simple) %>% 
  summarise(num.complaints = n())

p.complaints.by.rank.disposition <- plot_ly(count.by.rank.disposition, 
                                            x = ~Incident.type, 
                                            y = ~num.complaints, 
                                            type = 'bar',  name = ~disposition.simple, 
                                            color = ~disposition.simple) %>%
  
  layout(xaxis = list(title = "Type of complaint", 
                      showgrid = F), 
         yaxis = list(title = 'Number complaints'), 
         barmode = 'stack',
         hovermode = 'compare', 
         margin = list(r = 100, b = 100))

p.complaints.by.rank.disposition
