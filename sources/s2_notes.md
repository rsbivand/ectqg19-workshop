# Visualisation

## Anatomy of a graphic

- Figures

![Frame](https://upload.wikimedia.org/wikipedia/commons/a/ae/Tripod_easel.jpg)

- Axes

![Canvas](https://svgsilh.com/png-512/2027292.png)

- Layers

![One dataset](https://upload.wikimedia.org/wikipedia/commons/7/74/Grumpy_cat_drawing.jpg)

![Layered](https://upload.wikimedia.org/wikipedia/commons/2/22/Monet_Poppies.jpg)

![Multi-subplot](https://live.staticflickr.com/78/190673196_25690720f2_z_d.jpg)

## Non-spatial visualisation

Further: [`seaborn` tutorial](http://seaborn.pydata.org/tutorial.html)

### Univatiate continuous

- Histograms 

![](http://seaborn.pydata.org/_images/distributions_10_0.png)

- KDEs 

![](http://seaborn.pydata.org/_images/distributions_18_0.png)

### Bivariate continuous

- Scatter plots

![](http://seaborn.pydata.org/_images/distributions_28_0.png)

- Hexbin plots

![](http://seaborn.pydata.org/_images/distributions_30_0.png)

- 2D KDEs

![](http://seaborn.pydata.org/_images/distributions_32_0.png)

### Categorical plots

- Categorical scatter plots

![](http://seaborn.pydata.org/_images/categorical_4_0.png)

- Box plots

![](http://seaborn.pydata.org/_images/categorical_18_0.png)

- Violin plots

![](http://seaborn.pydata.org/_images/categorical_26_0.png)

## Spatial visualisation

Further: 

- GDS'19 Geovisualisation chapter [[`URL`]](http://darribas.org/gds19/labs/Lab_03.html)

## Choropleth mapping

- Choropleths as data reduction exercises

- Aspects to consider
    1. Classification scheme
        - Unique values
        
        ![](http://darribas.org/gds18/content/lectures/figs/l04_unique_values.png)
        
        - Equal intervals
        
        ![](https://github.com/darribas/gds18/raw/master/content/lectures/figs/l04_equal_interval.png)
        
        - Quantiles
        
        ![](https://github.com/darribas/gds18/raw/master/content/lectures/figs/l04_quantiles.png)
        
        - Fisher-Jenks
        - ...
    2. Number of classes
    3. Color palette (see [Colorbrewer](http://colorbrewer2.org))
        - Categorical 
        
            ![](http://darribas.org/gds18/content/lectures/figs/l04_pal_qual.png)
            
        - Sequential 
        
            ![](http://darribas.org/gds18/content/lectures/figs/l04_pal_seq.png)
            
        - Divergent 
        
            ![](http://darribas.org/gds18/content/lectures/figs/l04_pal_div.png)

Further: 

- [GDS'19 choropleth lab](http://darribas.org/gds19/labs/Lab_04.html)
- [GDS Book choropleth chapter](https://geographicdata.science/book/notebooks/05_choropleth.html)

