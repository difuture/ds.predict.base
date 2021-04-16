
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Actions
Status](https://github.com/difuture/ds.predict.base/workflows/R-CMD-check/badge.svg)](https://github.com/difuture/ds.predict.base/actions)
[![License: LGPL
v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](https://www.gnu.org/licenses/lgpl-3.0)
[![codecov](https://codecov.io/gh/difuture/ds.predict.base/branch/master/graph/badge.svg?token=OLIPLWDTN5)](https://codecov.io/gh/difuture/ds.predict.base)

# Base Predict Function for DataSHIELD

The package provides base functionality to push `R` objects to servers
using the DataSHIELD\](<https://www.datashield.ac.uk/>) infrastructure
for distributed computing. Additionally, it is possible to calculate
predictions on the server for a specific model. Combining these allows
to push a model from the local machine to all servers running DataSHIELD
and predicting on that model with data exclusively hold by the server.
The predictions are stored at the server and can be further analysed
using the DataSHIELD functionality for non-disclosive analyses.

## Installation

At the moment, there is no CRAN version available. Install the
development version from GitHub:

``` r
remotes::install_github("difuture-lmu/ds.predict.base")
```

#### Register assign methods

It is necessary to register the assign methods in the OPAL
administration. The assign methods are:

  - `decodeBinary`
  - `assignPredictModel`

These methods are registered automatically when publishing the package
on OPAL (see
[`DESCRIPTION`](https://github.com/difuture/ds.predict.base/blob/master/DESCRIPTION)).

Note that the package needs to be installed at both locations, the
server and the analysts machine.

## Usage

The following code shows the basic methods and how to use them. Note
that this package is intended for internal usage and base for the other
packages and does not really have any practical usage for the analyst.

``` r
library(DSI)
library(DSOpal)
library(DSLite)
library(dsBaseClient)

# library(ds.predict.base)

builder = DSI::newDSLoginBuilder()

builder$append(
  server   = "ibe",
  url      = "******",
  user     = "***",
  password = "******",
  table    = "ProVal.KUM"
)


logindata = builder$build()
connections = DSI::datashield.login(logins = logindata, assign = TRUE, symbol = "D", opts = list(ssl_verifyhost = 0, ssl_verifypeer=0))

### Get available tables:
DSI::datashield.symbols(connections)

### Test data with same structure as data on test server:
dat   = cbind(age = sample(20:100, 100L, TRUE), height = runif(100L, 150, 220))
probs = 1 / (1 + exp(-as.numeric(dat %*% c(-3, 1))))
dat   = data.frame(gender = rbinom(100L, 1L, probs), dat)

### Model we want to upload:
mod = glm(gender ~ age + height, family = "binomial", data = dat)

### Upload model to DataSHIELD server
pushObject(connections, mod)

# Check if model "mod" is now available:
DSI::datashield.symbols(connections)

# Check class of uploaded "mod":
ds.class("mod")

# Now predict on uploaded model and data set "D" and store as object "pred":
predictModel(connections, mod, "pred", dat_name = "D")

# Check if prediction "pred" is now available:
DSI::datashield.symbols(connections)

# Summary of "pred":
ds.summary("pred")

# Now assign values with response type "response":
predictModel(connections, mod, "pred", "D", predict_fun = "predict(mod, newdata = D, type = 'response')")
ds.summary("pred")

DSI::datashield.logout(connections)
```
