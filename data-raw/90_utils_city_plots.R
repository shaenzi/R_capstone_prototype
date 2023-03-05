get_osm_data <- function(bb){
  small_streets <- osmdata::opq(bb) %>%
    osmdata::add_osm_feature(
      key = "highway",
      value = c(
        "residential", "living_street",
        "unclassified",
        "service", "footway"
      )
    ) %>%
    osmdata::osmdata_sf() %>%
    purrr::pluck("osm_lines")

  # take some breaks as otherwise I don't get data back
  Sys.sleep(1.1)

  streets <-  osmdata::opq(bb) %>%
    osmdata::add_osm_feature(
      key = "highway",
      value = c(
        "motorway", "primary",
        "secondary", "tertiary"
      )
    ) %>%
    osmdata::osmdata_sf() %>%
    purrr::pluck("osm_lines")

  Sys.sleep(1.1)

  railway <- osmdata::opq(bb) %>%
    osmdata::add_osm_feature(
      key = "railway",
      value = c(
        "rail"
      )
    ) %>%
    osmdata::osmdata_sf() %>%
    purrr::pluck("osm_lines")

  Sys.sleep(1.1)

  metro <- osmdata::opq(bb) %>%
    osmdata::add_osm_feature(
      key = "railway",
      value = c(
        "subway"
      )
    ) %>%
    osmdata::osmdata_sf() %>%
    purrr::pluck("osm_lines")

  Sys.sleep(1.1)

  water <- osmdata::opq(bb) %>%
    osmdata::add_osm_feature(
      key = "natural",
      value = c("bay", "water", "strait")
    )%>%
    osmdata::osmdata_sf() %>%
    purrr::pluck("osm_multipolygons")

  output <- list("small_streets"=small_streets,
                 "streets" = streets,
                 "railway"= railway,
                 "metro"=metro,
                 "water"=water)

}

generic_plot <- function(data_osm, pal){
  p <- ggplot2::ggplot() +
    ggplot2::geom_sf(data = data_osm[["streets"]], color = pal[1], size = 1) +
    ggplot2::geom_sf(data = data_osm[["small_streets"]], color = pal[2], alpha = 0.6) +
    ggplot2::geom_sf(data = data_osm[["railway"]],  color = pal[3], size = 1) +
    ggplot2::geom_sf(data = data_osm[["metro"]], fill = pal[4], size = 0.6) +
    ggplot2::geom_sf(data = data_osm[["water"]], fill = pal[5], color = pal[5]) +
    ggplot2::coord_sf(
      expand = TRUE
    ) +
    ggplot2::theme_void() +
    ggplot2::theme(plot.background = ggplot2::element_rect(fill = pal[6],
                                                           color = pal[6]))

  p
}


plot_zurich <- function(zh_osm, pal){
  generic_plot(zh_osm, pal) +
    ggplot2::scale_x_continuous(limits = c(8.45, 8.63)) +
    ggplot2::scale_y_continuous(limits = c(47.32, 47.435))
}


plot_winterthur <- function(wi_osm, pal){
  generic_plot(wi_osm, pal) +
    ggplot2::scale_x_continuous(limits = c(8.65, 8.81)) +
    ggplot2::scale_y_continuous(limits = c(47.45, 47.55))
}

plot_basel <- function(bs_osm, pal){
  generic_plot(bs_osm, pal) +
    ggplot2::scale_x_continuous(limits = c(7.55, 7.64)) +
    ggplot2::scale_y_continuous(limits = c(47.518, 47.59))
}

