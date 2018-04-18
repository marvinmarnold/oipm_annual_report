check.vars(c("year", "allegations.for.year"))
title <- "Allegation to Action"

########################################################################################################
########################################################################################################

allegs <- unique(allegations.for.year$Allegation)
dispositions <- unique(allegations.for.year$Allegation.Disposition.OIPM)
officer.races <- unique(allegations.for.year$Officer.Race)

all.indices <- allegations.for.year %>% mutate(
  alleg.index = match(Allegation, allegs),
  race.index = match(Officer.Race, officer.races),
  disposition.index = match(Allegation.Disposition.OIPM, dispositions)
)

num.allegs <- length(allegs)
num.dispositions <- length(dispositions)
num.races <- length(officer.races)

m <- list(
  l = 100,
  r = 100,
  b = 10,
  t = 10,
  pad = 4
)

p.allegation.race.disposition <- plot_ly(all.indices, 
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
          list(range = c(1, num.allegs),
               label = 'Allegation', 
               tickvals = 1:num.allegs,
               ticktext = allegs,
               values = ~allegs),
          
          # Dispositions
          list(range = c(1, num.dispositions),
               label = 'Disposition', 
               tickvals = 1:num.dispositions,
               ticktext = dispositions,
               values = ~disposition.index)
        )
) %>%
  layout(autosize = T, margin = m)

p.allegation.race.disposition
