check.vars(c("year", "allegations.for.year", "complaints.for.year"))
title <- "Allegatiosn by disposition"

########################################################################################################
########################################################################################################

# Get NOPD's 2017 allegation data
# nopd.allegations <- read.csv("data/Dante/NOPD_Allegations_With_Dispositions.csv")

# Find all dispositions where the final disposition is not the same as the finding
#dispos <- allegations.for.year %>% select(Status, Allegation.finding, Allegation.final.disposition, Allegation.Finding.OIPM) %>% 
#  distinct %>% 
#  filter(as.character(Allegation.finding) != as.character(Allegation.final.disposition))

#write.csv(dispos, file = "data/Dante/export/Allegation_Finding_DifferentThan_FinalDisposition.csv")

# Print a rubric for how OIPM uses status and allegation finding to recategorize a new finding
#allegations.rubric <- allegations.for.year %>% select(Status, Allegation.finding, Allegation.final.disposition, Allegation.Finding.OIPM) %>% distinct
#write.csv(allegations.rubric, file = "data/Dante/export/OIPM_Allegation_Finding_Rubric.csv")

#nopd.cases <- nopd.allegations %>% select(PIB.Control.Number, Disposition) %>% distinct

#case.dispositions <- merge(nopd.cases, complaints.for.year, by = 'PIB.Control.Number', all.y = TRUE)
#write.csv(case.dispositions, file = "data/Dante/export/CaseDispositionsComparision.csv")

#allegations.findings <- allegations.for.year %>% select(PIB.Control.Number, Officer.badge.number, Allegation.class, Allegation.Finding.OIPM)
#write.csv(allegations.findings, file = "data/Dante/export/OIPM_Each_Allegation_With_Finding_And_Disposition.csv")
