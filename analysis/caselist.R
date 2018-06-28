case.list <- read.csv(file = "data_public/caselist.csv", header = FALSE)
trimws(case.list$V1)
allegations.for.year %>% distinct(PIB.Control.Number)
matching.cases <- allegations.all %>% 
  filter(
    trimws(PIB.Control.Number) %in% trimws(case.list$V1)) %>% 
  mutate(
    district = case_when(
      Assigned.division == "First District" ~ "1st District",
      Assigned.division == "Second District" ~ "2nd District",
      Assigned.division == "Third District" ~ "3rd District",
      Assigned.division == "Fourth District" ~ "4th District",
      Assigned.division == "Fifth District" ~ "5th District",
      Assigned.division == "Sixth District" ~ "6th District",
      Assigned.division == "Seventh District" ~ "7th District",
      Assigned.division == "Eighth District" ~ "8th District",
      TRUE ~ "Other"
    )
  )
# %>% 
#   select(
#     PIB.Control.Number,
#     Allegation.Finding.OIPM,
#     Officer.Race,
#     Officer.sex,
#     Citizen.sex,
#     Citizen.race,
#     officer.age.bucket,
#     citizen.age.bucket,
#     Officer.years.exp.at.time.of.UOF,
#     officer.exp.bucket,
#     district
#   ) %>% distinct()

#write.csv(matching.cases, file = "data/case_demographics_v01.csv")

# Num officers
matching.cases %>% distinct(Officer.primary.key) %>% nrow()

# Num cases
matching.cases %>% distinct(PIB.Control.Number) %>% nrow()

# Num sustained allegations
matching.cases %>% filter(Allegation.Finding.OIPM == "Sustained") %>% nrow()

# Num sustained cases
matching.cases %>% distinct(PIB.Control.Number, .keep_all = TRUE) %>% filter(Disposition.NOPD == "Sustained") %>% nrow()

# Num allegations
matching.cases %>% nrow()

# Pending
matching.cases %>% filter(Allegation.Finding.OIPM == "Pending")

# Race
## Public
cases.public.race.count <- matching.cases %>% 
  distinct(PIB.Control.Number, Citizen.primary.key, .keep_all = TRUE) %>% 
  group_by(Citizen.race) %>% 
  summarise(num.allegations = n())

