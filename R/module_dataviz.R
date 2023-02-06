#' dataviz UI
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
datavizUI <- function(id){
  ns <- NS(id)

  bslib::navs_tab_card(
    height = 550, full_screen = TRUE,
    bslib::nav(
      "Changes over the years",
      bslib::card_body_fill(
        shinyWidgets::radioGroupButtons(
          inputId = ns("time_select"),
          choices = c("Daily", "Weekly", "Monthly"),
          status = "primary",
          #justified = TRUE
        ),
        plotOutput(ns("lineplot"))
      ),
      # bslib::card_footer(
      #   htmlOutput(ns("latest_data_week")),
      # )
    ),
    bslib::nav(
      "Detailed yearly heatmap",
      bslib::card_body_fill(
        plotOutput(ns("heatmap"))
      ),
    ),
  )
}

#' dataviz Server
#'
#' @param id Unique id for module instance.
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

      })

      output$heatmap <- renderPlot({

      })
    }
  )
}

# UI
# datavizUI('id')

# server
# dataviz_server('id')
