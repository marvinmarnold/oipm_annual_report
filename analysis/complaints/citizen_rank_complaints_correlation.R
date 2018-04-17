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
