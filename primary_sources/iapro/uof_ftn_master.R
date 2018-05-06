check.vars(c("uof.csv", "year"))

########################################################################################################
########################################################################################################

# Read data
uof.all <- read.csv(uof.csv, stringsAsFactors = FALSE)
uof.all <- uof.all %>% filter(Force.type != "No Force by Officer", Force.type != "Not reported")
levels(uof.all$Force.type) <- uof.all %>% select(Force.type) %>% distinct

# 2017 analysis
uof.for.year <- uof.all %>% filter(Year.reported == year)
nrow(uof.for.year)

# create dataframe with FTN ids and counts
ftn.for.year <- setNames(
  aggregate(
    uof.for.year$FIT.Number, 
    list(FTN = uof.for.year$FIT.Number, month = uof.for.year$Month.occurred), 
    length), 
  c("ftn", "month", "num.uof"))

nrow(ftn.for.year)
