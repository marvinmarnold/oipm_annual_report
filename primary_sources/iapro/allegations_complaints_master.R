check.vars(c("year", "allegations.csv"))

########################################################################################################
########################################################################################################

# Read data
allegations.all <- read.csv(allegations.csv)

# 2017 analysis
allegations.for.year <- allegations.all %>% filter(Year.occurred == year)

# Complaints with the same FIT.Number shuold have the same disposition and assignment, so should be 
# effectively the same as getting allegations by unique FIT number
complaints.for.year <- allegations.for.year %>% 
  select(FIT.Number, Disposition.NOPD, Disposition.OIPM, Assigned.department, Assigned.division, Assigned.unit, Incident.type, Month.occurred) %>% 
  distinct

# Print disposition normalization
#dispositions <- unique(complaints.for.year %>% select(FIT.Number, Status, All.Findings, Disposition.OIPM, Disposition.NOPD))
#write.csv(dispositions, "disposition_conversion.csv")
