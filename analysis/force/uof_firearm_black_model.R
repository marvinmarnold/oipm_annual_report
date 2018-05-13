uof.firearm.black <- uof.for.year %>% filter(Force.level == "L1")%>% mutate(
  firearm = sapply(Force.type, function(type) {
    if (type == "Firearm Exhibited" ) {
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
m <- glm(firearm ~ isWhite, data = uof.firearm.black, family="binomial")

summary(m)

colnames(uof.for.year)

table(uof.for.year$Reason.for.force, uof.for.year$Force.level)
