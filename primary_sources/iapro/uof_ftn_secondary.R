check.vars(c("uof.csv"))

########################################################################################################
########################################################################################################

# Read data
uof.all <- read.csv(uof.csv, stringsAsFactors = FALSE)

# 2017 analysis
uof.for.year <- uof.all %>% filter(year.of.record == year)
nrow(uof.for.year)

# create dataframe with FTN ids and counts
ftn.for.year <- setNames(
  aggregate(
    uof.for.year$FIT.Number, 
    list(FTN = uof.for.year$FIT.Number, month = uof.for.year$Month.occurred), 
    length), 
  c("ftn", "month", "num.uof"))

nrow(ftn.for.year)

