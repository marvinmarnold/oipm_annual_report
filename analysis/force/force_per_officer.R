check.vars(c("uof.for.year", "ftn.for.year", "officers.adp.for.year"))

########################################################################################################
########################################################################################################

num.officers <- nrow(officers.adp.for.year)
num.officers.force <- uof.for.year %>% select(Officer.primary.key) %>% distinct %>% nrow

num.ftn <- ftn.for.year %>% nrow
num.uof <- uof.for.year %>% nrow

labels <- c("NOPD average", "Average for officers who used force at least once in 2017")
force.class <- c("FTN Avg", "UOF Avg")
avg.overall <- c(num.ftn / num.officers, num.uof / num.officers)
avg.w.force <- c(num.ftn / num.officers.force, num.uof / num.officers.force)

force.per.officer <- data.frame(
  force.class = force.class,
  avg.overall = avg.overall,
  avg.w.force = avg.w.force
)

p.force.per.officer <- plot_ly(force.per.officer, 
                               x = ~force.class, 
                               y = ~avg.overall, type = 'bar', name = labels[1]) %>%
  
  add_trace(y = ~avg.w.force, name = labels[2]) %>%
  layout(yaxis = list(title = 'Avg FTN/UOF per officer'), barmode = 'group')

p.force.per.officer

########################################################################################################
########################################################################################################

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

# FTN Analysis
# This is a little fudged. Not using the count of FTN, instead using the count of unique <FTN, Officer>
ftn.per.officer <- uof.for.year %>% select(FIT.Number, Officer.primary.key) %>% distinct %>% group_by(Officer.primary.key)
ftn.count.per.officer <- ftn.per.officer %>% summarise(count = n())
ftn.count.per.officer <- ftn.count.per.officer %>% mutate(
  rank = rank(-count, ties.method ="first"),
  rank.bucket = sapply(rank, bucket.rank)
) %>% arrange(rank)

ftn.per.bucket <- ftn.count.per.officer %>% group_by(rank.bucket)
ftn.count.per.bucket <- ftn.per.bucket %>% summarise(count = sum(count))
ftn.count.per.bucket <- ftn.count.per.bucket %>% mutate(
  hist.count = bucket.hist(ftn.count.per.bucket, rank.bucket, count),
  hist.pct = hist.count / sum(count) * 100,
  rank.bucket = as.character(rank.bucket)
)

force.count.per.bucket <- data.frame(
  rank.buckets = c("5", "10", "20", "100", "200", "300", "400", "500"),
  uof.pct.per.bucket = uof.count.per.bucket$hist.pct,
  ftn.pct.per.bucket = ftn.count.per.bucket$hist.pct
)

p.force.per.bucket <- plot_ly(force.count.per.bucket, 
                               x = ~rank.buckets, 
                               y = ~ftn.pct.per.bucket, type = 'bar', 
                              name = "Top X officers contribution to FTN") %>%
  
  add_trace(y = ~uof.pct.per.bucket, name = "Top X officers contribution to UOF") %>%
  
  layout(
    xaxis = list(
      categoryorder = "array",
      categoryarray = c("5", "10", "20", "100", "200", "300", "400", "500"),
      title = "Top X officers using most force"
    ),
    yaxis = list(title = 'Percentage of force by top X officers', dtick = 10), 
    barmode = 'group')

p.force.per.bucket

########################################################################################################
########################################################################################################
# Breakout information about officers using most force

## TOP 5
inspect.rank <- 5

top.5.uof <- uof.count.per.officer %>% filter(rank.bucket <= inspect.rank)
top.5.officers.uof <- merge(top.5.uof, all.officers.oipm, by.x = "Officer.primary.key", by.y = "Officer.number")

# Number missing
top.5.uof.num.missing <- inspect.rank - nrow(top.5.officers.uof)

# Pct force
top.5.uof.pct <- force.count.per.bucket %>% filter(rank.buckets == inspect.rank) %>% select(uof.pct.per.bucket)

# Count males
top.5.uof.num.male <- top.5.officers.uof %>% filter(Officer.sex == 'M') %>% nrow

# Age
top.5.uof.min.age <- min(top.5.officers.uof$Age %>% na.omit())
top.5.uof.max.age <- max(top.5.officers.uof$Age %>% na.omit())

# Experience
top.5.uof.min.exp <- min(top.5.officers.uof$Years.employed %>% na.omit())
top.5.uof.max.exp <- max(top.5.officers.uof$Years.employed %>% na.omit())

