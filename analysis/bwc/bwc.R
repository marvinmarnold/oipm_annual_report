########################################################################################################
################################## 2017 BODY WORN CAMERA ANALYSIS ######################################

# Reset environment
rm(list = ls())

########################################################################################################
######################################## GLOBAL VARIABLES ##############################################

# Working directory
wd <- "/media/sf_oipm/code/repo" 
setwd(wd)

# Filenames relative to wd
bwc.w.officer.2017.csv <- "data/BWC2017.csv"
epr.2017.csv <- "data/data.nola.gov/Electronic_Police_Report_2017.csv"

########################################################################################################
######################################## GLOBAL VARIABLES ##############################################
epr.2017 <- read.csv(epr.2017.csv)
epr.2017 %>% filter(grepl("18", Signal_Type)) %>% select(Signal_Description) %>% distinct 
elect(Signal_Description) %>% distinct
colnames(epr.2017)
nrow(epr.2017)
warning("This file is over 400GB and will take a long time to load into memory from CSV")
bwc.w.officer.2017 <- read.csv(bwc.w.officer.2017.csv)
colnames(bwc.w.officer.2017)

# To make command below a little faster
bwc.with.legible.id <- bwc.w.officer.2017 %>% 
  filter((nchar(as.character(id_external)) == 10)) %>%
  select(id_external) %>%
  distinct

# Convert factors to 
bwc.with.legible.id <- bwc.with.legible.id %>% mutate(
  id_external = toupper(as.character(id_external))
)

epr.2017 <- epr.2017 %>% mutate(
  id_external = toupper(as.character(Item_Number))
)

# Select EPR without BWC
epr.bwc.overlap <- merge(epr.2017, bwc.with.legible.id, by = 'id_external')

epr.missing.bwc <- setdiff(epr.2017$id_external, epr.bwc.overlap$id_external)
epr.missing.bwc <- data.frame(id_external = epr.missing.bwc)
epr.missing.bwc <- unique(merge(epr.missing.bwc, epr.2017, by = 'id_external'))
sample_n(missing.bwc, 1)

# Print basic stats
num.epr <- nrow(unique(epr.2017))
num.mising <- nrow(epr.missing.bwc)
pct.missing <- num.mising / num.epr * 100
print(paste(num.mising, "epr are missing corresponding bwc entries, that's equivalent to", pct.missing, "% missing"))

# SORT BY SIGNAL DESCRIPTION
#missing.bwc <- missing.bwc %>% arrange(Signal_Type)
#write.csv(missing.bwc, paste0("missing_bwc", format(Sys.time(), "_%Y%m%d_%H%M%S"), ".csv"))

# matt
# add more columns to epr
# back the idea of gettin cad data
# will analyze 30 cases 
