predict_2_weeks <- function(data) {
  data %>%
    fabletools::model(stl = fabletools::decomposition_model(
    feasts::STL(gross_energy_kwh ~ season(window = NULL)),
    fable::SNAIVE(season_adjust))) %>%
    forecast(h = "2 weeks")
}

plot_prediction <- function(data) {
  data %>%
    ggplot2::autoplot() +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
    ggplot2::labs(x = "",
                  title = "Next two weeks - prediction",
                  y = "power use per 15min (MWh)")
}

plot_prediction_and_actual <- function(data_predicted, data_actual) {
  data_predicted %>%
    ggplot2::autoplot() +
    ggplot2::geom_line(data = data_actual,
                       mapping = ggplot2::aes(x = timestamp, y = gross_energy_kwh),
                       color = "red") +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
    ggplot2::labs(x = "",
                  title = "last two weeks predicted and actual",
                  y = "power use per 15min (MWh)")
}
