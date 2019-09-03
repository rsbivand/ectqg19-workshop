FROM darribas/gds:3.0

COPY ./pack.zip ${HOME}/pack.zip
RUN unzip ${HOME}/pack.zip \
 && mv pack work \
 && rm -rf pack \
 && rm pack.zip
