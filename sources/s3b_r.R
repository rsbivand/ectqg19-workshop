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
(mi <- moran.test(lux$light_level, listw=lw_W, randomisation=TRUE, alternative="two.sided"))


## ------------------------------------------------------------------------
set.seed(1)
perm_boot <- moran.mc(lux$light_level, listw=lw_W, nsim=9999, return_boot=TRUE)
c(mean=mean(perm_boot$t), var=var(perm_boot$t))
plot(perm_boot)


## ------------------------------------------------------------------------
moran(lux$light_level, listw=lw_W, S0=Szero(lw_W), n=nrow(lux))$K


## ------------------------------------------------------------------------
moran.test(lux$light_level, listw=lw_W, randomisation=FALSE, alternative="two.sided")


## ------------------------------------------------------------------------
OLS0 <- lm(light_level ~ 1, lux)
lm.morantest(OLS0, listw=lw_W, alternative="two.sided")


## ------------------------------------------------------------------------
lm.morantest.exact(OLS0, listw=lw_W, alternative="two.sided")


## ------------------------------------------------------------------------
moran.plot(lux$light_level, listw=lw_W)


## ------------------------------------------------------------------------
OLS <- lm(light_level ~  pop_den, lux)
summary(OLS)


## ------------------------------------------------------------------------
lm.morantest(OLS, listw=lw_W, alternative="two.sided")


## ------------------------------------------------------------------------
(mie <- lm.morantest.exact(OLS, listw=lw_W, alternative="two.sided"))


## ------------------------------------------------------------------------
moran.plot(residuals(OLS), listw=lw_W)


## ------------------------------------------------------------------------
locm <- localmoran(lux$light_level, listw=lw_W, alternative="two.sided")
all.equal(sum(locm[,1])/Szero(lw_W), mi$estimate[1], check.attributes=FALSE)


## ------------------------------------------------------------------------
lux$locIz <- locm[,4]
plot(lux[,"locIz"], breaks=seq(-6, 12, 2))


## ------------------------------------------------------------------------
x <- lux$light_level
lw <- lw_W
xx <- mean(x)
z <- x - xx
s2 <- sum(z^2)/length(x)
crd <- card(lw$neighbours)
nsim <- 999
res_p <- numeric(nsim)
mns <- sds <- numeric(length(x))
set.seed(1)
for (i in seq(along=x)) {
  wtsi <- lw$weights[[i]]
  zi <- z[i]
  z_i <- z[-i]
  crdi <- crd[i]
  if (crdi > 0) {
    for (j in 1:nsim) {
      sz_i <- sample(z_i, size=crdi)
      lz_i <- sum(sz_i*wtsi)
      res_p[j] <- (zi/s2)*lz_i
    }
    mns[i] <- mean(res_p)
    sds[i] <- sd(res_p)
  } else {
    mns[i] <- as.numeric(NA)
    sds[i] <- as.numeric(NA)
  }
}
lux$perm_Zi <- (locm[,1] - mns)/sds
plot(lux[, "perm_Zi"], breaks=seq(-6, 12, 2))


## ------------------------------------------------------------------------
locm_ex <- localmoran.exact(OLS0, nb=nb_cont, style="W", alternative="two.sided")
lux$locmz_ex <- as.data.frame(locm_ex)[,4]
plot(lux[,"locmz_ex"], breaks=seq(-6, 12, 2))


## ------------------------------------------------------------------------
locm_pop_den_ex <- as.data.frame(localmoran.exact(OLS, nb=nb_cont, style="W", alternative="two.sided"))
all.equal(sum(locm_pop_den_ex[,1])/Szero(lw_W), mie$estimate[1], check.attributes=FALSE)


## ------------------------------------------------------------------------
lux$locmz_pd_ex <- locm_pop_den_ex[,4]
plot(lux[,"locmz_pd_ex"], breaks=seq(-6, 12, 2))


## ------------------------------------------------------------------------
LOSH <- LOSH.cs(lux$light_level, listw=lw_W)
lux$Z.Hi <- LOSH[,4]
plot(lux[,"Z.Hi"])


## ------------------------------------------------------------------------
lux$x_bar_i <- LOSH[,5]
plot(lux[,"x_bar_i"])

