check.vars(c("uof.for.year", "ftn.for.year"))
title <- "Force by month"

########################################################################################################
########################################################################################################

months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
uof.by.month <- uof.for.year %>% group_by(Month.occurred) %>% summarize(num.uof = n())
ftn.by.month <- ftn.for.year %>% group_by(month) %>% summarize(num.ftn = n())
df <- data.frame(month = months, 
                 uof.by.month = uof.by.month$num.uof, 
                 ftn.by.month = ftn.by.month$num.ftn)

df <- df %>% mutate(
  uof.per.ftn = uof.by.month / ftn.by.month
)

p.force.by.month <- plot_ly(df, x = ~month, y = ~ftn.by.month, name = 'FTN', type = 'scatter', 
             mode = 'lines+markers', 
             line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'solid')) %>%

  add_trace(y = ~uof.by.month, name = 'UOF', 
            mode = 'lines+markers',
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid')) %>%
  
  add_trace(y = ~uof.per.ftn, name = "UOF per FTN", yaxis = 'y2',
            mode = 'lines+markers',
            line = list(color = 'rgb(25, 12, 24)', width = 2, dash = 'dashdot')) %>%
  
  layout(
    hovermode = 'compare',
    margin = list(b = 150),
    xaxis = list(categoryorder = "array",
                 categoryarray = months,
                 title = "Month in 2017", 
                 showgrid = F), 
    yaxis = list(title = 'Instances', showgrid = T),
    yaxis2 = list(side = 'right', overlaying = "y", title = "Avg UOF per FTN", range = c(0, 10)))

p.force.by.month
