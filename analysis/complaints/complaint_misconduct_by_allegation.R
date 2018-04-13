check.vars(c("misconduct.alleg.act"))
title <- "2017 complaints and misconduct by allegation"

########################################################################################################
########################################################################################################

complaint.alleg.officer<- unique(misconduct.alleg.act %>% select(FIT.Number, Allegation, Officer.primary.key, Allegation.class))

# Group by allegation
complaints.by.allegation.and.class <- group_by(complaint.alleg.officer, Allegation.class, Allegation) 

# make a simple summary of allegation w/ class
count.by.class.alleg <- summarise(complaints.by.allegation.and.class, count = n())

p <- plot_ly(count.by.class.alleg, x = ~Allegation.class, y = ~count, type = 'bar',  name = ~Allegation, color = ~Allegation) %>%
  layout(yaxis = list(title = 'Number of complaints'), barmode = 'stack')

p
api_create(p, filename=title, sharing = "public")

