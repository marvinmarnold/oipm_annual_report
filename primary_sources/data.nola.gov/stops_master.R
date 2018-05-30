check.vars(c("stops.csv", "year"))

# How the date is formatted
dateFormat <- "%d/%m/%Y %I:%M:%S %p"

########################################################################################################
########################################################################################################

# Read data
stops.all <- read.csv(stops.csv, stringsAsFactors = FALSE)

# Parse date-time into year, date, day, and time
stops.all <- stops.all %>% mutate(
  event.year = sapply(EventDate, function (date) format(as.Date(date, format=dateFormat), "%Y")),
  event.month = sapply(EventDate, function (date) format(as.Date(date, format=dateFormat), "%b")),
  month = match(event.month, months),
  event.date = sapply(EventDate, function (date) format(as.Date(date, format=dateFormat),"%b %d, %Y")),
  event.day = sapply(EventDate, function (date) weekdays(as.Date(date, format=dateFormat))),
  event.time = sapply(EventDate, function (date) format(as.Date(date, format=dateFormat),"%I:%M:%S %p")),
  event.time.24 = sapply(EventDate, function (date) format(as.Date(date, format=dateFormat),"%H:%M:%S"))
)

# Parse Actions Taken column into multiple columns
possible.actions <- c(
  "Stop Results", 
  "Subject Type", 
  "Search Occurred", 
  "Evidence Seized", 
  "Consent To Search", 
  "Exit Vehicle",
  "Search Type Pat Down",
  "Search Types",
  "Consent Form Completed",
  "Legal Basises",
  "Evidence Types",
  "StripBody Cavity Search")

# Add a column for each possible action
# Can't extract all columns at the same time because the ActionsTaken column does not always contain the same values
# Instead, we loop over all the possible actions and extract a column for each individually
for (action in possible.actions) {
  regex.for.action <- paste(action, ": ([\\w\\s]*)", sep = "")
  stops.all <- stops.all %>% extract(ActionsTaken, c(action), regex.for.action, remove = FALSE)
}

normalize.race <- function(race) {
  if (race == 'ASIAN') {
    return(asian)
  } else if (race == 'BLACK') {
    return(black)
  } else if (race == 'WHITE') {
    return(white)
  } else if (race == 'HISPANIC') {
    return(hispanic)
  } else if (race == 'AMER. IND.') {
    return(native)
  } else {
    return(unknown.race)
  }
}

stops.all <- stops.all %>% mutate(
  SubjectRace = sapply(SubjectRace, normalize.race)
)

# 2017 analysis
stops.for.year <- stops.all %>% filter(event.year == year)

# Write data to file
write.csv(stops.for.year, file = "data_public/data.nola.gov/stops_2017.csv")
