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
p.bwc.matching.epr <- plot_ly(
  x = c("Total EPR", "EPR with matching BWC"),
  y = c(num.epr, num.epr.matched),
  name = "EPR with matching BWC",
  type = "bar"
)

p.bwc.matching.epr
########################################################################################################
########################################################################################################
cad <- read.csv(cad.csv, stringsAsFactors = FALSE)

cad <- cad %>% mutate(
  ItemNumber = trimws(toupper(ItemNumber))
) %>% distinct(ItemNumber)

cad$ItemNumber %>% head

# Select CAD without BWC
cad.bwc.overlap.id <- merge(cad, bwc.potential, by.x = 'ItemNumber', by.y = 'id_external')
cad.bwc.overlap.title <- merge(cad, bwc.potential, by.x = 'ItemNumber', by.y = 'title')
cad.bwc.overlap <- rbind(
  data.frame(matching.cad = cad.bwc.overlap.id$ItemNumber), 
  data.frame(matching.cad = cad.bwc.overlap.title$ItemNumber)) %>% distinct()

# Print basic stats
num.cad <- cad %>% nrow()
num.cad

num.cad.matched <- cad.bwc.overlap %>% nrow()
num.cad.matched
num.cad.missing <- num.cad - num.cad.matched

pct.cad.matched <- num.cad.matched / num.cad * 100
pct.cad.missing <- 100 - pct.cad.matched

print(paste(num.cad.missing, "cad are missing corresponding bwc entries, that's equivalent to", pct.cad.missing, "% missing"))
p.bwc.matching.cad <- plot_ly(
  x = c("Total Calls for Service", "Calls for Service with matching BWC"),
  y = c(num.cad, num.cad.matched),
  name = "Calls for Service with matching BWC",
  type = "bar"
)

p.bwc.matching.cad
