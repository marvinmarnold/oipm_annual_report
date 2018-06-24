check.vars(c("oipm.survey.csv.dirty"))

oipm.survey <- read.csv(oipm.survey.csv.dirty, header = TRUE)

oipm.survey <- oipm.survey %>% select(
  Concerned.with.homicide.investigations,
  Concerned.with.treatment.of.juveniles,
  Concerned.with.response.time,
  Concerned.with.human.rights,
  Concerned.with.crime.victim,
  Concerned.other,
  If.monitor.bad.apples,
  If.monitor.help.public,
  If.monitor.help.leadership,
  If.monitor.communicate.success,
  If.monitor.other
)

write.csv(oipm.survey, file = "data_public/clean/oipm_survey_clean.csv")
