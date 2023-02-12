## overview panel/module data
#weekly
wi_weekly <- prepare_data_for_weekly_plot(wi, lubridate::today())
zh_weekly <- prepare_data_for_weekly_plot(zh, lubridate::today())
bs_weekly <- prepare_data_for_weekly_plot(bs, lubridate::today())
# monthly
wi_monthly <- prepare_data_for_monthly_plot(wi, lubridate::today())
zh_monthly <- prepare_data_for_monthly_plot(zh, lubridate::today())
bs_monthly <- prepare_data_for_monthly_plot(bs, lubridate::today())
# yearly
wi_yearly <- prepare_data_for_yearly_plot(wi, lubridate::today())
zh_yearly <- prepare_data_for_yearly_plot(zh, lubridate::today())
bs_yearly <- prepare_data_for_yearly_plot(bs, lubridate::today())
# yearly cumulative
wi_yearly_cum <- prepare_data_for_yearly_cumulative_plot(wi, lubridate::today())
zh_yearly_cum <- prepare_data_for_yearly_cumulative_plot(zh, lubridate::today())
bs_yearly_cum <- prepare_data_for_yearly_cumulative_plot(bs, lubridate::today())

usethis::use_data(wi_weekly, wi_monthly, wi_yearly, wi_yearly_cum, overwrite = TRUE)
usethis::use_data(zh_weekly, zh_monthly, zh_yearly, zh_yearly_cum, overwrite = TRUE)
usethis::use_data(bs_weekly, bs_monthly, bs_yearly, bs_yearly_cum, overwrite = TRUE)

# Forecast module
# wi
wi_ts <- tsibble::as_tsibble(wi, index = "timestamp")
wi_next_2 <- predict_2_weeks(wi_ts)
max_date <- lubridate::as_date(max(wi_ts$timestamp)) - 13
wi_prev_2 <- wi_ts %>%
  dplyr::filter(timestamp < max_date) %>%
  predict_2_weeks()
usethis::use_data(wi_next_2, wi_prev_2, overwrite = TRUE)

# zh
zh_ts <- tsibble::as_tsibble(zh, index = "timestamp")
zh_next_2 <- predict_2_weeks(zh_ts)
max_date <- lubridate::as_date(max(zh_ts$timestamp)) - 13
zh_prev_2 <- zh_ts %>%
  dplyr::filter(timestamp < max_date) %>%
  predict_2_weeks()
usethis::use_data(zh_next_2, zh_prev_2, overwrite = TRUE)

# bs
bs_ts <- tsibble::as_tsibble(bs, index = "timestamp")
bs_next_2 <- predict_2_weeks(zh_ts)
max_date <- lubridate::as_date(max(bs_ts$timestamp)) - 13
bs_prev_2 <- bs_ts %>%
  dplyr::filter(timestamp < max_date) %>%
  predict_2_weeks()
usethis::use_data(bs_next_2, bs_prev_2, overwrite = TRUE)
