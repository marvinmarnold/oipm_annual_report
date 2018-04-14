########################################################################################################
################################## 2017 ANNUAL REPORT MAIN SCRIPT ######################################

# Reset environment
rm(list = ls())

########################################################################################################
######################################## GLOBAL VARIABLES ##############################################
setwd("/media/sf_oipm/code/repo")
# The current year to analyze
year <- 2017

# Filenames relative to wd
officers.csv <- "data/IAPro/2017AnnualReport/officers_201803302203.csv"
uof.csv <- "data_2017/uof_201804141313.csv"

# File with all complaints and misconduct
# Each row is a <officer, allegation, action-taken> tuple. This mean that one incidents may be represented by more than one line
complaints.misconduct.alleg.act.csv <- "data/IAPro/2017AnnualReport/complaints_misconduct_201804121747.csv"

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

#source("primary_sources/iapro/officers_master.R")
source("primary_sources/iapro/uof_ftn_master.R")
#source("primary_sources/iapro/complaints_misconduct_master.R")