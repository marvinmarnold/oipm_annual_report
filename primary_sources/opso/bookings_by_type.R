source("opso/bookings_master.R")
title <- "Bookings by"

########################################################################################################
########################################################################################################

# Group reason for booking
bookings.by.reason <- group_by(bookings, Reason.booking) 

count.by.reason <- summarize(bookings.by.reason, num.bookings = n())
count.by.reason

p <- plot_ly(count.by.reason, labels = ~Reason.booking, values = ~num.bookings, type = 'pie',
             textposition = 'inside',
             textinfo = 'label+value+percent',
             insidetextfont = list(color = '#FFFFFF'),
             hoverinfo = 'text') 
p
api_create(p, filename=paste(title, "reason"), sharing = "public")

########################################################################################################
########################################################################################################

# Group type of booking
bookings.by.type <- group_by(bookings, Type.booking) 

count.by.type <- summarize(bookings.by.type, num.bookings = n())
count.by.type

p <- plot_ly(count.by.type, labels = ~Type.booking, values = ~num.bookings, type = 'pie',
             textposition = 'inside',
             textinfo = 'label+value+percent',
             insidetextfont = list(color = '#FFFFFF'),
             hoverinfo = 'text') 
p
api_create(p, filename=paste(title, "type"), sharing = "public")
