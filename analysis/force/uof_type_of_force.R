source("iapro/uof_ftn_master.R")
title <- "UOF by type"

########################################################################################################
########################################################################################################

# Group UOF by type
uof.by.type <- group_by(uof2017, Force.level, Force.type) 

# make a simple summary of uof count by type
count.by.type <- summarise(uof.by.type, count = n())
count.by.type

# https://stackoverflow.com/questions/44929859/r-plotly-stacked-bar-chart-with-over-100-categories
xform <- list(categoryorder = "array",
              categoryarray = c('Not defined', '1', '2', '3', '4'),
              title = "Month", 
              showgrid = T)

p <- plot_ly(count.by.type, x = ~Force.level, y = ~count, type = 'bar',  name = ~Force.type, color = ~Force.type) %>%
  layout(xaxis = xform, yaxis = list(title = 'Number UOF'), barmode = 'stack')

p
api_create(p, filename=title, sharing = "public")

########################################################################################################
########################################################################################################

# Make a pie chart for every level
lvls <- 0:4
lapply(lvls, function (lvl) {
  l <- simple[simple$Force.level == lvl,]
  p <- plot_ly(l, labels = ~Force.type, values = ~count, type = 'pie',
          textposition = 'inside',
          textinfo = 'label+value+percent',
          insidetextfont = list(color = '#FFFFFF'),
          hoverinfo = 'text') %>%
    
    add_annotations(paste("Total=", sum(l$count)), showarrow=F)
  pieTitle <- paste(title, "for level", lvl)
  # api_create(p, filename=pieTitle, sharing = "public")
})
