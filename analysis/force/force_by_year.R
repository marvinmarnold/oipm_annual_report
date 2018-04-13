check.vars(c("year", "uof.all"))
title <- "UOF & FTN by year"

# Analyze years 2015 - 2018
years <- 2011:2017

# UOF by year
## Previous values taken from annual reports
ftn.previous <- c(302, 306, 421, 409, 724, 589, 0)
uof.previous <- c(NA, NA, 725, 706, 1071, 1563, 0)

########################################################################################################
########################################################################################################

ftn.by.year <- sapply(years, function (year) {
    nrow(unique(uof.all %>% filter(Year.reported == year) %>% select(FIT.Number)))
  })
                      
uof.by.year <- sapply(years, function (year) {
  nrow(uof.all %>% filter(Year.reported == year))
})

## IAPro starts in 2015 so have to use historic data
ftn.by.year[1:4] <- ftn.previous[1:4]
uof.by.year[1:4] <- uof.previous[1:4]

## There are no previous values for 2017
ftn.previous[7] <- ftn.by.year[7]
uof.previous[7] <- uof.by.year[7]

# Add all data to summary
annual.summary <- data.frame(uof.now = uof.by.year, uof.reported = uof.previous, ftn.now = ftn.by.year, ftn.reported = ftn.previous)
rownames(annual.summary) <- years

annual.summary <- rbind(ftn.previous, ftn.by.year, uof.previous, uof.by.year)
colnames(annual.summary) <- years
annual.summary <- data.frame(annual.summary)

force.by.year <- plot_ly(annual.summary, x = years, y = ~ftn.previous, name = 'FTN Already Reported', type = 'scatter', mode = 'lines+markers', line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'dash')) %>%
  add_trace(y = ~uof.previous, name = 'UOF Already Reported', line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'dash'), mode = 'lines+markers') %>%
  add_trace(y = ~ftn.by.year, name = 'FTN Current Analysis', mode = 'lines+markers', line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'solid')) %>%
  add_trace(y = ~uof.by.year, name = 'UOF Current Analysis', line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid'), mode = 'lines+markers') %>%
  layout(xaxis = list(title = "Year", showgrid = T), yaxis = list(title = "Number UOF or FTN"))

force.by.year
#api_create(p, filename=title, sharing = "public")

