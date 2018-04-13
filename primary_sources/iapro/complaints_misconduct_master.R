check.vars(c("year", "complaints.misconduct.alleg.act.csv"))

########################################################################################################
########################################################################################################

# Read data
complaints.misconduct.all <- read.csv(complaints.misconduct.alleg.act.csv)

# 2017 analysis
complaints.alleg.act.for.year <- complaints.misconduct.all %>% 
  filter(Year.occurred == year)

unique(complaints.alleg.act.for.year$Allegation.finding)
distinct(complaints.alleg.act.for.year %>% select(FIT.Number, Officer.primary.key, Citizen.primary.key, Allegation, Action.taken))

allegations.for.year <- complaints.alleg.act.for.year %>% 
  select(FIT.Number, Officer.Race, Disposition.OIPM, Officer.primary.key, Allegation, Allegation.class, Officer.sex) %>% 
  distinct()

distinct(al)

allegations.for.year %>% select(FIT.Number, Citizen.primary.key)

complaints.all <- complaints.misconduct.all %>% 
  filter(Year.occurred == year, Incident.type == "Citizen Initiated")

misconduct.alleg.act.for.year <- complaints.misconduct.all %>% 
  filter(Year.occurred == year, Incident.type == "Rank Initiated")

misconduct.alleg.act <- rbind(complaints.alleg.act.for.year, misconduct.alleg.act.for.year)

# Print disposition normalization
dispositions <- unique(misconduct.alleg.act %>% select(Status, Disposition.Reported, Disposition.OIPM, Disposition.NOPD))
# write.csv(dispositions, "disposition_conversion.csv")

unique(dispositions$Disposition.OIPM)
# Dispositions
sustained, not sustained, exonerated, unfounded, withdrawn / mediated, NFIM, Illigitimate outcomes, DI2, pending

[1] NFIM                         Unclear data                                           
[5] Pending                                       NSA  -> Negotiated settlement                        Negotiated Settlement       
[9] Resigned under investigation 

# Allegation finding
[1]                          NFIM CASE -> NFIM
NO VIOLATIONS OBSERVED   -> Unfounded
NFOUNDED               -> Unfounded
DI-2                -> DI-2    
[6] NOT SUSTAINED      
EXONERATED       
SUSTAINED          
PENDING INVESTIGATION   
WITHDRAWN               -> illigitimate
[11] WITHDRAWN- MEDIATION    
CANCELLED                -> ill
NEGOTIATED SETTLEMENT    -> sustained
DUPLICATE ALLEGATION    -> ill
RECLASSIFIED AS DI-2    -> DI-2
[16] DUPLICATE INVESTIGATION -> ill
SUSTAINED - RUI - RETIRE -> ill
SUSTAINED - Deceased  -> sustained
NOT SUSTAINED - RUI  -> not sustained
RUI-Resigned Under Inves -> ill 
[21] Sustained - Dismissed  
sustained               
REDIRECTION           -> di2
AWAITING HEARING     -> sustained
Exonerated 

if any allegation sutained, case sutained