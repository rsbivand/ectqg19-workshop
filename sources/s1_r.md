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

## Vectors, matrices and `data.frames`

### Simple vectors

In R, scalars are vectors of unit length, so most data are vectors or combinations of vectors. The printed results are prepended by a curious `[1]`; all these results are unit length vectors. We can combine several objects with `c()`:


```r
a <- c(2, 3)
a
```

```
## [1] 2 3
```

```r
sum(a)
```

```
## [1] 5
```

```r
str(a)
```

```
##  num [1:2] 2 3
```

```r
aa <- rep(a, 50)
aa
```

```
##   [1] 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2
##  [36] 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3
##  [71] 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3 2 3
```

The single square brackets `[]` are used to access or set elements of vectors (the colon `:` gives an integer sequence); negative indices drop elements:


```r
length(aa)
```

```
## [1] 100
```

```r
aa[1:10]
```

```
##  [1] 2 3 2 3 2 3 2 3 2 3
```

```r
sum(aa)
```

```
## [1] 250
```

```r
sum(aa[1:10])
```

```
## [1] 25
```

```r
sum(aa[-(11:length(aa))])
```

```
## [1] 25
```

### Arithmetic under the hood

Infix syntax is just a representation of the actual underlying forms


```r
a[1] + a[2]
```

```
## [1] 5
```

```r
sum(a)
```

```
## [1] 5
```

```r
`+`(a[1], a[2])
```

```
## [1] 5
```

```r
Reduce(`+`, a)
```

```
## [1] 5
```

We've done arithmetic on scalars, we can do vector-scalar arithmetic:


```r
sum(aa)
```

```
## [1] 250
```

```r
sum(aa+2)
```

```
## [1] 450
```

```r
sum(aa)+2
```

```
## [1] 252
```

```r
sum(aa*2)
```

```
## [1] 500
```

```r
sum(aa)*2
```

```
## [1] 500
```

But vector-vector arithmetic poses the question of vector length and recycling (the shorter one gets recycled):



```r
v5 <- 1:5
v2 <- c(5, 10)
v5 * v2
```

```
## Warning in v5 * v2: longer object length is not a multiple of shorter
## object length
```

```
## [1]  5 20 15 40 25
```

```r
v2_stretch <- rep(v2, length.out=length(v5))
v2_stretch
```

```
## [1]  5 10  5 10  5
```

```r
v5 * v2_stretch
```

```
## [1]  5 20 15 40 25
```

In working with real data, we often meet missing values, coded by NA meaning Not Available:


```r
anyNA(aa)
```

```
## [1] FALSE
```

```r
is.na(aa) <- 5
aa[1:10]
```

```
##  [1]  2  3  2  3 NA  3  2  3  2  3
```

```r
anyNA(aa)
```

```
## [1] TRUE
```

```r
sum(aa)
```

```
## [1] NA
```

```r
sum(aa, na.rm=TRUE)
```

```
## [1] 248
```

### Checking data


One way to check our input data is to print in the console --- this works with small objects as we've seen, but for larger objects we need methods:



```r
big <- 1:(10^5)
length(big)
```

```
## [1] 100000
```

```r
head(big)
```

```
## [1] 1 2 3 4 5 6
```

```r
str(big)
```

```
##  int [1:100000] 1 2 3 4 5 6 7 8 9 10 ...
```

```r
summary(big)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##       1   25001   50000   50000   75000  100000
```

### Basic vector types

There are `length`, `head`, `str` (*str*ucture) and `summary` methods for many types of objects. `str` also gives us a hint of the type of object and its dimensions. We've seen a couple of uses of `str` so far, `str(a)` was `num` and `str(big)` was `int`, what does this signify? They are both numbers, but of different types.

