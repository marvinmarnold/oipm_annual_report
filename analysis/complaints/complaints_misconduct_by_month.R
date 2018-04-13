if (!exists("complaints.misconduct.all")) source("iapro/complaints_misconduct_master.R")
title <- "2017 complaints and misconduct by month"

########################################################################################################
########################################################################################################

# Get unique complaint / misconduct IDs and the month they occurred
complaints.for.year <- unique(complaints.alleg.act.for.year %>% select(FIT.Number, Month.occurred))
misconduct.for.year <- unique(misconduct.alleg.act.for.year %>% select(FIT.Number, Month.occurred))

complaints.by.month <- complaints.for.year %>% group_by(Month.occurred) %>% summarize(num.complaints = n())
misconduct.by.month <- misconduct.for.year %>% group_by(Month.occurred) %>% summarize(num.misconduct = n())



df <- data.frame(month = months, 
                 complaints.by.month = complaints.by.month$num.complaints, 
                 misconduct.by.month = misconduct.by.month$num.misconduct)

xform <- list(categoryorder = "array",
              categoryarray = months,
              title = "Month", 
              showgrid = T)

p <- plot_ly(df, x = ~month, y = ~complaints.by.month, name = 'Complaints by month', type = 'scatter', 
             mode = 'lines+markers', 
             line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'solid')) %>%
  
  add_trace(y = ~misconduct.by.month, name = 'Misconduct by month', 
            mode = 'lines+markers',
            line = list(color = 'rgb(205, 12, 24)', width = 2, dash = 'solid')) %>%
  
  layout(title = title, xaxis = xform, yaxis = list(title = 'Num instance'))

p
#api_create(p, filename=title, sharing = "public")

########################################################################################################
########################################################################################################
# Plot correlation between variables

df <- data.frame(
  complaints.by.month = complaints.by.month$num.complaints,
  misconduct.by.month = misconduct.by.month$num.misconduct
)

# create multiple linear model
lm.fit <- lm(complaints.by.month ~ misconduct.by.month, data=df)
summary(lm.fit)

# save predictions of the model in the new data frame 
# together with variable you want to plot against
predicted.complaints <- data.frame(complaints.pred = predict(lm.fit, df), misconduct.by.month=df$misconduct.by.month)

# this is the predicted line of multiple linear regression
p <- ggplot(data = df, aes(x = complaints.by.month, y = misconduct.by.month)) + 
  geom_point(color='blue') +
  coord_cartesian(xlim = c(0, 50)) +
  geom_line(color='red', data = predicted.complaints, aes(x=complaints.pred, y=misconduct.by.month)) +
  ggtitle("Monthly coorelation between citizen and rank initiated complaints") +
  xlab("Citizent complaints per month") +
  ylab("Rank complaints per month")

p <- ggplotly(p)
#api_create(p, filename=paste("Coorelation between rank and civilian initiated complaints", year), sharing = "public")
