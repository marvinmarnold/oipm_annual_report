rel.allegs <- allegations.all %>% filter(year.of.record >= 2016, year.of.record < 2018)
allegations.all %>% select(year.plus.month) %>% distinct
colnames(allegations.all)

citizen.allegations <- rel.allegs %>% filter(Incident.type == "Public Initiated")
rank.allegations <- rel.allegs %>% filter(Incident.type == "Rank Initiated")

citizen.allegations.by.month <- citizen.allegations %>% group_by(year.plus.month) %>% summarize(num.allegations = n())
rank.allegations.by.month <- rank.allegations %>% group_by(year.plus.month) %>% summarize(num.allegations = n())

df <- data.frame(month = 1:25, 
                 citizen.allegations.by.month = citizen.allegations.by.month$num.allegations, 
                 rank.allegations.by.month = rank.allegations.by.month$num.allegations)

p.allegations.by.month <- plot_ly(df, x = 1:25, y = ~citizen.allegations.by.month, name = 'Public allegations', type = 'scatter', 
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
chart_link = api_create(p.allegations.by.month, filename="allegations by month")
chart_link