There are six basic vector types: list, integer, double, logical, character and [complex](http://www.johnmyleswhite.com/notebook/2009/12/18/using-complex-numbers-in-r/). The derived type factor (to which we return shortly) is integer with extra information. `str` reports these as int, num, logi, chr and cplx, and lists are enumerated recursively. In RStudio you see more or less the `str` output in the environment pane as Values in the list view; the grid view adds the object size in memory. From early S, we have `typeof` and `storage.mode` (including single precision, not used in R) --- these are important for interfacing C, C++, Fortran and other languages. Beyond this is `class`, but then the different class systems (S3 and formal S4) complicate things. Objects such as vectors may also have attributes in which their class and other information may be placed. Typically, a lot of use is made of attributes to squirrel away strings and short vectors. 

`is` methods are used to test types of objects; note that integers are also seen as numeric:


```r
set.seed(1)
x <- runif(50, 1, 10)
is.numeric(x)
```

```
## [1] TRUE
```

```r
y <- rpois(50, lambda=6)
is.numeric(y)
```

```
## [1] TRUE
```

```r
is.integer(y)
```

```
## [1] TRUE
```

```r
xy <- x < y
is.logical(xy)
```

```
## [1] TRUE
```

`as` methods try to convert between object types and are widely used:


```r
str(as.integer(xy))
```

```
##  int [1:50] 1 1 0 0 1 0 0 0 1 1 ...
```

```r
str(as.numeric(y))
```

```
##  num [1:50] 6 9 5 4 3 3 5 6 7 5 ...
```

```r
str(as.character(y))
```

```
##  chr [1:50] "6" "9" "5" "4" "3" "3" "5" "6" "7" "5" "9" "5" "6" "5" ...
```

```r
str(as.integer(x))
```

```
##  int [1:50] 3 4 6 9 2 9 9 6 6 1 ...
```

### The data frame object

First, let us see that is behind the `data.frame` object: the `list` object. `list` objects are vectors that contain other objects, which can be addressed by name or by 1-based indices. Like the vectors we have already met, lists can be  accessed and manipulated using square brackets `[]`. Single list elements can be accessed and manipulated using double square brackets `[[]]`. 

### List objects

Starting with four vectors of differing types, we can assemble a list object; as we see, its structure is quite simple. The vectors in the list may vary in length, and lists can (and do often) include lists


```r
V1 <- 1:3
V2 <- letters[1:3]
V3 <- sqrt(V1)
V4 <- sqrt(as.complex(-V1))
L <- list(v1=V1, v2=V2, v3=V3, v4=V4)
str(L)
```

```
## List of 4
##  $ v1: int [1:3] 1 2 3
##  $ v2: chr [1:3] "a" "b" "c"
##  $ v3: num [1:3] 1 1.41 1.73
##  $ v4: cplx [1:3] 0+1i 0+1.41i 0+1.73i
```

```r
L$v3[2]
```

```
## [1] 1.414214
```

```r
L[[3]][2]
```

```
## [1] 1.414214
```

### Data Frames

Our `list` object contains four vectors of different types but of the same length; conversion to a `data.frame` is convenient. Note that by default strings are converted into factors:


```r
DF <- as.data.frame(L)
str(DF)
```

```
## 'data.frame':	3 obs. of  4 variables:
##  $ v1: int  1 2 3
##  $ v2: Factor w/ 3 levels "a","b","c": 1 2 3
##  $ v3: num  1 1.41 1.73
##  $ v4: cplx  0+1i 0+1.41i 0+1.73i
```

```r
DF <- as.data.frame(L, stringsAsFactors=FALSE)
str(DF)
```

```
## 'data.frame':	3 obs. of  4 variables:
##  $ v1: int  1 2 3
##  $ v2: chr  "a" "b" "c"
##  $ v3: num  1 1.41 1.73
##  $ v4: cplx  0+1i 0+1.41i 0+1.73i
```

We can also provoke an error in conversion from a valid `list` made up of vectors of different length to a `data.frame`:



```r
V2a <- letters[1:4]
V4a <- factor(V2a)
La <- list(v1=V1, v2=V2a, v3=V3, v4=V4a)
DFa <- try(as.data.frame(La, stringsAsFactors=FALSE), silent=TRUE)
message(DFa)
```

```
## Error in (function (..., row.names = NULL, check.rows = FALSE, check.names = TRUE,  : 
##   arguments imply differing number of rows: 3, 4
```

We can access `data.frame` elements as `list` elements, where the `$` is effectively the same as `[[]]` with the list component name as a string:


```r
DF$v3[2]
```

```
## [1] 1.414214
```

```r
DF[[3]][2]
```

```
## [1] 1.414214
```

```r
DF[["v3"]][2]
```

```
## [1] 1.414214
```

Since a `data.frame` is a rectangular object with named columns with equal numbers of rows, it can also be indexed like a matrix, where the rows are the first index and the columns (variables) the second:



```r
DF[2, 3]
```

```
## [1] 1.414214
```

```r
DF[2, "v3"]
```

```
## [1] 1.414214
```

```r
str(DF[2, 3])
```

```
##  num 1.41
```

```r
str(DF[2, 3, drop=FALSE])
```

```
## 'data.frame':	1 obs. of  1 variable:
##  $ v3: num 1.41
```

If we coerce a `data.frame` containing a character vector or factor into a matrix, we get a character matrix; if we extract an integer and a numeric column, we get a numeric matrix.


```r
as.matrix(DF)
```

```
##      v1  v2  v3         v4           
## [1,] "1" "a" "1.000000" "0+1.000000i"
## [2,] "2" "b" "1.414214" "0+1.414214i"
## [3,] "3" "c" "1.732051" "0+1.732051i"
```

```r
as.matrix(DF[,c(1,3)])
```

```
##      v1       v3
## [1,]  1 1.000000
## [2,]  2 1.414214
## [3,]  3 1.732051
```

The fact that `data.frame` objects descend from `list` objects is shown by looking at their lengths; the length of a matrix is not its number of columns, but its element count:


```r
length(L)
```

```
## [1] 4
```

```r
length(DF)
```

```
## [1] 4
```

```r
length(as.matrix(DF))
```

```
## [1] 12
```

There are `dim` methods for `data.frame` objects and matrices (and arrays with more than two dimensions); matrices and arrays are seen as vectors with dimensions; `list` objects have no dimensions:



```r
dim(L)
```

```
## NULL
```

```r
dim(DF)
```

```
## [1] 3 4
```

```r
dim(as.matrix(DF))
```

```
## [1] 3 4
```


```r
str(as.matrix(DF))
```

```
##  chr [1:3, 1:4] "1" "2" "3" "a" "b" "c" "1.000000" "1.414214" ...
##  - attr(*, "dimnames")=List of 2
##   ..$ : NULL
##   ..$ : chr [1:4] "v1" "v2" "v3" "v4"
```

`data.frame` objects have `names` and `row.names`, matrices have `dimnames`, `colnames` and `rownames`; all can be used for setting new values:


```r
row.names(DF)
```

```
## [1] "1" "2" "3"
```

```r
names(DF)
```

```
## [1] "v1" "v2" "v3" "v4"
```

```r
names(DF) <- LETTERS[1:4]
names(DF)
```

```
## [1] "A" "B" "C" "D"
```

```r
str(dimnames(as.matrix(DF)))
```

```
## List of 2
##  $ : NULL
##  $ : chr [1:4] "A" "B" "C" "D"
```

R objects have attributes that are not normally displayed, but which show their structure and class (if any); we can see that `data.frame` objects are quite different internally from matrices:



```r
str(attributes(DF))
```

```
## List of 3
##  $ names    : chr [1:4] "A" "B" "C" "D"
##  $ class    : chr "data.frame"
##  $ row.names: int [1:3] 1 2 3
```

```r
str(attributes(as.matrix(DF)))
```

```
## List of 2
##  $ dim     : int [1:2] 3 4
##  $ dimnames:List of 2
##   ..$ : NULL
##   ..$ : chr [1:4] "A" "B" "C" "D"
```

If the reason for different vector lengths was that one or more observations are missing on that variable, `NA` should be used; the lengths are then equal, and a rectangular table can be created:


```r
V1a <- c(V1, NA)
V3a <- sqrt(V1a)
La <- list(v1=V1a, v2=V2a, v3=V3a, v4=V4a)
DFa <- as.data.frame(La, stringsAsFactors=FALSE)
str(DFa)
```

```
## 'data.frame':	4 obs. of  4 variables:
##  $ v1: int  1 2 3 NA
##  $ v2: chr  "a" "b" "c" "d"
##  $ v3: num  1 1.41 1.73 NA
##  $ v4: Factor w/ 4 levels "a","b","c","d": 1 2 3 4
```


## New style spatial vector representation

### The **sf** package

The recent **sf** package bundles GDAL and GEOS (**sp** just defined the classes and methods, leaving I/O and computational geometry to other packages **rgdal** and **rgeos**). **sf** used `data.frame` objects with one (or more) geometry column for vector data. The representation follows ISO 19125 (*Simple Features*), and has WKT (text) and WKB (binary) representations (used by GDAL and GEOS internally). The drivers include PostGIS and other database constructions permitting selection, and WFS for server APIs. These are the key references for **sf**: [@geogompr], [@sdsr], [@RJ-2018-009], package [vignettes](https://cran.r-project.org/package=sf) and blog posts on (https://www.r-spatial.org/).



```r
library(sf)
```

```
## Linking to GEOS 3.7.2, GDAL 3.0.1, PROJ 6.1.1
```

The `st_read()` method, here for a `"character"` first object giving the file name and path, uses GDAL through **Rcpp** to identify the driver required, and to use it to read the feature geometries and fields. The character string fields are not converted to `"factor"` representation, as they are not categorical variables:


```r
lux <- st_read("../data/lux_regions.gpkg", stringsAsFactors=FALSE)
```

```
## Reading layer `lux_regions' from data source `/home/rsb/presentations/ectqg19-workshop/data/lux_regions.gpkg' using driver `GPKG'
## Simple feature collection with 102 features and 10 fields
## geometry type:  MULTIPOLYGON
## dimension:      XY
## bbox:           xmin: 5.735708 ymin: 49.44786 xmax: 6.530898 ymax: 50.18277
## epsg (SRID):    4326
## proj4string:    +proj=longlat +datum=WGS84 +no_defs
```

Package **sf** provides handling of feature data, where feature
geometries are points, lines, polygons or combinations of those.
It implements the full set of geometric functions described in the
_simple feature access_ standard, and some. The basic storage is
very simple, and uses only base R types (list, matrix).

* feature sets are held as records (rows) in `"sf"` objects, inheriting from `"data.frame"`
* `"sf"` objects have at least one simple feature geometry list-column of class `"sfc"`
* geometry list-columns are *sticky*, that is they stay stuck to the object when subsetting columns, for example using `[`
* `"sfc"` geometry list-columns have a bounding box and a coordinate reference system as attribute, and a class attribute pointing out the common type (or `"GEOMETRY"` in case of a mix)
* a single simple feature geometry is of class `"sfg"`, and further classes pointing out dimension and type

Storage of simple feature geometry:

* `"POINT"` is a numeric vector
* `"LINESTRING"` and `"MULTIPOINT"` are numeric matrix, points/vertices in rows
* `"POLYGON"` and `"MULTILINESTRING"` are lists of matrices
* `"MULTIPOLYGON"` is a lists of those
* `"GEOMETRYCOLLECTION"` is a list of typed geometries



```r
class(lux)
```

```
## [1] "sf"         "data.frame"
```

The columns of the `"data.frame"` object have these names:


```r
names(lux)
```

```
##  [1] "POPULATION"  "COMMUNE_1"   "LAU2"        "X_subtype"   "COMMUNE"    
##  [6] "DISTRICT"    "CANTON"      "tree_count"  "ghsl_pop"    "light_level"
## [11] "geom"
```

Two of the attributes of the object are those all `"data.frame"` objects possess: `names` shown above and `row.names`. The fourth, `sf_column` gives the name of the active geometry column.


```r
names(attributes(lux))
```

```
## [1] "names"     "row.names" "class"     "sf_column" "agr"
```

The `$` access operator lets us operate on a single column of the object as with any other `"data.frame"` object:


```r
hist(lux$ghsl_pop)
```

![](s1_r_files/figure-html/unnamed-chunk-19-1.png)<!-- -->

Using the attribute value to extract the name of the geometry column, and the `[[` access operator to give programmatic access to a column by name, we can see that the `"sfc"` object is composed of `POLYGON` objects:


```r
class(lux[[attr(lux, "sf_column")]])
```

```
## [1] "sfc_MULTIPOLYGON" "sfc"
```

The geometry column is a list column, of the same length as the other columns in the `"data.frame"` object.


```r
is.list(lux[[attr(lux, "sf_column")]])
```

```
## [1] TRUE
```

`"sf"` objects may be subsetted by row and column in the same way as regular `"data.frame"` objects, with the implicit understanding that the geometry column is _sticky_; here we choose only the first column, but the geometry column follows along, _stuck_ to the subsetted object, and obviously subsetted by row too.



```r
class(lux[1:5, 1])
```

```
## [1] "sf"         "data.frame"
```

Geometry columns have their own list of attributes, the count of empty geometries, the coordinate reference system, the precision and the bounding box (subsetting will refresh the bounding box; transformation will update the coordinate reference system and the bounding box):


```r
attributes(lux[[attr(lux, "sf_column")]])
```

```
## $n_empty
## [1] 0
## 
## $crs
## Coordinate Reference System:
##   EPSG: 4326 
##   proj4string: "+proj=longlat +datum=WGS84 +no_defs"
## 
## $class
## [1] "sfc_MULTIPOLYGON" "sfc"             
## 
## $precision
## [1] 0
## 
## $bbox
##      xmin      ymin      xmax      ymax 
##  5.735708 49.447859  6.530898 50.182772
```
The coordinate reference system is an object of class `"crs"`:


```r
class(attr(lux[[attr(lux, "sf_column")]], "crs"))
```

```
## [1] "crs"
```

It contains an integer EPSG code (so far not compound codes), and a PROJ string:


```r
str(attr(lux[[attr(lux, "sf_column")]], "crs"))
```

```
## List of 2
##  $ epsg       : int 4326
##  $ proj4string: chr "+proj=longlat +datum=WGS84 +no_defs"
##  - attr(*, "class")= chr "crs"
```

Objects of this class can be instantiated for example by giving the relevant EPSG code:


```r
st_crs(4674)
```

```
## Coordinate Reference System:
##   EPSG: 4674 
##   proj4string: "+proj=longlat +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +no_defs"
```


```r
st_crs(31983)
```

```
## Coordinate Reference System:
##   EPSG: 31983 
##   proj4string: "+proj=utm +zone=23 +south +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"
```

We can drill down to the first feature geometry `"sfg"` object, which is a matrix with a class attribute - a vector of three elements, `"XY"` for two dimensions, `"POLYGON"` for the simple features definition, and `"sfg"` as the container class:


```r
str(lux[[attr(lux, "sf_column")]][[1]])
```

```
## List of 1
##  $ :List of 1
##   ..$ : num [1:159, 1:2] 6 6 6 6 6 ...
##  - attr(*, "class")= chr [1:3] "XY" "MULTIPOLYGON" "sfg"
```


## Old style spatial vector representation

[@pebesma+bivand:05], [@asdar]


```r
library(rgdal)
```

```
## Loading required package: sp
```

```
## rgdal: version: 1.4-6, (SVN revision 828)
##  Geospatial Data Abstraction Library extensions to R successfully loaded
##  Loaded GDAL runtime: GDAL 3.0.1, released 2019/06/28
##  Path to GDAL shared files: 
##  GDAL binary built with GEOS: TRUE 
##  Loaded PROJ.4 runtime: Rel. 6.1.1, July 1st, 2019, [PJ_VERSION: 611]
##  Path to PROJ.4 shared files: (autodetected)
##  Linking to sp version: 1.3-1
```



```r
lux_old <- readOGR("../data/lux_regions.gpkg", integer64="warn.loss", stringsAsFactors=FALSE)
```

```
## OGR data source with driver: GPKG 
## Source: "/home/rsb/presentations/ectqg19-workshop/data/lux_regions.gpkg", layer: "lux_regions"
## with 102 features
## It has 10 fields
## Integer64 fields read as signed 32-bit integers:  POPULATION
```


```r
summary(lux_old)
```

```
## Object of class SpatialPolygonsDataFrame
## Coordinates:
##         min       max
## x  5.735708  6.530898
## y 49.447859 50.182772
## Is projected: FALSE 
## proj4string :
## [+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0]
## Data attributes:
##    POPULATION      COMMUNE_1             LAU2            X_subtype        
##  Min.   :   790   Length:102         Length:102         Length:102        
##  1st Qu.:  1915   Class :character   Class :character   Class :character  
##  Median :  2938   Mode  :character   Mode  :character   Mode  :character  
##  Mean   :  5902                                                           
##  3rd Qu.:  5489                                                           
##  Max.   :116323                                                           
##    COMMUNE            DISTRICT            CANTON            tree_count    
##  Length:102         Length:102         Length:102         Min.   : 0.000  
##  Class :character   Class :character   Class :character   1st Qu.: 2.000  
##  Mode  :character   Mode  :character   Mode  :character   Median : 4.000  
##                                                           Mean   : 5.245  
##                                                           3rd Qu.: 7.000  
##                                                           Max.   :43.000  
##     ghsl_pop         light_level    
##  Min.   :   815.1   Min.   : 299.0  
##  1st Qu.:  1726.2   1st Qu.: 628.8  
##  Median :  3072.4   Median : 896.5  
##  Mean   :  5542.2   Mean   :1076.9  
##  3rd Qu.:  5190.2   3rd Qu.:1255.2  
##  Max.   :106144.0   Max.   :5614.0
```



```r
str(lux_old, max.level=2)
```

```
## Formal class 'SpatialPolygonsDataFrame' [package "sp"] with 5 slots
##   ..@ data       :'data.frame':	102 obs. of  10 variables:
##   ..@ polygons   :List of 102
##   ..@ plotOrder  : int [1:102] 95 15 25 44 84 10 94 27 5 6 ...
##   ..@ bbox       : num [1:2, 1:2] 5.74 49.45 6.53 50.18
##   .. ..- attr(*, "dimnames")=List of 2
##   ..@ proj4string:Formal class 'CRS' [package "sp"] with 1 slot
```



```r
class(lux_old)
```

```
## [1] "SpatialPolygonsDataFrame"
## attr(,"package")
## [1] "sp"
```



```r
class(slot(lux_old, "data"))
```

```
## [1] "data.frame"
```



```r
hist(lux_old$ghsl_pop)
```

![](s1_r_files/figure-html/unnamed-chunk-35-1.png)<!-- -->



```r
class(slot(lux_old, "polygons"))
```

```
## [1] "list"
```



```r
class(slot(lux_old, "proj4string"))
```

```
## [1] "CRS"
## attr(,"package")
## [1] "sp"
```



```r
class(lux_old[1:5, 1])
```

```
## [1] "SpatialPolygonsDataFrame"
## attr(,"package")
## [1] "sp"
```
