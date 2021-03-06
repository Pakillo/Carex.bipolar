SDM analysis of *Carex* bipolar species
================
2017-11-15

[![DOI](https://zenodo.org/badge/89584660.svg)](https://zenodo.org/badge/latestdoi/89584660)

[![Travis-CI Build Status](https://travis-ci.org/Pakillo/Carex.bipolar.svg?branch=master)](https://travis-ci.org/Pakillo/Carex.bipolar)

Research compendium (code and data) used for the species distribution modelling analyses in the following journal publication:

Villaverde T, González-Moreno P, Rodríguez-Sánchez F & Escudero M. (2017) Niche shifts after long-distance dispersal events in bipolar sedges (*Carex*, Cyperaceae). *American Journal of Botany*, in press.

Compendium DOI: 10.5281/zenodo.896787

CITATION: Francisco Rodriguez-Sanchez (2017) Research compendium for "Niche shifts after long-distance dispersal events in bipolar sedges (Carex, Cyperaceae)" (Version 0.1.0). Zenodo. <http://doi.org/10.5281/zenodo.896787>

Installation
------------

In order to run the analyses you will need to install the package first:

``` r
devtools::install_github("Pakillo/Carex.bipolar")
```

Usage
-----

There is a [`makefile.R`](https://github.com/Pakillo/Carex.bipolar/blob/master/makefile.R) that runs each analysis in the appropriate order. Note these analyses use many GIS layers stored locally. To be able to reproduce the analyses you will then need to download those files and adapt the code to your local path.

A more user-friendly version of the functions and analyses can be browsed at <https://pakillo.github.io/Carex.bipolar/index.html>.
