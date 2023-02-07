get_winti_data_up_to_date <- function() {

  # read latest csv for Winterthur
  wi_current <- data.table::fread("https://www.web.statistik.zh.ch/ogd/daten/ressourcen/KTZH_00001863_00003562.csv") %>%
    janitor::clean_names() %>%
    dplyr::mutate(timestamp = zeitpunkt,
                  gross_energy_kwh = bruttolastgang_kwh) %>%
    dplyr::select(timestamp, gross_energy_kwh) %>%
    # pre-process
    deal_with_ts_utc() %>%
    add_date_components()
}

get_zh_data_up_to_date <- function() {

  # read latest csv for Zurich
  zh_current <- data.table::fread("https://data.stadt-zuerich.ch/dataset/ewz_bruttolastgang_stadt_zuerich/download/2023_ewz_bruttolastgang.csv") %>%
    janitor::clean_names() %>%
    dplyr::mutate(timestamp = zeitpunkt,
                  gross_energy_kwh = bruttolastgang) %>%
    dplyr::select(timestamp, gross_energy_kwh, status) %>%
    deal_with_ts_zh() %>%
    add_date_components()

}
