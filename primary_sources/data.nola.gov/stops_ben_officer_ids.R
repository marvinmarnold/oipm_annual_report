# Ben gave jakob two stop and search exports with officer IDS

# Global constants

# Working directory
wd <- "/media/sf_oipm/code/repo" 

# File with all bookings
benStops2016File <- "data/Ben/FIC_2016.csv"
benStops2017File <- "data/Ben/FIC_2017.csv"

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
benStops2016 <- read.csv(benStops2016File)
benStops2017 <- read.csv(benStops2017File)
benStopsAll <- rbind(benStop2016, benStop2017)

# How the date is formatted
dateFormat <- "%Y-%m-%d %H:%M:%S"

# Parse date-time into year, date, day, and time
benStopsAll <- benStopsAll %>% mutate(
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
  benStopsAll <- benStopsAll %>% extract(ActionsTaken, c(action), regex.for.action, remove = FALSE)
}

# Write data to file
write.csv(benStopsAll, file = "data/Ben/BenStops20162017_DataNolaCom_Cleaned_20180406.csv")
