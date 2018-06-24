check.vars(c("uof.reported.2015.csv.dirty"))

########################################################################################################
########################################################################################################

uof.reported.2015 <- read.csv(uof.reported.2015.csv.dirty, stringsAsFactors = FALSE)

recategorize.force.type <- function(force.types, force.levels) {
  mapply(function (force.type, force.level) {
    if (force.type == 'Firearm (Exhibited)') {
      "Firearm Exhibited"
    } else if (force.type == 'CEW Deployment') { 
      "Taser No-Hit" 
    } else if (force.type == 'Hands') { 
      "Hands / Escort tech" 
    } else if (force.type == 'CEW Exhibited/Laser') { 
      "Taser Exhibited " 
    } else if (force.type == 'Rifle (Pointed)') { 
      "Firearm Exhibited" 
    } else if (force.type == 'Force (Take Down)') { 
      "Defense Tech / Take-down" 
    } else if (force.type == 'Force (Escort Tech)') { 
      "Hands / Escort tech" 
    } else if (force.type == 'Baton/PR-24 (Miss)') { 
      "Baton Miss" 
    } else if (force.type == 'Baton/PR-24(NonStrk)') { 
      "Baton Miss" 
    } else if (force.type == 'Handgun Exhibited') { 
      "Firearm Exhibited" 
    } else if (force.type == 'Handcuffed Subject') { 
      "Head strike while Hancuffed" 
    } else if (force.type == 'Firearm (Discharged)') { 
      "Firearm Discharged" 
    } else if (force.type == 'CEW') { 
      "Taser Hit" 
    } else if (force.type == 'NULL') { 
      "Not reported" 
    } else if (force.type == 'Force (Defense Tech)') { 
      "Defense Tech / Take-down" 
    } else if (force.type == 'Other') { 
      paste0(force.level, "-", force.type)
    } else {
      as.character(force.type)
    }
  }, force.types, force.levels)
}

recategorize.force.level <- function(force.types, force.levels) {
  mapply(function (force.type, force.level) {
    if (force.type == 'Handgun Exhibited') {
      "L1"
    } else if (force.type == 'NULL') { 
      "Not reported" 
    } else {
      as.character(force.level)
    }
  }, force.types, force.levels)
}


uof.reported.2015 <- uof.reported.2015 %>% mutate(
  Force.type = recategorize.force.type(Use.of.Force.Type, Use.of.Force.Level),
  Force.level = recategorize.force.level(Use.of.Force.Type, Use.of.Force.Level),
  Year.Occurred = 2015,
  year.of.record = 2015
) %>% select(
  Force.type, 
  Force.level, 
  year.of.record
)

write.csv(uof.reported.2015, "data_public/clean/uof_2015_clean.csv")

