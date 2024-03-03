
bs_new <- get_data_one_year_bs(lubridate::year(lubridate::today())) |>
  deal_with_ts_utc() |>
  get_clean_data() |>
  add_date_components()

wi_new <- get_winti_data_up_to_date() |>
  deal_with_ts_utc() |>
  add_date_components()

zh_new <- get_zh_data_up_to_date() |>
  deal_with_ts_zh() |>
  get_clean_data() |>
  add_date_components()

zh_details <- data.table::fread("https://data.stadt-zuerich.ch/dataset/ewz_stromabgabe_netzebenen_stadt_zuerich/download/ewz_stromabgabe_netzebenen_stadt_zuerich.csv") |>
  janitor::clean_names() |>
  deal_with_ts_utc()

# combine updated and previous data

bs <- dplyr::bind_rows(bs_old, bs_new)
zh <- dplyr::bind_rows(zh_old, zh_new)
wi <- dplyr::bind_rows(wi_old, wi_new)

usethis::use_data(wi, zh, bs, zh_details, overwrite = TRUE)
