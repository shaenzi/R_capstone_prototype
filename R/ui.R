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
	navbarPage(
		theme = bs_theme(version = 5),
		header = list(assets()),
		title = "capstonePrototype",
		id = "main-menu",
		tabPanel(
			"First tab",
			shiny::h1("First tab"),
			verbatimTextOutput("wi"),
			verbatimTextOutput("zh")
		),
		tabPanel(
			"Second tab",
			shiny::h1("Second tab")
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
