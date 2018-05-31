check.vars(c("allegations.for.year"))


########################################################################################################
########################################################################################################
title <- "Allegations of retaliation"
retaliation <- "retaliation"
retaliation.for.year <- allegations.for.year %>% mutate(
  is.retaliation = grepl(retaliation, tolower(Allegation))
)

allegations.for.year %>% nrow()
num.retal <- retaliation.for.year %>% filter(is.retaliation == TRUE) %>% nrow()

p.retaliation <- plot_ly(
  x = c("Retaliation allegations (total)", "Retaliation allegations (unfounded)"),
  y = c(num.retal, num.retal),
  name = "Retaliation",
  type = "bar"
) %>% layout(title = title)

p.retaliation
