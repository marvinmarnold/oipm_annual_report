check.vars(c("uof.for.year", "ftn.for.year", "active.officers.for.year"))

########################################################################################################
########################################################################################################

num.officers <- nrow(active.officers.for.year)
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