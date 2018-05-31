check.vars(c("oipm.survey.csv"))

########################################################################################################
########################################################################################################

oipm.survey <- read.csv(oipm.survey.csv, header = TRUE)
head(oipm.survey)
oipm.survey %>% colnames

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


p.survey.pies <- lapply(survey.questions, function (question) {
  
  # Set title
  question.title <- question
  
  # How many people answered each
  oipm.survey <- oipm.survey %>% mutate(
    answered.yes = !!as.name(question) != ""
  )

  # Filter UOF by year
  num.answered.yes <- oipm.survey %>% filter(answered.yes == TRUE) %>% nrow()
  num.answered.no <- oipm.survey %>% nrow - num.answered.yes
    
  # Construct pie chart
  plot_ly(oipm.survey,  type = 'pie', name = question.title,
          labels = c("Answered yes", "Answered no"), 
          values = c(num.answered.yes, num.answered.no),
          textposition = 'inside',
          textinfo = 'label+value+percent',
          insidetextfont = list(color = '#FFFFFF')) %>%
    
    layout(hovermode = "compare", title = question.title, showlegend = FALSE)
})

p.survey.pies[[1]]
