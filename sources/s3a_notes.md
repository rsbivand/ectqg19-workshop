# ESDA

**E**xploratory

**S**patial

**D**ata

**A**nalysis

## Spatial Weights

# Why?

- Formal representation of space
- Bridge between geography and statistics
- Widely used in a range of applications (e.g. ESDA, spatial regression, regionalisation...)

## What?

[`W`](http://darribas.org/gds19/slides/lecture_05.html#/w):

> *N x N positive matrix that contains spatial relations between all the observations in the sample*

$$
w_{ij} = \left\{ \begin{array}{rl}
x > 0 &\mbox{ if $i$ and $j$ are neighbors} \\
0 &\mbox{ otherwise}
\end{array} \right\}
$$

... **what is a *neighbor*?**

## How?

![](https://geographicdata.science/book/images/notebooks/04_spatial_weights_4_0.png)

- "Next door": Contiguity-based Ws
- "Close": Distance-based Ws
- "In the same 'place'": Block weights

### Contiguity

![](https://geographicdata.science/book/images/notebooks/04_spatial_weights_8_0.png)

**Quiz** 

What is the dimension of the $W$ for the image above?

1. 3x3
1. 9x3
1. 3x9
1. 9x9
1. None of the above

[[Answer](https://geographicdata.science/book/notebooks/04_spatial_weights.html#Contiguity-Weights)]

### Distance

- *k*-NN
- Distance threshold

### Block weights

- Counties in states
- Regions in countries
- ...

## Sources

* [GDS Book - Weights](https://geographicdata.science/book/notebooks/04_spatial_weights.html)
* [GDS'19 - Weights lecture](http://darribas.org/gds19/notes/Class_05.html)
* [GDS'19 - Weights lab](http://darribas.org/gds19/labs/Lab_05.html)
