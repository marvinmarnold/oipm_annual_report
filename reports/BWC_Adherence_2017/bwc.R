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

warning("This file is over 400GB and will take a long time to load into memory from CSV")
bwc.w.officer.2017 <- read.csv(bwc.w.officer.2017.csv)
bwc.w.officer.2017 <- bwc.w.officer.2017 %>% mutate(
  id_external = as.factor(id_external)
)
epr.2017 <- read.csv(epr.2017.csv)
levels(epr.2017$Item_Number)
levels(bwc.w.officer.2017$id_external)
epr.2017 %>% mutate(
  Item_Number = as.factor(Item_Number),
  should.be.on = nrow(bwc.w.officer.2017[bwc.w.officer.2017$id_external == Item_Number,]) > 0
)

bwc.w.officer.2017$
colnames(bwc.w.officer.2017)
colnames(epr.2017)

nrow(bwc.w.officer.2017 %>% filter(id_external == "H-10721-17")) > 0
