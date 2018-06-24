check.vars(c("actions.taken.csv.dirty"))

########################################################################################################
########################################################################################################

actions.taken.all <- read.csv(actions.taken.csv.dirty, stringsAsFactors = FALSE)
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
) %>% mutate(
  Allegation.primary.key = vdigest(Allegation.primary.key)
)  %>% select(
  Action.taken.OIPM,
  Action.taken.year,
  Allegation.short,
  Allegation.primary.key
)

colnames(actions.taken.all)
write.csv(actions.taken.all, file = "data_public/clean/actions_taken_clean.csv")

