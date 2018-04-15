check.vars(c("officers.csv"))

########################################################################################################
########################################################################################################

active.officers.for.year <- read.csv(officers.csv)
active.officers.for.year <- active.officers.for.year %>% mutate(
  age.bucket = sapply(Age, age.bucket.function)
)
