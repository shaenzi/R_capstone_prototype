#' dataviz UI
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
datavizUI <- function(id){
	ns <- NS(id)

	tagList(
		h2("dataviz")
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
		}
	)
}

# UI
# datavizUI('id')

# server
# dataviz_server('id')
