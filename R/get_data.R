get_winti_data_up_to_date <- function() {

  # read latest csv for Winterthur
  wi_current <- data.table::fread("https://www.web.statistik.zh.ch/ogd/daten/ressourcen/KTZH_00001863_00003562.csv") %>%
    janitor::clean_names() %>%
    dplyr::mutate(timestamp = zeitpunkt,
                  gross_energy_kwh = bruttolastgang_kwh) %>%
    dplyr::select(timestamp, gross_energy_kwh)

  # Combine latest with previous data
  dplyr::bind_rows(wi, wi_current)
}

get_zh_data_up_to_date <- function() {

  # read latest csv for Zurich
  zh_current <- data.table::fread("https://data.stadt-zuerich.ch/dataset/ewz_bruttolastgang_stadt_zuerich/download/2023_ewz_bruttolastgang.csv") %>%
    janitor::clean_names() %>%
    dplyr::mutate(timestamp = zeitpunkt,
                  gross_energy_kwh = bruttolastgang) %>%
    dplyr::select(timestamp, gross_energy_kwh, status)

  # combine with previous data
  dplyr::bind_rows(zh, zh_current)

}
