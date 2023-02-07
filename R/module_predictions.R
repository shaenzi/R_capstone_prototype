#' predictions UI
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
predictionsUI <- function(id){
	ns <- NS(id)

	bslib::navs_tab_card(
	  height = 550, full_screen = TRUE,
	  #title = title,
	  bslib::nav(
	    "Next two weeks",
	    bslib::card_body_fill(
	      plotOutput(ns("prediction"))
	    ),
	    # bslib::card_footer(
	    #   htmlOutput(ns("latest_data_week")),
	    # )
	  ),
	  bslib::nav(
	    "Previous two weeks",
	    bslib::card_body_fill(
	      plotOutput(ns("predicted_vs_actual"))
	    ),
	  ),
	)
}

#' predictions Server
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
predictions_server <- function(id, data){
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

				data_ts <- tsibble::as_tsibble(data, index = "timestamp")

				output$prediction <- renderPlot({
				  data_forecast <- predict_2_weeks(data_ts)
				  plot_prediction(data_forecast)
				}) %>%
				  bindCache(data_ts, Sys.Date())

				output$predicted_vs_actual <- renderPlot({
				  max_date <- lubridate::as_date(max(data_ts$timestamp)) - 13
				  data_predicted <- data_ts %>%
				    dplyr::filter(timestamp < max_date) %>%
				    predict_2_weeks()

				  plot_prediction_and_actual(
				    data_predicted,
				    data_ts %>%
				      dplyr::filter(timestamp > max_date)
				    )
				}) %>%
				  bindCache(data_ts, Sys.Date())
		}
	)
}

# UI
# predictionsUI('id')

# server
# predictions_server('id')
