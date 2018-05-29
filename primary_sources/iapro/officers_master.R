check.vars(c("officers.legacy.csv", "officers.oipm.csv", "officers.adp.csv"))

########################################################################################################
########################################################################################################

#officers.oipm <- read.csv(officers.oipm.csv, stringsAsFactors = FALSE)
officers.adp.for.year <- read.csv(officers.adp.csv, stringsAsFactors = FALSE)

officers.adp.for.year <- officers.adp.for.year %>% mutate(
  age.bucket = sapply(Age, age.bucket.function)
)
