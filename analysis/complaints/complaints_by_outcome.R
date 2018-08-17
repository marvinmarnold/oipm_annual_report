check.vars(c("year", "complaints.for.year"))

########################################################################################################
########################################################################################################
dispositions.for.year <- complaints.for.year %>% group_by(Disposition.OIPM)
count.dispositions.for.year <- summarise(dispositions.for.year, num.complaints = n())
count.dispositions.for.year <- count.dispositions.for.year %>% mutate(
  color = case_when(
    Disposition.OIPM == "DI-2" ~ "red",
    Disposition.OIPM == "Unfounded" ~ "blue",
    Disposition.OIPM == "NFIM" ~ "orange",
    Disposition.OIPM == "Sustained" ~ "pink",
    Disposition.OIPM == "Not Sustained" ~ "green",
    Disposition.OIPM == "Exonerated" ~ "black",
    Disposition.OIPM == "Mediation" ~ "cyan",
    Disposition.OIPM == "Pending" ~ "magenta",
    TRUE ~ "yellow"
  )
)

title <- "Disposition of all complaints"
p.complaint.by.outcome <- plot_ly(count.dispositions.for.year,  type = 'pie',
        labels = ~Disposition.OIPM, 
        values = ~num.complaints,
        marker = list(colors = ~color),
        textposition = 'middle center',
        textinfo = 'label+value+percent',
        insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", showlegend = FALSE)

p.complaint.by.outcome

########################################################################################################
########################################################################################################
rank.dispositions.for.year <- complaints.for.year %>% filter(Incident.type == "Rank Initiated") %>% group_by(Disposition.OIPM)
count.rank.dispositions.for.year <- summarise(rank.dispositions.for.year, num.complaints = n())
count.rank.dispositions.for.year <- count.rank.dispositions.for.year %>% mutate(
  color = case_when(
    Disposition.OIPM == "DI-2" ~ "red",
    Disposition.OIPM == "Unfounded" ~ "blue",
    Disposition.OIPM == "NFIM" ~ "orange",
    Disposition.OIPM == "Sustained" ~ "pink",
    Disposition.OIPM == "Not Sustained" ~ "green",
    Disposition.OIPM == "Exonerated" ~ "black",
    Disposition.OIPM == "Mediation" ~ "cyan",
    Disposition.OIPM == "Pending" ~ "magenta",
    TRUE ~ "yellow"
  )
)

title <- "Disposition of rank initiated complaints"
p.rank.complaint.by.outcome <- plot_ly(count.rank.dispositions.for.year,  type = 'pie', 
                                  labels = ~Disposition.OIPM, 
                                  values = ~num.complaints,
                                  marker = list(colors = ~color),
                                  textposition = 'middle center',
                                  textinfo = 'label+value+percent',
                                  insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", showlegend = FALSE)

p.rank.complaint.by.outcome

########################################################################################################
########################################################################################################
citizen.dispositions.for.year <- complaints.for.year %>% filter(Incident.type == "Public Initiated") %>% group_by(Disposition.OIPM)
count.citizen.dispositions.for.year <- summarise(citizen.dispositions.for.year, num.complaints = n())
count.citizen.dispositions.for.year <- count.citizen.dispositions.for.year %>% mutate(
  color = case_when(
    Disposition.OIPM == "DI-2" ~ "red",
    Disposition.OIPM == "Unfounded" ~ "blue",
    Disposition.OIPM == "NFIM" ~ "orange",
    Disposition.OIPM == "Sustained" ~ "pink",
    Disposition.OIPM == "Not Sustained" ~ "green",
    Disposition.OIPM == "Exonerated" ~ "black",
    Disposition.OIPM == "Mediation" ~ "cyan",
    Disposition.OIPM == "Pending" ~ "magenta",
    TRUE ~ "yellow"
  )
)

title <- "Disposition of citizen initiated complaints"
p.citizen.complaint.by.outcome <- plot_ly(count.citizen.dispositions.for.year,  type = 'pie',
                                       labels = ~Disposition.OIPM,
                                       values = ~num.complaints,
                                       marker = list(colors = ~color),
                                       textposition = 'middle center',
                                       textinfo = 'label+value+percent',
                                       insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", showlegend = FALSE)

p.citizen.complaint.by.outcome
