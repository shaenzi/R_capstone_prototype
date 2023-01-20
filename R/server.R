#' Server
#'
#' Core server function.
#'
#' @param input,output Input and output list objects
#' containing said registered inputs and outputs.
#' @param session Shiny session.
#'
#' @noRd
#' @keywords internal
server <- function(input, output, session){
	send_message <- make_send_message(session)

	wi <- get_winti_data_up_to_date()
	zh <- get_zh_data_up_to_date()

	output$wi <- renderPrint({tail(wi)})

	output$zh <- renderPrint({tail(zh)})


}
