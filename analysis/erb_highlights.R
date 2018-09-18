# https://stackoverflow.com/questions/47668106/paper-border-on-plotly-r-graph
# https://stackoverflow.com/questions/47750950/how-do-i-remove-the-blankspace-white-margin-in-rstudio-viewer-pane-for-plotly

bb <- 'rgb(68, 116, 209)'
yy <- 'rgb(162, 182, 0)'
ll <- 'rgb(223, 237, 247)'

f1 <- list(
  family = "Arial, sans-serif",
  size = 24,
  color = "black"
)
f2 <- list(
  family = "Old Standard TT, serif",
  size = 18,
  color = "black"
)

complaints <- c(850, 734)
allegations <- c(1948, 1546)
years <- c(2016, 2017)

dat <- data.frame(
  complaints,
  allegations,
  years
)

p.complaints <- plot_ly(dat,
        x = ~years,
        y = ~complaints,
        name = "Complaints by year",
        type = "bar",
        marker = list(color = bb)) %>%
  
  layout(
    paper_bgcolor = ll,
    plot_bgcolor = ll,
    xaxis = list(
      dtick = 1,
      title = FALSE,
      tickfont = f1
    ),
    yaxis = list(
      title = FALSE,
      tickfont = f2
    )
  )
p.complaints$dependencies[[4]]$stylesheet <- "plotly-oipm.css"
p.complaints


p.allegations <- plot_ly(dat,
                        x = ~years,
                        y = ~allegations,
                        name = "Allegations by year",
                        type = "bar",
                        marker = list(color = yy)) %>%
  
  layout(
    paper_bgcolor = ll,
    plot_bgcolor = ll,
    xaxis = list(
      dtick = 1,
      title = FALSE,
      tickfont = f1
    ),
    yaxis = list(
      title = FALSE,
      tickfont = f2
    )
  )
p.allegations$dependencies[[4]]$stylesheet <- "plotly-oipm.css"
p.allegations


########################################################################################################
########################################################################################################
complaints.for.year <- complaints.for.year %>% mutate(
  recat = case_when(
    Disposition.OIPM == "Mediation" ~ "Mediation",
    Disposition.OIPM == "Pending" ~ "Pending",
    Disposition.OIPM == "Sustained" ~ "Sustained or DI-2",
    Disposition.OIPM == "DI-2" ~ "Sustained or DI-2",
    TRUE ~ "Not Sustained"
  )
)

rank.dispositions.for.year <- complaints.for.year %>% filter(Incident.type == "Rank Initiated") %>% group_by(recat)
count.rank.dispositions.for.year <- summarise(rank.dispositions.for.year, num.complaints = n())
count.rank.dispositions.for.year <- count.rank.dispositions.for.year %>% mutate(
  color = case_when(
    recat == "DI-2" ~ "red",
    recat == "Sustained or DI-2" ~ bb,
    recat == "Not Sustained" ~ yy,
    recat == "Mediation" ~ "green",
    recat == "Pending" ~ "pink",
    TRUE ~ "yellow"
  )
)

