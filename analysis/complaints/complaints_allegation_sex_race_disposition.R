check.vars(c("year", "allegations.for.year"))
title <- "Impact of officer race on disposition of complaints"

########################################################################################################
########################################################################################################

# Get unique allegation
allegs <- allegations.for.year %>% select(Allegation.class) %>% distinct
colnames(allegs) <- 'label'

# Unique dispositions
dispositions <- allegations.for.year %>% select(Allegation.Finding.OIPM) %>% distinct
colnames(dispositions) <- 'label'

# Officer races
officer.races <- allegations.for.year %>% select(Officer.Race) %>% distinct
colnames(officer.races) <- 'label'

# Labels containing all
all.labels <- rbind(allegs, officer.races, dispositions)

# Compute edges
alleg.by.race <- allegations.for.year %>% group_by(Allegation.class, Officer.Race)
alleg.by.race.dispo <- allegations.for.year %>% group_by(Allegation.Finding.OIPM, Officer.Race)

alleg.race.counts <- summarise(alleg.by.race, count = n())
alleg.race.dispo.counts <- summarise(alleg.by.race.dispo, count = n())
# loop over alleg.classes, count the number of times to each disposition

alleg.race.counts <- alleg.race.counts %>% mutate(
  alleg.label.index = match(Allegation.class, allegs$label) - 1, # 0 indexed
  race.label.index = match(Officer.Race, officer.races$label) + nrow(allegs) - 1 # 0 indexed
)

alleg.race.dispo.counts <- alleg.race.dispo.counts %>% mutate(
  race.label.index = match(Officer.Race, officer.races$label) + nrow(allegs) - 1, # 0 indexed
  dispo.label.index = match(Allegation.Finding.OIPM, dispositions$label) + nrow(allegs) + nrow(officer.races) - 1 # 0 indexed
)

sankey.sources <- append(alleg.race.counts$alleg.label.index, alleg.race.dispo.counts$race.label.index)
sankey.destinations <- append(alleg.race.counts$race.label.index, alleg.race.dispo.counts$dispo.label.index)
sankey.values <- append(alleg.race.counts$count, alleg.race.dispo.counts$count)
  
p.allegation.race.disposition <- plot_ly(
  type = "sankey",
  orientation = "h",
  
  node = list(
    label = all.labels$label,
    pad = 15,
    thickness = 20,
    line = list(
      color = "black",
      width = 0.5
    )
  ),
  
  link = list(
    source = sankey.sources,
    target = sankey.destinations,
    value =  sankey.values
  )
) %>% 
  layout(
    title = title,
    font = list(
      size = 10
    )
  )

p.allegation.race.disposition

