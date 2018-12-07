check.vars(c("oipm.survey.csv"))

########################################################################################################
########################################################################################################

survey.questions <- c(
  "Concerned.with.homicide.investigations",
  "Concerned.with.treatment.of.juveniles",
  "Concerned.with.response.time",
  "Concerned.with.human.rights",
  "Concerned.with.crime.victim",
  "Concerned.other",
  "If.monitor.bad.apples",
  "If.monitor.help.public",
  "If.monitor.help.leadership",
  "If.monitor.communicate.success",
  "If.monitor.other")


head(oipm.survey)
colnames(oipm.survey)

oipm.survey.concerned <- data.frame(
  response.time = sum(oipm.survey$Concerned.with.response.time != ""),
  homicide = sum(oipm.survey$Concerned.with.homicide.investigations != ""),
  juveniles = sum(oipm.survey$Concerned.with.treatment.of.juveniles != ""),
  human.rights = sum(oipm.survey$Concerned.with.human.rights != ""),
  victim = sum(oipm.survey$Concerned.with.crime.victim != ""),
  other = sum(oipm.survey$Concerned.other != "")
)
oipm.survey.concerned <- data.frame(
  question = rownames(t(oipm.survey.concerned)),
  answered.yes = as.numeric(oipm.survey.concerned[1,])
)

oipm.survey.if.monitor <- data.frame(
  bad.apples = sum(oipm.survey$If.monitor.bad.apples != ""),
  help.public = sum(oipm.survey$If.monitor.help.public != ""),
  help.leadership = sum(oipm.survey$If.monitor.help.leadership != ""),
  communicate.success = sum(oipm.survey$If.monitor.communicate.success != ""),
  other = sum(oipm.survey$If.monitor.other != "")
)
oipm.survey.if.monitor <- data.frame(
  question = rownames(t(oipm.survey.if.monitor)),
  answered.yes = as.numeric(oipm.survey.if.monitor[1,])
)
oipm.survey.if.monitor

p.survey.concerned <- plot_ly(oipm.survey.concerned, x = ~question, y = ~answered.yes, type = "bar") %>%
  layout(
    xaxis = list(title=FALSE),
    yaxis = list(title=FALSE),
    margin = list(b=250)
  )
p.survey.concerned

p.survey.if.monitor <- plot_ly(oipm.survey.if.monitor, x = ~question, y = ~answered.yes, type = "bar") %>%
  layout(
    xaxis = list(title=FALSE),
    yaxis = list(title=FALSE),
    margin = list(b=250)
  )
p.survey.if.monitor

