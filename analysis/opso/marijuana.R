title <- "Marijuana charges by year"

########################################################################################################
########################################################################################################

marijuana.by.year <- charges.all %>% 
                        select(In.Year, Verbage) %>% 
                        filter(grepl("marijuana", Verbage, ignore.case = TRUE)) %>%
                        filter(In.Year >= 2015) %>%
                        group_by(In.Year) %>%
                        summarise(marijuana.charges = n())

#violations <- charges.for.year %>% select(Verbage, Violation) %>% distinct
#write.csv(violations, file = "OPSO_Violations.csv")


p <- plot_ly(marijuana.by.year, 
             x = ~In.Year, 
             y = ~marijuana.charges, 
             name = 'Marijuana related charges by year', 
             type = 'scatter', 
             mode = 'lines+markers', 
             line = list(color = 'rgb(22, 96, 167)', width = 2, dash = 'dash')) %>%
  
  layout(title = title,
          xaxis = list(dtick = 1),
         yaxis = list(range = c(0, 1800)))
p
#api_create(p, filename=paste(title, "reason"), sharing = "public")


