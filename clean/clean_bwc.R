check.vars(c("bwc.public.csv", "cad.csv.dirty"))

valid.id.regex <- "(\\w-\\d\\d\\d\\d\\d-\\d\\d)+"

########################################################################################################
########################################################################################################
bwc.all <- read.csv(bwc.public.csv, stringsAsFactors = FALSE)
bwc.all <- bwc.all %>% mutate(
  id_external = trimws(toupper(id_external)),
  title = trimws(toupper(title)),
  id.external.has.id = grepl(valid.id.regex, id_external),
  title.has.id = grepl(valid.id.regex, title)
)

# Only include entries with valid IDs
bwc.w.id <- bwc.all %>% filter(
  grepl(valid.id.regex, id_external)
)
bwc.w.id %>% colnames()
bwc.w.title <- bwc.all %>% filter(
  grepl(valid.id.regex, title)
)

bwc.potential <- rbind(bwc.w.id, bwc.w.title) %>% select(
  id_external, title
) %>% distinct()
#bwc.potential %>% colnames()
#bwc.potential <-  %>% distinct(evidence_id, id_external, title)

#bwc.all %>% nrow
#bwc.w.id %>% nrow
#bwc.w.title %>% nrow
#bwc.potential %>% nrow

# Free up memory
rm(bwc.all)

write.csv(bwc.potential, "data_public/data.nola.gov/bwc_potential.csv")

########################################################################################################
########################################################################################################
cad <- read.csv(cad.csv.dirty, stringsAsFactors = FALSE)
cad <- cad %>% select(
  ItemNumber
) %>% distinct()

write.csv(cad, file = "data_public/clean/cad_2017_clean.csv")
