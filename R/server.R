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

	wi <- get_winti_data_up_to_date() %>%
	  dplyr::bind_rows(wi)
	zh <- get_zh_data_up_to_date() %>%
	  dplyr::bind_rows(zh)

	overview_server('zh', zh)

	overview_server('wi', wi)

	predictions_server("zh", zh)

	predictions_server("wi", wi)


}
