check.vars(c("year", "uof.all"))
title <- "UOF & FTN by year"

# Analyze years 2015 - 2017
years <- 2011:year

iapro.year <- 2015

# UOF by year
## Previous values taken from annual reports
ftn.previous <- c(302, 306, 421, 409, 724, 589, NA)
uof.previous <- c(NA, NA, 725, 706, 1071, 1563, NA)

########################################################################################################
########################################################################################################

# Count total FTN by year. Replace 0 with NA
ftn.by.year <- sapply(years, function (year) {
    num.for.year <- nrow(
      uof.all %>% 
        filter(Year.reported == year) %>% 
        select(FIT.Number) %>% 
        distinct)
    
    if (num.for.year == 0) NA else num.for.year
  })
                     
# Count total UOF by year. Replace 0 with NA 
uof.by.year <- sapply(years, function (year) {
  num.for.year <- nrow(
    uof.all %>% 
      filter(Year.reported == year))
  
  if (num.for.year == 0) NA else num.for.year
})

## IAPro starts in 2015 so have to use historic data
ftn.by.year[1:4] <- ftn.previous[1:4]
uof.by.year[1:4] <- uof.previous[1:4]

# Add all data to summary
annual.summary <- data.frame(uof.now = uof.by.year, uof.reported = uof.previous, ftn.now = ftn.by.year, ftn.reported = ftn.previous)
rownames(annual.summary) <- years

annual.summary <- rbind(ftn.previous, ftn.by.year, uof.previous, uof.by.year)
colnames(annual.summary) <- years
annual.summary <- data.frame(annual.summary)

p.force.by.year <- plot_ly(annual.summary, x = years, 
                         # Start with FTN according to NOPD
                         y = ~ftn.previous, name = 'FTN from NOPD', 
                         type = 'scatter', 
                         mode = 'lines+markers', 
                         line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'dash')) %>%
  
  # UOF according to NOPD
  add_trace(y = ~uof.previous, name = 'UOF from NOPD', 
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'dash'), 
            mode = 'lines+markers') %>%
  
  # FTN according to OIPM
  add_trace(y = ~ftn.by.year, name = 'FTN OIPM Analysis', 
            mode = 'lines+markers', 
            line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'solid')) %>%
  
  # UOF according to OIPM
  add_trace(y = ~uof.by.year, name = 'UOF OIPM Analysis', 
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid'), 
            mode = 'lines+markers') %>%
  
  # Add vertival line showing the year IAPro started being used
  add_segments(name = "First year DB access",
               x = iapro.year, xend = iapro.year, 
               y = 0, yend = 2500, 
               line = list(color = 'rgb(229, 221, 59)', dash = 'solid')) %>%

  layout(xaxis = list(title = "Year"), 
         yaxis = list(title = "Number UOF or FTN"),
         hovermode = 'compare')
  

p.force.by.year
