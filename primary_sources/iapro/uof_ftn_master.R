source("primary_sources/uof2015.R")
source("primary_sources/data.nola.gov/uof.R")

########################################################################################################
########################################################################################################

# Read data
uof.all <- read.csv(uof.csv, stringsAsFactors = FALSE)

# Use the PIB number to determine the year
uof.all <- uof.all %>% mutate(
  year.of.record = as.integer(substr(FIT.Number, 4, 7))
)

uof.all <- uof.all %>% filter(Force.type != "No Force by Officer", Force.type != "Not reported")
levels(uof.all$Force.type) <- uof.all %>% select(Force.type) %>% distinct

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

