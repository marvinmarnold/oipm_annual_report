check.vars(c("year", "allegations.for.year"))
title <- "Fourth amendment violations"

########################################################################################################
########################################################################################################

relevant.directives <- c(
  "Policy # 400 - Patrol Operations; Policy 440 - PR 440 - Contacts-Detentions and Photographing Detainees, Paragraph PR440.3 - Reporting",
  "R.S. 14:46 False Imprisonment",
  "R.S. 14:46, False Imprisonment",
  "NOPD Chapter 1 Law Enforcement and Authority - Chapter 1.2.4.1 - Stops - Terry Stops",
  "NOPD Chapter 1 Law Enforcement and Authority - Chapter 1.2.4.1 - Stops - Terry Stops section 31",
  "NOPD Chapter 1.3.1.1 - Handcuffing and Restraint Devices, Paragraph 47",
  "NOPD Policy: Chapter 1.2.4 - Search and Seizure",
  "NOPD Policy: Chapter 1.2.4.1 - Stops / Terry Stops",
  "NOPD Policy: Chapter 1.3.1.1 - Handcuffing and Restraint Devices",
  "NOPD Policy: Chapter 1.3.1.1 - Handcuffing and Restraint Devices, subsection 12F",
  "Policy # 300 - Procedures; Policy 322 - PR322 - Search & Seizure; Paragraph 322.2 - Searches",
  "Policy # 300 - Procedures; Policy 322 - PR322 - Search & Seizure; Paragraph 322.3 - Searches",
  "Policy # 300 - Procedures; Policy 323 - PR323 - Custody Searches",
  "Policy # 300 - Procedures; Policy 323 - PR323 - Custody Searches; Paragraph 323.2 - Definitions, Strip Search",
  "Policy # 400 - Patrol Operations; Policy 402 - PR 402 - Discriminatory Policing-Racial Bias-Based Profiling",
  "Policy # 400 - Patrol Operations; Policy 402 - PR 402 - Discriminatory Policing-Racial Bias-Based Profiling, Paragraph 402.2 - Policy",
  "Policy # 400 - Patrol Operations; Policy 402 - PR 402 - Discriminatory Policing-Racial Bias-Based Profiling, Paragraph PR402.3 Discriminatory Policing/Bias Based Profiling Prohibited",
  "Policy # 400 - Patrol Operations; Policy 440 - PR 440 - Contacts-Detentions and Photographing Detainees",
  "Policy # 400 - Patrol Operations; Policy 440 - PR 440 - Contacts-Detentions and Photographing Detainees, Paragraph PR440.2- Pat-Down Searches",
  "Policy # 400 - Patrol Operations; Policy 440 - PR 440 - Contacts-Detentions and Photographing Detainees, Paragraph PR440.3 - (b)",
  "Policy # 400 - Patrol Operations; Policy 440 - PR 440 - Contacts-Detentions and Photographing Detainees, Paragraph PR440.3 - Reporting",
  "Policy # 400 - Patrol Operations; Policy 440 - PR 440 - Contacts-Detentions and Photographing Detainees, Paragraph PR440.3 - Reporting, Subparagraph (a) - FIC to be recorded for Terry Stop",
  "Policy # 400 - Patrol Operations; Policy 440 - PR 440 - Contacts-Detentions and Photographing Detainees, Paragraph PR440.3 - Reporting, Subparagraph (c) - FIC to be recorded for Traffic Stop",
  "Policy # 400 - Patrol Operations; Policy 440 - PR 440 - Contacts-Detentions and Photographing Detainees, Paragraph PR440.3 (a)"
)

library(plyr)
fourth.violations <- ldply(relevant.directives, function(directive) {
  allegations.for.year %>% filter(grepl(directive, Allegation.directive))
})
detach("package:plyr", unload=FALSE)

fourth.violations <- fourth.violations %>% select(PIB.Control.Number, Allegation.directive) %>% 
  distinct %>% 
  mutate(
    abbr.directive = substr(Allegation.directive, 1, 45)    
  ) %>%
  select (abbr.directive) %>%
  group_by(abbr.directive)

count.fourth.violations <- fourth.violations %>% summarise(num.violations = n())
count.fourth.violations

p.fourth.viol <- plot_ly(count.fourth.violations,  type = 'pie', name = title,
                       labels = ~abbr.directive, 
                       values = ~num.violations,
                       textposition = 'inside',
                       textinfo = 'label+value+percent',
                       insidetextfont = list(color = '#FFFFFF'))
p.fourth.viol



                                