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

	bslib::card(
	  height = 550, full_screen = TRUE,
	  bslib::card_header(title),
	  bslib::card_body_fill(
	    materialSwitch(
	      inputId = ns("cumulative"),
	      label = "Cumulative",
	      right = TRUE
	    ),

	    plotOutput(ns("week")) %>%
	      withLoader(
	        type="html",
	        loader= "loader9") #list(shinycustomloader::marquee("getting the latest data...")))
	  ),
	  bslib::card_footer(
	    htmlOutput(ns("latest_data")),
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
