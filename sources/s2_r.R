## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)


## ---- echo=TRUE----------------------------------------------------------
library(sf)
lux_tmerc <- st_read("../data/lux_tmerc.gpkg")


## ---- echo=TRUE----------------------------------------------------------
names(lux_tmerc)


## ---- echo=TRUE----------------------------------------------------------
sapply(lux_tmerc, function(x) class(x)[1])


## ---- echo=TRUE----------------------------------------------------------
plot(density(lux_tmerc$pop_den), main="Population density per square km")
rug(lux_tmerc$pop_den)


## ---- echo=TRUE----------------------------------------------------------
hist(lux_tmerc$pop_den, main="Population density per square km")


## ---- echo=TRUE----------------------------------------------------------
plot(lux_tmerc$light_level, lux_tmerc$pop_den)


## ---- echo=TRUE----------------------------------------------------------
plot(pop_den ~ light_level, lux_tmerc)


## ---- echo=TRUE----------------------------------------------------------
opar <- par(mar=c(3, 10, 3, 1), las=1)
boxplot(pop_den ~ DISTRICT, lux_tmerc, horizontal=TRUE, ylab="", main="Population density per administrative area by district")
par(opar)


## ---- echo=TRUE----------------------------------------------------------
library(classInt)
args(classIntervals)


## ---- echo=TRUE----------------------------------------------------------
(cI <- classIntervals(lux_tmerc$pop_den, n=7, style="fisher"))


## ---- echo=TRUE----------------------------------------------------------
(cI_pr <- classIntervals(lux_tmerc$pop_den, n=7, style="pretty"))


## ---- echo=TRUE----------------------------------------------------------
(cI_qu <- classIntervals(lux_tmerc$pop_den, n=7, style="quantile"))


## ---- echo=TRUE----------------------------------------------------------
library(RColorBrewer)
pal <- RColorBrewer::brewer.pal((length(cI$brks)-1), "Reds")
plot(cI_pr, pal)


## ---- echo=TRUE----------------------------------------------------------
plot(cI_qu, pal)


## ---- echo=TRUE----------------------------------------------------------
plot(cI, pal)


## ---- echo=TRUE----------------------------------------------------------
display.brewer.all()


## ---- echo=TRUE----------------------------------------------------------
plot(lux_tmerc[,"pop_den"], breaks=cI$brks, pal=pal)


## ---- echo=TRUE----------------------------------------------------------
plot(lux_tmerc[,"pop_den"], nbreaks=7, breaks="fisher", pal=pal)


## ---- echo=TRUE----------------------------------------------------------
library(mapview)
mapview(lux_tmerc, zcol="pop_den", col.regions=pal, at=cI$brks)


## ---- echo=TRUE----------------------------------------------------------
library(tmap)
tmap_mode("plot")
o <- tm_shape(lux_tmerc) + tm_fill("pop_den", style="fisher", n=7, palette="Reds")
class(o)


## ---- echo=TRUE----------------------------------------------------------
o


## ---- echo=TRUE----------------------------------------------------------
o + tm_borders(alpha=0.5, lwd=0.5)


## ---- echo=TRUE----------------------------------------------------------
tmap_mode("view")


## ---- echo=TRUE----------------------------------------------------------
o + tm_borders(alpha=0.5, lwd=0.5)


## ---- echo=TRUE----------------------------------------------------------
tmap_mode("plot")


## ---- echo=TRUE, eval=FALSE----------------------------------------------
## tmaptools::palette_explorer()


## ---- echo=TRUE----------------------------------------------------------
library(cartography)
display.carto.all()


## ---- echo=TRUE----------------------------------------------------------
choroLayer(lux_tmerc, var="pop_den", method="fisher-jenks", nclass=7, col=pal, legend.values.rnd=3)


## ---- echo=TRUE----------------------------------------------------------
library(ggplot2)


## ---- echo=TRUE----------------------------------------------------------
g <- ggplot(lux_tmerc) + geom_sf(aes(fill=pop_den))
g


## ---- echo=TRUE----------------------------------------------------------
g + theme_void()


## ---- echo=TRUE----------------------------------------------------------
g + theme_void() + scale_fill_distiller(palette="Reds", direction=1)


## ---- echo=TRUE----------------------------------------------------------
library(stars)
ghsl0 <- read_stars("../data/ghsl.tiff", proxy=FALSE)
plot(ghsl0["ghsl.tiff"])


## ---- echo=TRUE----------------------------------------------------------
plot(ghsl0["ghsl.tiff"], breaks="fisher", nbreaks=11)


## ---- echo=TRUE----------------------------------------------------------
library(mapview)
library(raster)
r <- as(st_warp(ghsl0, crs=3857, cellsize=250), "Raster")
mapview(r)


## ---- echo=TRUE----------------------------------------------------------
library(colorspace)
hcl_palettes("sequential (single-hue)", n = 7, plot = TRUE)


## ---- echo=TRUE, eval=FALSE----------------------------------------------
## pal <- hclwizard()
## pal(6)


## ---- echo=TRUE----------------------------------------------------------
wheel <- function(col, radius = 1, ...)
  pie(rep(1, length(col)), col = col, radius = radius, ...) 
opar <- par(mfrow=c(1,2))
wheel(rainbow_hcl(12))
wheel(rainbow(12))
par(opar)

