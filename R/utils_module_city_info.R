#' plot_cities
#'
#' @param cantons sf object with cantonal boundaries
#' @param cities small tibble with Winterthur, Zurich and Basel coordinates
#' @param bs_colors named hex color vector with "info", "danger" and "success" colors
#'
#' @return a ggplot object
#' @keywords interal
plot_cities <- function(cantons, cities, bs_colors) {
  cantons %>%
    ggplot2::ggplot() +
    ggplot2::geom_sf(fill = NA,
                     colour = "white", #this does not work?
                     alpha = 0.8) +
    ggplot2::geom_point(data = cities, ggplot2::aes(x = x, y = y, color = city),
                        size = 8) +
    ggplot2::scale_color_manual(values = c(bs_colors[["danger"]],
                                           bs_colors[["success"]],
                                           bs_colors[["info"]]),
                                ) +
    ggplot2::annotate(geom = "label",
                      x = cities %>% dplyr::filter(city == "Basel") %>% dplyr::pull(x),
                      y = cities %>% dplyr::filter(city == "Basel") %>% dplyr::pull(y) + 15000,
                      label = "Basel",
                      hjust = "center",
                      color = bs_colors[["danger"]],
                      fill = "#f0f0f0",
                      size = 10) +
    ggplot2::annotate(geom = "label",
                      x = cities %>% dplyr::filter(city == "Zurich") %>% dplyr::pull(x),
                      y = cities %>% dplyr::filter(city == "Zurich") %>% dplyr::pull(y) - 15000,
                      label = "Zurich",
                      hjust = "center",
                      color = bs_colors[["info"]],
                      fill = "#f0f0f0",
                      size = 10) +
    ggplot2::annotate(geom = "label",
                      x = cities %>% dplyr::filter(city == "Winterthur") %>% dplyr::pull(x),
                      y = cities %>% dplyr::filter(city == "Winterthur") %>% dplyr::pull(y) + 15000,
                      label = "Winterthur",
                      hjust = "center",
                      color = bs_colors[["success"]],
                      fill = "#f0f0f0",
                      size = 10) +
    ggplot2::guides(color = "none") +
    ggplot2::theme_void()
}
