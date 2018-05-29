check.vars(c("bwc.nopd.csv", "bwc.public.csv"))

########################################################################################################
########################################################################################################

bwc.nopd <- read.csv(bwc.nopd.csv)
bwc.public <- read.csv(bwc.public.csv)

bwc.for.year <- merge(bwc.nopd, bwc.public, by = "evidence_id")
