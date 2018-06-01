check.vars(c("bwc.potential.csv", "cad.csv", "epr.csv"))

# % cad w/ BWC
# % epr w/ BWC

########################################################################################################
########################################################################################################
bwc.potential <- read.csv(bwc.potential.csv, stringsAsFactors = FALSE)

epr <- read.csv(epr.csv, stringsAsFactors = FALSE)
epr <- epr %>% mutate(
  Item_Number = trimws(toupper(Item_Number))
) %>% distinct(Item_Number)

# Select EPR without BWC
epr.bwc.overlap.id <- merge(epr, bwc.potential, by.x = 'Item_Number', by.y = 'id_external')
epr.bwc.overlap.title <- merge(epr, bwc.potential, by.x = 'Item_Number', by.y = 'title')
epr.bwc.overlap <- rbind(
  data.frame(matching.epr = epr.bwc.overlap.id$Item_Number), 
  data.frame(matching.epr = epr.bwc.overlap.title$Item_Number)) %>% distinct()

#epr.missing.bwc <- setdiff(epr.2017$id_external, epr.bwc.overlap$id_external)
#epr.missing.bwc <- data.frame(id_external = epr.missing.bwc)
#epr.missing.bwc <- unique(merge(epr.missing.bwc, epr.2017, by = 'id_external'))
#sample_n(missing.bwc, 1)

# Print basic stats
num.epr <- epr %>% nrow()
num.epr

num.epr.matched <- epr.bwc.overlap %>% nrow()
num.epr.matched
num.epr.missing <- num.epr - num.epr.matched

pct.epr.matched <- num.epr.matched / num.epr * 100
pct.epr.missing <- 100 - pct.epr.matched

print(paste(num.epr.missing, "epr are missing corresponding bwc entries, that's equivalent to", pct.epr.missing, "% missing"))

# SORT BY SIGNAL DESCRIPTION
#missing.bwc <- missing.bwc %>% arrange(Signal_Type)
#write.csv(missing.bwc, paste0("missing_bwc", format(Sys.time(), "_%Y%m%d_%H%M%S"), ".csv"))

# matt
# add more columns to epr
# back the idea of gettin cad data
# will analyze 30 cases 
