check.vars(c("complaints.for.year"))
title <- "Citizen and rank complaints by month"

########################################################################################################
########################################################################################################

# Get unique complaint / misconduct IDs and the month they occurred
citizen.complaints <- unique(complaints.for.year %>% filter(Incident.type == "Citizen Initiated") %>% select(FIT.Number, Month.occurred))
rank.complaints <- unique(complaints.for.year %>% filter(Incident.type == "Rank Initiated") %>% select(FIT.Number, Month.occurred))

citizen.complaints.by.month <- citizen.complaints %>% group_by(Month.occurred) %>% summarize(num.complaints = n())
rank.complaints.by.month <- rank.complaints %>% group_by(Month.occurred) %>% summarize(num.complaints = n())

df <- data.frame(month = months, 
                 citizen.complaints.by.month = citizen.complaints.by.month$num.complaints, 
                 rank.complaints.by.month = rank.complaints.by.month$num.complaints)

p.complaints.by.month <- plot_ly(df, x = ~month, y = ~citizen.complaints.by.month, name = 'Citizen complaints', type = 'scatter', 
             mode = 'lines+markers', 
             line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'solid')) %>%
  
  add_trace(y = ~rank.complaints.by.month, name = 'Rank complaints', 
            mode = 'lines+markers',
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid')) %>%
  
  layout(title = title, 
         xaxis = list(categoryorder = "array",
                                     categoryarray = months,
                                     title = "Month", 
                                     showgrid = F), 
         yaxis = list(title = 'Num complaints'))

p.complaints.by.month
