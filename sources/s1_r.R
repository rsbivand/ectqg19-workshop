## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = FALSE)


## ---- echo=TRUE----------------------------------------------------------
needed <- c("sf", "stars", "raster", "sp", "rgdal", "rgeos")


## ----vect1, echo = TRUE--------------------------------------------------
a <- c(2, 3)
a
sum(a)
str(a)
aa <- rep(a, 50)
aa


## ----vect2, echo = TRUE--------------------------------------------------
length(aa)
aa[1:10]
sum(aa)
sum(aa[1:10])
sum(aa[-(11:length(aa))])


## ----vect2a, echo = TRUE-------------------------------------------------
a[1] + a[2]
sum(a)
`+`(a[1], a[2])
Reduce(`+`, a)


## ----vect3, echo = TRUE--------------------------------------------------
sum(aa)
sum(aa+2)
sum(aa)+2
sum(aa*2)
sum(aa)*2


## ----vect4, echo = TRUE--------------------------------------------------
v5 <- 1:5
v2 <- c(5, 10)
v5 * v2
v2_stretch <- rep(v2, length.out=length(v5))
v2_stretch
v5 * v2_stretch


## ----NA, echo = TRUE-----------------------------------------------------
anyNA(aa)
is.na(aa) <- 5
aa[1:10]
anyNA(aa)
sum(aa)
sum(aa, na.rm=TRUE)


## ----check1, echo = TRUE-------------------------------------------------
big <- 1:(10^5)
length(big)
head(big)
str(big)
summary(big)


## ----coerce1, echo = TRUE------------------------------------------------
set.seed(1)
x <- runif(50, 1, 10)
is.numeric(x)
y <- rpois(50, lambda=6)
is.numeric(y)
is.integer(y)
xy <- x < y
is.logical(xy)


## ----coerce2, echo = TRUE------------------------------------------------
str(as.integer(xy))
str(as.numeric(y))
str(as.character(y))
str(as.integer(x))


## ---- echo = TRUE--------------------------------------------------------
V1 <- 1:3
V2 <- letters[1:3]
V3 <- sqrt(V1)
V4 <- sqrt(as.complex(-V1))
L <- list(v1=V1, v2=V2, v3=V3, v4=V4)
str(L)
L$v3[2]
L[[3]][2]


## ---- echo = TRUE--------------------------------------------------------
DF <- as.data.frame(L)
str(DF)
DF <- as.data.frame(L, stringsAsFactors=FALSE)
str(DF)


## ---- echo = TRUE--------------------------------------------------------
V2a <- letters[1:4]
V4a <- factor(V2a)
La <- list(v1=V1, v2=V2a, v3=V3, v4=V4a)
DFa <- try(as.data.frame(La, stringsAsFactors=FALSE), silent=TRUE)
message(DFa)


## ---- echo = TRUE--------------------------------------------------------
DF$v3[2]
DF[[3]][2]
DF[["v3"]][2]


## ---- echo = TRUE--------------------------------------------------------
DF[2, 3]
DF[2, "v3"]
str(DF[2, 3])
str(DF[2, 3, drop=FALSE])


## ---- echo = TRUE--------------------------------------------------------
as.matrix(DF)
as.matrix(DF[,c(1,3)])


## ---- echo = TRUE--------------------------------------------------------
length(L)
length(DF)
length(as.matrix(DF))


## ---- echo = TRUE--------------------------------------------------------
dim(L)
dim(DF)
dim(as.matrix(DF))


## ---- echo = TRUE--------------------------------------------------------
str(as.matrix(DF))


## ---- echo = TRUE--------------------------------------------------------
row.names(DF)
names(DF)
names(DF) <- LETTERS[1:4]
names(DF)
str(dimnames(as.matrix(DF)))


## ---- echo = TRUE--------------------------------------------------------
str(attributes(DF))
str(attributes(as.matrix(DF)))


## ---- echo = TRUE--------------------------------------------------------
V1a <- c(V1, NA)
V3a <- sqrt(V1a)
La <- list(v1=V1a, v2=V2a, v3=V3a, v4=V4a)
DFa <- as.data.frame(La, stringsAsFactors=FALSE)
str(DFa)


## ---- echo=TRUE----------------------------------------------------------
library(sf)


## ---- echo=TRUE----------------------------------------------------------
lux <- st_read("../data/lux_regions.gpkg", stringsAsFactors=FALSE)


## ---- echo=TRUE----------------------------------------------------------
st_drivers(what="vector")[,c(2:4, 7)]


## ---- echo=TRUE----------------------------------------------------------
class(lux)


## ---- echo=TRUE----------------------------------------------------------
names(lux)


## ---- echo=TRUE----------------------------------------------------------
names(attributes(lux))


## ---- echo=TRUE----------------------------------------------------------
hist(lux$ghsl_pop)


## ---- echo=TRUE----------------------------------------------------------
class(lux[[attr(lux, "sf_column")]])


## ---- echo=TRUE----------------------------------------------------------
is.list(lux[[attr(lux, "sf_column")]])


## ---- echo=TRUE----------------------------------------------------------
class(lux[1:5, 1])


## ---- echo=TRUE----------------------------------------------------------
attributes(lux[[attr(lux, "sf_column")]])


## ---- echo=TRUE----------------------------------------------------------
class(attr(lux[[attr(lux, "sf_column")]], "crs"))


## ---- echo=TRUE----------------------------------------------------------
str(attr(lux[[attr(lux, "sf_column")]], "crs"))


