
## ------------------------------------------------------------------------
library(HSAR)
library(sp)
data(landSPDF)
data(landprice)
data(Beijingdistricts)


## ------------------------------------------------------------------------
library(sf)
land_sf <- st_as_sf(landSPDF)
landprice_sf <- merge(land_sf, landprice, by="obs")
(landprice_sf <- landprice_sf[order(landprice_sf$district.id.x),])


## ------------------------------------------------------------------------
all.equal(landprice_sf$district.id.x, landprice_sf$district.id.y)


## ---- warning=FALSE------------------------------------------------------
library(spatialreg)
dnb1.5 <- spdep::dnearneigh(landprice_sf, 0, 1500, row.names=as.character(landprice_sf$obs))
dists <- spdep::nbdists(dnb1.5, st_geometry(landprice_sf))
edists <- lapply(dists, function(x) exp((-((x/1000)^2))/(1.5^2)))
ozpo <- spdep::set.ZeroPolicyOption(TRUE)
set.ZeroPolicyOption(TRUE)
lw <- spdep::nb2listw(dnb1.5, glist=edists, style="W")
hist(spdep::card(dnb1.5))


## ------------------------------------------------------------------------
landprice_sf$fyear <- factor(landprice_sf$year + 2003)
landprice_sf$price <- exp(landprice_sf$lnprice)
landprice_sf$area <- exp(landprice_sf$lnarea)
landprice_sf$Dcbd <- exp(landprice_sf$lndcbd)
landprice_sf$Dsubway <- exp(landprice_sf$dsubway)
landprice_sf$Dpark <- exp(landprice_sf$dpark)
landprice_sf$Dele <- exp(landprice_sf$dele)
landprice_sf$f_district.id <- factor(landprice_sf$district.id.x)
(t1 <- table(table(landprice_sf$f_district.id)))


## ------------------------------------------------------------------------
Beijingdistricts$id1 <- Beijingdistricts$id+1
all.equal(unique(landprice_sf$district.id.x), Beijingdistricts$id1)


## ------------------------------------------------------------------------
(Beijingdistricts_sf <- st_as_sf(Beijingdistricts))


## ------------------------------------------------------------------------
t2 <- table(sapply(st_contains(Beijingdistricts_sf, landprice_sf), length))
all.equal(t1, t2)


## ---- warning=FALSE, message=FALSE---------------------------------------
nb_M <- spdep::poly2nb(Beijingdistricts, queen=FALSE, row.names=as.character(Beijingdistricts$id1))
M <- as(spdep::nb2listw(nb_M, style="B"), "CsparseMatrix")
dim(M)


## ------------------------------------------------------------------------
hist(spdep::card(nb_M))


## ------------------------------------------------------------------------
form <- log(price) ~ log(area) + log(Dcbd) + log(Dele) + log(Dpark) + log(Dsubway) + 
  crimerate + popden + fyear
OLS <- lm(form, data=landprice_sf)
summary(OLS)


## ------------------------------------------------------------------------
spdep::lm.morantest(OLS, listw=lw)


## ------------------------------------------------------------------------
spdep::lm.LMtests(OLS, listw=lw, test="all")


## ------------------------------------------------------------------------
SLX <- lmSLX(form, data=landprice_sf, listw=lw)
summary(impacts(SLX))


## ------------------------------------------------------------------------
spdep::lm.morantest(SLX, listw=lw)


## ------------------------------------------------------------------------
spdep::lm.LMtests(SLX, listw=lw, test="all")

## ------------------------------------------------------------------------
e <- eigenw(lw)
SDEM <- errorsarlm(form, data=landprice_sf, listw=lw, Durbin=TRUE, control=list(pre_eig=e))
summary(impacts(SDEM))


## ------------------------------------------------------------------------
LR1.sarlm(SDEM)


## ------------------------------------------------------------------------
Hausman.test(SDEM)


## ------------------------------------------------------------------------
library(lme4)
mlm_1 <- lmer(update(form, . ~ . + (1 | f_district.id)), data=landprice_sf, REML=FALSE)
Beijingdistricts_sf$mlm_re <- ranef(mlm_1)[[1]][,1]


## ------------------------------------------------------------------------
library(Matrix)
suppressMessages(library(MatrixModels))
Delta <- as(model.Matrix(~ -1 + f_district.id, data=landprice_sf, sparse=TRUE), "dgCMatrix")


## ---- warning=FALSE------------------------------------------------------
m_hsar <- hsar(form, data=landprice_sf, W=NULL, M=M, Delta=Delta, burnin=500, Nsim=5000, thinning=1)
Beijingdistricts_sf$hsar_re <- m_hsar$Mus[1,]


## ------------------------------------------------------------------------
plot(Beijingdistricts_sf[,"mlm_re"])


## ------------------------------------------------------------------------
plot(Beijingdistricts_sf[,"hsar_re"])

