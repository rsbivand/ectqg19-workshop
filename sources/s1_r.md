---
title: "R: Data structures"
author: "Roger Bivand"
date: "Thursday, 5 September 2019, 09:45-10:15"
output: 
  html_document:
    keep_md: true
bibliography: rmd.bib
link-citations: yes
---



### Required current contributed CRAN packages:

I am running R 3.6.1, with recent `update.packages()`.


```r
needed <- c("sf", "stars", "raster", "sp", "rgdal", "rgeos")
```

# Spatial vector data

## New style


```r
library(sf)
```

```
## Linking to GEOS 3.7.2, GDAL 3.0.1, PROJ 6.1.1
```


```r
bh <- st_read("../data/bh.gpkg", stringsAsFactors=FALSE)
```

```
## Reading layer `bh' from data source `/home/rsb/presentations/ectqg19-workshop/data/bh.gpkg' using driver `GPKG'
## Simple feature collection with 105 features and 7 fields
## geometry type:  POLYGON
## dimension:      XY
## bbox:           xmin: -45.01195 ymin: -20.92759 xmax: -42.47446 ymax: -18.06804
## epsg (SRID):    4674
## proj4string:    +proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs
```



```r
str(bh, max.level=2)
```

```
## Classes 'sf' and 'data.frame':	105 obs. of  8 variables:
##  $ NM_MUNICIP          : chr  "ALVINÃ\u0093POLIS" "ALVORADA DE MINAS" "ARAÃ\u0087AÃ\u008d" "BALDIM" ...
##  $ CD_GEOCMU           : chr  "3102308" "3102407" "3103207" "3105004" ...
##  $ Total.Monthly.Wages : num  3133839 325871 667453 2446941 8377654 ...
##  $ Total.Jobs          : num  2566 243 550 1780 4686 ...
##  $ Total.Establishments: num  275 65 55 165 505 ...
##  $ Average.Monthly.Wage: num  1221 1341 1214 1375 1788 ...
##  $ Industry.Diversity  : num  104 22 26 65 139 63 585 62 411 47 ...
##  $ geom                :sfc_POLYGON of length 105; first list element: List of 1
##   ..$ : num [1:4961, 1:2] -43 -43 -43 -43 -43 ...
##   ..- attr(*, "class")= chr  "XY" "POLYGON" "sfg"
##  - attr(*, "sf_column")= chr "geom"
##  - attr(*, "agr")= Factor w/ 3 levels "constant","aggregate",..: NA NA NA NA NA NA NA
##   ..- attr(*, "names")= chr  "NM_MUNICIP" "CD_GEOCMU" "Total.Monthly.Wages" "Total.Jobs" ...
```

## Old style


```r
library(rgdal)
```

```
## Loading required package: sp
```

```
## rgdal: version: 1.4-4, (SVN revision 833)
##  Geospatial Data Abstraction Library extensions to R successfully loaded
##  Loaded GDAL runtime: GDAL 3.0.1, released 2019/06/28
##  Path to GDAL shared files: 
##  GDAL binary built with GEOS: TRUE 
##  Loaded PROJ.4 runtime: Rel. 6.1.1, July 1st, 2019, [PJ_VERSION: 611]
##  Path to PROJ.4 shared files: (autodetected)
##  Linking to sp version: 1.3-1
```


```r
bh_old <- readOGR("../data/bh.gpkg", stringsAsFactors=FALSE)
```

```
## OGR data source with driver: GPKG 
## Source: "/home/rsb/presentations/ectqg19-workshop/data/bh.gpkg", layer: "bh"
## with 105 features
## It has 7 fields
## Integer64 fields read as strings:  Total Jobs Total Establishments Industry Diversity
```



```r
summary(bh_old)
```

```
## Object of class SpatialPolygonsDataFrame
## Coordinates:
##         min       max
## x -45.01195 -42.47446
## y -20.92759 -18.06804
## Is projected: FALSE 
## proj4string :
## [+proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs]
## Data attributes:
##   NM_MUNICIP         CD_GEOCMU         Total.Monthly.Wages
##  Length:105         Length:105         Min.   :7.651e+04  
##  Class :character   Class :character   1st Qu.:6.702e+05  
##  Mode  :character   Mode  :character   Median :2.040e+06  
##                                        Mean   :5.200e+07  
##                                        3rd Qu.:1.377e+07  
##                                        Max.   :3.616e+09  
##   Total.Jobs        Total.Establishments Average.Monthly.Wage
##  Length:105         Length:105           Min.   : 979.6      
##  Class :character   Class :character     1st Qu.:1197.3      
##  Mode  :character   Mode  :character     Median :1353.7      
##                                          Mean   :1536.0      
##                                          3rd Qu.:1704.4      
##                                          Max.   :3811.5      
##  Industry.Diversity
##  Length:105        
##  Class :character  
##  Mode  :character  
##                    
##                    
## 
```




```r
bh_old <- readOGR("../data/bh.gpkg", integer64="warn.loss", stringsAsFactors=FALSE)
```

```
## OGR data source with driver: GPKG 
## Source: "/home/rsb/presentations/ectqg19-workshop/data/bh.gpkg", layer: "bh"
## with 105 features
## It has 7 fields
## Integer64 fields read as signed 32-bit integers:  Total Jobs Total Establishments Industry Diversity
```


```r
summary(bh_old)
```

```
## Object of class SpatialPolygonsDataFrame
## Coordinates:
##         min       max
## x -45.01195 -42.47446
## y -20.92759 -18.06804
## Is projected: FALSE 
## proj4string :
## [+proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs]
## Data attributes:
##   NM_MUNICIP         CD_GEOCMU         Total.Monthly.Wages
##  Length:105         Length:105         Min.   :7.651e+04  
##  Class :character   Class :character   1st Qu.:6.702e+05  
##  Mode  :character   Mode  :character   Median :2.040e+06  
##                                        Mean   :5.200e+07  
##                                        3rd Qu.:1.377e+07  
##                                        Max.   :3.616e+09  
##    Total.Jobs      Total.Establishments Average.Monthly.Wage
##  Min.   :     71   Min.   :   16        Min.   : 979.6      
##  1st Qu.:    560   1st Qu.:   87        1st Qu.:1197.3      
##  Median :   1657   Median :  186        Median :1353.7      
##  Mean   :  21866   Mean   : 1313        Mean   :1536.0      
##  3rd Qu.:   6569   3rd Qu.:  629        3rd Qu.:1704.4      
##  Max.   :1354683   Max.   :70605        Max.   :3811.5      
##  Industry.Diversity
##  Min.   :  9       
##  1st Qu.: 44       
##  Median : 80       
##  Mean   :113       
##  3rd Qu.:162       
##  Max.   :585
```



```r
str(bh_old, max.level=2)
```

```
## Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
##   ..@ data       :'data.frame':	105 obs. of  7 variables:
##   ..@ polygons   :List of 105
##   ..@ plotOrder  : int [1:105] 20 42 66 87 102 55 48 35 82 34 ...
##   ..@ bbox       : num [1:2, 1:2] -45 -20.9 -42.5 -18.1
##   .. ..- attr(*, "dimnames")=List of 2
##   ..@ proj4string:Formal class 'CRS' [package "sp"] with 1 slot
```
