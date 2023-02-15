ggplot2::theme_set(ggplot2::theme_gray(base_size = 16))
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

	navbarPage(
		theme = bs_theme(bootswatch = "darkly"), # darkly (round)/ superhero(corners) / morph / slate / cyborg
		header = list(assets()),
		title = "Power use in Swiss cities",
		id = "main-menu",
		tabPanel(
			"Latest use",
			shiny::h1("Recent power use compared to the last 4 years"),
			shinyWidgets::radioGroupButtons(
			    inputId = "city_select_tab1",
			    choices = c("Zurich", "Winterthur", "Basel"),
			    status = "primary",
			    justified = TRUE
			  ),
			conditionalPanel(
			  condition = "input.city_select_tab1 == 'Zurich'",
			  overviewUI('zh')
			  ),
			conditionalPanel(
			  condition = "input.city_select_tab1 == 'Winterthur'",
			  overviewUI('wi')
			  ),
			conditionalPanel(
			  condition = "input.city_select_tab1 == 'Basel'",
			  overviewUI('bs')
			)
		),
		tabPanel(
			"Who uses how much",
			shiny::h1("Industry vs. household use in Zurich"),
			p("In Zurich, the power use data is also available split according to the supply voltage.
			  The lower voltage but larger group are the households and small businesses; larger industrial
			  users, of which there are fewer, are supplied with a higher voltage. To keep the plots simple,
			  the first group is referred to as the households (though bear in mind that it includes more
			  than just households), and the second group as industry."),
			zh_detailsUI('zh_details')
		),
		tabPanel(
		  "Power, electricity etc.",
		  p("work in progress")
		),
		tabPanel(
		  "Forecast",
		  shiny::h1("Seasonal decomposition and forecast"),
		  p("The data on electricity usage can be decomposed into different temporal components:
		    a trend, seasonal components for variations within each year, week, day and hour, and
		    a remainder. This can then be used to forecast the electricity usage in the future.
		    However, note that this is a very simple model which does not take into account
		    major factors known to affect electricity usage such as the weather."),
		  shinyWidgets::radioGroupButtons(
		    inputId = "city_select_tab2",
		    choices = c("Zurich", "Winterthur", "Basel"),
		    status = "primary",
		    justified = TRUE
		  ),
		  conditionalPanel(
		    condition = "input.city_select_tab2 == 'Zurich'",
		    predictionsUI('zh')
		  ),
		  conditionalPanel(
		    condition = "input.city_select_tab2 == 'Winterthur'",
		    predictionsUI('wi')
		  ),
		  conditionalPanel(
		    condition = "input.city_select_tab2 == 'Basel'",
		    predictionsUI('bs')
		  )
		),
		tabPanel(
		  "Data exploration",
		  shiny::h1("What does the power use over the last years look like?"),
		  p("The power consumption time series is a rich data source. Can you spot
		  the seasonal changes with lower power usage in summer? The lower power use on the weekends
		    and bank holidays? And even the hour for which no data exists due to the switch from
		    winter to summer time?"),
		  shinyWidgets::radioGroupButtons(
		    inputId = "city_select_tab3",
		    choices = c("Zurich", "Winterthur", "Basel"),
		    status = "primary",
		    justified = TRUE
		  ),
		  conditionalPanel(
		    condition = "input.city_select_tab3 == 'Zurich'",
		    datavizUI('zh')
		  ),
		  conditionalPanel(
		    condition = "input.city_select_tab3 == 'Winterthur'",
		    datavizUI('wi')
		  ),
		  conditionalPanel(
		    condition = "input.city_select_tab3 == 'Basel'",
		    datavizUI('bs')
		  )
		),
		tabPanel(
		  "About",
		  includeMarkdown(system.file("app/www/about.md", package = "capstonePrototype"))
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
