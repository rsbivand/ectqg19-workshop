## ------------------------------------------------------------------------
library(sf)
lux <- st_read("../data/lux_tmerc.gpkg")


## ------------------------------------------------------------------------
library(spdep)
nb_cont <- poly2nb(lux, row.names=as.character(lux$LAU2))
lw_B <- nb2listw(nb_cont, style="B")
lw_W <- nb2listw(nb_cont) # default style="W"


## ------------------------------------------------------------------------
moran.test(lux$light_level, listw=lw_B, randomisation=TRUE, alternative="two.sided")


## ------------------------------------------------------------------------
moran.test(lux$light_level, listw=lw_W, randomisation=TRUE, alternative="two.sided")


## ------------------------------------------------------------------------
set.seed(1)
perm_boot <- moran.mc(lux$light_level, listw=lw_W, nsim=9999, return_boot=TRUE)
c(mean=mean(perm_boot$t), var=var(perm_boot$t))
plot(perm_boot)


## ------------------------------------------------------------------------
moran.plot(lux$light_level, listw=lw_W)


## ------------------------------------------------------------------------
OLS <- lm(light_level ~  pop_den, lux)
summary(OLS)


## ------------------------------------------------------------------------
lm.morantest(OLS, listw=lw_W, alternative="two.sided")


## ------------------------------------------------------------------------
moran.plot(residuals(OLS), listw=lw_W)


## ------------------------------------------------------------------------
locm <- localmoran(lux$light_level, listw=lw_W, alternative="two.sided")
lux$locIz <- locm[,4]
plot(lux[,"locIz"])

