########################################################################################################
################################## 2017 ANNUAL REPORT MAIN SCRIPT ######################################

# Reset environment
rm(list = ls())

########################################################################################################
######################################## GLOBAL VARIABLES ##############################################
#setwd("/home/pili/MEGA/code/repo")
setwd("/media/sf_oipm/code/repo/")

# The current year to analyze
year <- 2017

# Filenames relative to wd
officers.csv <- "data/officers_201805012117.csv"
all.officers.csv <- "data/all_officers_201805062014.csv"
uof.csv <- "data/uof_201805072046.csv"

# File with all complaints <complainant, officers, id, allegation>
allegations.csv <- "data/allegations_201805061225.csv"

# Bookings file from OPSO
bookings.csv <- "data/OPSO/Marvin_Arnold/JFI12M.TXT"

# Stops and searches from data.nola.gov
stops.csv <- "data/data.nola.gov/Stop_and_Search__Field_Interviews_20180507.csv"

########################################################################################################
######################################## LOAD DEPENDENCIES #############################################

# Load libraries
library(plotly)
library(dplyr)
library(tidyr)
library(ggplot2)

# You may also need to follow the three steps below if you want to use ggplot with plotly
# install.packages('devtools')
# library(devtools)
# devtools::install_github('hadley/ggplot2')

# Local helpers
source("lib/utils.R")

# Actual keys stored in .Rkeys
# Sys.setenv("plotly_username"="")
# Sys.setenv("plotly_api_key"="")

########################################################################################################
######################################## LOAD MASTER SCRIPTS ###########################################

source("primary_sources/iapro/officers_master.R")
source("primary_sources/iapro/uof_ftn_master.R")
source("primary_sources/uof2015.R")
source("primary_sources/iapro/allegations_complaints_master.R")
source("primary_sources/data.nola.gov/stops_master.R")
source("primary_sources/opso/bookings_master.R")
