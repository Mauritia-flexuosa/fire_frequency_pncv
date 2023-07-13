
library(raster)
library(tidyverse)
library(leaflet)
library(sp)

x <- c(-47.75014, -47.74389, -47.76830, -47.72287, -47.73264, -47.73613, -47.68317,
       -47.66713, -47.69987, -47.70263, -47.76707, -47.71484, -47.71418, -47.67871,
       -47.67911, -47.68465, -47.63446, -47.63412, -47.63415, -47.69065, -46.97297,
       -46.98341, -46.98311, -46.98177, -47.84833, -47.84950, -47.84347, -46.97983,
       -46.98513, -46.98280)#, -47.63719, -47.63690, -47.63657, -47.63625, -47.63551,
#-47.63513, -47.63479, -47.63447, -47.63412, -47.63376, -47.63497, -47.63472,
#-47.63449, -47.63425, -47.63398, -47.63376, -47.63349, -47.63340, -47.63323,
#-47.63333)
y <- c(-14.14786, -14.14263, -14.13991, -14.13116, -14.12362, -14.12612, -14.12855,
       -14.12713, -14.12875, -14.12913, -14.13310, -14.13943, -14.13980, -14.11648,
       -14.11652, -14.11530, -14.09114, -14.09050, -14.08997, -14.12734, -13.92030,
       -13.88963, -13.88625, -13.88888, -14.20525, -14.20966, -14.20466, -13.89772,
       -13.88366, -13.88300)#, -14.10703, -14.10691, -14.10672, -14.10647, -14.10615,
#-14.10608, -14.10588, -14.10573, -14.10555, -14.10556, -14.09398, -14.09369,
#-14.09341, -14.09310, -14.09275, -14.09240, -14.09212, -14.09177, -14.09145,
#-14.09123)

xy <- cbind(x,y)

coordR <- SpatialPoints(xy,
                        proj4string = crs("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))


firefreq <- raster("/home/mcure/Downloads/mapbiomas-brazil-collection-10-parnadachapadadosveadeiros-1985_2018.tif")


#par(mfrow=c(1,2))
#plot(firefreq)
#points(coordR)

# plot(firefreq, xlim=c(-47.799,-47.61),ylim=c(-14.2,-14), main = "Fire frequency (1985-2018)")
#points(coordR)



# Setting vegetation types (or Biomes) with cordinates.
`Vegetation type` <- c(rep("savanna", 10), rep("gallery forest", 10), rep("dry forest", 10)) %>% factor
parcelas <- ""
lat <- y
lon <- x

dat <- data.frame(parcelas, lat, lon, `Vegetation type`)%>% tibble %>%
  mutate(popup_info = paste(`Vegetation type`,"<br/>","Coordenadas: lat ", lat, ";"," lon ", lon,"<br/>"))

# png("fogo_na_mata.png", res = 400, width = 3800, height = 3800)
# plot(firefreq, xlim=c(-47.799,-47.58),ylim=c(-14.2,-14), main = "Fire frequency (1985-2018)")
# points(x = dat$lon[11:20], y = dat$lat[11:20], col="black", pch = 16)
# dev.off()
#
# getwd()
#

#leaflet(options = leafletOptions(minZoom = 0, maxZoom = 18))

#pal <- colorNumeric(c("#0C2C84", "#41B6C4", "#FFFFCC"), values(firefreq),
#     na.color = "transparent")

#leaflet() %>% addTiles() %>%
#  addRasterImage(firefreq, colors = pal, opacity = 0.8) %>%
#  addLegend(pal = pal, values = values(firefreq),
#    title = "Fire frequency (1985-2018)")

colors = colorBin("Reds", domain = NULL, bins = 30, na.color = "transparent")

pal <- colorNumeric(colors, values(firefreq),
                    na.color = "transparent")

pal1 <- colorFactor(c("purple", "blue", "orange"), domain = factor(dat$Vegetation.type))

fogo <- leaflet() %>% addTiles() %>%
  addRasterImage(firefreq, colors = pal, opacity = 0.8) %>%
  addLegend(pal = pal, values = values(firefreq),
            title = "Fire frequency (1985-2018)") %>%
  addCircleMarkers(data = dat, lat = dat$lat, lng = dat$lon, fillOpacity = 90,
                   radius = ~2.45, popup = dat$popup_info, color = pal1(dat$Vegetation.type))%>%

  # add a map scalebar
  addScaleBar(position = 'topright')
#addCircles(lng=dat$lon, lat=dat$lat, fillColor = factor(dat$Vegetation.type))

#widgetframe::saveWidgetframe(fogo, file="/home/mcure/Documents/STOTEN/mapa_fogo.html")

