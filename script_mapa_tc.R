library(raster)
library(tidyverse)
library(leaflet)
library(sp)
### Tree cover

tc <- raster("/home/mcure/Downloads/Hansen_GFC-2019-v1.7_treecover2000_10S_050W.tif")


shape <- sf::read_sf("/home/mcure/Documents/STOTEN/UC_fed_julho_2019/UC_fed_julho_2019.shp")

chapada <- shape[302,][2]

tc_p <- raster::crop(tc, extent(chapada))

colors = colorBin("Greens", domain = NULL, bins = 30, na.color = "transparent")

pal <- colorNumeric(colors, values(tc_p),
                    na.color = "transparent")

tree_cover <- leaflet() %>% addTiles() %>%
  addRasterImage(tc_p, colors = pal, opacity = 0.8) %>%
  addLegend(pal = pal, values = values(tc_p),
            title = "Tree cover (Hansen-GFC-2019-v1.7)") %>%
  addCircleMarkers(data = dat, lat = dat$lat, lng = dat$lon, fillOpacity = 90,
                   radius = ~2.45, popup = dat$popup_info, color = pal1(dat$Vegetation.type))%>%
  addScaleBar(position = 'topright')


# widgetframe::saveWidgetframe(tree_cover, file = "/home/mcure/Documents/STOTEN/tree_cover.html")
tc_p <- raster::crop(tc, extent(chapada))

colors = colorBin("Greens", domain = NULL, bins = 30, na.color = "transparent")

pal <- colorNumeric(colors, values(tc_p),
                    na.color = "transparent")

tree_cover <- leaflet() %>% addTiles() %>%
  addRasterImage(tc_p, colors = pal, opacity = 0.8) %>%
  addLegend(pal = pal, values = values(tc_p),
            title = "Tree cover (Hansen-GFC-2019-v1.7)") %>%
  addCircleMarkers(data = dat, lat = dat$lat, lng = dat$lon, fillOpacity = 90,
                   radius = ~2.45, popup = dat$popup_info, color = pal1(dat$Vegetation.type))%>%
  addScaleBar(position = 'topright')
