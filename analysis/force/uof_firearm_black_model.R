uof.firearm.black <- uof.for.year %>% mutate(
  firearm = sapply(Force.type, function(type) {
    if (type == "Firearm Exhibited" || type == "Firearm Discharged" || type == "Taser Exhibited" || type == "Taser No-Hit") {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }),
  isBlack = sapply(Citizen.race, function(race) {
    if (race == black) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }),
  isWhite = sapply(Citizen.race, function(race) {
    if (race == white) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  })
)

uof.firearm.black %>% group_by(firearm) %>% summarise(count = n())

m <- lm(firearm ~ isWhite, data = uof.firearm.black)
summary(m)
