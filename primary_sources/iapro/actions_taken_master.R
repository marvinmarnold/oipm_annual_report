check.vars(c("actions.csv"))

########################################################################################################
########################################################################################################

actions.taken.all <- read.csv(actions.csv, stringsAsFactors = FALSE)

actions.for.year <- actions.taken.all %>% filter(Action.taken.year == year)

actions.for.year %>% group_by(Action.taken) %>% summarise(count = n())
actions.for.year %>% select(Action.taken) %>% distinct