# Race
#top.5.uof.races <- top.5.officers.uof %>% select(Officer.race) %>% group_by(Officer.race) %>% summarise(count = n())
top.5.uof.num.white <- top.5.officers.uof %>% filter(Officer.race == 'White') %>% nrow
top.5.uof.num.black <- top.5.officers.uof %>% filter(Officer.race == 'Black / African American') %>% nrow
top.5.uof.num.hispanic <- top.5.officers.uof %>% filter(Officer.race == 'Hispanic') %>% nrow
top.5.uof.num.native <- top.5.officers.uof %>% filter(Officer.race == 'Native American') %>% nrow
top.5.uof.num.asian <- top.5.officers.uof %>% filter(Officer.race == 'Asian / Pacific Islander') %>% nrow
top.5.uof.num.race <- top.5.officers.uof %>% filter(Officer.race == 'Unknown race') %>% nrow

# Division
top.5.officers.uof.division <- top.5.officers.uof %>% select(Officer.division) %>% group_by(Officer.division) %>% summarise(count = n())

# Unit
top.5.officers.uof.unit <- top.5.officers.uof %>% select(Officer.sub.division.A) %>% group_by(Officer.sub.division.A) %>% summarise(count = n())

#### FTN

top.5.ftn <- ftn.count.per.officer %>% filter(rank.bucket <= inspect.rank)
top.5.officers.ftn <- merge(top.5.ftn, all.officers.oipm, by.x = "Officer.primary.key", by.y = "Officer.number")

# Number missing
top.5.ftn.num.missing <- inspect.rank - nrow(top.5.officers.ftn)

# Pct force
top.5.ftn.pct <- force.count.per.bucket %>% filter(rank.buckets == inspect.rank) %>% select(ftn.pct.per.bucket)

# Count males
top.5.ftn.num.male <- top.5.officers.ftn %>% filter(Officer.sex == 'M') %>% nrow

# Age
top.5.ftn.min.age <- min(top.5.officers.ftn$Age %>% na.omit())
top.5.ftn.max.age <- max(top.5.officers.ftn$Age %>% na.omit())

# Experience
top.5.ftn.min.exp <- min(top.5.officers.ftn$Years.employed %>% na.omit())
top.5.ftn.max.exp <- max(top.5.officers.ftn$Years.employed %>% na.omit())

# Race
#top.5.ftn.races <- top.5.officers.ftn %>% select(Officer.race) %>% group_by(Officer.race) %>% summarise(count = n())
top.5.ftn.num.white <- top.5.officers.ftn %>% filter(Officer.race == 'White') %>% nrow
top.5.ftn.num.black <- top.5.officers.ftn %>% filter(Officer.race == 'Black / African American') %>% nrow
top.5.ftn.num.hispanic <- top.5.officers.ftn %>% filter(Officer.race == 'Hispanic') %>% nrow
top.5.ftn.num.native <- top.5.officers.ftn %>% filter(Officer.race == 'Native American') %>% nrow
top.5.ftn.num.asian <- top.5.officers.ftn %>% filter(Officer.race == 'Asian / Pacific Islander') %>% nrow
top.5.ftn.num.race <- top.5.officers.ftn %>% filter(Officer.race == 'Unknown race') %>% nrow

# Division
top.5.officers.ftn.division <- top.5.officers.ftn %>% select(Officer.division) %>% group_by(Officer.division) %>% summarise(count = n())

# Unit
top.5.officers.ftn.unit <- top.5.officers.ftn %>% select(Officer.sub.division.A) %>% group_by(Officer.sub.division.A) %>% summarise(count = n())

########################################################################################################
########################################################################################################
# Breakout information about officers using most force

## TOP 10
inspect.rank <- 10

top.10.uof <- uof.count.per.officer %>% filter(rank.bucket <= inspect.rank)
top.10.officers.uof <- merge(top.10.uof, all.officers.oipm, by.x = "Officer.primary.key", by.y = "Officer.number")

# Number missing
top.10.uof.num.missing <- inspect.rank - nrow(top.10.officers.uof)

# Pct force
top.10.uof.pct <- force.count.per.bucket %>% filter(rank.buckets == inspect.rank) %>% select(uof.pct.per.bucket)

# Count males
top.10.uof.num.male <- top.10.officers.uof %>% filter(Officer.sex == 'M') %>% nrow

