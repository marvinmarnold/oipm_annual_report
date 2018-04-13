# Global constants

# Working directory
wd <- "/media/sf_oipm/code/repo" 

# File with all bookings
stopsFile <- "data/data.nola.gov/stops_20180406.csv"

# The year to analyze
year <- 2017 

########################################################################################################
########################################################################################################

# Set wor
# Set working directory
setwd(wd)

# Load libraries
library(plotly)
library(dplyr)
library(tidyr)

# Actual keys stored in .Rkeys
# Sys.setenv("plotly_username"="")
# Sys.setenv("plotly_api_key"="")

########################################################################################################
########################################################################################################

# Read data
stopsAll <- read.csv(stopsFile)

# How the date is formatted
dateFormat <- "%d/%m/%Y %I:%M:%S %p"

# Parse date-time into year, date, day, and time
stopsAll <- stopsAll %>% mutate(
  event.year = sapply(EventDate, function (date) format(as.Date(date, format=dateFormat), "%Y")),
  event.month = sapply(EventDate, function (date) format(as.Date(date, format=dateFormat), "%b")),
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
  stopsAll <- stopsAll %>% extract(ActionsTaken, c(action), regex.for.action, remove = FALSE)
}

# 2017 analysis
stops2017 <- stopsAll %>% filter(event.year == year)

# Write data to file
# write.csv(stopsAll, file = "data/data.nola.gov/Stops_DataNolaCom_Cleaned_20180406.csv")
