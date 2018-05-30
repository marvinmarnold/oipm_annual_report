# Import UOF from data.nola.gov

check.vars(c("uof.opendata.csv"))

########################################################################################################
########################################################################################################

nopd.opendata.uof <- read.csv(uof.opendata.csv) 
nopd.opendata.uof <- nopd.opendata.uof %>% mutate(
  year.of.record = as.integer(substr(PIB.File.Number, 4, 7))
)
