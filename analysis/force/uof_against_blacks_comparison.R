check.vars(c("uof.for.year", "bookings.for.year", "stops.for.year"))
title <- "Force, Bookings, and Stops of Black people by month"

########################################################################################################
########################################################################################################

# Group by month and race
uof.by.month <- uof.for.year %>% group_by(Month.occurred, Citizen.race)
bookings.by.month <- bookings.for.year %>% group_by(In.Month, Race)
stops.by.month <- stops.for.year %>% group_by(month, SubjectRace)

# Count items in each group
count.uof.by.month <- uof.by.month %>% summarise(count = n())
count.bookings.by.month <- bookings.by.month %>% summarise(count = n())
count.stops.by.month <- stops.by.month %>% summarise(count = n())

# Count totals for each group
total.uof.by.month <- count.uof.by.month %>% group_by(Month.occurred) %>% summarise(total = sum(count))
total.bookings.by.month <- count.bookings.by.month %>% group_by(In.Month) %>% summarise(total = sum(count))
total.stops.by.month <- count.stops.by.month %>% group_by(month) %>% summarise(total = sum(count))

# Add total to every row
count.uof.by.month <- merge(count.uof.by.month, total.uof.by.month, by = "Month.occurred")
count.bookings.by.month <- merge(count.bookings.by.month, total.bookings.by.month, by = "In.Month")
count.stops.by.month <- merge(count.stops.by.month, total.stops.by.month, by = "month")


# Add percentage of each subgroup of group
count.uof.by.month <- count.uof.by.month %>% mutate(
  pct = count / total * 100
)
count.bookings.by.month <- count.bookings.by.month %>% mutate(
  pct = count / total * 100
)
count.stops.by.month <- count.stops.by.month %>% mutate(
  pct = count / total * 100
)

# Get data for black people
black.uof.by.month <- count.uof.by.month %>% filter(Citizen.race == black)
black.bookings.by.month <- count.bookings.by.month %>% filter(Race == black)
black.stops.by.month <- count.stops.by.month %>% filter(SubjectRace == black)

# Put it all together
black.by.month <- data.frame(
  month = black.uof.by.month$Month.occurred,
  uof = black.uof.by.month$pct,
  bookings = black.bookings.by.month$pct,
  stops = black.stops.by.month$pct
)

p.black.by.month <- plot_ly(black.by.month, 
                            x = ~month, 
                            y = ~uof, name = 'Force', type = 'scatter', 
                              mode = 'lines+markers', 
                              line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'solid')) %>%
  
  add_trace(y = ~bookings, name = 'Bookings / Arrests', 
            mode = 'lines+markers',
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid')) %>%
  
  add_trace(y = ~stops, name = 'Stops & Searches', 
            mode = 'lines+markers',
            line = list(color = 'rgb(0, 255, 24)', width = 2, dash = 'solid')) %>%
  
  layout(title = title, xaxis = list(
      dtick = 1
    ),
    yaxis = list(title = 'Percent against black people'))

p.black.by.month