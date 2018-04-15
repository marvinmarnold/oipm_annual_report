check.vars(c("uof.for.year", "officers.all"))
title <- "Force by officer age and experience"

ordered.age.buckets <- c('25 or younger', '26 - 30', '31 - 35', '36 - 40', '41 - 45', '46 - 50', '51 or older', 'Unknown age')

########################################################################################################
########################################################################################################

# Add columns containing officer age and experience in buckets

exp.bucket.function <- function(exp) {
  if (is.na(exp)) {
    'Unknown experience'
  } else  if (exp < 6) {
    '00 - 5 yr exp'
  } else if (exp >= 6 & exp < 11) {
    '06 - 10 yr exp'
  } else if (exp >= 11 & exp < 16) {
    '11 - 15 yr exp'
  } else {
    '16+ yr exp'
  }
}

uof.bucketed <- uof.for.year %>% mutate(
  age.bucket = sapply(Officer.age.at.time.of.UOF, age.bucket.function),
  exp.bucket = sapply(Officer.years.exp.at.time.of.UOF, exp.bucket.function)
)

# group by age and experience
uof.by.age.exp <- uof.bucketed %>% group_by(age.bucket, exp.bucket) 
count.by.age.exp <- summarise(uof.by.age.exp, num.uof = n())

# pct of active officers in each age bucket
num.officers <- nrow(officers.all)
age.buckets <- uof.bucketed %>% select(age.bucket) %>% distinct
age.buckets <- age.buckets %>% mutate(
  count = sapply(age.buckets$age.bucket, function(age.bucket) {
    sum(officers.all$age.bucket == age.bucket)
  }),
  
  pct = count / num.officers * 100)

p.uof.by.officer.age.exp <- plot_ly(count.by.age.exp) %>%
  
  # Stacked bars by exp
  add_trace(x = ~age.bucket, 
            y = ~num.uof, 
            type = 'bar',  
            name = ~exp.bucket, 
            color = ~exp.bucket) %>%
  
  # pct active officers at age
  add_trace(x = ordered.age.buckets, 
            y = age.buckets$pct,
            name = "% officers this age", 
            yaxis = 'y2',
            type = "scatter",
            mode = 'lines+markers',
            line = list(color = 'rgb(0, 0, 0)', width = 2, dash = 'solid')) %>%
  
  layout(barmode = 'stack',
         margin = list(b = 150),
         hovermode = 'compare',
         xaxis = list(categoryorder = "array",
                      categoryarray = ordered.age.buckets,
                      title = "Age range", 
                      showgrid = F), 
         
         yaxis = list(title = "Number UOF", showgrid = T),
         yaxis2 = list(side = 'right', overlaying = "y", 
                       title = "Percent active officers same age", 
                       range = c(0, 50), showgrid = F))

p.uof.by.officer.age.exp
