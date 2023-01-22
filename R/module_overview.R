#' overview UI
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
overviewUI <- function(id, title){
	ns <- NS(id)

	tagList(
		h2(title),
		plotOutput(ns("week"))
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

				output$week <- renderPlot({
				  plot_week_reference(data_ref, data_current)
				})
		}
	)
}

# UI
# overviewUI('id')

# server
# overview_server('id')
