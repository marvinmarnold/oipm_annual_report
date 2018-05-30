check.vars(c("year", "complaints.for.year", "allegations.for.year"))

########################################################################################################
########################################################################################################
# Complaints by month initiated by citizens vs rank

citizen.complaints <- complaints.for.year %>% filter(Incident.type == "Public Initiated")
rank.complaints <- complaints.for.year %>% filter(Incident.type == "Rank Initiated")

citizen.complaints.by.month <- citizen.complaints %>% group_by(Month.occurred) %>% summarize(num.complaints = n())
rank.complaints.by.month <- rank.complaints %>% group_by(Month.occurred) %>% summarize(num.complaints = n())

months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Unknown")

df <- data.frame(month = months, 
                 citizen.complaints.by.month = citizen.complaints.by.month$num.complaints, 
                 rank.complaints.by.month = rank.complaints.by.month$num.complaints)

p.complaints.by.month <- plot_ly(df, x = ~month, y = ~citizen.complaints.by.month, name = 'Citizen complaints', type = 'scatter', 
             mode = 'lines+markers', 
             line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'solid')) %>%
  
  add_trace(y = ~rank.complaints.by.month, name = 'Rank complaints', 
            mode = 'lines+markers',
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid')) %>%
  
  layout(title = "Complaints by month", 
         xaxis = list(categoryorder = "array",
                                     categoryarray = months,
                                     title = "Month", 
                                     showgrid = F), 
         yaxis = list(title = 'Num complaints'))

p.complaints.by.month

########################################################################################################
########################################################################################################
# Allegations by month initiated by citizens vs rank

citizen.allegations <- allegations.for.year %>% filter(Incident.type == "Public Initiated")
rank.allegations <- allegations.for.year %>% filter(Incident.type == "Rank Initiated")

citizen.allegations.by.month <- citizen.allegations %>% group_by(Month.occurred) %>% summarize(num.allegations = n())
rank.allegations.by.month <- rank.allegations %>% group_by(Month.occurred) %>% summarize(num.allegations = n())

df <- data.frame(month = months, 
                 citizen.allegations.by.month = citizen.allegations.by.month$num.allegations, 
                 rank.allegations.by.month = rank.allegations.by.month$num.allegations)

p.allegations.by.month <- plot_ly(df, x = ~month, y = ~citizen.allegations.by.month, name = 'Public allegations', type = 'scatter', 
                                 mode = 'lines+markers', 
                                 line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'solid')) %>%
  
  add_trace(y = ~rank.allegations.by.month, name = 'Rank allegations', 
            mode = 'lines+markers',
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid')) %>%
  
  layout(title = "Allegations by month", 
         xaxis = list(categoryorder = "array",
                      categoryarray = months,
                      title = "Month", 
                      showgrid = F), 
         yaxis = list(title = 'Num allegations'))

p.allegations.by.month

########################################################################################################
########################################################################################################
# Total compalints and allegations by month with average line

allegations.by.month <- allegations.for.year %>% group_by(Month.occurred) %>% summarize(num.allegations = n())
complaints.by.month <- complaints.for.year %>% group_by(Month.occurred) %>% summarize(num.allegations = n())

df <- data.frame(month = months, 
                 allegations.by.month = allegations.by.month$num.allegations, 
                 complaints.by.month = complaints.by.month$num.allegations)

df <- df %>% mutate(
  allegations.per.complaint = allegations.by.month / complaints.by.month
)

p.complaints.allegations.by.month <- plot_ly(df, x = ~month, y = ~allegations.by.month, name = 'Total allegations', type = 'scatter', 
                                  mode = 'lines+markers', 
                                  line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'solid')) %>%
  
  add_trace(y = ~complaints.by.month, name = 'Total complaints', 
            mode = 'lines+markers',
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid')) %>%
  
  add_trace(y = ~allegations.per.complaint, name = "Allegations per complaint", yaxis = 'y2',
            mode = 'lines+markers',
            line = list(color = 'rgb(25, 12, 24)', width = 2, dash = 'dashdot')) %>%
  
  layout(title = "Total complaints and allegations by month", 
         xaxis = list(categoryorder = "array",
                      categoryarray = months,
                      title = "Month", 
                      showgrid = F), 
         yaxis = list(title = 'Num allegations or complaints'),
         yaxis2 = list(side = 'right', overlaying = "y", title = "Avg allegations per complaint", range = c(0, 5)))

p.complaints.allegations.by.month

