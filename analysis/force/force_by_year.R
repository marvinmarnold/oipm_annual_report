check.vars(c("year", "uof.all"))
title <- "UOF & FTN by year"

# Analyze years 2016 - 2017
first.year <- 2011
years <- first.year:year

iapro.access.starts.year <- 2016

# UOF by year
## Previous values taken from annual reports, 2011 - 2016
ftn.previous <- c(302, 306, 421, 409, 724, 589, NA)
uof.previous <- c(NA, NA, 725, 706, 1071, 1563, NA)

########################################################################################################
########################################################################################################

# Count total FTN by year. Replace 0 with NA
ftn.by.year <- uof.all %>% select(FIT.Number, year.of.record) %>% group_by(year.of.record) %>% distinct()
count.ftn.by.year <- ftn.by.year %>% summarise(num = n())
count.ftn.by.year <- merge(
  data.frame(year = years), 
  count.ftn.by.year, 
  by.x = "year", 
  by.y = "year.of.record", 
  all.x = TRUE)

# This hints that 2015 isn't acutally available in IAPro.
opendata.ftn.by.year <- nopd.opendata.uof %>% select(PIB.File.Number, year.of.record) %>% group_by(year.of.record) %>% distinct()
count.opendata.ftn.by.year <- opendata.ftn.by.year %>% summarise(num = n())
count.opendata.ftn.by.year <- merge(
  data.frame(year = years), 
  count.opendata.ftn.by.year, 
  by.x = "year", 
  by.y = "year.of.record", 
  all.x = TRUE)

#ftn.previous[6] <- count.opendata.ftn.by.year %>% filter(year == 2016) %>% select(num) %>% first
#ftn.previous[7] <- count.opendata.ftn.by.year %>% filter(year == 2017) %>% select(num) %>% first

# Count total UOF by year. Replace 0 with NA 
uof.by.year <- uof.all %>% group_by(year.of.record)
count.uof.by.year <- uof.by.year %>% summarise(num = n())
count.uof.by.year <- merge(
  data.frame(year = years), 
  count.uof.by.year, 
  by.x = "year", 
  by.y = "year.of.record", 
  all.x = TRUE)

uof.opendata.by.year <- nopd.opendata.uof %>% group_by(year.of.record)
count.opendata.uof.by.year <- uof.opendata.by.year %>% summarise(num = n())
count.opendata.uof.by.year <- merge(
  data.frame(year = years), 
  count.opendata.uof.by.year, 
  by.x = "year", 
  by.y = "year.of.record", 
  all.x = TRUE)

#uof.previous[6] <- count.opendata.uof.by.year %>% filter(year == 2016) %>% select(num) %>% first
#uof.previous[7] <- count.opendata.uof.by.year %>% filter(year == 2017) %>% select(num) %>% first


## IAPro starts in 2016 so have to use historic data until 2015
#copy.to.index <- iapro.access.starts.year - first.year + 1
#ftn.by.year <- count.ftn.by.year$num
#uof.by.year <- count.uof.by.year$num
#ftn.by.year[1:copy.to.index] <- ftn.previous[1:copy.to.index]
#uof.by.year[1:copy.to.index] <- uof.previous[1:copy.to.index]

# 2015 data isn't valid
ftn.oipm <- count.ftn.by.year$num
ftn.oipm[5] <- NA
uof.oipm <- count.uof.by.year$num
uof.oipm[5] <- NA

ftn.data.nola <- count.opendata.ftn.by.year$num
uof.data.nola <- count.opendata.uof.by.year$num

# Add all data to summary
annual.summary <- rbind(
  years = years,
  ftn.previous = ftn.previous, 
  ftn.oipm = ftn.oipm, 
  uof.previous = uof.previous, 
  uof.oipm = uof.oipm,
  uof.data.nola = uof.data.nola,
  ftn.data.nola = ftn.data.nola)

annual.summary <- data.frame(annual.summary)
colnames(annual.summary) <- years

p.force.by.year <- plot_ly(annual.summary, x = ~years, 
                         # Start with FTN according to NOPD
                         y = ~ftn.previous, name = 'FTN NOPD reports', 
                         type = 'scatter', 
                         mode = 'lines+markers', 
                         line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'dash')) %>%
  
  # UOF according to NOPD
  add_trace(y = ~uof.previous, name = 'UOF NOPD reports', 
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'dash'), 
            mode = 'lines+markers') %>%
  
  # FTN according to OIPM
  add_trace(y = ~ftn.oipm, name = 'FTN OIPM Analysis', 
            mode = 'lines+markers', 
            line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'solid')) %>%
  
  # FTN according to data.nola.gov
  add_trace(y = ~ftn.data.nola, name = 'FTN data.nola.gov', 
            mode = 'lines+markers', 
            line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'dot')) %>%
  
  # UOF according to OIPM
  add_trace(y = ~uof.oipm, name = 'UOF OIPM Analysis', 
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid'), 
            mode = 'lines+markers') %>%
  
  # UOF according to data.nola.gov
  add_trace(y = ~uof.data.nola, name = 'UOF data.nola.gov', 
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'dot'), 
            mode = 'lines+markers') %>%
  
  # Add vertical line showing the year IAPro started being used
  add_segments(name = "First year DB access",
               x = iapro.access.starts.year, 
               xend = iapro.access.starts.year, 
               y = 0, yend = 2500, 
               line = list(color = 'rgb(229, 221, 59)', dash = 'solid')) %>%

  layout(xaxis = list(title = "Year", 
                      autosize = FALSE,
                      ticks = "outside",
                      tick0 = 0,
                      dtick = 1,
                      ticklen = 5,
                      tickwidth = 2,
                      tickcolor = toRGB("blue"),
                      showgrid = F,
                      range = years),
         
         yaxis = list(title = "Number UOF or FTN", 
                      range = c(0, 2500), 
                      tick0 = 0,
                      showgrid = T),
         hovermode = 'compare', 
         margin = list( b = 200))
  
p.force.by.year

