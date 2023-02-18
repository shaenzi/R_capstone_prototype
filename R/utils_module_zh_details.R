prepare_zh_details_years <- function(zh_details){
  zh_details %>%
    dplyr::mutate(year = lubridate::year(timestamp)) %>%
    dplyr::filter(year < lubridate::year(lubridate::today())) %>%
    dplyr::group_by(year) %>%
    dplyr::summarise(ne5 = sum(value_ne5),
                     ne7 = sum(value_ne7)) %>%
    tidyr::pivot_longer(cols = c("ne5", "ne7"),
                        names_to = "category",
                        values_to = "value")
}

plot_zh_details_years <- function(zh_details_yearly) {
  zh_details_yearly %>%
    ggplot2::ggplot(ggplot2::aes(x = year, y = value, fill = category))+
    ggplot2::geom_area()+
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::scale_x_continuous(breaks = seq(2010, 2022, 3)) +
    ggplot2::scale_fill_discrete(labels = c("ne5" = "industry", "ne7" = "households")) +
    ggplot2::labs(y = "Total energy consumption per year [GWh]", x = "")
}

prepare_zh_details_last_week <- function(zh_details){
  latest_date <- max(lubridate::as_date(zh_details$timestamp))
  isoweek  <- lubridate::isoweek(latest_date - 7)
  zh_details %>%
    dplyr::select(-timestamp_utc) %>%
    dplyr::filter(lubridate::isoweek(timestamp) == isoweek,
           lubridate::isoyear(timestamp) == lubridate::isoyear(lubridate::today())) %>%
    dplyr::group_by(lubridate::wday(timestamp),
                    lubridate::hour(timestamp),
                    lubridate::minute(timestamp)) %>%
    dplyr::mutate(step_in_week = dplyr::cur_group_id()) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(step_in_week) %>%
    dplyr::mutate(cum_ne5 = cumsum(value_ne5),
                  cum_ne7 = cumsum(value_ne7)) %>%
    tidyr::pivot_longer(cols = c(value_ne5, value_ne7),
                        names_to = "category")
}

plot_zh_details_last_week <- function(zh_details_week){
  zh_details_week %>%
    dplyr::mutate(category = forcats::fct_rev(category)) %>%
    ggplot2::ggplot(ggplot2::aes(x = step_in_week, y = value, fill = category)) +
    ggplot2::geom_area() +
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.001)) +
    ggplot2::scale_x_continuous(breaks = seq(49,625,96),
                       labels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")) +
    ggplot2::scale_fill_discrete(labels = c("value_ne5" = "industry", "value_ne7" = "households etc.")) +
    ggplot2::labs(x = "",
         y = "Energy consumption [MWh]",
         title = paste0(
           "Week starting on ",
           format(lubridate::as_date(min(zh_details_week$timestamp)),
                  format = '%d %b %Y')))
}

prepare_zh_details_months <- function(zh_details){
  latest_date <- max(lubridate::as_date(zh_details$timestamp))
  last_year  <- lubridate::year(latest_date - 365)
  zh_details %>%
    dplyr::filter(lubridate::year(timestamp) == last_year) %>%
    dplyr::select(-timestamp_utc) %>%
    dplyr::mutate(date = lubridate::as_date(timestamp)) %>%
    dplyr::group_by(date) %>%
    dplyr::summarise(daily_ne5 = cumsum(value_ne5),
                     daily_ne7 = cumsum(value_ne7))  %>%
    dplyr::ungroup() %>%
    dplyr::mutate(year = lubridate::year(date),
                  month = lubridate::month(date)) %>%
    dplyr::group_by(year, month) %>%
    dplyr::summarise(monthly_avg_ne5 = mean(daily_ne5),
                     monthly_avg_ne7 = mean(daily_ne7))%>%
    tidyr::pivot_longer(cols = dplyr::starts_with("monthly"),
                        names_to = "category")
}

plot_zh_details_last_year <- function(zh_details_last_year) {
  year <- zh_details_last_year$year[[1]]
  zh_details_last_year  %>%
    ggplot2::ggplot(ggplot2::aes(x = month, y = value, fill = category)) +
    ggplot2::geom_area()+
    ggplot2::scale_y_continuous(labels = scales::label_number(scale = 0.000001)) +
    ggplot2::scale_x_continuous(breaks = seq(12)) +
    ggplot2::scale_fill_discrete(labels = c("monthly_avg_ne5" = "industry",
                                            "monthly_avg_ne7" = "households")) +
    ggplot2::labs(x = "month",
         y = "average daily energy consumption (GWh)",
         title = paste0("Zurich ", year))
}
