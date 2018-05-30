check.vars(c("year", "complaints.for.year"))

########################################################################################################
########################################################################################################
dispositions.for.year <- complaints.for.year %>% group_by(Disposition.OIPM)
count.dispositions.for.year <- summarise(dispositions.for.year, num.complaints = n())

title <- "Disposition of all complaints"
p.complaint.by.outcome <- plot_ly(count.dispositions.for.year,  type = 'pie', name = title,
        labels = ~Disposition.OIPM, 
        values = ~num.complaints,
        textposition = 'middle center',
        textinfo = 'label+value+percent',
        insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", title = title, showlegend = FALSE)

p.complaint.by.outcome

########################################################################################################
########################################################################################################
rank.dispositions.for.year <- complaints.for.year %>% filter(Incident.type == "Rank Initiated") %>% group_by(Disposition.OIPM)
count.rank.dispositions.for.year <- summarise(rank.dispositions.for.year, num.complaints = n())

title <- "Disposition of rank initiated complaints"
p.rank.complaint.by.outcome <- plot_ly(count.rank.dispositions.for.year,  type = 'pie', name = title,
                                  labels = ~Disposition.OIPM, 
                                  values = ~num.complaints,
                                  textposition = 'middle center',
                                  textinfo = 'label+value+percent',
                                  insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", title = title, showlegend = FALSE)

p.rank.complaint.by.outcome

########################################################################################################
########################################################################################################
citizen.dispositions.for.year <- complaints.for.year %>% filter(Incident.type == "Public Initiated") %>% group_by(Disposition.OIPM)
count.citizen.dispositions.for.year <- summarise(citizen.dispositions.for.year, num.complaints = n())

title <- "Disposition of citizen initiated complaints"
p.citizen.complaint.by.outcome <- plot_ly(count.citizen.dispositions.for.year,  type = 'pie', name = title,
                                       labels = ~Disposition.OIPM, 
                                       values = ~num.complaints,
                                       textposition = 'middle center',
                                       textinfo = 'label+value+percent',
                                       insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", title = title, showlegend = FALSE)

p.citizen.complaint.by.outcome