title <- "Disposition of rank initiated complaints"
p.rank.complaint.by.outcome <- plot_ly(count.rank.dispositions.for.year,  type = 'pie', 
                                       labels = ~recat, 
                                       values = ~num.complaints,
                                       marker = list(colors = ~color),
                                       textposition = 'middle center',
                                       textinfo = 'label+value+percent',
                                       insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", showlegend = FALSE) %>% 
  layout(
    paper_bgcolor = ll,
    plot_bgcolor = ll)

p.rank.complaint.by.outcome$dependencies[[4]]$stylesheet <- "plotly-oipm.css"
p.rank.complaint.by.outcome

########################################################################################################
########################################################################################################
citizen.dispositions.for.year <- complaints.for.year %>% filter(Incident.type == "Public Initiated") %>% group_by(recat)
count.citizen.dispositions.for.year <- summarise(citizen.dispositions.for.year, num.complaints = n())
count.citizen.dispositions.for.year <- count.citizen.dispositions.for.year %>% mutate(
  color = case_when(
    recat == "DI-2" ~ "red",
    recat == "Sustained or DI-2" ~ bb,
    recat == "Not Sustained" ~ yy,
    recat == "Mediation" ~ "green",
    recat == "Pending" ~ "pink",
    TRUE ~ "yellow"
  )
)

title <- "Disposition of citizen initiated complaints"
p.citizen.complaint.by.outcome <- plot_ly(count.citizen.dispositions.for.year,  type = 'pie',
                                          labels = ~recat,
                                          values = ~num.complaints,
                                          marker = list(colors = ~color),
                                          textposition = 'middle center',
                                          textinfo = 'label+value+percent',
                                          insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", showlegend = FALSE) %>%
  layout(
    paper_bgcolor = ll,
    plot_bgcolor = ll)

p.citizen.complaint.by.outcome$dependencies[[4]]$stylesheet <- "plotly-oipm.css"
p.citizen.complaint.by.outcome


p.fourth.viol.outcomes <- plot_ly(count.fourth.violations,
                                  x = ~friendly.name,
                                  y = ~num.allegs,
                                  name = ~Allegation.finding,
                                  type = "bar",
                                  color = ~Allegation.finding
) %>% 
  
  layout(xaxis = list(title = FALSE, 
                      showgrid = F), 
         yaxis = list(title = FALSE),
         xaxis = list(title = FALSE),
         barmode = 'stack',
         hovermode = 'compare', 
         margin = list(r = 100, b = 135)) %>%
  layout(
    paper_bgcolor = ll,
    plot_bgcolor = ll)

p.fourth.viol.outcomes$dependencies[[4]]$stylesheet <- "plotly-oipm.css"
p.fourth.viol.outcomes

years <- 2011:2017
ftn.previous <- c(302, 306, 421, 409, 724, 588, 604)
uof.previous <- c(NA, NA, 725, 706, 1071, 1592, 1574)

annual.summary <- data.frame(years, ftn = ftn.previous, uof = uof.previous)

p.force.by.year <- plot_ly(annual.summary, x = ~years, 
                           # Start with FTN according to NOPD
                           y = ~ftn, name = 'Num incidents (FTN)', 
                           type = 'scatter', 
                           mode = 'lines+markers', 
                           line = list(color = bb, width = 3, dash = 'solid')) %>%
  
  # UOF according to NOPD
  add_trace(y = ~uof, name = 'Total force (UOF)', 
            line = list(color = yy, width = 3, dash = 'solid'), 
            mode = 'lines+markers') %>%

layout(
  paper_bgcolor = ll,
  plot_bgcolor = ll,
  xaxis = list(dtick=1, title=FALSE, showgrid=F, tickfont=f1),
  yaxis = list(tick0=0, title=FALSE, tickfont=f2),
  legend = list(x = .1, y = +0.85))

p.force.by.year$dependencies[[4]]$stylesheet <- "plotly-oipm.css"
p.force.by.year


p.unauth <- plot_ly(dat,
                        x = c(2016, 2017),
                        y = c(1, 7),
                        name = "Complaints by year",
                        type = "bar",
                        marker = list(color = bb)) %>%
  
  layout(
    paper_bgcolor = ll,
    plot_bgcolor = ll,
    xaxis = list(
      dtick = 1,
      title = FALSE,
      tickfont = f1
    ),
    yaxis = list(
      title = FALSE,
      tickfont = f2
    )
  )
p.unauth$dependencies[[4]]$stylesheet <- "plotly-oipm.css"
p.unauth

bucket.rank <- function(rank) {
  if (rank <= 5) {
    return(5)
  } else if (rank <= 10) {
    return(10)
  } else if (rank <= 20) {
    return(20)
  } else if (rank <= 100) {
    return(100)
  } else if (rank <= 200) {
    return(200)
  } else if (rank <= 300) {
    return(300)
  } else if (rank <= 400) {
    return(400)
  } else {
    return(500)
  }
}

# Manually construct histogram
bucket.hist <- function(dt, rank.buckets, counts) {
  hist.count <- sapply(rank.buckets, function(bucket) {
    return(sum(dt %>% filter(rank.bucket <= bucket) %>% select(count)))
  })
  
  return(hist.count)
}

# UOF Analysis
uof.per.officer <- uof.for.year %>% group_by(Officer.primary.key)
uof.count.per.officer <- uof.per.officer %>% summarise(count = n())
uof.count.per.officer <- uof.count.per.officer %>% mutate(
  rank = rank(-count, ties.method ="first"),
  rank.bucket = sapply(rank, bucket.rank)
) %>% arrange(rank)

uof.per.bucket <- uof.count.per.officer %>% group_by(rank.bucket)
uof.count.per.bucket <- uof.per.bucket %>% summarise(count = sum(count))
uof.count.per.bucket <- uof.count.per.bucket %>% mutate(
  hist.count = bucket.hist(uof.count.per.bucket, rank.bucket, count),
  hist.pct = hist.count / sum(count) * 100,
  rank.bucket = as.character(rank.bucket)
)

force.count.per.bucket <- data.frame(
  rank.buckets = c("5", "10", "20", "100", "200", "300", "400", "500"),
  uof.pct.per.bucket = uof.count.per.bucket$hist.pct
)

p.force.per.bucket <- plot_ly(force.count.per.bucket, 
                              x = ~rank.buckets, 
                              y = ~uof.pct.per.bucket, type = 'bar', 
                              name = "Top X officers contribution to FTN") %>%
  
  layout(
    xaxis = list(
      categoryorder = "array",
      categoryarray = c("5", "10", "20", "100", "200", "300", "400", "500"),
      title = F,
      tickfont=f1
    ),
    yaxis = list(title = F, dtick = 10, tickfont=f2), 
    barmode = 'group') %>% layout(
      paper_bgcolor = ll,
      plot_bgcolor = ll)

p.force.per.bucket$dependencies[[4]]$stylesheet <- "plotly-oipm.css"
p.force.per.bucket

uof.by.reason <- uof.for.year %>% group_by(Reason.for.force)
count.by.reason <- summarise(uof.by.reason, count = n())

p.uof.by.reason <- plot_ly(count.by.reason,  type = 'pie', name = title,
                           labels = ~Reason.for.force, 
                           values = ~count,
                           textposition = 'inside',
                           textinfo = 'label+value+percent',
                           insidetextfont = list(color = '#FFFFFF')) %>%
  layout(
    paper_bgcolor = ll,
    plot_bgcolor = ll)
p.uof.by.reason$dependencies[[4]]$stylesheet <- "plotly-oipm.css"
p.uof.by.reason


title <- "Reason for exhibiting firearm"

firearm.by.reason <- uof.for.year %>% filter(Force.type == "Firearm Exhibited") %>% group_by(Reason.for.force)
count.by.firearm.reason <- summarise(firearm.by.reason, count = n())

p.firearm.by.reason <- plot_ly(count.by.firearm.reason,  type = 'pie', name = title,
                               labels = ~Reason.for.force, 
                               values = ~count,
                               textposition = 'inside',
                               textinfo = 'label+value+percent',
                               insidetextfont = list(color = '#FFFFFF')) %>%
  layout(
    paper_bgcolor = ll,
    plot_bgcolor = ll)
p.firearm.by.reason$dependencies[[4]]$stylesheet <- "plotly-oipm.css"
p.firearm.by.reason


p.black.by.district <- plot_ly(black.by.district, 
                               x = ~district, 
                               y = ~population, 
                               type = 'bar', 
                               name = "% black pop. by district") %>%
  
  add_trace(y = ~stops, name = "% stops are of black ppl by district") %>%
  
  add_trace(y = ~bookings, name = "% bookings are of black ppl by district") %>%
  
  add_trace(y = ~uof, name = "% force against black ppl by district") %>%
  
  layout(
    xaxis = list(
      categoryorder = "array",
      categoryarray = districts,
      title = F
    ),
    hovermode = 'compare',
    yaxis = list(title = F, dtick = 10),
    barmode = 'group') %>% layout(
  paper_bgcolor = ll,
  plot_bgcolor = ll, yaxis=list(tickfont=f2),
  legend = list(x = .1, y = -.5))


p.black.by.district$dependencies[[4]]$stylesheet <- "plotly-oipm.css"
p.black.by.district

#x = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"), 


p.black.by.month <- plot_ly(black.by.month, 
                            x = ~month, 
                            y = ~uof, name = 'Force', type = 'scatter', 
                            mode = 'lines+markers', 
                            line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'solid')) %>%
  
  add_trace(y = ~bookings, name = 'Bookings / Arrests', 
            mode = 'lines+markers',
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid')) %>%
  
  add_trace(y = ~stops, name = 'Stops & Searches', 
            mode = 'lines+markers',
            line = list(color = 'rgb(0, 255, 24)', width = 2, dash = 'solid')) %>%
  
  # Add horizontal line showing black pop in new orleans
  add_segments(name = "Black population of NO",
               x = 0, xend = 13, 
               y = 61, yend = 61, 
               line = list(color = 'rgb(229, 221, 59)', dash = 'solid')) %>%
  
  layout(title = F, xaxis = list(
    dtick = 1,
    title = F,
    tickfont = f1,
    showgrid = F
  ),
  yaxis = list(title = F, tickfont = f2)) %>% layout(
    paper_bgcolor = ll,
    plot_bgcolor = ll,
    legend = list(x = .1, y = 1.05))

p.black.by.month$dependencies[[4]]$stylesheet <- "plotly-oipm.css"
p.black.by.month
