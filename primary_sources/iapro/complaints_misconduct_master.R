check.vars(c("year", "complaints.misconduct.alleg.act.csv"))

########################################################################################################
########################################################################################################

# Read data
complaints.misconduct.all <- read.csv(complaints.misconduct.alleg.act.csv)

# 2017 analysis
complaints.alleg.act.for.year <- complaints.misconduct.all %>% 
  filter(Year.occurred == year)

unique(complaints.alleg.act.for.year$Allegation.finding)
distinct(complaints.alleg.act.for.year %>% select(FIT.Number, Officer.primary.key, Citizen.primary.key, Allegation, Action.taken))

allegations.for.year <- complaints.alleg.act.for.year %>% 
  select(FIT.Number, Officer.Race, Disposition.OIPM, Officer.primary.key, Allegation, Allegation.class, Officer.sex) %>% 
  distinct()

complaints.all <- complaints.misconduct.all %>% 
  filter(Year.occurred == year, Incident.type == "Citizen Initiated")

misconduct.alleg.act.for.year <- complaints.misconduct.all %>% 
  filter(Year.occurred == year, Incident.type == "Rank Initiated")

misconduct.alleg.act <- rbind(complaints.alleg.act.for.year, misconduct.alleg.act.for.year)

# Print disposition normalization
dispositions <- unique(misconduct.alleg.act %>% select(Status, Disposition.Reported, Disposition.OIPM, Disposition.NOPD))
# write.csv(dispositions, "disposition_conversion.csv")