check.vars(c("officers.csv"))

########################################################################################################
########################################################################################################

officers.all <- read.csv(officers.csv)
officers.all <- officers.all %>% mutate(
  age.bucket = sapply(Age, age.bucket.function)
)
