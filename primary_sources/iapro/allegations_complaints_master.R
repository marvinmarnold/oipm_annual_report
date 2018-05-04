check.vars(c("year", "allegations.csv"))

########################################################################################################
########################################################################################################

# Read data
allegations.all <- read.csv(allegations.csv)
#allegations.all <- allegations.all %>% filter(Allegation.final.disposition != "NFIM CASE")

# 2017 analysis
allegations.for.year <- allegations.all %>% filter(grepl("2017", PIB.Control.Number))

# Complaints with the same FIT.Number shuold have the same disposition and assignment, so should be 
# effectively the same as getting allegations by unique FIT number
complaints.for.year <- allegations.for.year %>% 
  select(PIB.Control.Number, Disposition.NOPD, Disposition.OIPM.by.officer, Assigned.department, Assigned.division, Assigned.unit, 
         Incident.type, Month.occurred) %>% 
  distinct

# Print disposition normalization
#dispositions <- unique(complaints.for.year %>% select(FIT.Number, Status, All.Findings, Disposition.OIPM, Disposition.NOPD))
#write.csv(dispositions, "disposition_conversion.csv")