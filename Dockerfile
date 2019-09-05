FROM darribas/gds:3.0

USER root
RUN R -e "install.packages(c( \
		'stars', \
		'cartography', \
		'spatialreg', \
		'MatrixModels', \
		'HSAR' \
		), repos='http://cran.rstudio.com');"
USER $NB_UID

COPY ./pack.zip ${HOME}/pack.zip
RUN unzip ${HOME}/pack.zip \
 && mv pack work \
 && mv work/pack/* work \
 && rm -rf pack work/pack \
 && rm pack.zip