# Age
top.10.uof.min.age <- min(top.10.officers.uof$Age %>% na.omit())
top.10.uof.max.age <- max(top.10.officers.uof$Age %>% na.omit())

# Experience
top.10.uof.min.exp <- min(top.10.officers.uof$Years.employed %>% na.omit())
top.10.uof.max.exp <- max(top.10.officers.uof$Years.employed %>% na.omit())

# Race
#top.10.uof.races <- top.10.officers.uof %>% select(Officer.race) %>% group_by(Officer.race) %>% summarise(count = n())
top.10.uof.num.white <- top.10.officers.uof %>% filter(Officer.race == 'White') %>% nrow
top.10.uof.num.black <- top.10.officers.uof %>% filter(Officer.race == 'Black / African American') %>% nrow
top.10.uof.num.hispanic <- top.10.officers.uof %>% filter(Officer.race == 'Hispanic') %>% nrow
top.10.uof.num.native <- top.10.officers.uof %>% filter(Officer.race == 'Native American') %>% nrow
top.10.uof.num.asian <- top.10.officers.uof %>% filter(Officer.race == 'Asian / Pacific Islander') %>% nrow
top.10.uof.num.race <- top.10.officers.uof %>% filter(Officer.race == 'Unknown race') %>% nrow

# Division
top.10.officers.uof.division <- top.10.officers.uof %>% select(Officer.division) %>% group_by(Officer.division) %>% summarise(count = n())

# Unit
top.10.officers.uof.unit <- top.10.officers.uof %>% select(Officer.sub.division.A) %>% group_by(Officer.sub.division.A) %>% summarise(count = n())

#### FTN

top.10.ftn <- ftn.count.per.officer %>% filter(rank.bucket <= inspect.rank)
top.10.officers.ftn <- merge(top.10.ftn, all.officers.oipm, by.x = "Officer.primary.key", by.y = "Officer.number")

# Number missing
top.10.ftn.num.missing <- inspect.rank - nrow(top.10.officers.ftn)

# Pct force
top.10.ftn.pct <- force.count.per.bucket %>% filter(rank.buckets == inspect.rank) %>% select(ftn.pct.per.bucket)

# Count males
top.10.ftn.num.male <- top.10.officers.ftn %>% filter(Officer.sex == 'M') %>% nrow

# Age
top.10.ftn.min.age <- min(top.10.officers.ftn$Age %>% na.omit())
top.10.ftn.max.age <- max(top.10.officers.ftn$Age %>% na.omit())

# Experience
top.10.ftn.min.exp <- min(top.10.officers.ftn$Years.employed %>% na.omit())
top.10.ftn.max.exp <- max(top.10.officers.ftn$Years.employed %>% na.omit())

# Race
#top.10.ftn.races <- top.10.officers.ftn %>% select(Officer.race) %>% group_by(Officer.race) %>% summarise(count = n())
top.10.ftn.num.white <- top.10.officers.ftn %>% filter(Officer.race == 'White') %>% nrow
top.10.ftn.num.black <- top.10.officers.ftn %>% filter(Officer.race == 'Black / African American') %>% nrow
top.10.ftn.num.hispanic <- top.10.officers.ftn %>% filter(Officer.race == 'Hispanic') %>% nrow
top.10.ftn.num.native <- top.10.officers.ftn %>% filter(Officer.race == 'Native American') %>% nrow
top.10.ftn.num.asian <- top.10.officers.ftn %>% filter(Officer.race == 'Asian / Pacific Islander') %>% nrow
top.10.ftn.num.race <- top.10.officers.ftn %>% filter(Officer.race == 'Unknown race') %>% nrow

# Division
top.10.officers.ftn.division <- top.10.officers.ftn %>% select(Officer.division) %>% group_by(Officer.division) %>% summarise(count = n())

# Unit
top.10.officers.ftn.unit <- top.10.officers.ftn %>% select(Officer.sub.division.A) %>% group_by(Officer.sub.division.A) %>% summarise(count = n())

########################################################################################################
########################################################################################################
# Breakout information about officers using most force

## TOP 20
inspect.rank <- 20

top.20.uof <- uof.count.per.officer %>% filter(rank.bucket <= inspect.rank)
top.20.officers.uof <- merge(top.20.uof, all.officers.oipm, by.x = "Officer.primary.key", by.y = "Officer.number")

