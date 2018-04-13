check.vars(c("uof.for.year"))
title <- "Force by officer age and experience"

########################################################################################################
########################################################################################################

# Add columns containing officer age and experience in buckets
age.bucket.function <- function(age) {
  if (is.na(age)) {
    'Unknown age'
  } else  if (age < 26) {
    'Age 25 or under'
  } else if (age >= 26 & age < 31) {
    'Age 26 to 30'
  } else if (age >= 31 & age < 36) {
    'Age 31 to 35'
  } else if (age >= 36 & age < 41) {
    'Age 36 to 40'
  } else if (age >= 41 & age < 46) {
    'Age 41 to 45'
  } else if (age >= 46 & age < 50) {
    'Age 46 to 50'
  } else {
    'Age 51 or older'
  }
}

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

# plot the summary
xform <- list(categoryorder = "array",
              categoryarray = c('Unknown age', 'Age under 26', 'Age 26 to 30', 'Age 31 to 35', 'Age 36 to 40', 'Age 41 to 45', 'Age 46 to 50', 'Age 51 or older'),
              title = "Age range", 
              showgrid = T)

p <- plot_ly(count.by.age.exp, x = ~age.bucket, y = ~num.uof, type = 'bar',  name = ~exp.bucket, color = ~exp.bucket) %>%
  layout(xaxis = xform, yaxis = list(title = 'Number UOF'), barmode = 'stack')

p
api_create(p, filename=title, sharing = "public")
