p.mediation <- plot_ly(
  x = c("Total mediations", "Mediations misclassified as rank initiated"),
  y = c(30, 2),
  name = "Mediation",
  type = "bar"
) %>% layout(title = "Mediation misclassifications")

p.mediation