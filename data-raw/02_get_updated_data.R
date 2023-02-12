get_latest_winti_data <- function() {
  winti_files <- "https://www.web.statistik.zh.ch/ogd/daten/ressourcen/KTZH_00001863_00003562.csv" # 2022 onwards

  purrr::map_df(winti_files, get_csv_from_link) %>%
    dplyr::mutate(timestamp = zeitpunkt,
                  gross_energy_kwh = bruttolastgang_kwh) %>%
    dplyr::select(timestamp, gross_energy_kwh)
}

get_latest_zh_data <- function() {
  zh_files <-
    "https://data.stadt-zuerich.ch/dataset/ewz_bruttolastgang_stadt_zuerich/download/2023_ewz_bruttolastgang.csv"

  purrr::map_df(zh_files, get_csv_from_link) %>%
    dplyr::mutate(timestamp = zeitpunkt,
                  gross_energy_kwh = bruttolastgang) %>%
    dplyr::select(timestamp, gross_energy_kwh, status)

}

get_bs_data <- function() {
  bs_file <- "https://data.bs.ch/api/v2/catalog/datasets/100233/exports/csv"

  data.table::fread(bs_file) %>%
    janitor::clean_names() %>%
    dplyr::mutate(timestamp = timestamp_interval_start,
           gross_energy_kwh = stromverbrauch_kwh) %>%
    dplyr::select(timestamp, gross_energy_kwh, grundversorgte_kunden_kwh, freie_kunden_kwh)
}

bs <- get_bs_data() %>%
  deal_with_ts_utc() %>%
  get_clean_data() %>%
  add_date_components()

wi_new <- get_latest_winti_data() %>%
  deal_with_ts_utc() %>%
  add_date_components()

zh_new <- get_latest_zh_data() %>%
  deal_with_ts_zh() %>%
  get_clean_data() %>%
  add_date_components()

zh_details <- data.table::fread("https://data.stadt-zuerich.ch/dataset/ewz_stromabgabe_netzebenen_stadt_zuerich/download/ewz_stromabgabe_netzebenen_stadt_zuerich.csv") %>%
  janitor::clean_names() %>%
  deal_with_ts_utc()

# combine updated and previous data

zh <- dplyr::bind_rows(zh_old, zh_new)
wi <- dplyr::bind_rows(wi_old, wi_new)

usethis::use_data(wi, zh, bs, zh_details, overwrite = TRUE)
