check.vars(c("year", "allegations.all", "complaints.for.year", "allegations.for.year"))
title <- "Complaints and allegations by year"

# Taken from 2016 annual report
num.reported.complaints.2016 <- 850
num.reported.allegations.2016 <- 1821
num.reported.complaints.2017 <- 734
num.reported.allegations.2017 <- 1505
########################################################################################################
########################################################################################################
# Get 2017 counts
num.complaints.2017 <- complaints.for.year %>% nrow
num.allegations.2017 <- allegations.for.year %>% nrow

allegations.2016 <- allegations.all %>% filter(grepl("^2016", PIB.Control.Number))
complaints.2016 <- allegations.2016 %>% select(PIB.Control.Number, Incident.type) %>% distinct

num.calculated.complaints.2016 <- complaints.2016 %>% nrow
num.calculated.allegations.2016 <- allegations.2016 %>% nrow

# Percent of complaints / allegations initiated by citizens
pct.citizen.complaints.2016 <- complaints.2016 %>% filter(Incident.type == "Public Initiated") %>% nrow / 
  num.calculated.complaints.2016 * 100

pct.citizen.complaints.2017 <-complaints.for.year %>% filter(Incident.type == "Public Initiated") %>% nrow / 
  num.complaints.2017 * 100
  
pct.citizen.allegations.2016 <- allegations.2016 %>% filter(Incident.type == "Public Initiated") %>% nrow / 
  num.calculated.allegations.2016 * 100

pct.citizen.allegations.2017 <-allegations.for.year %>% filter(Incident.type == "Public Initiated") %>% nrow / 
  num.allegations.2017 * 100
  
# Construct vectors
complaints.calculated <- c(num.calculated.complaints.2016, num.complaints.2017)
allegations.calculated <- c(num.calculated.allegations.2016, num.allegations.2017)
complaints.nopd <- c(num.reported.complaints.2016, num.reported.complaints.2017)
allegations.nopd <- c(num.reported.allegations.2016, num.reported.allegations.2017)
pct.citizen.complaints <- c(pct.citizen.complaints.2016, pct.citizen.complaints.2017)
pct.citizen.allegations <- c(pct.citizen.allegations.2016, pct.citizen.allegations.2017)

# Add all data to summary table
annual.summary <- data.frame(
  complaints.calculated = complaints.calculated, 
  allegations.calculated = allegations.calculated, 
  complaints.nopd = complaints.nopd, 
  allegations.nopd = allegations.nopd,
  pct.citizen.complaints = pct.citizen.complaints,
  pct.citizen.allegations = pct.citizen.allegations,
  years = c(2016, 2017))

# Plot allegations
p.allegations.by.year <- plot_ly(annual.summary, x = ~years, 
                           # Start with complaints according to NOPD
                           y = ~allegations.nopd, 
                           name = 'Allegations from NOPD', 
                           type = 'bar', 
                           marker = list(color = 'rgb(22, 296, 167)')) %>%
  
  # Allegations according to OIPM
  add_trace(y = ~allegations.calculated, name = 'Allegations OIPM Analysis', 
            marker = list(color = 'rgb(205, 12, 240)')) %>%
  
  # Single line for % allegations by citizen
  add_trace(y = ~pct.citizen.allegations,
            name = "% citizen allegations", 
            yaxis = 'y2',
            type = "scatter",
            mode = 'lines+markers',
            line = list(color = 'rgb(0, 0, 0)', width = 2, dash = 'solid')) %>%
  
  layout(xaxis = list(title = "Year", 
                      ticks = "outside",
                      tickcolor = toRGB("blue"),
                      tick0 = 2016,
                      dtick = 1,
                      showgrid = F),
         
         yaxis = list(title = "Number allegations", 
                      showgrid = T),
         hovermode = 'compare',
         barmode = 'group',
         margin = list( b = 50),
         
         yaxis2 = list(side = 'right', overlaying = "y", 
                       title = "Percent allegations initiated by citizens", 
                       range = c(0, 100), showgrid = F))

p.allegations.by.year

########################################################################################################
########################################################################################################
# Plot complaints

p.complaints.by.year <- plot_ly(annual.summary, x = ~years, 
                                 # Start with complaints according to NOPD
                                 y = ~complaints.nopd, 
                                 name = 'Complaints from NOPD', 
                                 type = 'bar', 
                                 marker = list(color = 'rgb(22, 296, 167)')) %>%
  
  # Complaints according to OIPM
  add_trace(y = ~complaints.calculated, name = 'Complaints OIPM Analysis', 
            marker = list(color = 'rgb(22, 96, 167)')) %>%
  
  # Single line for % allegations by citizen
  add_trace(y = ~pct.citizen.complaints,
            name = "% citizen complaints", 
            yaxis = 'y2',
            type = "scatter",
            mode = 'lines+markers',
            line = list(color = 'rgb(0, 0, 0)', width = 2, dash = 'solid')) %>%
  
  layout(xaxis = list(title = "Year", 
                      ticks = "outside",
                      tickcolor = toRGB("blue"),
                      dtick = 1,
                      tick0 = 2016,
                      showgrid = F),
         
         yaxis = list(title = "Number complaints", 
                      showgrid = T),
         hovermode = 'compare',
         barmode = 'group',
         margin = list( b = 50),
         
         yaxis2 = list(side = 'right', overlaying = "y", 
                       title = "Percent allegations initiated by citizens", 
                       range = c(0, 100), showgrid = F))

p.complaints.by.year

