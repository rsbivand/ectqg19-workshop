## ------------------------------------------------------------------------
library(sf)
lux <- st_read("../data/lux_tmerc.gpkg")


## ------------------------------------------------------------------------
library(spdep)
nb_cont <- poly2nb(lux, row.names=as.character(lux$LAU2))
nb_cont

## ------------------------------------------------------------------------
summary(nb_cont)


## ------------------------------------------------------------------------
hist(card(nb_cont))


## ------------------------------------------------------------------------
plot(st_geometry(lux), border="grey")
crds <- st_centroid(st_geometry(lux))
plot(nb_cont, crds, add=TRUE)


## ------------------------------------------------------------------------
knn5 <- knn2nb(knearneigh(crds, k=5))
knn5


## ------------------------------------------------------------------------
knn5s <- knn2nb(knearneigh(crds, k=5), sym=TRUE)
knn5s


## ------------------------------------------------------------------------
knn5_ll <- knn2nb(knearneigh(st_transform(crds, 4326), k=5))
knn5_ll


## ------------------------------------------------------------------------
all.equal(knn5, knn5_ll, check.attributes=FALSE)


## ------------------------------------------------------------------------
knn5_ll_eucl <- knn2nb(knearneigh(st_coordinates(st_transform(crds, 4326)), k=5))
knn5_ll_eucl


## ------------------------------------------------------------------------
isTRUE(all.equal(knn5, knn5_ll_eucl, check.attributes=FALSE))


## ------------------------------------------------------------------------
plot(st_geometry(lux), border="grey")
plot(knn5, crds, add=TRUE)
plot(diffnb(knn5, knn5_ll_eucl), crds, add=TRUE, col="orange")


## ------------------------------------------------------------------------
args(nb2listw)


## ------------------------------------------------------------------------
lw_B <- nb2listw(nb_cont, style="B")
lw_B


## ------------------------------------------------------------------------
lw_W <- nb2listw(nb_cont) # default style="W"
lw_W

