#' city_info UI
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
city_infoUI <- function(id){
	ns <- NS(id)

	card1 <- bslib::card(
	  bslib::card_header("Scrolling content"),
	  bslib::card_body("lorem_ipsum_dolor_sit_amet, ", fill = TRUE)
	)
	card2 <- bslib::card(
	  bslib::card_header("Nothing much here"),
	  "This is it."
	)
	card3 <- bslib::card(
	  full_screen = TRUE,
	  bslib::card_header("Filling content"),
	  bslib::card_body_fill(
	    class = "p-0",
	    shiny::plotOutput("p")
	  )
	)

	bslib::layout_column_wrap(
	  width = "200px", height = 300,
	  card1, card2, card3
	)
}

#' city_info Server
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
city_info_server <- function(id){
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
# city_infoUI('id')

# server
# city_info_server('id')
