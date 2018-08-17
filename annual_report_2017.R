########################################################################################################
################################## 2017 ANNUAL REPORT MAIN SCRIPT ######################################

# Reset environment
rm(list = ls())

########################################################################################################
######################################## GLOBAL VARIABLES ##############################################
#setwd("/media/sf_oipm/code/repo/")
#setwd("/Users/sstone-777/Documents/GitHub/oipm_annual_report/")

# The current year to analyze
year <- 2017

# If source data is available, set to true.
# If the only data available is coming from a public repository, this should probably be set to false.
RECLEAN_DATA <- FALSE

############################################ DATA ##################################################
######### Officers

# ADP
officers.adp.csv.dirty <- "data/NOPD_20170511/officers_adp_20180507.csv"
officers.adp.csv <- "data_public/clean/officers_adp_clean.csv"

# IAPro
all.officers.iapro.csv.dirty <- "data/IAPro/officers_all_201805300012.csv"
all.officers.iapro.csv <- "data_public/clean/officer_iapro_clean.csv"

######### Use of Force
uof.csv.dirty <- "data/IAPro/uof_201805291744.csv"
uof.csv <- "data_public/clean/uof_clean.csv"

uof.reported.2015.csv.dirty <- "data/Dante/2015UOF.csv"
uof.reported.2015.csv <- "data_public/clean/uof_2015_clean.csv"

uof.opendata.csv <- "data_public/data.nola.gov/NOPD_Use_of_Force_Incidents_20180529.csv"

######### OIPM Survey
oipm.survey.csv.dirty <- "data/oipm_survey_results_20180531.csv"
oipm.survey.csv <- "data_public/clean/oipm_survey_clean.csv"

######## Bookings
bookings.csv.dirty <- "data/OPSO/20180516/JFI15M.TXT"
bookings.for.year.csv <- "data_public/clean/bookings_2017_clean.csv"

charges.csv.dirty <- "data/OPSO/20180516/JFI15MC.TXT"
charges.for.year.csv <- "data_public/clean/charges_2017_clean.csv"

##### Stops and searches from data.nola.gov
stops.csv <- "data/data.nola.gov/Stop_and_Search__Field_Interviews_20180507.csv"
stops.for.year.csv <- "data_public/data.nola.gov/stops_2017.csv"

##### Complaints and misconduct
# File with all complaints <complainant, officers, id, allegation>
allegations.csv.dirty <- "data/IAPro/allegations_201806241816.csv"
allegations.csv <- "data_public/clean/allegations_all_clean.csv"

actions.taken.csv.dirty <- "data/IAPro/actions_taken_201805300118.csv"
actions.taken.csv <- "data_public/clean/actions_taken_clean.csv"

######### Bodyworn cameras
bwc.public.csv <- "data_public/data.nola.gov/NOPD_Body_Worn_Camera_Metadata_2017.csv"
bwc.potential.csv <- "data_public/data.nola.gov/bwc_potential.csv"

cad.csv.dirty <- "data/NOPD_20170511/cad_2017.csv"
cad.csv <- "data_public/clean/cad_2017_clean.csv"
epr.csv <- "data_public/data.nola.gov/Electronic_Police_Report_2017.csv"

########################################################################################################
######################################## LOAD DEPENDENCIES #############################################

# Load libraries
library(plotly)
library(dplyr)
library(tidyr)
library(ggplot2)
library(leaflet)
library(maptools)
library(censusapi)

# You may also need to follow the three steps below if you want to use ggplot with plotly
# install.packages('devtools')
# library(devtools)
# devtools::install_github('hadley/ggplot2')
# devtools::install_github("hrecht/censusapi")
# devtools::install_github('rstudio/leaflet')

# Local helpers
source("lib/utils.R")

# Actual keys stored in .Rkeys
# Sys.setenv("plotly_username"="")
# Sys.setenv("plotly_api_key"="")
# Sys.setenv("CENSUS_KEY"="")
readRenviron("../.Renviron")

########################################################################################################
############################################# LOAD DATA ################################################

# Public data
source("primary_sources/data.nola.gov/police_districts.R")

# Data coming from non-public sources
if (RECLEAN_DATA) {
  # Officers
  source("clean/clean_officers.R")
  
  # OIPM survey
  source("clean/clean_oipm_survey.R")
  
  # Use of force
  source("clean/clean_uof.R")
  source("primary_sources/iapro/uof_ftn_secondary.R")
  source("primary_sources/data.nola.gov/uof.R")
  source("clean/clean_uof_2015.R")
  
  # Allegations
  source("clean/clean_allegations_complaints.R")
  source("primary_sources/iapro/allegations_complaints_secondary.R")
  
  source("clean/clean_actions_taken.R")
  source("primary_sources/iapro/actions_taken_secondary.R")
  
  # Stops and searches
  source("primary_sources/data.nola.gov/stops_master.R")

  # Bookings
  source("clean/clean_bookings.R")
  source("clean/clean_charges.R")
  
  source("clean/clean_bwc.R")
} else {
  # Officers
  source("primary_sources/iapro/officers_secondary.R")
  
  # OIPM survey
  source("primary_sources/oipm_survey_secondary.R")
  
  # Use of force
  source("primary_sources/data.nola.gov/uof.R")
  source("primary_sources/iapro/uof_ftn_secondary.R")
  source("primary_sources/uof2015_secondary.R")
  
  # Allegations
  source("primary_sources/iapro/allegations_complaints_secondary.R")
  source("primary_sources/iapro/actions_taken_secondary.R")
  
  # Bookings
  source("primary_sources/opso/bookings_secondary.R")
  source("primary_sources/opso/charges_secondary.R")
  
  # Stops
  source("primary_sources/data.nola.gov/stops_secondary.R")
}

