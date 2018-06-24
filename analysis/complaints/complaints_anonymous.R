check.vars(c("year", "allegations.for.year"))

########################################################################################################
########################################################################################################

anon.allegs <-  allegations.for.year %>% 
  distinct(Citizen.primary.key, PIB.Control.Number, .keep_all = TRUE) %>%
  group_by(Is.anonymous)
num.anon.allegs <- anon.allegs %>% summarise(num.allegs = n())

p.anon.allegs <- plot_ly(num.anon.allegs,
  x = ~Is.anonymous,
  y = ~num.allegs,
  name = "Number active officers",
  type = "bar"
)

p.anon.allegs
write.csv(anon.allegs %>% select(
  PIB.Control.Number,
  Is.anonymous
), file = "data/IAPro/anonymous_complaints.csv")
