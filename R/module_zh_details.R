#' zh_details UI
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
zh_detailsUI <- function(id){
  ns <- NS(id)

  bslib::navs_tab_card(
    height = 550, full_screen = TRUE,
    bslib::nav(
      "Last week",
      bslib::card_body_fill(
        plotOutput(ns("week")) %>%
          shinycssloaders::withSpinner()
      ),
    ),
    bslib::nav(
      "Last year",
      bslib::card_body_fill(
        plotOutput(ns("last_year")) %>%
          shinycssloaders::withSpinner()
      ),
    ),
    bslib::nav(
      "Over the years",
      bslib::card_body_fill(
        plotOutput(ns("years")) %>%
          shinycssloaders::withSpinner()
      )
    )
  )
}

#' zh_details Server
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
zh_details_server <- function(id, bs_colors){
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

      output$week <- renderPlot({
        plot_zh_details_last_week(zh_details_week, bs_colors)
      })

      output$last_year <- renderPlot({
        plot_zh_details_last_year(zh_details_last_year, bs_colors)
      })

      output$years <- renderPlot({
        plot_zh_details_years(zh_details_yearly, bs_colors)
      })
    }
  )
}

# UI
# zh_detailsUI('id')

# server
# zh_details_server('id')
