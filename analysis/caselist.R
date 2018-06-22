case.list <- read.csv(file = "data_public/caselist.csv", header = FALSE)
trimws(case.list$V1)

matching.cases <- allegations.all %>% 
  filter(
    trimws(PIB.Control.Number) %in% trimws(case.list$V1)) %>% 
  select(
    PIB.Control.Number,
    Allegation.Finding.OIPM,
    Officer.Race,
    Officer.sex,
    Citizen.sex,
    Citizen.race
  ) %>% distinct()

write.csv(matching.cases, file = "data/case_demographics_v01.csv")

matching.cases %>% select(PIB.Control.Number) %>% distinct() %>% nrow
matching.cases %>% filter(PIB.Control.Number == "2017-0037-P")
