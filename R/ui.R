thematic::thematic_shiny()

#' Shiny UI
#'
#' Core UI of package.
#'
#' @param req The request object.
#'
#' @import shiny
#' @importFrom bslib bs_theme
#'
#' @keywords internal
ui <- function(req){
  shinybusy::html_dependency_epic()
  shinybusy::html_dependency_spinkit()
  shinybusy::html_dependency_shinybusy()
  shinybusy::add_busy_spinner(spin = "hollow-dots",
                              color = "#ff5733",
                              position = "full-page")

	navbarPage(
		theme = bs_theme(bootswatch = "darkly"), # darkly (round)/ superhero(corners) / morph / slate / cyborg
		header = list(assets()),
		title = "Power use in Swiss cities",
		id = "main-menu",
		tabPanel(
			"Latest use",
			shiny::h1("Power use over the last week"),
			overviewUI('zh', "Zurich"),
			overviewUI('wi', "Winterthur"),
		),
		tabPanel(
			"Who uses how much",
			shiny::h1("Industry vs. household use in Zurich")
		),
		tabPanel(
		  "Power, electricity etc."
		),
		tabPanel(
		  "Decomposition and forecast"
		),
		tabPanel(
		  "Cool dataviz",
		  shiny::h1("asdf")
		),
		tabPanel(
		  "About"
		)
	)
}

#' Assets
#'
#' Includes all assets.
#' This is a convenience function that wraps
#' [serveAssets] and allows easily adding additional
#' remote dependencies (e.g.: CDN) should there be any.
#'
#' @importFrom shiny tags
#'
#' @keywords internal
assets <- function(){
	list(
		serveAssets(), # base assets (assets.R)
		tags$head(
			# Place any additional depdendencies here
			# e.g.: CDN
		)
	)
}
