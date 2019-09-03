FROM darribas/gds:3.0

COPY ./pack.zip ${HOME}/pack.zip
RUN unzip ${HOME}/pack.zip \
 && mv pack work \
 && mv work/pack/* work \
 && rm -rf pack work/pack \
 && rm pack.zip
