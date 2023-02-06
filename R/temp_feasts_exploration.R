library(fable)
library(feasts)
library(tsibble)
#
# wi_ts <- tsibble::as_tsibble(wi, index = "timestamp")
#
# dcmp_wi <- wi_ts %>%
#   fabletools::model(feasts::STL(gross_energy_kwh ~ season(window = NULL)))
#
# # next two weeks
# wi_forecast <- wi_ts %>%
#   fabletools::model(stl = fabletools::decomposition_model(
#     feasts::STL(gross_energy_kwh ~ season(window = NULL)),
#     fable::SNAIVE(season_adjust))) %>%
#   forecast(h = "2 weeks")
# wi_forecast %>%
#   ggplot2::autoplot() +
#   ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
#   ggplot2::labs(x = "",
#        title = "Next two weeks - prediction",
#        y = "power use per 15min (MWh)")
# # how to access/change the legend label? fill does not make a difference
#
# # last two weeks
# last_2_w_predicted <- wi_ts %>%
#   dplyr::filter(timestamp < (lubridate::as_date(max(wi_ts$timestamp)) - 13)) %>%
#   fabletools::model(stl = fabletools::decomposition_model(
#     feasts::STL(gross_energy_kwh ~ season(window = NULL)),
#     fable::SNAIVE(season_adjust))) %>%
#   forecast(h = "2 weeks")
#
# last_2_w_predicted %>%
#   ggplot2::autoplot() +
#   ggplot2::geom_line(data = wi_ts %>% dplyr::filter(timestamp > (lubridate::as_date(max(wi_ts$timestamp)) - 13)),
#             mapping = ggplot2::aes(x = timestamp, y = gross_energy_kwh),
#             color = "red") +
#   ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
#   ggplot2::labs(x = "",
#        title = "last two weeks predicted and actual",
#        y = "power use per 15min (MWh)")
