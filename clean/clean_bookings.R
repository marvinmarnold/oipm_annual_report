check.vars(c("bookings.csv.dirty", "year"))

# Two different ways to change encoding from 8859 to UTF-8
# iconv -f ISO_8859-1 -t UTF-8 JFI12M.TXT> JFI12M_SANITIZED.TXT
# sed -e 's/<A6>/A/g' JFI12M.TXT > JFI12M_SANITIZED.TXT

allNames <- c("Folder number", "CCN", "Name", "DOB Year", "DOB Month", "DOB Day", "Race", "Sex", 
              "In Year", "In Month", "In Day", "In time", 
              "Release Year", "Release Month", "Release Day", "Release time", "Release reason", 
              "Agency booking",
              "Building", "Tier", "Side", "Cell", "Type booking", "Gang affiliation", "Reason booking", 
              "Security level", "Ctl level", "OPSO facility", "Bond amount")

safeNames <- c("Folder.number", "DOB.Year", "DOB.Month", "DOB.Day", "Race", "Sex", 
               "In.Year", "In.Month", "In.Day", "In.time", 
               "Release.Year", "Release.Month", "Release.Day", "Release.time", "Release.reason", 
               "Agency.booking",
               "Building", "Tier", "Side", "Cell", "Type.booking", "Gang.affiliation", "Reason.booking", 
               "Security.level", "Ctl.level", "OPSO.facility", "Bond.amount")

########################################################################################################
########################################################################################################

bookings.all <- read.fwf(bookings.csv.dirty,
  col.names = allNames,
  fileEncoding = "ISO_8859-1",
  header = FALSE,
  comment.char="",
  widths=c(9, 9, 35, 4, 2, 2, 1, 1, 4, 2, 2, 6, 4, 2, 2, 6, 50, 6, 3, 2, 1, 3, 4, 20, 4, 1, 1, 6, 10))

normalize.race <- function(race) {
  if (race == 'A') {
    return(asian)
  } else if (race == 'B') {
    return(black)
  } else if (race == 'W') {
    return(white)
  } else if (race == 'H') {
    return(hispanic)
  } else if (race == 'I') {
    return(native)
  } else {
    return(unknown.race)
  }
}

bookings.all <- bookings.all %>% mutate(
  Race = as.character(Race),
  Race = sapply(Race, normalize.race)
)

bookings.for.year <- filter(bookings.all, In.Year == year) %>% 
  select(safeNames) %>% select(
    Folder.number,
    Race,
    In.Year,
    In.Month
  )

# Uncomment to create a new file that does not contain sensitive information
write.csv(bookings.for.year %>% mutate(
  Folder.number = vdigest(Folder.number)
), file = "data_public/clean/bookings_2017_clean.csv")
