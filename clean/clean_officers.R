check.vars(c("all.officers.iapro.csv.dirty", "officers.adp.csv.dirty"))

########################################################################################################
########################################################################################################

#officers.oipm <- read.csv(officers.oipm.csv, stringsAsFactors = FALSE)
officers.adp.for.year.dirty <- read.csv(officers.adp.csv.dirty, stringsAsFactors = FALSE)

officers.adp.for.year.dirty <- officers.adp.for.year.dirty %>% mutate(
  Empl.ID = vdigest(Empl.ID),
  age.bucket = sapply(Age, age.bucket.function),
  Officer.sex = case_when(
    Gender == 'F' ~ 'Female',
    Gender == 'M' ~ 'Male',
    TRUE ~ 'Not Specified'
  ),
  Officer.race = case_when(
    Ethnic.Group.Desc == 'American Indian/Alaska Native' ~ native,
    Ethnic.Group.Desc == 'Asian/Pacific Islander' ~ asian,
    Ethnic.Group.Desc == 'Black' ~ black,
    Ethnic.Group.Desc == 'Hispanic' ~ hispanic,
    Ethnic.Group.Desc == 'White' ~ white,
    TRUE ~ unknown.race
  ),
  Zip = zip
)

officers.adp.for.year <- officers.adp.for.year.dirty %>% select(
  Empl.ID,
  age.bucket,
  Officer.sex,
  Officer.race,
  Zip
)

write.csv(officers.adp.for.year, file = "data_public/clean/officers_adp_clean.csv")

########################################################################################################
########################################################################################################

all.officers.iapro.dirty <- read.csv(all.officers.iapro.csv.dirty, stringsAsFactors = FALSE)
all.officers.iapro.dirty %>% colnames

all.officers.iapro <- all.officers.iapro.dirty %>% mutate(
  Officer.number = vdigest(Officer.number)
) %>% select(
  Officer.number,
  Years.employed,
  Age,
  Officer.sex,
  Officer.race,
  Officer.department,
  Officer.division,
  Officer.sub.division.A,
  Officer.sub.division.B
)

write.csv(all.officers.iapro, file = "data_public/clean/officer_iapro_clean.csv")

