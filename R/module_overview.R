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
    title = title,
    bslib::nav(
      "Week",
      bslib::card_body_fill(
        materialSwitch(
          inputId = ns("cumulative"),
          label = "Cumulative",
          right = TRUE
        ),

        plotOutput(ns("week"))
      ),
      bslib::card_footer(
        htmlOutput(ns("latest_data")),
      )
    ),
    bslib::nav(
      "Month"
    ),
    bslib::nav(
      "Year"
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

      # your code here
      data_for_plots <- prepare_data_for_weekly_plot(data, lubridate::today())
      data_ref <- data_for_plots[["data_ref"]]
      data_current <- data_for_plots[["data_current"]]

      output$latest_data <- renderText({
        latest_date <- format(lubridate::as_date(max(data_current$timestamp)),
                              format = "%d %b %Y")
        glue::glue("Latest data from {latest_date}")
      })

      output$week <- renderPlot({
        if (input$cumulative) {
          plot_week_cumulative(data_ref, data_current)
        } else {
          plot_week_reference(data_ref, data_current)
        }
      }) %>%
        bindCache(input$cumulative, data_ref, data_current) %>%
        bindEvent(input$cumulative)
    }
  )
}

# UI
# overviewUI('id')

# server
# overview_server('id')
