source("iapro/uof_ftn_master.R")
title <- "Force by month"

########################################################################################################
########################################################################################################

months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
uof.by.month <- uof2017 %>% group_by(Month.occurred) %>% summarize(num.uof = n())
ftn.by.month <- ftn2017 %>% group_by(month) %>% summarize(num.ftn = n())
df <- data.frame(month = months, 
                 uof.by.month = uof.by.month$num.uof, 
                 ftn.by.month = ftn.by.month$num.ftn)

xform <- list(categoryorder = "array",
              categoryarray = months,
              title = "Month", 
              showgrid = T)

p <- plot_ly(df, x = ~month, y = ~ftn.by.month, name = 'FTN by month', type = 'scatter', 
             mode = 'lines+markers', 
             line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'solid')) %>%

  add_trace(y = ~uof.by.month, name = 'UOF by month', 
            mode = 'lines+markers',
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid')) %>%
  
  layout(title = title, xaxis = xform, yaxis = list(title = 'Num instance'))

api_create(p, filename=title, sharing = "public")