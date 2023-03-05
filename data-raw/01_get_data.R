
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

#geographic data
cantons <- sf::st_read(file.path("data-raw", "swissBOUNDARIES3D_1_4_TLM_KANTONSGEBIET.shp"))

city <- c("Zurich", "Winterthur", "Basel")
x <- c(2682217.000,  2696563.250, 2611414.500)
y <- c(1247945.250, 1261709.875, 1267104.125)
cities <- tibble::tibble(city, x, y)

usethis::use_data(cantons, cities, overwrite = TRUE)
