check.vars(c("year", "allegations.csv.dirty"))
require(stringr)
########################################################################################################
########################################################################################################

# Read data
allegations.all <- read.csv(allegations.csv.dirty, stringsAsFactors = FALSE)
colnames(allegations.all)
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
) %>% mutate(
  Allegation.primary.key = vdigest(Allegation.primary.key),
  year.of.record = as.integer(str_match(PIB.Control.Number, "(\\d\\d\\d\\d)-")[,2]),
  year.plus.month = (year.of.record - 2016) * 12 + Month.occurred,
  officer.age.bucket = sapply(as.integer(Officer.age.at.time.of.UOF), age.bucket.function),
  citizen.age.bucket = sapply(as.integer(Citizen.age), age.bucket.function),
  officer.exp.bucket = sapply(as.integer(Officer.years.exp.at.time.of.UOF), exp.bucket.function),
  Officer.primary.key = vdigest(Officer.primary.key),
  Citizen.primary.key = vdigest(Citizen.primary.key)
) %>%
  select(
    PIB.Control.Number,
    Disposition.OIPM.by.officer,
    Disposition.NOPD,
    Allegation.finding,
    Allegation.Finding.OIPM,
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
    Allegation,
    Citizen.sex,
    Allegation.primary.key,
    Officer.sex,
    Citizen.race,
    year.of.record,
    year.plus.month, 
    Officer.age.at.time.of.UOF,
    Officer.years.exp.at.time.of.UOF,
    Citizen.age,
    officer.age.bucket,
    citizen.age.bucket,
    officer.exp.bucket,
    Officer.primary.key,
    Citizen.primary.key
  )
detach("package:stringr", unload=TRUE)

colnames(allegations.all)
write.csv(allegations.all, "data_public/clean/allegations_all_clean.csv")
