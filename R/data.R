#' Winterthur power usage data
#'
#' Open government data with a power consumption data point every 15min for the city of Winterthur
#'
#' Downloaded and pre-processed with the scripts data-raw/01_get_data.R and data-raw/02_get_updated_data
#'
#' @format ## `wi`
#' A data frame, growing every day, the main two columns (all the others are derived):
#' \describe{
#'   \item{timestamp}{local time}
#'   \item{gross_energy_kwh}{gross energy ("Bruttolastgang") value in kWh for every 15min}
#' }
#'
#' @source <https://www.zh.ch/de/politik-staat/opendata.zhweb-noredirect.zhweb-cache.html?keywords=ogd#/datasets/1863@statistisches-amt-kanton-zuerich>
#'
"wi"

#' Zurich power usage data
#'
#'Open government data with a power consumption data point every 15min for the city of Zurich
#'
#'Downloaded and pre-processed with the scripts data-raw/01_get_data.R and data-raw/02_get_updated_data
#'
#' @format ## `zh`
#' A data frame, growing every day, the main two columns (all the others are derived):
#' \describe{
#'   \item{timestamp}{local time}
#'   \item{gross_energy_kwh}{gross energy ("Bruttolastgang") value in kWh for every 15min}
#' }
#'
#' @source <https://data.stadt-zuerich.ch/dataset/ewz_bruttolastgang_stadt_zuerich>
"zh"

#' Basel power usage data
#'
#'Open government data with a power consumption data point every 15min for the city of Zurich
#'
#'Downloaded and pre-processed with the script data-raw/02_get_updated_data
#'
#' @format ## `bs`
#' A data frame, growing every day, the main two columns (all the others are derived):
#' \describe{
#'   \item{timestamp}{local time}
#'   \item{gross_energy_kwh}{gross energy ("Bruttolastgang") value in kWh for every 15min}
#' }
#'
#' @source <https://data.bs.ch/explore/dataset/100233/information/?sort=timestamp_interval_start>
"bs"

#' Zurich power usage data split according to voltage supply level
#'
#'Open government data with a power consumption data point every 15min for the city of Zurich but
#'split according to voltage level ("Netzebene")
#'
#'Downloaded and pre-processed with the script data-raw/02_get_updated_data
#'
#' @format ## `zh_details`
#' A data frame, growing every day, the main three columns (all the others are derived):
#' \describe{
#'   \item{timestamp}{local time}
#'   \item{value_ne5}{energy consumption in Netzebene 5, industry and users with higher voltage level supply, in kWh}
#'   \item{value_ne7}{energy consumption in Netzebene 7, households and other users with low voltage supply level, in kWh}
#' }
#'
#' @source <https://data.stadt-zuerich.ch/dataset/ewz_stromabgabe_netzebenen_stadt_zuerich>
"zh_details"

###### all other data files ----------------------------------------
# all other data files are derived from these four starting points.
# Code for generating these derived data can be found in data-raw/03_prepare_data_for_modules.R
