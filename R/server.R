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

	overview_server('zh', zh_weekly, zh_monthly, zh_yearly, zh_yearly_cum)

	overview_server('wi', wi_weekly, wi_monthly, wi_yearly, wi_yearly_cum)

	overview_server('bs', bs_weekly, bs_monthly, bs_yearly, bs_yearly_cum)

	predictions_server("zh", zh_next_2, zh_prev_2, zh)

	predictions_server("wi", wi_next_2, wi_prev_2, wi)

	predictions_server("bs", bs_next_2, bs_prev_2, bs)

	dataviz_server('zh', zh)

	dataviz_server('wi', wi)

	dataviz_server('bs', bs)

}