title <- "Race of complainant"
p.cases.public.race.count <- plot_ly(cases.public.race.count,  
                                     type = 'pie',
                                     name = title,
                                      labels = ~Citizen.race, 
                                      values = ~num.allegations,
                                      textposition = 'inside',
                                      textinfo = 'label+value+percent',
                                      insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", title = title, showlegend = FALSE)

## NOPD
cases.nopd.race.count <- matching.cases %>% 
  distinct(PIB.Control.Number, Officer.primary.key, .keep_all = TRUE) %>% 
  group_by(Officer.Race) %>% 
  summarise(num.allegations = n())

title <- "Race of officer"
p.cases.officer.race.count <- plot_ly(cases.nopd.race.count,  
                                     type = 'pie',
                                     name = title,
                                     labels = ~Officer.Race, 
                                     values = ~num.allegations,
                                     textposition = 'inside',
                                     textinfo = 'label+value+percent',
                                     insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", title = title, showlegend = FALSE)

# Sex
## Public
cases.public.sex.count  <- matching.cases %>%
  distinct(PIB.Control.Number, Citizen.primary.key, .keep_all = TRUE) %>% 
  group_by(Citizen.sex) %>% 
  summarise(num.allegations = n())

title <- "Sex of complainant"
p.cases.public.sex.count <- plot_ly(cases.public.sex.count,  
                                      type = 'pie',
                                      name = title,
                                      labels = ~Citizen.sex, 
                                      values = ~num.allegations,
                                      textposition = 'inside',
                                      textinfo = 'label+value+percent',
                                      insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", title = title, showlegend = FALSE)

## NOPD
cases.nopd.sex.count  <- matching.cases %>% 
  distinct(PIB.Control.Number, Officer.primary.key, .keep_all = TRUE) %>% 
  group_by(Officer.sex) %>% 
  summarise(num.allegations = n())

title <- "Sex of officer"
p.cases.nopd.sex.count <- plot_ly(cases.nopd.sex.count,  
                                      type = 'pie',
                                      name = title,
                                      labels = ~Officer.sex, 
                                      values = ~num.allegations,
                                      textposition = 'inside',
                                      textinfo = 'label+value+percent',
                                      insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", title = title, showlegend = FALSE)

# Age
## Public
cases.public.age.count  <- matching.cases %>%
  distinct(PIB.Control.Number, Citizen.primary.key, .keep_all = TRUE) %>% 
  group_by(citizen.age.bucket) %>% 
  summarise(num.allegations = n())

title <- "Age of complainant"
p.cases.public.age.count <- plot_ly(cases.public.age.count,  
                                      type = 'pie',
                                      name = title,
                                      labels = ~citizen.age.bucket, 
                                      values = ~num.allegations,
                                      textposition = 'inside',
                                      textinfo = 'label+value+percent',
                                      insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", title = title, showlegend = FALSE)

## NOPD
cases.nopd.age.count  <- matching.cases %>% 
  distinct(PIB.Control.Number, Officer.primary.key, .keep_all = TRUE) %>% 
  group_by(officer.age.bucket) %>%
  summarise(num.allegations = n())

title <- "Age of officer"
p.cases.nopd.age.count <- plot_ly(cases.nopd.age.count,  
                                      type = 'pie',
                                      name = title,
                                      labels = ~officer.age.bucket, 
                                      values = ~num.allegations,
                                      textposition = 'inside',
                                      textinfo = 'label+value+percent',
                                      insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", title = title, showlegend = FALSE)

# Experience
cases.nopd.exp.count  <- matching.cases %>% 
  distinct(PIB.Control.Number, Officer.primary.key, .keep_all = TRUE) %>% 
  group_by(officer.exp.bucket) %>% 
  summarise(num.allegations = n())

title <- "Experience of officer"
p.cases.nopd.exp.count <- plot_ly(cases.nopd.exp.count,  
                                      type = 'pie',
                                      name = title,
                                      labels = ~officer.exp.bucket, 
                                      values = ~num.allegations,
                                      textposition = 'inside',
                                      textinfo = 'label+value+percent',
                                      insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", title = title, showlegend = FALSE)

# District
cases.nopd.district.count  <- matching.cases %>% 
  distinct(PIB.Control.Number, .keep_all = TRUE) %>% 
  group_by(district) %>% summarise(num.allegations = n())

title <- "District assigned"
p.cases.nopd.district.count <- plot_ly(cases.nopd.district.count,  
                                      type = 'pie',
                                      name = title,
                                      labels = ~district, 
                                      values = ~num.allegations,
                                      textposition = 'inside',
                                      textinfo = 'label+value+percent',
                                      insidetextfont = list(color = '#FFFFFF')) %>%
  
  layout(hovermode = "compare", title = title, showlegend = FALSE)

# Allegation outcomes
cases.finding.count  <- matching.cases %>% 
  distinct(Allegation.primary.key, .keep_all = TRUE) %>% 
  group_by(Allegation, Allegation.Finding.OIPM) %>% 
  summarise(num.allegations = n())

title <- "Allegation finding"
p.cases.allegation.findings <- plot_ly(cases.finding.count, 
                                            x = ~Allegation, 
                                            y = ~num.allegations, 
                                            type = 'bar', 
                                            name = ~Allegation.Finding.OIPM, 
                                            color = ~Allegation.Finding.OIPM) %>%
  
  layout(xaxis = list(title = "Type of allegation", 
                      showgrid = F), 
         yaxis = list(title = 'Number allegations'), 
         barmode = 'stack',
         hovermode = 'compare', 
         margin = list(r = 100, b = 200))

p.cases.allegation.findings
#write.csv(cases.finding.count, file = "data/export/caselist_findings.csv")

