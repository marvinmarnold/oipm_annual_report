nopd.uof <- read.csv("data/data.nola.gov/NOPD_Use_of_Force_Incidents.csv") 
nopd.ftn <- nopd.uof %>% filter(grepl("^FTN2017", PIB.File.Number)) %>% select(PIB.File.Number) %>% distinct
our.ftn <- ftn.for.year %>% select(ftn) %>% distinct

nopd.ftn <- nopd.ftn %>% mutate(
  ftn = as.character(PIB.File.Number)
)

our.ftn <- our.ftn %>% mutate(
  ftn = as.character(ftn)
)

setdiff(nopd.ftn$ftn, our.ftn$ftn)
setdiff(our.ftn$ftn, nopd.ftn$ftn)

our.ftn %>% filter(ftn == "FTN2017-0097")
uof.for.year %>% filter(FIT.Number == "FTN2017-0097") %>% select(Force.type)

# "FTN2017-0563" this is a level 4 CEW added on 3/8/17
# "FTN2017-0617" l1 hands, l1 hands, l2 cew deployment (3 different officers)
# "FTN2017-0651" 4 uof, dante couldn't see but it's on open data

# even if we do start early
# not having remote access makes it a pain to resolve conflicts