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

# Filenames relative to wd
officers.legacy.csv <- "data/IAPro/officers_201805012117.csv"
officers.oipm.csv <- "data/IAPro/officers_oipm_201805291837.csv"
officers.adp.csv <- "data/NOPD_20170511/officers_adp_20180507.csv"
all.officers.csv <- "data/all_officers_201805062014.csv"
uof.csv <- "data/IAPro/uof_201805291744.csv"

# File with all complaints <complainant, officers, id, allegation>
allegations.csv <- "data/IAPro/allegations_201805181532.csv"

# Actions taken
actions.csv <- "data/IAPro/actions_taken_201805162155.csv"

######### OPSO

# Bookings file from OPSO
bookings.csv <- "data/OPSO/20180516/JFI15M.TXT"
charges.csv <- "data/OPSO/20180516/JFI15MC.TXT"

######### data.nola.gov

# Stops and searches from data.nola.gov
stops.csv <- "data/data.nola.gov/Stop_and_Search__Field_Interviews_20180507.csv"

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

source("primary_sources/iapro/officers_master.R")
#source("primary_sources/iapro/uof_ftn_master.R")
#source("primary_sources/uof2015.R")
#source("primary_sources/iapro/allegations_complaints_master.R")
#source("primary_sources/iapro/actions_taken_master.R")
#source("primary_sources/data.nola.gov/stops_master.R")
#source("primary_sources/opso/bookings_master.R")
#source("primary_sources/opso/charges_master.R")
#source("primary_sources/data.nola.gov/police_districts.R")

