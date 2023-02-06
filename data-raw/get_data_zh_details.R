get_zh_details <- function() {
  zh_details <- data.table::fread("https://data.stadt-zuerich.ch/dataset/ewz_stromabgabe_netzebenen_stadt_zuerich/download/ewz_stromabgabe_netzebenen_stadt_zuerich.csv") %>%
    janitor::clean_names()
}

zh_details <- get_zh_details() %>%
  deal_with_ts_utc() %>%
  add_date_components()

usethis::use_data(zh_details, overwrite = TRUE)
