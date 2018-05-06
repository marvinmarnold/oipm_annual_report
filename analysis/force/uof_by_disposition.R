check.vars(c("uof.for.year"))
title <- "UOF by diposition"

dispositions <- c("Authorized", "Not Authorized", "Illigitimate outcome")
########################################################################################################
########################################################################################################

uof.by.disposition <- uof.for.year %>% group_by(Disposition)
disposition.counts <- summarise(uof.by.disposition, count = n())

p.uof.by.disposition <- plot_ly(disposition.counts, x = ~Disposition, y = ~count, type = "bar")
p.uof.by.disposition