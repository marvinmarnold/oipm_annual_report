
# make data wide
wide <- data.table::dcast(simple, Force.type ~ Force.level, value.var = "count")
wide[is.na(wide)] <- 0
wide

plot_ly(simple, x = ~Force.level, y = ~count, type = 'bar',  name = ~Force.type, color = ~Force.type) %>%
  layout(yaxis = list(title = 'Count'), barmode = 'stack')

data.m <- data.table::melt(simple, id.vars='Force.level', variable.name='count')
data.m 

nrow(simple)
length(unique(simple$Force.type))
plot_ly(simple, x = ~Force.level, y = ~count, type = "bar")

p <- plot_ly(x = lvls, type = "bar") 

e <- function (r) {
  p %>% add_trace(y = ~count)
}

apply(simple, 1, e)

report <- summarise(uofByType, count = n()) %>% mutate(
  L0 = as.integer(ifelse(Force.level == 0, count, 0)),
  L1 = as.integer(ifelse(Force.level == 1, count, 0)),
  L2 = as.integer(ifelse(Force.level == 2, count, 0)),
  L3 = as.integer(ifelse(Force.level == 3, count, 0)),
  L4 = as.integer(ifelse(Force.level == 4, count, 0))
)
report


# Check and change type of Force.level column
transform(uof2017, Force.level = as.integer(Force.level))
sapply(uof2017, mode)

lvls <- uof2017 %>% select(Force.level) %>% distinct()
lvls

