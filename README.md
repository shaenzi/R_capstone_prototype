
# Shiny app with latest energy use of Swiss cities

<!-- badges: start -->
<!-- badges: end -->

This app was programmed as a capstone project as part of the [EPFL extension school's](https://www.extensionschool.ch/) course on [data visualisation and communication](https://www.extensionschool.ch/learn/applied-data-science-communication-visualization).
The live version of the app can be found [here, hosted on shinyapps.io](https://shaenzi.shinyapps.io/energy).

## Data sources

The data comes from the [open data portal of the city of Zurich](https://data.stadt-zuerich.ch/dataset/ewz_bruttolastgang_stadt_zuerich) for data on the city of Zurich, from the [open data portal of the canton of Zurich](https://www.zh.ch/de/politik-staat/opendata.zhweb-noredirect.zhweb-cache.html?keywords=ogd#/datasets/1863@statistisches-amt-kanton-zuerich) the data of Winterthur, and from the [open data portal from the canton of Basel-Stadt](https://data.bs.ch/explore/dataset/100233/information/) for the data of Basel.

The split according to supply voltage comes from data from the [open data portal from the city of Zurich](https://data.stadt-zuerich.ch/dataset/ewz_stromabgabe_netzebenen_stadt_zuerich) as well. 

## Data updates

Of these four datasets, the Basel one is updated weekly and the other three are updated daily. Some corrections of previous values might still occur at later times though.

The latest data is downloaded every night at 4 am with [this github action](.github/workflows/update_data.yaml). It is also preprocessed, and saved as .rda files in the "data" subfolder.

Lesson learnt here to remember for my future self: the git push in the github action only works if in the repository's settings > actions > general, the workflows are given read and write permissions. Otherwise even a personal access token fails to push.

## Deployment

To make sure the latest data is available on the app as it can be accessed on shinyapps.io, a [second github action](.github/workflows/deploy_push.yaml) automatically re-deploys the app every night at 5 am.

## Local use / installation

Since the app has been developed as a regular R package, you could also install the package and run the app locally with

``` r
# install.packages("devtools")
devtools::install_github("shaenzi/R_capstone_prototype")
R_capstone_prototype::run()
```

