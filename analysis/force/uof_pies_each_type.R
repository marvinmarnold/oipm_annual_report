# Make a pie chart by type of force for each level of force

check.vars(c("lvls", "uof.count.by.type"))
title <- "UOF by type"

########################################################################################################
########################################################################################################

uof.pies.each.type <- lapply(lvls, function (lvl) {
  
  # Filter UOF by year
  uof.for.lvl <- uof.count.by.type %>% filter(Force.level == lvl)
  total.for.lvl <- sum(uof.for.lvl$count)
  lvl.title <-paste(title, "for level", lvl, "(Total = ", total.for.lvl, ")")

  # Construct pie chart
  plot_ly(uof.for.lvl,  type = 'pie', name = lvl.title,
          labels = ~Force.type, 
          values = ~count,
          textposition = 'inside',
          textinfo = 'label+value+percent',
          insidetextfont = list(color = '#FFFFFF')) %>%
    
    layout(hovermode = "compare", title = lvl.title)
})