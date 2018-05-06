check.vars(c("officers.csv"))
if (!exists("complaints.by.month")) source("iapro/complaints_misconduct_by_month.R")

title <- paste("Percent of active duty officers with complaints and misconduct in", year)

########################################################################################################
########################################################################################################

num.officers <- nrow(officersAll)
complaints.by.month <- complaints.by.month %>% mutate(
  pct.officers.w.complaint = num.complaints / num.officers * 100
)

misconduct.by.month <- misconduct.by.month %>% mutate(
  pct.officers.w.misconduct = num.misconduct / num.officers * 100
)

xform <- list(categoryorder = "array",
              categoryarray = months,
              title = "Month", 
              showgrid = T)

df <- data.frame(
  months, 
  pct.complaint = complaints.by.month$pct.officers.w.complaint, 
  pct.misconduct = misconduct.by.month$pct.officers.w.misconduct)

p <- plot_ly(df, x = ~months, y = ~pct.complaint, type = 'bar', name = '% officers w/ compaint') %>%
  add_trace(y = ~pct.misconduct, name = '% officers w/ misconduct') %>%
  layout(yaxis = list(title = paste('Percent of active duty officers in', year)), xaxis = xform, barmode = 'group')

chart_link = api_create(p, filename=title)
chart_link