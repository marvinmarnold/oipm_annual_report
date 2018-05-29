# Reduce huge datasets to smaller ones by year
check.vars(c("year", "bwc.for.year", "stops.for.year"))

write.csv(bwc.for.year, file = paste0("data_public/bwc_for_", year, ".csv"))
write.csv(stops.for.year, file = paste0("data_public/stops_for_", year, ".csv"))