# Number missing
top.20.uof.num.missing <- inspect.rank - nrow(top.20.officers.uof)

# Pct force
top.20.uof.pct <- force.count.per.bucket %>% filter(rank.buckets == inspect.rank) %>% select(uof.pct.per.bucket)

# Count males
top.20.uof.num.male <- top.20.officers.uof %>% filter(Officer.sex == 'M') %>% nrow

# Age
top.20.uof.min.age <- min(top.20.officers.uof$Age %>% na.omit())
top.20.uof.max.age <- max(top.20.officers.uof$Age %>% na.omit())

# Experience
top.20.uof.min.exp <- min(top.20.officers.uof$Years.employed %>% na.omit())
top.20.uof.max.exp <- max(top.20.officers.uof$Years.employed %>% na.omit())

# Race
#top.20.uof.races <- top.20.officers.uof %>% select(Officer.race) %>% group_by(Officer.race) %>% summarise(count = n())
top.20.uof.num.white <- top.20.officers.uof %>% filter(Officer.race == 'White') %>% nrow
top.20.uof.num.black <- top.20.officers.uof %>% filter(Officer.race == 'Black / African American') %>% nrow
top.20.uof.num.hispanic <- top.20.officers.uof %>% filter(Officer.race == 'Hispanic') %>% nrow
top.20.uof.num.native <- top.20.officers.uof %>% filter(Officer.race == 'Native American') %>% nrow
top.20.uof.num.asian <- top.20.officers.uof %>% filter(Officer.race == 'Asian / Pacific Islander') %>% nrow
top.20.uof.num.race <- top.20.officers.uof %>% filter(Officer.race == 'Unknown race') %>% nrow

# Division
top.20.officers.uof.division <- top.20.officers.uof %>% select(Officer.division) %>% group_by(Officer.division) %>% summarise(count = n())

# Unit
top.20.officers.uof.unit <- top.20.officers.uof %>% select(Officer.sub.division.A) %>% group_by(Officer.sub.division.A) %>% summarise(count = n())

#### FTN

top.20.ftn <- ftn.count.per.officer %>% filter(rank.bucket <= inspect.rank)
top.20.officers.ftn <- merge(top.20.ftn, all.officers.oipm, by.x = "Officer.primary.key", by.y = "Officer.number")

# Number missing
top.20.ftn.num.missing <- inspect.rank - nrow(top.20.officers.ftn)

# Pct force
top.20.ftn.pct <- force.count.per.bucket %>% filter(rank.buckets == inspect.rank) %>% select(ftn.pct.per.bucket)

# Count males
top.20.ftn.num.male <- top.20.officers.ftn %>% filter(Officer.sex == 'M') %>% nrow

# Age
top.20.ftn.min.age <- min(top.20.officers.ftn$Age %>% na.omit())
top.20.ftn.max.age <- max(top.20.officers.ftn$Age %>% na.omit())

# Experience
top.20.ftn.min.exp <- min(top.20.officers.ftn$Years.employed %>% na.omit())
top.20.ftn.max.exp <- max(top.20.officers.ftn$Years.employed %>% na.omit())

# Race
#top.20.ftn.races <- top.20.officers.ftn %>% select(Officer.race) %>% group_by(Officer.race) %>% summarise(count = n())
top.20.ftn.num.white <- top.20.officers.ftn %>% filter(Officer.race == 'White') %>% nrow
top.20.ftn.num.black <- top.20.officers.ftn %>% filter(Officer.race == 'Black / African American') %>% nrow
top.20.ftn.num.hispanic <- top.20.officers.ftn %>% filter(Officer.race == 'Hispanic') %>% nrow
top.20.ftn.num.native <- top.20.officers.ftn %>% filter(Officer.race == 'Native American') %>% nrow
top.20.ftn.num.asian <- top.20.officers.ftn %>% filter(Officer.race == 'Asian / Pacific Islander') %>% nrow
top.20.ftn.num.race <- top.20.officers.ftn %>% filter(Officer.race == 'Unknown race') %>% nrow

# Division
top.20.officers.ftn.division <- top.20.officers.ftn %>% select(Officer.division) %>% group_by(Officer.division) %>% summarise(count = n())

# Unit
top.20.officers.ftn.unit <- top.20.officers.ftn %>% select(Officer.sub.division.A) %>% group_by(Officer.sub.division.A) %>% summarise(count = n())

