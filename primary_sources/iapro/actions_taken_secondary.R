check.vars(c("actions.taken.csv"))

########################################################################################################
########################################################################################################

actions.taken.all <- read.csv(actions.taken.csv, stringsAsFactors = FALSE)

actions.for.year <- actions.taken.all %>% filter(Action.taken.year == year)
actions.for.year %>% select(Action.taken.OIPM) %>% distinct
discipline.for.year <- actions.for.year %>% filter(
  Action.taken.OIPM != "None",
  Action.taken.OIPM != "Illegitimate outcome",
  Action.taken.OIPM != "Resigned before disposition",
  Action.taken.OIPM != "Pending Investigation",
  Action.taken.OIPM != "Unknown action taken"
)
