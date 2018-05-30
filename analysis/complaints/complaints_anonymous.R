check.vars(c("year", "complaints.for.year"))

########################################################################################################
########################################################################################################

num.anon.allegs <- allegations.for.year %>% group_by(Is.anonymous) %>% summarise(num.allegs = n())
p.anon.allegs <- plot_ly(num.anon.allegs,
  x = ~Is.anonymous,
  y = ~num.allegs,
  name = "Number active officers",
  type = "bar"
)

p.anon.allegs
