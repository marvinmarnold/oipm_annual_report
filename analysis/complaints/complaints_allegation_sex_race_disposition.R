check.vars(c("year", "misconduct.alleg.act"))
title <- "Impact of officer sex and race on disposition of complaints"

########################################################################################################
########################################################################################################

# Get unique allegation
alleg.classes <- allegations.for.year %>% select(Allegation.class) %>% distinct
colnames(alleg.classes) <- 'label'

# Unique dispositions
dispositions <- allegations.for.year %>% select(Disposition.OIPM) %>% distinct
colnames(dispositions) <- 'label'

# Labels containing all
all.labels <- rbind(alleg.classes, dispositions)

# Compute edges
alleg.by.dispo <- allegations.for.year %>% group_by(Allegation.class, Disposition.OIPM)

alleg.dispo.counts <- summarise(alleg.by.dispo, count = n())
# loop over alleg.classes, count the number of times to each disposition

alleg.dispo.counts <- alleg.dispo.counts %>% mutate(
  alleg.label.index = match(Allegation.class, alleg.classes$label) - 1, # 0 indexed
  dispo.label.index = match(Disposition.OIPM, dispositions$label) + nrow(alleg.classes) - 1 #0 indexed
)

p <- plot_ly(
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
    source = alleg.dispo.counts$alleg.label.index,
    target = alleg.dispo.counts$dispo.label.index,
    value =  alleg.dispo.counts$count
  )
) %>% 
  layout(
    title = title,
    font = list(
      size = 10
    )
  )

api_create(p, filename=title)
#chart_link

