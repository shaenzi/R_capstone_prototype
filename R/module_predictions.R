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
	      plotOutput(ns("week"))
	    ),
	    # bslib::card_footer(
	    #   htmlOutput(ns("latest_data_week")),
	    # )
	  ),
	  bslib::nav(
	    "Previous two weeks",
	    bslib::card_body_fill(
	      plotOutput(ns("month"))
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
		}
	)
}

# UI
# predictionsUI('id')

# server
# predictions_server('id')
