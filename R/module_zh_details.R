#' zh_details UI
#' 
#' @param id Unique id for module instance.
#' 
#' @keywords internal
zh_detailsUI <- function(id){
	ns <- NS(id)

	tagList(
		h2("zh_details")
	)
}

#' zh_details Server
#' 
#' @param id Unique id for module instance.
#' 
#' @keywords internal
zh_details_server <- function(id){
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
# zh_detailsUI('id')

# server
# zh_details_server('id')
