check.vars(c("officers.legacy.csv", "officers.oipm.csv", "officers.adp.csv"))

########################################################################################################
########################################################################################################

#officers.oipm <- read.csv(officers.oipm.csv, stringsAsFactors = FALSE)
officers.adp.for.year <- read.csv(officers.adp.csv, stringsAsFactors = FALSE)

officers.adp.for.year <- officers.adp.for.year %>% mutate(
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