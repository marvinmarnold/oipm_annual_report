########################################################################################################
################################## 2017 ANNUAL REPORT MAIN SCRIPT ######################################

# Reset environment
rm(list = ls())

########################################################################################################
######################################## GLOBAL VARIABLES ##############################################
#setwd("/home/pili/MEGA/code/repo")
#setwd("/media/sf_oipm/code/repo/")

# The current year to analyze
year <- 2017

######### IAPro

# Officers
officers.oipm.csv <- "data/IAPro/officers_oipm_201805291837.csv"
officers.adp.csv <- "data/NOPD_20170511/officers_adp_20180507.csv"
all.officers.csv <- "data/IAPro/officers_all_201805300012.csv"

# UOF
uof.csv <- "data/IAPro/uof_201805291744.csv"
uof.reported.2015.csv <- "data/Dante/2015UOF.csv"
uof.opendata.csv <- "data_public/data.nola.gov/NOPD_Use_of_Force_Incidents_20180529.csv"

# File with all complaints <complainant, officers, id, allegation>
allegations.csv <- "data/IAPro/allegations_201805301327.csv"

# Actions taken
actions.taken.csv <- "data/IAPro/actions_taken_201805300118.csv"

######### OPSO

# Bookings file from OPSO
bookings.csv <- "data/OPSO/20180516/JFI15M.TXT"
bookings.for.year.csv <- "data_public/opso/bookings_2017.csv"

charges.csv <- "data/OPSO/20180516/JFI15MC.TXT"
charges.for.year.csv <- "data_public/opso/charges_2017.csv"

######### data.nola.gov

# Stops and searches from data.nola.gov
stops.csv <- "data/data.nola.gov/Stop_and_Search__Field_Interviews_20180507.csv"
stops.for.year.csv <- "data_public/data.nola.gov/stops_2017.csv"

######### NOPD exports
bwc.nopd.csv <- "data/NOPD_20170511/2017 BWC officer ID and category for IPM.csv"
bwc.public.csv <- "data_public/data.nola.gov/NOPD_Body_Worn_Camera_Metadata_20180521.csv"

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
######################################## LOAD MASTER SCRIPTS ###########################################

source("primary_sources/data.nola.gov/police_districts.R")
source("primary_sources/iapro/officers_master.R")
source("primary_sources/iapro/uof_ftn_master.R")
source("primary_sources/iapro/allegations_complaints_master.R")
source("primary_sources/iapro/actions_taken_master.R")

# Uncomment the master script to re-generated cached data
# WARNING: This should be turned on when released

#source("primary_sources/data.nola.gov/stops_master.R")
source("primary_sources/data.nola.gov/stops_secondary.R")

#source("primary_sources/opso/bookings_master.R")
source("primary_sources/opso/bookings_secondary.R")

#source("primary_sources/opso/charges_master.R")
source("primary_sources/opso/charges_secondary.R")
