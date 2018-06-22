check.vars(c("year", "allegations.csv.dirty"))

########################################################################################################
########################################################################################################

# Read data
allegations.all <- read.csv(allegations.csv.dirty, stringsAsFactors = FALSE)
allegations.all <- allegations.all %>% mutate(
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
) %>%
  select(
    PIB.Control.Number,
    Disposition.OIPM.by.officer,
    Disposition.NOPD,
    Assigned.department,
    Assigned.division,
    Assigned.unit, 
    Incident.type, 
    Month.occurred, 
    Officer.Race,
    Allegation.short,
    Allegation.Finding.OIPM,
    Allegation.simple,
    Allegation.class,
    Source,
    Is.anonymous,
    Allegation.directive,
    Allegation
  )

write.csv(allegations.all, "data_public/clean/allegations_all_clean.csv")

