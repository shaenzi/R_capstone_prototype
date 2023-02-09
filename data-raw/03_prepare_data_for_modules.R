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
