# Reset environment
rm(list = ls())

# Load force data
source("iapro/uof_ftn_master.R")

# Load booking data
source("opso/bookings_master.R")

# Load stops data
source("data.nola.gov/stops_master.R")

title <- "Stops v Bookings v Force"

########################################################################################################
########################################################################################################

months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
uof.by.month <- uof2017 %>% group_by(Month.occurred) %>% summarize(num.uof = n())
ftn.by.month <- ftn2017 %>% group_by(which(months == month)) %>% summarize(num.ftn = n())
bookings.by.month <- bookings2017 %>% group_by(In.Month) %>% summarize(num.bookings = n())

# Convert stop month names to integers
stops.w.month.num <- stops2017 %>% mutate(month.num = sapply(event.month, function(event.month) which(event.month == months)))
stops.by.month <- stops.w.month.num %>% group_by(month.num) %>% summarize(num.stops = n())

df <- data.frame(month = months, 
                 uof.by.month = uof.by.month$num.uof, 
                 ftn.by.month = ftn.by.month$num.ftn,
                 stops.by.month = stops.by.month$num.stops,
                 bookings.by.month = bookings.by.month$num.bookings)

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
  
  add_trace(y = ~stops.by.month, name = 'Stops by month', 
            mode = 'lines+markers',
            line = list(color = 'rgb(0, 255, 24)', width = 2, dash = 'solid')) %>%
  
  add_trace(y = ~bookings.by.month, name = 'Bookings by month', 
            mode = 'lines+markers',
            line = list(color = 'rgb(204, 12, 204)', width = 2, dash = 'solid')) %>%
  
  layout(title = title, xaxis = xform, yaxis = list(title = 'Num instance'))

p
api_create(p, filename=title, sharing = "public")
