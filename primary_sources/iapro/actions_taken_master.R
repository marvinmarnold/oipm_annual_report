check.vars(c("actions.taken.csv"))

########################################################################################################
########################################################################################################

actions.taken.all <- read.csv(actions.taken.csv, stringsAsFactors = FALSE)
actions.taken.all <- actions.taken.all %>% mutate(
  Allegation.short = substring(trim(Allegation), 16, 999),
  Allegation.simple = case_when(
    Allegation.short == "NEGLECT OF DUTY" ~ "Neglect of duty",
    Allegation.short == "Professionalism" ~ "Professionalism",
    Allegation.short == "INSTRUCTIONS FROM AUTHORITATIVE SOURCE" ~ "Instructions from authoritative source",
    Allegation.short == "ADHERENCE TO LAW" ~ "Adherence to law",
    Allegation.short == "UNAUTHORIZED FORCE" ~ "Unauthorized force",
    Allegation.short == "COURTESY" ~ "Courtesy",
    Allegation.short == "VERBAL INTIMIDATION" ~ "Verbal intimidation",
    TRUE ~ "Other"
  )
)
actions.for.year <- actions.taken.all %>% filter(Action.taken.year == year)
actions.for.year %>% select(Action.taken.OIPM) %>% distinct
discipline.for.year <- actions.for.year %>% filter(
  Action.taken.OIPM != "None",
  Action.taken.OIPM != "Illegitimate outcome",
  Action.taken.OIPM != "Resigned before disposition",
  Action.taken.OIPM != "Pending Investigation",
  Action.taken.OIPM != "Unknown action taken"
)
