#' get_csv_from_link
#'
#' @description function to read a csv function from a file/link
#'
#' @param my_url Parameter specifying the csv file's url.
#'
#' @return returns the data from the csv as a tibble
#'
#' @noRd
get_csv_from_link <- function(my_url){
  data <- data.table::fread(my_url) %>%
    janitor::clean_names()
}


get_winti_data_to_2021 <- function() {
  winti_files <- c(
    "https://www.web.statistik.zh.ch/ogd/daten/ressourcen/KTZH_00001863_00003561.csv", #2013-2015
    "https://www.web.statistik.zh.ch/ogd/daten/ressourcen/KTZH_00001863_00003563.csv", # 2016-2018
    "https://www.web.statistik.zh.ch/ogd/daten/ressourcen/KTZH_00001863_00003564.csv" # 2019-2021
  )

  purrr::map_df(winti_files, get_csv_from_link) %>%
    dplyr::mutate(timestamp = zeitpunkt,
           gross_energy_kwh = bruttolastgang_kwh) %>%
    dplyr::select(timestamp, gross_energy_kwh)
}

get_zh_data_to_2022 <- function() {
  zh_files <- c(
    "https://data.stadt-zuerich.ch/dataset/ewz_bruttolastgang_stadt_zuerich/download/2019_ewz_bruttolastgang.csv",
    "https://data.stadt-zuerich.ch/dataset/ewz_bruttolastgang_stadt_zuerich/download/2020_ewz_bruttolastgang.csv",
    "https://data.stadt-zuerich.ch/dataset/ewz_bruttolastgang_stadt_zuerich/download/2021_ewz_bruttolastgang.csv",
    "https://data.stadt-zuerich.ch/dataset/ewz_bruttolastgang_stadt_zuerich/download/2022_ewz_bruttolastgang.csv"
  )

  purrr::map_df(zh_files, get_csv_from_link) %>%
    dplyr::mutate(timestamp = zeitpunkt,
           gross_energy_kwh = bruttolastgang) %>%
    dplyr::select(timestamp, gross_energy_kwh, status)

}

wi_old <- get_winti_data_to_2021() %>%
  deal_with_ts_utc() %>%
  add_date_components()

zh_old <- get_zh_data_to_2022() %>%
  deal_with_ts_zh() %>%
  get_clean_data() %>%
  add_date_components()

usethis::use_data(wi_old, zh_old, overwrite = TRUE)
