check.vars(c("officers.adp.for.year"))
title <- "Officers by zip"

center.long <- -90.078634
center.lat <- 29.942234
zoom <- 9 # higher numbers are more zoomed in

bins <- c(0, 1, 2, 5, 10, 25, 50, 75, 100, Inf)
  
########################################################################################################
########################################################################################################
# Count officers by zip
officers.with.zip <- officers.adp.for.year %>% filter(!is.na(Zip))
officers.by.zip <- officers.with.zip %>% group_by(Zip)
count.by.zip <- summarize(officers.by.zip, num.officers = n())

# Load LA zip geojson
louisiana <- geojsonio::geojson_read("data_public/louisiana.json", what = "sp")
la.zips <- louisiana@data$ZCTA5CE10
length(louisiana@data$ZCTA5CE10)
#names(louisiana)

count.la.zips <- sapply(la.zips, function(zip) {
  nrow(officers.with.zip[officers.with.zip$Zip == zip,])
})

# Create new data frame with all zips in LA and count of officers in each (lots of 0s)
la.zips.with.counts <- data.frame(
  ZCTA5CE10 = la.zips,
  officers.in.zip = count.la.zips
)

geo.zips.with.counts <- spCbind(louisiana, la.zips.with.counts$officers.in.zip)

head(geo.zips.with.counts@data)
# Color bins according to how many officers there are
pal <- colorBin("YlOrRd", domain = geo.zips.with.counts$la.zips.with.counts.officers.in.zip, bins = bins)

m <- leaflet(geo.zips.with.counts) %>%
  setView(center.long, center.lat, zoom) %>%
  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    
    # Replace with your key
    accessToken = Sys.getenv("MAPBOX_KEY")))

labels <- sprintf(
  "<strong>%s officers</strong> in %s",
  geo.zips.with.counts$la.zips.with.counts.officers.in.zip,
  geo.zips.with.counts$ZCTA5CE10
) %>% lapply(htmltools::HTML)

p.officer.map <- m %>% addPolygons(
  fillColor = ~pal(la.zips.with.counts.officers.in.zip),
  weight = 2,
  opacity = 1,
  color = "white",
  dashArray = "3",
  fillOpacity = 0.7,
  highlight = highlightOptions(
    weight = 5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))

p.officer.map
