# Spatial Regression

## Spatial error model

In trying to model these spatial processes, we may choose to model the spatial autocorrelation in the residual with a spatial error model (SEM). 

$$
{\mathbf y} = {\mathbf X}{\mathbf \beta} + {\mathbf u},
\qquad {\mathbf u} = \rho_{\mathrm{Err}} {\mathbf W} {\mathbf u} + {\mathbf \varepsilon},
$$
where ${\mathbf y}$ is an $(N \times 1)$ vector of observations on a response variable taken  at each of $N$ locations, ${\mathbf X}$ is an $(N \times k)$ matrix of covariates, ${\mathbf \beta}$ is a $(k \times 1)$ vector of parameters, ${\mathbf u}$ is an $(N \times 1)$ spatially autocorrelated disturbance vector, ${\mathbf \varepsilon}$ is an $(N \times 1)$ vector of independent and identically distributed disturbances and $\rho_{\mathrm{Err}}$ is a scalar spatial parameter. Case weights are not shown here.

If the processes in the covariates and the response match, we should find little difference between the coefficients of a least squares and a SEM, but very often they diverge, suggesting that a Hausman test for this condition should be employed.

### Spatial lag model


A model with a spatial process in the response only is termed a spatial lag model (SLM, often SAR - spatial autoregressive). 

$$
{\mathbf y} = \rho_{\mathrm{Lag}} {\mathbf W}{\mathbf y} + {\mathbf X}{\mathbf \beta} + {\mathbf \varepsilon},
$$
where $\rho_{\mathrm{Lag}}$ is a scalar spatial parameter.

### Spatial Durbin model

The Durbin model adds the spatially lagged covariates to the covariates included in the spatial lag model, giving a spatial Durbin model (SDM) with different processes in the response and covariates: 

$$
{\mathbf y} = \rho_{\mathrm{Lag}} {\mathbf W}{\mathbf y} + {\mathbf X}{\mathbf \beta} + {\mathbf W}{\mathbf X}{\mathbf \gamma} + {\mathbf \varepsilon},
$$
where ${\mathbf \gamma}$ is a $(k' \times 1)$ vector of parameters. $k'$ defines the subset of the intercept and covariates, often $k' = k-1$ when using row standardised spatial weights and omitting the spatially lagged intercept.


### General nested model

If we extend this family with processes in the covariates and the residual, we get  a spatial error Durbin model (SDEM). If it is chosen to admit a spatial process in the residuals in addition to a spatial process in the response, again two models are formed, a general nested model (GNM) nesting all the others, and a model without spatially lagged covariates (SAC, also known as SARAR - Spatial AutoRegressive-AutoRegressive model). If neither the residuals nor the residual are modelled with spatial processes, spatially lagged covariates may be added to a linear model, as a spatially lagged X model (SLX).

We can write the general nested model (GNM) as:

$$
{\mathbf y} = \rho_{\mathrm{Lag}} {\mathbf W_{\mathrm{Lag}}}{\mathbf y} + {\mathbf X}{\mathbf \beta} + {\mathbf W_{\mathrm{Lag}}}{\mathbf X}{\mathbf \gamma} + {\mathbf u},
\qquad {\mathbf u} = \rho_{\mathrm{Err}} {\mathbf W_{\mathrm{Err}}} {\mathbf u} + {\mathbf \varepsilon},
$$
where ${\mathbf W_{\mathrm{Lag}}}$ and ${\mathbf W_{\mathrm{Err}}}$ are two possibly different spatial weights matrices.

This may be constrained to the double spatial coefficient model SAC/SARAR by setting ${\mathbf \gamma} = 0$, to the spatial Durbin (SDM) by setting $\rho_{\mathrm{Err}} = 0$, and to the error Durbin model (SDEM) by setting $\rho_{\mathrm{Lag}} = 0$. Imposing more conditions gives the spatial lag model (SLM) with ${\mathbf \gamma} = 0$ and $\rho_{\mathrm{Err}} = 0$, the spatial error model (SEM) with ${\mathbf \gamma} = 0$ and $\rho_{\mathrm{Lag}} = 0$, and the spatially lagged X model (SLX) with $\rho_{\mathrm{Lag}} = 0$ and $\rho_{\mathrm{Err}} = 0$.


## Impacts

Although making predictions for new locations for which covariates are observed was raised as an issue some time ago, it has many years to make progress in reviewing the possibilities. The prediction methods for SLM, SDM, SEM, SDEM, SAC and GNM models fitted with maximum likelihood were contributed as a Google Summer of Coding project by Martin Gubri. Work on prediction also exposed the importance of the reduced form of these models, in which the spatial process in the response interacts with the regression coefficients in the SLM, SDM, SAC and GNM models. 

The consequence of these interactions is that a unit change in a covariate will only impact the response as the value of the regression coefficient if the spatial coefficient of the lagged response is zero. Where it is non-zero, global spillovers, impacts, come into play, and these impacts should be reported rather than the regression coefficients. Local impacts may be reported for SDEM and SLX models, using linear combination to calculate standard errors for the total impacts of each covariate (sums of coefficients on the covariates and their spatial lags).

## References

- [SDSR](https://keen-swartz-3146c4.netlify.com/spatial-regression.html)
- [JSS: Bivand and Piras, 2015](https://doi.org/10.18637/jss.v063.i18)
- [JSS: Bivand et al., 2017](https://doi.org/10.1016/j.spasta.2017.01.002)
- [GDS Book, intro to spatial regression](https://geographicdata.science/book/notebooks/11_regression.html)

