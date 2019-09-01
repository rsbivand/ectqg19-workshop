---
title: "R: Data structures"
author: "Roger Bivand and Daniel Arribas-Bel"
date: "Thursday, 5 September 2019, 09:30-10:45"
output: 
  html_document:
bibliography: rmd.bib
link-citations: yes
---

# Data Structures

Notes to introduce data structures

### Suggested background reading, links

A selection of R resources includes the second edition of our book [@asdar], much of which remains revelant. Since the **sf** package has become available, it is sensible to begin with [@geocompr] - based as it is on a review of ASDAR pointing out its steep learning curve. A forthcoming book [@sdsr] is not the third revision of ASDAR, taking a more finely masked approach much closer to the code, and supplementing ASDAR and GEOCOMPR more than competing with them.

## Data structures

### Vectors, matrices, arrays, sparse matrices

In R, scalars are vectors of unit length, so most data are vectors or combinations of vectors. There are six basic vector types: list, integer, double, logical, character and [complex](http://www.johnmyleswhite.com/notebook/2009/12/18/using-complex-numbers-in-r/). The derived type factor is integer with extra information. Objects such as vectors may also have attributes in which their class and other information may be placed. Typically, a lot of use is made of attributes to squirrel away strings and short vectors.

### Data frames

First, let us see that is behind the `data.frame` object in R: the `list` object. `list` objects are vectors that contain other objects, which can be addressed by name or by 1-based indices. Since a `data.frame` is a rectangular object with named columns with equal numbers of rows, it can also be indexed like a matrix. R objects have attributes that are not normally displayed, but which show their structure and class (if any). 

## Spatial vector data

The R **sf** package bundles GDAL and GEOS (**sp** just defined the classes and methods, leaving I/O and computational geometry to other packages **rgdal** and **rgeos**). **sf** uses `data.frame` objects with one (or more) geometry column for vector data. The representation follows ISO 19125 (*Simple Features*), and has WKT (text) and WKB (binary) representations (used by GDAL and GEOS internally).

Because R has always provided the `data.frame` class, and uses it as the container for data for most steps in data manipulation, visualization and analysis, R does not need Python `pandas`. R **sf** provides geometry objects corresponding to `shapely` for Python as well as the `data.frame`-geometry column integration found in `geopandas`. They share underlying libraries such as PROJ, GEOS and GDAL.

The R **stars** package will provide spatio-temporal arrays for irregular geometries despite being initially conceptualized for spatio-temporal raster arrays. It will supercede the **spacetime** package.

The R Global project is being started to provide native support for global datasets, with better handling of vector tiles.

### Input/output

In R, **sf** uses GDAL and PROJ for input/output of vector data using the vector drivers in the GDAL linked to **sf**. R CRAN **sf** Windows and OSX binaries include most commonly used drivers, but for more complex workflows, others may be needed.

## Spatial raster data

In R, the **raster** package uses formal classes through **sp** and handles input/output through **rgdal** and other packages. The new **stars** package piggy-backs onto **sf** to integrate GDAL drivers, handling functions and array conceptualizations (see also **gdalcubesr**).

### Input/output

GDAL drivers can be used to read data into memory and to create R objects containing the metadata of the data source as a virtual or proxy driver. In **stars**, steps are being provided to resample on-the-fly from proxy data sources, for example to avoid calculating results that have higher resolution than the chosen display device.

## Coordinate metadata

Because so much open source (and other) software uses the PROJ library and framework, many are affected when PROJ upgrades. Until very recently, PROJ has been seen as very reliable, and the changes taking place now are intended to confirm and reinforce this reliability. Before PROJ 5 (PROJ 6 is out now, PROJ 7 is coming early in 2020), the `+datum=` tag was used, perhaps with `+towgs84=` with three or seven coefficients, and possibly `+nadgrids=` where datum transformation grids were available. However, transformations from one projection to another first inversed to longitude-latitude in WGS84, then projected on to the target projection. R packages typically use EPSG codes and/or PROJ strings to specify coordinate reference systems.

### PROJ 4 & WKT1

Typically, user-facing workflows used an ambiguous WGS84 hub, so projection from a known projection to another known projection, specified as PROJ (4) strings, inverse projected to an WGS84 perhaps given by a `+towgs84=` key value or a `+nadgrids=` grid found in the collection of PROJ metadata files. None of the metadata files were versioned; even the EPSG database was a flat CSV file. WKT1 varied between providers, with ESRI using a slightly different version from GDAL.

### PROJ & WKT2

With ISO standardization, PROJ needed to advance, abandoning hub transformation, `+datum=` and `+towgs84=` key values, and switching to an SQLite database for EPSG records. Coordinate metadata will also need an epoch (at which time do the definitions apply, maybe when were the observations made in that CRS) and a region of application. Transformation will need (much) more user intervention to specify the transformation path. **sf** used GDAL for transformation, but GDAL from version 3 uses PROJ 6 directly, and may run into trouble if grids are absent. Many grids are not (yet) open access, or provided on open licenses from PROJ.




