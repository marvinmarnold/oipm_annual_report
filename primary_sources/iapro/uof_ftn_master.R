check.vars(c("officers.all", "uof.csv", "year"))

########################################################################################################
########################################################################################################

# Read data
uof.all <- read.csv(uof.csv)

# 2017 analysis
uof.for.year <- uof.all %>% filter(Year.reported == year)

# create dataframe with FTN ids and counts
ftn.ids.counts <- setNames(
  aggregate(
    uof.for.year$FIT.Number, 
    list(FTN = uof.for.year$FIT.Number, month = uof.for.year$Month.occurred), 
    length), 
  c("ftn", "month", "num.uof"))
