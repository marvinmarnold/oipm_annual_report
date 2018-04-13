# Race info from census
# Provided by Jakob and referenced in 2016 annual report (source 2010 census)
races <- c("White", "Black", "Latino", "Asian", "American Indian", "Other")

district.1.races <- c(5866, 20711, 2926, 270, 54, 503)
sum(district.1.races) == 30330 # check

district.2.races <- c(32977, 21642, 3133, 1217, 144, 1112)
sum(district.2.races) == 60225 # check

district.3.races <- c(24516, 30097, 3271, 1099, 132, 1086)
sum(district.3.races) == 60201 # check

district.4.races <- c(13090, 34585, 2728, 1438, 151, 793)
sum(district.4.races) == 52785 # check

district.5.races <- c(3719, 24755, 992, 100, 91, 427)
sum(district.5.races) == 30084 # check

district.6.races <- c(15206, 17925, 2402, 553, 106, 640)
sum(district.6.races) == 36832 # check

district.7.races <- c(2401, 54081, 2120, 4898, 96, 714)
sum(district.7.races) == 64310 # check

district.8.races <- c(6995, 1070, 479, 308, 53, 157)
sum(district.8.races) == 9062 # check

district.races <- data.frame(
  district.1 = district.1.races, 
  district.2 = district.2.races, 
  district.3 = district.3.races, 
  district.4 = district.4.races, 
  district.5 = district.5.races, 
  district.6 = district.6.races,
  district.7 = district.7.races, 
  district.8 = district.8.races)

rownames(district.races) <- races
t(district.races)
