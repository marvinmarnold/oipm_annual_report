check.vars(c("uof.csv.dirty"))

########################################################################################################
########################################################################################################

# Read data
uof.all.dirty <- read.csv(uof.csv.dirty, stringsAsFactors = FALSE)

# Use the PIB number to determine the year
uof.all.dirty <- uof.all.dirty %>% mutate(
  year.of.record = as.integer(substr(FIT.Number, 4, 7))
)

uof.all.dirty <- uof.all.dirty %>% filter(Force.type != "No Force by Officer", Force.type != "Not reported")
uof.all.dirty <- uof.all.dirty %>% mutate(
  Force.type = as.character(Force.type)
)

uof.all <- uof.all.dirty %>% 

  mutate(
    Officer.primary.key = vdigest(Officer.primary.key)
  ) %>%
  
  select(
    FIT.Number,
    year.of.record,
    Service.type,
    Reason.for.force,
    UOF.effective,
    District.or.division,
    Force.type,
    Force.level,
    Month.occurred,
    Officer.primary.key,
    Officer.sex,
    Officer.race,
    Officer.age.at.time.of.UOF,
    Officer.years.exp.at.time.of.UOF,
    Officer.injured,
    Citizen.race,
    Citizen.sex,
    Citizen.age,
    Citizen.injured,
    Disposition)

nrow(uof.all)
write.csv(uof.all, file = "data_public/clean/uof_clean.csv")


