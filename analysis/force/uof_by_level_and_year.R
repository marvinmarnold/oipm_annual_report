check.vars(c("year", "uof.all", "uof.reported.2015"))

########################################################################################################
########################################################################################################
# Combine 2015 UOF with all other uof taken directly from IAPro
all.uof.with.lvl.type <- uof.all %>% select(Force.type, Force.level, year.of.record)
uof.2015.with.lvl.type <- uof.reported.2015 %>% select(Force.type, Force.level, year.of.record)
all.uof.with.lvl.type <- rbind(all.uof.with.lvl.type, uof.2015.with.lvl.type)

all.uof.with.lvl.type <- all.uof.with.lvl.type %>% filter(year.of.record >= 2015, year.of.record <= year)
lvls <- c("L1", "L2", "L3", "L4")
p.lvl.by.year <- lapply(lvls, function (lvl) {
  
  # Filter UOF by year
  uof.for.lvl <- all.uof.with.lvl.type %>% filter(Force.level == lvl) %>% group_by(year.of.record, Force.type)

  # make a simple summary of uof count by type
  uof.count.by.type <- summarise(uof.for.lvl, count = n())
  
  p.uof.by.type <- plot_ly(uof.count.by.type, 
                           x = ~year.of.record, y = ~count, 
                           type = 'bar',  name = ~Force.type, 
                           color = ~Force.type) %>%
    
    layout(xaxis = list(categoryorder = "array",
                        categoryarray = lvls,
                        title = paste("Level", lvl, "force"), 
                        showgrid = F, 
                        dtick = 1,
                        tick0 = 2016), 
           yaxis = list(title = 'Number UOF'),
           legend = list(x = 0, y = -.50), 
           barmode = 'stack',
           hovermode = 'compare')
})
p.lvl.by.year[[4]]
