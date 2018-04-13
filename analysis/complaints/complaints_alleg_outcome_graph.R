check.vars(c("year", "allegations.for.year"))
title <- "Allegation to Action"

########################################################################################################
########################################################################################################

alleg.act <- allegations.for.year %>% select(Allegation, Allegation.class, Officer.race, Disposition.OIPM)
allegs <- unique(alleg.act$Allegation)
alleg.classes <- unique(alleg.act$Allegation.class)
acts <- unique(alleg.act$Action.taken)
dispositions <- unique(alleg.act$Disposition.OIPM)
officer.races <- unique(alleg.act$Race)

alleg.act <- alleg.act %>% mutate(
  alleg.index = match(Allegation, allegs),
  alleg.class.index = match(Allegation.class, alleg.classes),
  act.index = match(Action.taken, acts),
  race.index = match(Race, officer.races),
  disposition.index = match(Disposition.OIPM, dispositions)
)

num.alleg <- length(allegs)
num.alleg.classes <- length(alleg.classes)
num.action <- length(acts)
num.dispositions <- length(dispositions)
num.races <- length(officer.races)

m <- list(
  l = 100,
  r = 100,
  b = 10,
  t = 10,
  pad = 4
)

length(races)
p <- plot_ly(alleg.act, 
             type = 'parcoords', 
             labelfont = list(size = 20),
             tickfont = list(size = 12),
             line = list(color = ~disposition.index,
                         colorscale = list(c(0,'red'),
                                          c(0.5, 'green'), 
                                          c(1,'blue'))),
             
        dimensions = list(
        
          # Races
          list(range = c(1, num.races),
               label = 'Officer race', 
               tickvals = 1:num.races,
               ticktext = races,
               values = ~race.index),
      
          # Allegations
          list(range = c(1, num.alleg.classes),
               label = 'Allegation class', 
               tickvals = 1:num.alleg.classes,
               ticktext = alleg.classes,
               values = ~alleg.class.index),
          
          # Dispositions
          list(range = c(1, num.dispositions),
               label = 'Disposition', 
               tickvals = 1:num.dispositions,
               ticktext = dispositions,
               values = ~disposition.index)
        )
) %>%
  layout(autosize = T, margin = m)

p
api_create(p, filename=title)
#chart_link

########################################################################################################
########################################################################################################
