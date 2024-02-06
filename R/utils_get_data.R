#' get_winti_data_up_to_date
#'
#' @description function to download and pre-process the latest csv file for
#' Winterthur
#'
#' @return wi_current tibble
#' @keywords internal
get_winti_data_up_to_date <- function() {

  # read latest csv for Winterthur
  wi_current <- data.table::fread("https://www.web.statistik.zh.ch/ogd/daten/ressourcen/KTZH_00001863_00003562.csv") %>%
    janitor::clean_names() %>%
    dplyr::mutate(timestamp = zeitpunkt,
                  gross_energy_kwh = bruttolastgang_kwh) %>%
    dplyr::select(timestamp, gross_energy_kwh)
}

#' get_zh_data_up_to_date
#'
#' @description function to download and pre-process the latest csv file for
#' Zurich
#'
#' @return zh_current tibble
#' @keywords internal
get_zh_data_up_to_date <- function() {

  # read latest csv for Zurich
  zh_current <- data.table::fread("https://data.stadt-zuerich.ch/dataset/ewz_bruttolastgang_stadt_zuerich/download/2024_ewz_bruttolastgang.csv") %>%
    janitor::clean_names() %>%
    dplyr::mutate(timestamp = zeitpunkt,
                  gross_energy_kwh = bruttolastgang) %>%
    dplyr::select(timestamp, gross_energy_kwh, status)

}

#' get_bs_data
#'
#' @description function to download the entire bs data as one csv (takes a while)
#'
#' @return bs tibble
#' @keywords internal
get_bs_data <- function() {
  bs_file <- "https://data.bs.ch/api/v2/catalog/datasets/100233/exports/csv"

  data.table::fread(bs_file) %>%
    janitor::clean_names() %>%
    dplyr::mutate(timestamp = timestamp_interval_start,
                  gross_energy_kwh = stromverbrauch_kwh) %>%
    dplyr::select(timestamp, gross_energy_kwh, grundversorgte_kunden_kwh, freie_kunden_kwh)
}

#' get_csv_from_link
#'
#' @description function to read a csv function from a file/link
#'
#' @param my_url Parameter specifying the csv file's url.
#'
#' @return returns the data from the csv as a tibble
#'
#' @keywords internal
get_csv_from_link <- function(my_url){
  data <- data.table::fread(my_url) %>%
    janitor::clean_names()
}
