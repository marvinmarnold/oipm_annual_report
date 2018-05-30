title <- "New Orleans Police Districts"

center.long <- -90.078634
center.lat <- 29.942234
zoom <- 12 # higher numbers are more zoomed in

########################################################################################################
########################################################################################################
# Load NO police districts
geo.police.districts <- geojsonio::geojson_read("data_public/Police_Districts.geojson", what = "sp")

labels <- sprintf(
  "District %s",
  geo.police.districts$district
)

# Color bins according to district number
pal <- colorNumeric("viridis", NULL)

p.police.districts <- leaflet(geo.police.districts) %>% setView(lng = center.long, lat = center.lat, zoom = zoom) %>%

  addProviderTiles("MapBox", options = providerTileOptions(
    id = "mapbox.light",
    accessToken = Sys.getenv("MAPBOX_KEY"))) %>% 
  
  addPolygons(stroke = FALSE, 
              smoothFactor = 0.3, 
              fillColor = ~pal(as.integer(district)),
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

p.police.districts
