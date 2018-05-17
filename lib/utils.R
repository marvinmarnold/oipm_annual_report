########################################################################################################
############################################### HELPERS ################################################

check.var <- function(var.name) {
  if (!exists(var.name)) {
    stop(paste("Variable name", var.name, "must be set."))
  }
}

check.vars <- function(var.names) {
  print.result.to.null.output <- lapply(var.names, check.var)
}

age.bucket.function <- function(age) {
  if (is.na(age)) {
    'Unknown age'
  } else  if (age < 26) {
    '25 or younger'
  } else if (age >= 26 & age < 31) {
    '26 - 30'
  } else if (age >= 31 & age < 36) {
    '31 - 35'
  } else if (age >= 36 & age < 41) {
    '36 - 40'
  } else if (age >= 41 & age < 46) {
    '41 - 45'
  } else if (age >= 46 & age < 50) {
    '46 - 50'
  } else {
    '51 or older'
  }
}

########################################################################################################
############################################# CONSTANTS ################################################

la.zips <- c(
  70112, 70113, 70114, 70115, 70116, 70117, 70118, 70119, 70122, 
  70124, 70125, 70126, 70127, 70128, 70129, 70130, 70131, 70139, 
  70142, 70143, 70145, 70146, 70148, 70150, 70151, 70152, 70153, 
  70154, 70156, 70157, 70158, 70159, 70160, 70161, 70162, 70163, 
  70164, 70165, 70166, 70167, 70170, 70172, 70174, 70175, 70176, 
  70177, 70178, 70179, 70182, 70184, 70185, 70186, 70187, 70189, 
  70190, 70195)

# Months of the year
months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")

# Police districts in New Orleans
districts <- c("1st District", "2nd District", "3rd District", "4th District",
               "5th District", "6th District", "7th District", "8th District")

district.nums <- 1:8

district.num.names <- data.frame(
  district.name = districts,
  district.num = district.nums
)

source("lib/race.R")
