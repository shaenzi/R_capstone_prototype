#' predictions UI
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
predictionsUI <- function(id){
	ns <- NS(id)

	tagList(
		h2("predictions")
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
