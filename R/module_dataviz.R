#' dataviz UI
#'
#' @description UI of the dataviz module,
#' once for each city
#'
#' @param id Unique id for module instance.
#' @param choices_years vector of possible years to be chosen from the data
#'
#' @keywords internal
datavizUI <- function(id, choices_years){
  ns <- NS(id)

  bslib::navset_card_tab(
    height = 550, full_screen = TRUE,
    bslib::nav_panel(
      "Changes over the years",
      bslib::card_body(
        shinyWidgets::radioGroupButtons(
          inputId = ns("time_select"),
          choices = c("Daily", "Weekly", "Monthly"),
          status = "primary",
          #justified = TRUE
        ),
        plotOutput(ns("lineplot")) |>
          shinycssloaders::withSpinner()
      ),
      # bslib::card_footer(
      #   htmlOutput(ns("latest_data_week")),
      # )
    ),
    bslib::nav_panel(
      "Detailed yearly heatmap",
      bslib::card_body(
        shinyWidgets::radioGroupButtons(
          inputId = ns("year_select"),
          choices = choices_years,
          selected = max(choices_years),
          status = "primary",
          #justified = TRUE
        ),
        plotOutput(ns("heatmap")) |>
          shinycssloaders::withSpinner(),
        p("How to read this chart: One line represents a day, with the darkness of the
          colour indicating how much power was used at that time of day. The days are
          then stacked on top of each other so that one plot represents an entire year,
          from top to bottom.")
      ),
    ),
  )
}

#' dataviz Server
#'
#' @description server of the dataviz module
#'
#' @param id Unique id for module instance.
#' @param data wi/bs/zh tibble
#'
#' @keywords internal
dataviz_server <- function(id, data){
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

      output$lineplot <- renderPlot({
        if (input$time_select == "Daily") {
          plot_daily_per_year(data)
        } else if (input$time_select == "Weekly") {
          plot_weekly_per_year(data)
        } else if (input$time_select == "Monthly") {
          plot_monthly_per_year(data)

      }

      }) |>
        bindCache(data, input$time_select, Sys.Date()) |>
        bindEvent(input$time_select)


      output$heatmap <- renderPlot({
        data |>
          dplyr::filter(year == input$year_select) |>
          heatmap_tod_date()
      }) |>
        bindCache(data, input$year_select, Sys.Date()) |>
        bindEvent(input$year_select)
    }
  )
}

# UI
# datavizUI('id')

# server
# dataviz_server('id')
