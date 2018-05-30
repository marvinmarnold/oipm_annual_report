check.vars(c("year", "allegations.csv"))

########################################################################################################
########################################################################################################

# Read data
allegations.all <- read.csv(allegations.csv, stringsAsFactors = FALSE)
allegations.all <- allegations.all %>% mutate(
  Allegation.short = substring(trim(Allegation), 16, 999),
  Allegation.simple = case_when(
    Allegation.short == "NEGLECT OF DUTY" ~ "Neglect of duty",
    Allegation.short == "Professionalism" ~ "Professionalism",
    Allegation.short == "INSTRUCTIONS FROM AUTHORITATIVE SOURCE" ~ "Instructions from authoritative source",
    Allegation.short == "ADHERENCE TO LAW" ~ "Adherence to law",
    Allegation.short == "UNAUTHORIZED FORCE" ~ "Unauthorized force",
    Allegation.short == "COURTESY" ~ "Courtesy",
    Allegation.short == "VERBAL INTIMIDATION" ~ "Verbal intimidation",
    TRUE ~ "Other"
  )
)
#allegations.all <- allegations.all %>% filter(Allegation.final.disposition != "NFIM CASE")

# 2017 analysis
allegations.for.year <- allegations.all %>% filter(grepl("2017", PIB.Control.Number))
allegations.for.year %>% select(Allegation.short) %>% distinct

nrow(allegations.for.year)
# Function to recategorize an array of dispositions/findings to a single disposition
SelectDisp <- function(disp) {
  if (any(disp == 'Sustained')) {
    return('Sustained')
  } else if (any(disp == 'Mediation')) {
    return('Mediation')
  } else if (any(disp == 'DI-2')) {
    return('DI-2')
  } else if (any(disp == 'Pending')) {
    return('Pending')
  } else if (any(disp == 'Not Sustained')) {
    return('Not Sustained')
  } else if (any(disp == 'Unfounded')) {
    return('Unfounded')
  } else if (any(disp == 'Exonerated')) {
    return('Exonerated')
  } else if (any(disp == 'NFIM')) {
    return('NFIM')
  } else {
    return('Illegitimate outcome')
  } 
}

# Complaints with the same PIB.Control.Number shuold have the same disposition and assignment, so should be 
# effectively the same as getting allegations by unique PIB.Control.Number
complaints.by.officer.for.year <- allegations.for.year %>% 
  select(PIB.Control.Number, Disposition.OIPM.by.officer, Disposition.NOPD, Assigned.department, Assigned.division, Assigned.unit, 
         Incident.type, Month.occurred, Officer.Race) %>% 
  distinct
  
complaints.for.year <- complaints.by.officer.for.year %>% 
  select(PIB.Control.Number, Disposition.NOPD, Assigned.department, Assigned.division, Assigned.unit, 
         Incident.type, Month.occurred) %>% 
  distinct

oipm.dispositions <- complaints.by.officer.for.year %>% 
  group_by(PIB.Control.Number) %>% 
  summarise_at(c("Disposition.OIPM.by.officer"), SelectDisp)

oipm.dispositions <- rename(oipm.dispositions, Disposition.OIPM = Disposition.OIPM.by.officer)

complaints.for.year <- merge(complaints.for.year, oipm.dispositions, by = "PIB.Control.Number")
colnames(complaints.for.year)

