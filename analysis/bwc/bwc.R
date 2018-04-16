########################################################################################################
################################## 2017 BODY WORN CAMERA ANALYSIS ######################################

# Reset environment
rm(list = ls())

########################################################################################################
######################################## GLOBAL VARIABLES ##############################################

# Working directory
wd <- "/media/sf_oipm/code/repo" 

# Filenames relative to wd
bwc.w.officer.2017.csv <- "data/BWC/BWC_Metadata_with_Officer_Names_9_28_2017.csv"
epr.2017.csv <- "data/data.nola.gov/Electronic_Police_Report_2017.csv"

########################################################################################################
######################################## GLOBAL VARIABLES ##############################################
epr.2017 <- read.csv(epr.2017.csv)
colnames(epr.2017)
warning("This file is over 400GB and will take a long time to load into memory from CSV")
bwc.w.officer.2017 <- read.csv(bwc.w.officer.2017.csv)
bwc.w.officer.2017 <- bwc.w.officer.2017 %>% mutate(
  id_external = as.factor(id_external)
)

# To make command below a little faster
bwc.with.legible.id <- bwc.w.officer.2017 %>% 
  filter((nchar(as.character(id_external)) == 10)) %>%
  select(id_external) %>%
  distinct

# FIXME this is horrendously inefficient
epr.has.bwc <- sapply(epr.2017$Item_Number, function(epr_id) {
  bwc.with.legible.id %>% filter(as.character(id_external) == as.character(epr_id)) %>% nrow > 0
})


