check.vars(c("uof.for.year", "bookings.for.year", "stops.for.year", "districts.by.race"))
title <- paste("Force, Bookings, & Stops of Black people by month in", year)

########################################################################################################
########################################################################################################
# By month

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
  
  # Add horizontal line showing black pop in new orleans
  add_segments(name = "Black population of NO",
               x = 0, xend = 13, 
               y = 61, yend = 61, 
               line = list(color = 'rgb(229, 221, 59)', dash = 'solid')) %>%
  
  layout(title = title, xaxis = list(
      dtick = 1
    ),
    yaxis = list(title = 'Percent against black people'))

p.black.by.month

########################################################################################################
########################################################################################################
# By district

# Group by month and race
uof.by.district <- uof.for.year %>% filter(District.or.division %in% districts) %>% group_by(District.or.division, Citizen.race)

bookings.by.district <- charges.for.year %>% 
  select(Folder.number, Race, Arrest.district) %>% 
  filter(Arrest.district %in% 1:8) %>%
  distinct %>% 
  group_by(Arrest.district, Race)

stops.by.district <- stops.for.year %>% group_by(District, SubjectRace)

# Count items in each group
count.uof.by.district <- uof.by.district %>% summarise(count = n())
count.bookings.by.district <- bookings.by.district %>% summarise(count = n())
count.stops.by.district <- stops.by.district %>% summarise(count = n())

# Count totals for each group
total.uof.by.district <- count.uof.by.district %>% group_by(District.or.division) %>% summarise(total = sum(count))
total.bookings.by.district <- count.bookings.by.district %>% group_by(Arrest.district) %>% summarise(total = sum(count))
total.stops.by.district <- count.stops.by.district %>% group_by(District) %>% summarise(total = sum(count))

# Add total to every row
count.uof.by.district <- merge(count.uof.by.district, total.uof.by.district, by = "District.or.division")
count.bookings.by.district <- merge(count.bookings.by.district, total.bookings.by.district, by = "Arrest.district")
count.stops.by.district <- merge(count.stops.by.district, total.stops.by.district, by = "District")

# Add percentage of each subgroup of group
count.uof.by.district <- count.uof.by.district %>% mutate(
  pct = count / total * 100
)
count.bookings.by.district <- count.bookings.by.district %>% mutate(
  pct = count / total * 100
)
count.stops.by.district <- count.stops.by.district %>% mutate(
  pct = count / total * 100
)

# Get data for black people
black.uof.by.district <- count.uof.by.district %>% filter(Citizen.race == black)
black.bookings.by.district <- count.bookings.by.district %>% filter(Race == black)
black.stops.by.district <- count.stops.by.district %>% filter(SubjectRace == black)
pct.black.by.district <- districts.by.race %>% filter(race == black)

# Put it all together
black.by.district <- data.frame(
  population = pct.black.by.district$pct.race.in.district,
  district = black.uof.by.district$District.or.division,
  uof = black.uof.by.district$pct,
  bookings = black.bookings.by.district$pct,
  stops = black.stops.by.district$pct
)

p.black.by.district <- plot_ly(black.by.district, 
                              x = ~district, 
                              y = ~population, 
                              type = 'bar', 
                              name = "% black pop. by district") %>%
  
  add_trace(y = ~stops, name = "% stops are of black ppl by district") %>%
  
  add_trace(y = ~bookings, name = "% bookings are of black ppl by district") %>%
  
  add_trace(y = ~uof, name = "% force against black ppl by district") %>%
  
  layout(
    margin = list(b = 150),
    xaxis = list(
      categoryorder = "array",
      categoryarray = districts,
      title = "District"
    ),
    legend = list(x = 0, y = -.50),
    hovermode = 'compare',
    yaxis = list(title = 'Percent black', dtick = 10), 
    barmode = 'group')

p.black.by.district



