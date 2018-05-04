check.vars(c("year", "allegations.for.year"))
title <- "Allegatiosn by disposition"

########################################################################################################
########################################################################################################

nopd.allegations <- read.csv("data/Dante/NOPD_Allegations_With_Dispositions.csv")

dispos <- allegations.for.year %>% select(Status, Allegation.finding, Allegation.final.disposition, Allegation.Finding.OIPM) %>% 
  distinct %>% 
  filter(as.character(Allegation.finding) != as.character(Allegation.final.disposition))

write.csv(dispos, file = "data/Dante/export/Allegation_Finding_DifferentThan_FinalDisposition.csv")

allegations.rubric <- allegations.for.year %>% select(Status, Allegation.finding, Allegation.final.disposition, Allegation.Finding.OIPM) %>% distinct
write.csv(allegations.rubric, file = "data/Dante/export/OIPM_Allegation_Finding_Rubric.csv")

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

oipm.cases <- allegations.for.year %>% select(PIB.Control.Number, Disposition.OIPM.by.officer) %>% distinct
oipm.cases <- oipm.cases %>% group_by(PIB.Control.Number) %>% summarise_at(c("Disposition.OIPM.by.officer"), SelectDisp) %>% distinct
oipm.cases <- rename(oipm.cases, Disposition.OIPM = Disposition.OIPM.by.officer)
nrow(oipm.cases)
nopd.cases <- nopd.allegations %>% select(PIB.Control.Number, Disposition) %>% distinct
nrow(nopd.cases)

case.dispositions <- merge(nopd.cases, oipm.cases, by = 'PIB.Control.Number', all.y = TRUE)
nrow(case.dispositions)
write.csv(case.dispositions, file = "data/Dante/export/CaseDispositionsComparision.csv")

allegations.findings <- allegations.for.year %>% select(PIB.Control.Number, Officer.badge.number, Allegation.class, Allegation.Finding.OIPM)
allegations.findings <- merge(allegations.findings, oipm.cases, by = "PIB.Control.Number")
write.csv(allegations.findings, file = "data/Dante/export/OIPM_Each_Allegation_With_Finding_And_Disposition.csv")