## ---- echo=TRUE----------------------------------------------------------
st_crs(4674)


## ---- echo=TRUE----------------------------------------------------------
st_crs(31983)


## ---- echo=TRUE----------------------------------------------------------
str(lux[[attr(lux, "sf_column")]][[1]])


## ---- echo=TRUE----------------------------------------------------------
pop <- st_read("../data/statec_population_by_municipality.geojson")


## ---- echo=TRUE----------------------------------------------------------
all.equal(pop$POPULATION, lux$POPULATION)
o <- match(as.character(pop$LAU2), as.character(lux$LAU2))
all.equal(pop$POPULATION, lux$POPULATION[o])


## ---- echo=TRUE----------------------------------------------------------
plot(lux[, c("POPULATION", "ghsl_pop")])


## ---- echo=TRUE----------------------------------------------------------
trees <- st_read("../data/trees/anf_remarkable_trees_0.shp")


## ---- echo=TRUE----------------------------------------------------------
area_sph <- lwgeom::st_geod_area(lux)
lux_tmerc <- st_transform(lux, 2169)
area_tmerc <- st_area(lux_tmerc)


## ---- echo=TRUE----------------------------------------------------------
lux_tmerc$area <- area_tmerc
lux_tmerc$area_err <- (lux_tmerc$area - area_sph)/lux_tmerc$area
summary(lux_tmerc$area_err)


## ---- echo=TRUE----------------------------------------------------------
plot(lux_tmerc[, "area_err"], axes=TRUE, main="area difference in m2 per m2")


## ---- echo=TRUE----------------------------------------------------------
units(lux_tmerc$area)


## ---- echo=TRUE----------------------------------------------------------
units(lux_tmerc$area) <- "km^2"
units(lux_tmerc$area)


## ---- echo=TRUE----------------------------------------------------------
lux_tmerc$pop_den <- lux_tmerc$POPULATION/lux_tmerc$area
summary(lux_tmerc$pop_den)


## ---- echo=TRUE----------------------------------------------------------
lux_tmerc$ghsl_den <- lux_tmerc$ghsl_pop/lux_tmerc$area
summary(lux_tmerc$ghsl_den)


## ---- echo=TRUE----------------------------------------------------------
trees_sgbp <- st_intersects(lux_tmerc, trees)
trees_cnt <- sapply(trees_sgbp, length)
all.equal(trees_cnt, lux_tmerc$tree_count)


## ---- echo=TRUE----------------------------------------------------------
cat(system("projinfo EPSG:4326 -o PROJ", intern=TRUE), sep="\n")


## ---- echo=TRUE----------------------------------------------------------
cat(system("projinfo EPSG:4326 -o WKT1_GDAL", intern=TRUE), sep="\n")


## ---- echo=TRUE----------------------------------------------------------
cat(system("projinfo EPSG:4326 -o WKT2_2018", intern=TRUE), sep="\n")


## ---- echo=TRUE----------------------------------------------------------
cat(system("projinfo EPSG:2169 -o PROJ", intern=TRUE), sep="\n")


## ---- echo=TRUE----------------------------------------------------------
cat(system("projinfo EPSG:2169 -o WKT1_GDAL", intern=TRUE), sep="\n")


## ---- echo=TRUE----------------------------------------------------------
cat(system("projinfo EPSG:2169 -o WKT2_2018", intern=TRUE), sep="\n")


## ---- echo=TRUE----------------------------------------------------------
cat(system("projinfo -s EPSG:4326 -t EPSG:2169 -o PROJ", intern=TRUE), sep="\n")


## ---- echo=TRUE----------------------------------------------------------
library(stars)
system.time(ghsl0 <- read_stars("../data/ghsl.tiff", proxy=FALSE))
ghsl0


## ---- echo=TRUE----------------------------------------------------------
system.time(ghsl1 <- read_stars("../data/ghsl.tiff", proxy=TRUE))
ghsl1


## ---- echo=TRUE----------------------------------------------------------
plot(ghsl0)


## ---- echo=TRUE----------------------------------------------------------
system.time(ghsl_sum0 <- aggregate(st_warp(ghsl0, crs=2169, cellsize=250, use_gdal=FALSE), lux_tmerc, sum))


## ---- echo=TRUE----------------------------------------------------------
system.time(ghsl_sum1 <- aggregate(st_warp(ghsl1, crs=2169, cellsize=250, use_gdal=FALSE), lux_tmerc, sum))


## ---- echo=TRUE----------------------------------------------------------
system.time(ghsl_sum2 <- aggregate(ghsl0, st_transform(lux, crs=st_crs(ghsl0)$proj4string), sum))


## ---- echo=TRUE----------------------------------------------------------
summary(cbind(orig=lux_tmerc$ghsl_pop, warp=ghsl_sum0$ghsl.tiff, warp_proxy=ghsl_sum1$ghsl.tiff, moll=ghsl_sum2$ghsl.tiff))


## ---- echo=TRUE----------------------------------------------------------
lux_tmerc$ghsl_tiff <- ghsl_sum0$ghsl.tiff
lux_tmerc$ghsl_warp_diff <- lux_tmerc$ghsl_tiff - lux_tmerc$ghsl_pop
plot(lux_tmerc[,"ghsl_warp_diff"])


## ---- echo=TRUE----------------------------------------------------------
st_write(lux_tmerc, "../data/lux_tmerc.gpkg", delete_dsn=TRUE)

