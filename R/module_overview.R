#' overview UI
#'
#' @param id Unique id for module instance.
#'
#' @importFrom shinyWidgets materialSwitch
#' @importFrom shinycustomloader withLoader
#'
#' @keywords internal
overviewUI <- function(id, title){
  ns <- NS(id)


  bslib::navs_tab_card(
    height = 550, full_screen = TRUE,
    #title = title,
    bslib::nav(
      "Week",
      bslib::card_body_fill(
        materialSwitch(
          inputId = ns("cumulative_week"),
          label = "Cumulative",
          right = TRUE
        ),

        plotOutput(ns("week"))
      ),
      bslib::card_footer(
        htmlOutput(ns("latest_data_week")),
      )
    ),
    bslib::nav(
      "Month",
      bslib::card_body_fill(
        materialSwitch(
          inputId = ns("cumulative_month"),
          label = "Cumulative",
          right = TRUE
        ),

        plotOutput(ns("month"))
      ),
      bslib::card_footer(
        htmlOutput(ns("latest_data_month")),
      )
    ),
    bslib::nav(
      "Year",
      bslib::card_body_fill(
        materialSwitch(
          inputId = ns("cumulative_year"),
          label = "Cumulative",
          right = TRUE
        ),

        plotOutput(ns("year"))
      ),
      bslib::card_footer(
        htmlOutput(ns("latest_data_year")),
      )
    )
  )
}

#' overview Server
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
overview_server <- function(id, data){
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
      data_for_plots_week <- prepare_data_for_weekly_plot(data, lubridate::today())
      data_ref_week <- data_for_plots_week[["data_ref"]]
      data_current_week <- data_for_plots_week[["data_current"]]

      output$latest_data_week <- renderText({
        latest_date <- format(lubridate::as_date(max(data_current_week$timestamp)),
                              format = "%d %b %Y")
        glue::glue("Latest data from {latest_date}")
      })

      output$week <- renderPlot({

        if (input$cumulative_week) {
          plot_week_cumulative(data_ref_week, data_current_week)
        } else {
          plot_week_reference(data_ref_week, data_current_week)
        }
      }) %>%
        bindCache(input$cumulative_week, data_ref_week, data_current_week, Sys.Date()) %>%
        bindEvent(input$cumulative_week)

      # monthly stuff -------------------------------------------
      data_for_plots_month <- prepare_data_for_monthly_plot(
        data, lubridate::today())
      data_ref_month <- data_for_plots_month[["data_ref"]]
      data_current_month <- data_for_plots_month[["data_current"]]

      output$latest_data_month <- renderText({
        latest_date <- format(max(data_current_month$date),
                              format = "%d %b %Y")
        glue::glue("Latest data from {latest_date}")
      })

      output$month <- renderPlot({

        if (input$cumulative_month) {
          plot_month_cumulative(data_ref_month, data_current_month)
        } else {
          plot_month_reference(data_ref_month, data_current_month)
        }
      }) %>%
        bindCache(input$cumulative_month, data_ref_month, data_current_month, Sys.Date()) %>%
        bindEvent(input$cumulative_month)

      # yearly stuff -------------------------------------------------------
      data_for_plots_year <- prepare_data_for_yearly_plot(
        data, lubridate::today())
      data_ref_year <- data_for_plots_year[["data_ref"]]
      data_current_year <- data_for_plots_year[["data_current"]]

      output$latest_data_year <- renderText({
        latest_date <- format(max(data_current_year$date),
                              format = "%d %b %Y")
        glue::glue("Latest data from {latest_date}")
      })

      output$year <- renderPlot({

        if (input$cumulative_year) {
          plot_year_cumulative(data_ref_year, data_current_year)
        } else {
          plot_year_reference(data_ref_year, data_current_year)
        }
      }) %>%
        bindCache(input$cumulative_year, data_ref_year, data_current_year, Sys.Date()) %>%
        bindEvent(input$cumulative_year)
    }
  )
}

# UI
# overviewUI('id')

# server
# overview_server('id')
