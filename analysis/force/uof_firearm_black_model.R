# Statistical significance
# glm(isL2 ~ isBlack + isHispanic + age + as.factor(Reason.for.force) + as.factor(Reason.for.stop), whatever for logit)
# + district level crime + month

# Questions
# - Remind me what the "whatever for logit" is a placeholder for
# - What is district level crime? If I use arrest data, is it the total number of arrests per district per month? 
# Arrests per month/age/[isBlack+isHispanci]

########################################################################################################
########################################################################################################

# Add firearm.exhibited, is.victim.black, and is.victim.hispanic to the uof data
uof.recategorized <- uof.for.year %>% filter(Force.level == "L1")%>% mutate(
  
  # Was a firearm exhibited
  firearm.exhibited = case_when(
    Force.type == "Firearm Exhibited" ~ 1,
    TRUE ~ 0
  ),
  
  # Is the victim black
  is.victim.black = case_when(
    Citizen.race == black ~ 1,
    TRUE ~ 0
  ),
  
  # Is the victim hispanic
  is.victim.hispanic = case_when(
    Citizen.race == hispanic ~ 1,
    TRUE ~ 0
  )
)

# Add bookings
bookings.by.district <- charges.for.year %>% 
  select(Arrest.district, Folder.number, Race) %>% 
  filter(Arrest.district %in% 1:8) %>%
  distinct %>% 
  merge(district.num.names, by.x = "Arrest.district", by.y = "district.num") %>%
  group_by(Arrest.district, Race)

count.bookings.by.district <- bookings.by.district %>% 
  summarise(count = n())

# m <- lm(firearm ~ isWhite, data = uof.firearm.black)
# m <- glm(firearm ~ isWhite, data = uof.firearm.black, family="binomial")
# table(uof.for.year$Reason.for.force, uof.for.year$Force.level)
