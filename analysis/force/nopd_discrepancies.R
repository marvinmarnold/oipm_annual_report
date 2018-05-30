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

nopd.uofs <- nopd.uof %>% group_by(PIB.File.Number) %>% summarise(num.uof = n()) %>% select(PIB.File.Number, num.uof)
ipm.uof <- uof.for.year %>% group_by(FIT.Number) %>% summarise(num.uof = n()) %>% select(FIT.Number, num.uof)

uof.for.year %>% filter(FIT.Number == "FTN2017-0649")

uofs <- merge(nopd.uofs, ipm.uof, by.x = "PIB.File.Number", by.y = "FIT.Number") %>% filter(num.uof.x != num.uof.y)

our.ftn %>% filter(ftn == "FTN2017-0097")
uof.for.year %>% filter(FIT.Number == "FTN2017-0097") %>% select(Force.type)

uof.for.year %>% filter(Force.type == "Taser while Handcuffed")

# "FTN2017-0563" this is a level 4 CEW added on 3/8/17
# "FTN2017-0617" l1 hands, l1 hands, l2 cew deployment (3 different officers)
# "FTN2017-0651" 4 uof, dante couldn't see but it's on open data

# even if we do start early
# not having remote access makes it a pain to resolve conflicts

########################################################################################################
########################################################################################################
nopd.allegs <- read.csv("data/Dante/Allegations_20180420.csv", stringsAsFactors = FALSE) 
nopd.complaints <- nopd.allegs %>% select(PIB.Control.Number) %>% distinct
our.complaints <- allegations.for.year %>% select(PIB.Control.Number) %>% distinct

nrow(our.complaints)
nrow(nopd.complaints)
setdiff(nopd.complaints$PIB.Control.Number, our.complaints$PIB.Control.Number)
setdiff(our.complaints$PIB.Control.Number, nopd.complaints$PIB.Control.Number)

nrow(allegations.for.year)
# Citizens can complain years after an incident actually occurs. 
# how do we want to want report that? the year it happens or the year the complaint occurs

#nopd.allegs <- read.csv("data/Dante/AllAllegations_20180420.csv") 
nrow(nopd.allegs)
nopd.allegs.by.id <- nopd.allegs %>% group_by(PIB.Control.Number)
nopd.alleg.count <- summarise(nopd.allegs.by.id, num.allegs = n())

oipm.alleg.count <- allegations.for.year %>% 
  group_by(PIB.Control.Number) %>% 
  summarise(num.allegs = n())

nrow(oipm.2016.allegs)

alleg.counts <- merge(oipm.alleg.count, nopd.alleg.count, by = 'PIB.Control.Number')
alleg.counts %>% filter(num.allegs.x != num.allegs.y)

oipm.2016.allegs %>% filter(FIT.Number == "2016-0084-P")
