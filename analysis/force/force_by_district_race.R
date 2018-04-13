check.vars(c("uof.for.year"))
title <- "Force by district and race of victim"

########################################################################################################
########################################################################################################

uof.by.district.race <- uof.for.year %>% group_by(District.or.division, Citizen.race)
count.by.district.race <- summarise(uof.by.district.race, num.uof = n())
unique(uof.by.district.race$District.or.division)

p <- plot_ly(count.by.district.race, x = ~District.or.division, y = ~num.uof, type = 'bar',  name = ~Citizen.race, color = ~Citizen.race) %>%
  layout(yaxis = list(title = 'Number UOF'), barmode = 'stack')

p
api_create(p, filename=title, sharing = "public")

1] Seventh District                                   Fourth District                                   
[3] Eighth District                                    Third District                                    
[5] Second District                                    First District                                    
[7] Special Operations Division      (keep)                  Sixth District                                    
[9] Fifth District                                     Reserve Division                                  
[11] ISB Staff  (remove)                                        Special Investigations Division        (keep)           
[13] Records & Identification / Support Services Divisi Staff             (remove)                                
[15] Criminal Investigations Division    (remove)               Technology Section          (remove)     