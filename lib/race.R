check.vars(c("districts"))

# Race info from census
# Provided by Jakob and referenced in 2016 annual report (source 2010 census)
# Race
asian <- "Asian / Pacific Islander"
black <- "Black / African American"
white <- "White"
hispanic <- "Hispanic / Latinx"
native <- "Native / Indigenous"
unknown.race <- "Unknown race"

########################################################################################################
########################################################################################################

district.races <- c(white, black, hispanic, asian, native, unknown.race)
district.total.pops <- c(30330, 60225, 60201, 52785, 30084, 36832, 64310, 9062)

district.1.races <- c(5866, 20711, 2926, 270, 54, 503)
sum(district.1.races) == district.total.pops[1] # check

district.2.races <- c(32977, 21642, 3133, 1217, 144, 1112)
sum(district.2.races) == district.total.pops[2] # check

district.3.races <- c(24516, 30097, 3271, 1099, 132, 1086)
sum(district.3.races) == district.total.pops[3] # check

district.4.races <- c(13090, 34585, 2728, 1438, 151, 793)
sum(district.4.races) == district.total.pops[4] # check

district.5.races <- c(3719, 24755, 992, 100, 91, 427)
sum(district.5.races) == district.total.pops[5] # check

district.6.races <- c(15206, 17925, 2402, 553, 106, 640)
sum(district.6.races) == district.total.pops[6] # check

district.7.races <- c(2401, 54081, 2120, 4898, 96, 714)
sum(district.7.races) == district.total.pops[7] # check

district.8.races <- c(6995, 1070, 479, 308, 53, 157)
sum(district.8.races) == district.total.pops[8] # check

districts.by.race.wide <- data.frame()

districts.by.race.wide <- rbind(districts.by.race.wide, 
                           district.1.races, district.2.races, district.3.races, district.4.races,
                           district.5.races, district.6.races, district.7.races, district.8.races)

colnames(districts.by.race.wide) <- district.races
districts.by.race.wide <- districts.by.race.wide %>% mutate(
  district = districts,
  district.total.pop = district.total.pops
)

districts.by.race <- gather(districts.by.race.wide, race, population, 1:6) %>% mutate(
  population = as.integer(population),
  pct.race.in.district = population / district.total.pop * 100
)
districts.by.race
