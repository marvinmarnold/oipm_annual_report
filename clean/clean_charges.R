check.vars(c("bookings.for.year", "year", "charges.csv.dirty"))

# Two different ways to change encoding from 8859 to UTF-8
# iconv -f ISO_8859-1 -t UTF-8 JFI12M.TXT> JFI12M_SANITIZED.TXT
# sed -e 's/<A6>/A/g' JFI12M.TXT > JFI12M_SANITIZED.TXT

charge.names <- c("Folder number", "Item number", "Statute", "Violation", "SubP", "Verbage", "Counts", "Bond Amt", 
              "Sentence Type", "Sentence Date", "Sentence Yrs", "Sentence Mos", "Sentence Dys", "Sentence Oth", 
              "Good Time Date", "Flat Time Date", "Early Release Day", "Expired Date", "Details", 
              "Fel/Mis/City/Traf", "FBI Code", "Category", "UCR Code", "Disposition",
              "Court Type", "Court Section", "Court Date", "Court Time", "Court time am/pm",
              "Arrest district", "Arrest credit", "Arrest credit descr")

########################################################################################################
########################################################################################################

charges.all <- read.fwf(charges.csv.dirty,
                        col.names = charge.names,
                        fileEncoding = "ISO_8859-1",
                        header = FALSE,
                        comment.char="",
                        strip.white = TRUE,
                        widths=c(9, 10, 6, 12, 5, 50, 3, 9, 4, 8, 3, 3, 3, 7, 8, 8, 8, 8, 50, 1, 2, 1, 2, 12, 3, 1, 8, 4, 2, 5, 2, 40),
                        stringsAsFactors = FALSE)

charges.all <- merge(charges.all, bookings.all, by = "Folder.number") %>% mutate(
  Arrest.district = as.integer(Arrest.district),
  Folder.number = vdigest(Folder.number)
)

charges.for.year <- charges.all %>% 
  filter(In.Year == year) %>% 
  select(
    Arrest.district,
    Folder.number,
    Race)

# Uncomment to create a new file that does not contain sensitive information
write.csv(charges.for.year, file = "data_public/clean/charges_2017_clean.csv")
