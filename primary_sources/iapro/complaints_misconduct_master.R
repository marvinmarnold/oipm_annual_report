check.vars(c("year", "complaints.csv"))

########################################################################################################
########################################################################################################

# Read data
complaints.all <- read.csv(complaints.csv)

# 2017 analysis
complaints.for.year <- complaints.all %>% filter(Year.occurred == year)

# Print disposition normalization
dispositions <- unique(complaints.for.year %>% select(FIT.Number, Status, All.Findings, Disposition.OIPM, Disposition.NOPD))
write.csv(dispositions, "disposition_conversion.csv")
