#' get_winti_data_up_to_date
#'
#' @description function to download and pre-process the latest csv file for
#' Winterthur
#'
#' @return wi_current tibble
#' @keywords internal
get_winti_data_up_to_date <- function() {

  # read latest csv for Winterthur
  wi_current <- data.table::fread("https://www.web.statistik.zh.ch/ogd/daten/ressourcen/KTZH_00001863_00003562.csv") |>
    janitor::clean_names() |>
    dplyr::mutate(timestamp = zeitpunkt,
                  gross_energy_kwh = bruttolastgang_kwh) |>
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
  zh_current <- data.table::fread("https://data.stadt-zuerich.ch/dataset/ewz_bruttolastgang_stadt_zuerich/download/2024_ewz_bruttolastgang.csv") |>
    janitor::clean_names() |>
    dplyr::mutate(timestamp = zeitpunkt,
                  gross_energy_kwh = bruttolastgang) |>
    dplyr::select(timestamp, gross_energy_kwh, status)

}

#' get_data_one_year_bs
#'
#' @param year YYYY to get the data for
#'
#' @return tibble
#' @export
#'
get_data_one_year_bs <- function(year) {
  httr2::request("https://data.bs.ch/explore/dataset/100233/download/") |>
    httr2::req_url_query(
      "format" = "csv",
      #"use_labels_for_header" = "false",
      "refine.timestamp_interval_start" = year) |>
    httr2::req_perform() |>
    httr2::resp_body_string() |>
    data.table::fread() |>
    tibble::tibble() |>
    janitor::clean_names() |>
    dplyr::mutate(timestamp = timestamp_interval_start,
                  gross_energy_kwh = stromverbrauch_kwh) |>
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
  data <- data.table::fread(my_url) |>
    janitor::clean_names()
}
