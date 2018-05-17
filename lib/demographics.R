
# Vintage year
vintage.year <-2016

# Name of census API
census.api.name <- "acs/acs5"

census.state <- "Louisiana"

########################################################################################################
########################################################################################################

# Get available APIs
available.apis <- listCensusApis()
View(available.apis)

# Search for APIs related to year
available.vars <- listCensusMetadata(name=census.api.name, vintage=vintage.year)
View(available.vars)

zip.str <- paste(la.zips, collapse = ",")

relevant.vars <- subset(available.vars, 
                        grepl("zip", available.vars$label, 
                              ignore.case = TRUE))
View(relevant.vars)

# Available geographies
available.geos <- listCensusMetadata(name=census.api.name, vintage=vintage.year, type="g")
View(available.geos)

# Demographics by ZIP from 
demographics.by.zip <- getCensus(name=census.api.name, 
                                 vintage=vintage.year, 
                                 vars=c("NAME", "B19013_001E", "B19013_001M", "B01003_001E", "B01003_001M"), 
                                 region="state:*")

# Get LA's code
la.code <- demographics.by.zip$state[demographics.by.zip$NAME == census.state]
la.code

# Demographics by ZIP from 
demographics.by.zip <- getCensus(name=census.api.name, 
                                 vintage=vintage.year, 
                                 vars=c("B00001_001E"), 
                                 region = paste0("zip code tabulation area:", zip.str))

demographics.by.zip
