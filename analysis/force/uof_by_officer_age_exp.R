check.vars(c("uof.for.year", "officers.adp.for.year"))
title <- "Force by officer age and experience"

ordered.age.buckets <- c('25 or younger', '26 - 30', '31 - 35', '36 - 40', '41 - 45', '46 - 50', '51 or older', 'Unknown age')

########################################################################################################
########################################################################################################

# Add columns containing officer age and experience in buckets

uof.bucketed <- uof.for.year %>% mutate(
  age.bucket = sapply(Officer.age.at.time.of.UOF, age.bucket.function),
  exp.bucket = sapply(Officer.years.exp.at.time.of.UOF, exp.bucket.function)
)

# group by age and experience
uof.by.age.exp <- uof.bucketed %>% group_by(age.bucket, exp.bucket) 
count.by.age.exp <- summarise(uof.by.age.exp, num.uof = n())

# pct of active officers in each age bucket
num.officers <- nrow(officers.adp.for.year)
age.buckets <- uof.bucketed %>% select(age.bucket) %>% distinct
age.buckets <- age.buckets %>% mutate(
  count = sapply(age.buckets$age.bucket, function(age.bucket) {
    sum(officers.adp.for.year$age.bucket == age.bucket)
  }),
  
  pct = count / num.officers * 100)

ordered.pct.by.age.bucket <- merge(data.frame(age.bucket=ordered.age.buckets), age.buckets)
p.uof.by.officer.age.exp <- plot_ly(count.by.age.exp) %>%
  
  # Stacked bars by exp
  add_trace(x = count.by.age.exp$age.bucket, 
            y = count.by.age.exp$num.uof, 
            type = 'bar',  
            name = count.by.age.exp$exp.bucket, 
            color = count.by.age.exp$exp.bucket) %>%
  
  # pct active officers at age
  add_trace(x = ordered.age.buckets, 
            y = ordered.pct.by.age.bucket$pct,
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
