#' overview UI
#'
#' @description UI of the overview module, which is shown on the first tab,
#' once for each city
#'
#' @param id Unique id for module instance.
#'
#' @importFrom shinyWidgets materialSwitch
#'
#' @keywords internal
overviewUI <- function(id){
  ns <- NS(id)


  bslib::navset_card_tab(
    height = 550, full_screen = TRUE,
    bslib::nav_panel(
      "Week",
      bslib::card_body(
        materialSwitch(
          inputId = ns("cumulative_week"),
          label = "Cumulative",
          right = TRUE
        ),

        plotOutput(ns("week")) |>
          shinycssloaders::withSpinner()
      ),
      bslib::card_footer(
        htmlOutput(ns("latest_data_week")),
      )
    ),
    bslib::nav_panel(
      "Month",
      bslib::card_body(
        materialSwitch(
          inputId = ns("cumulative_month"),
          label = "Cumulative",
          right = TRUE
        ),

        plotOutput(ns("month")) |>
          shinycssloaders::withSpinner()
      ),
      bslib::card_footer(
        htmlOutput(ns("latest_data_month")),
      )
    ),
    bslib::nav_panel(
      "Year",
      bslib::card_body(
        materialSwitch(
          inputId = ns("cumulative_year"),
          label = "Cumulative",
          right = TRUE
        ),

        plotOutput(ns("year")) |>
          shinycssloaders::withSpinner()
      ),
      bslib::card_footer(
        htmlOutput(ns("latest_data_year")),
      )
    )
  )
}

#' overview Server
#'
#' @description server of the overview module, which is shown on the first tab,
#' once for each city
#'
#' @param id Unique id for module instance.
#' @param data_for_plots_week output from prepare_data_for_weekly_plot, list of two tibbles named data_ref and data_current
#' @param data_for_plots_month output from  repare_data_for_monthly_plot, list of two tibbles named data_ref and data_current
#' @param data_for_plots_year output from prepare_data_for_yearly_plot, list of two tibbles named data_ref and data_current
#' @param data_for_plots_year_cumulative output from  prepare_data_for_yearly_cumulative_plot, list of two tibbles named data_ref and data_current
#' @param bs_colors named hex color vector with "light", "secondary" and "success" colors
#'
#' @keywords internal
overview_server <- function(id,
                            data_for_plots_week,
                            data_for_plots_month,
                            data_for_plots_year,
                            data_for_plots_year_cumulative,
                            bs_colors){
  moduleServer(
    id,
    function(
    input,
    output,
    session
    ){

      ns <- session$ns
      send_message <- make_send_message(session)

      # weekly stuff ------------------------------------------
      #data_for_plots_week <- prepare_data_for_weekly_plot(data, lubridate::today())
      data_ref_week <- data_for_plots_week[["data_ref"]]
      data_current_week <- data_for_plots_week[["data_current"]]

      output$latest_data_week <- renderText({
        latest_date <- format(lubridate::as_date(max(data_current_week$timestamp)),
                              format = "%d %b %Y")
        glue::glue("Latest data from {latest_date}")
      })

      output$week <- renderPlot({

        if (input$cumulative_week) {
          plot_week_cumulative(data_ref_week, data_current_week, bs_colors)
        } else {
          plot_week_reference(data_ref_week, data_current_week, bs_colors)
        }
      }) |>
        bindCache(input$cumulative_week, data_ref_week, data_current_week, Sys.Date()) |>
        bindEvent(input$cumulative_week)

      # monthly stuff -------------------------------------------
      # data_for_plots_month <- prepare_data_for_monthly_plot(
      #   data, lubridate::today())
      data_ref_month <- data_for_plots_month[["data_ref"]]
      data_current_month <- data_for_plots_month[["data_current"]]

      output$latest_data_month <- renderText({
        latest_date <- format(max(data_current_month$date),
                              format = "%d %b %Y")
        glue::glue("Latest data from {latest_date}")
      })

      output$month <- renderPlot({

        if (input$cumulative_month) {
          plot_month_cumulative(data_ref_month, data_current_month, bs_colors)
        } else {
          plot_month_reference(data_ref_month, data_current_month, bs_colors)
        }
      }) |>
        bindCache(input$cumulative_month, data_ref_month, data_current_month, Sys.Date()) |>
        bindEvent(input$cumulative_month)

      # yearly stuff -------------------------------------------------------
      # data_for_plots_year <- prepare_data_for_yearly_plot(
      #   data, lubridate::today())
      data_ref_year <- data_for_plots_year[["data_ref"]]
      data_current_year <- data_for_plots_year[["data_current"]]

      # data_for_plots_year_cumulative <- prepare_data_for_yearly_cumulative_plot(
      #   data, lubridate::today())
      data_ref_year_cumulative <- data_for_plots_year_cumulative[["data_ref"]]
      data_current_year_cumulative <- data_for_plots_year_cumulative[["data_current"]]

      output$latest_data_year <- renderText({
        latest_date <- format(max(data_current_year$date),
                              format = "%d %b %Y")
        glue::glue("Latest data from {latest_date}")
      })

      output$year <- renderPlot({

        if (input$cumulative_year) {
          plot_year_cumulative(data_ref_year_cumulative,
                               data_current_year_cumulative,
                               bs_colors)
        } else {
          plot_year_reference(data_ref_year, data_current_year, bs_colors)
        }
      }) |>
        bindCache(input$cumulative_year, data_ref_year, data_current_year,
                  Sys.Date(), data_ref_year_cumulative, data_current_year_cumulative) |>
        bindEvent(input$cumulative_year)
    }
  )
}

# UI
# overviewUI('id')

# server
# overview_server('id')
