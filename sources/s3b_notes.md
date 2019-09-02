# Spatial Autocorrelation

## Spatial Lag

Product of a spatial weights matrix W and a given variably Y

$$
Y_{sl} = WY
$$

$$
y_{sl-i} = \sum_j w_{ij} \; y_j
$$

## Global

> *Everything is related to everything else, but near things are more related than distant things*

Tobler (1,970)

[![Binder](http://mybinder.org/badge.svg)](http://mybinder.org/repo/darribas/int_sp_auto)

[`URL`](http://mybinder.org/repo/darribas/int_sp_auto)

### Moran Plot

![](http://darribas.org/gds18/content/lectures/figs/l06_imd_score_choro.png)

![](http://darribas.org/gds18/content/lectures/figs/l05_moranplot_std.png)

### Moran's I

$$
I = \dfrac{N} {\sum_{i} \sum_{j} w_{ij}} \dfrac {\sum_{i} \sum_{j}
w_{ij}(Z_i) (Z_j)} {\sum_{i} (Z_i)^2}
$$

Inference through *permutations*

## Local

Cluster*ing* Vs Cluster*s*

![](../figs/lisa_plots.png)

Local Moran's I (Anselin, 1996):

$$
I_i = \frac{Z_i}{m_2} \sum_j W_{ij} Z_j \; \; ; \; \;  m_2= \frac{\sum_i Z_i^2
}{N}
$$

Inference through *permutations*

## Sources

* [GDS Book - Global chapter](https://geographicdata.science/book/notebooks/06_spatial_autocorrelation.html)
* [GDS Book - Local chapter](https://geographicdata.science/book/notebooks/07_local_autocorrelation.html)
* [GDS'19 - Spatial Autocorrelation lecture](http://darribas.org/gds19/notes/Class_06.html)
* [GDS'19 - Spatial Autocorrelation lab](http://darribas.org/gds19/labs/Lab_06.html)
