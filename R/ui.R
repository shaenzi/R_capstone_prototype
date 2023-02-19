ggplot2::theme_set(ggplot2::theme_gray(base_size = 16))
thematic::thematic_shiny()
bs_theme_name <- "darkly"
bs_theme_used <- bslib::bs_theme(bootswatch = bs_theme_name)
bs_vars <- c("primary", "secondary", "success", "info", "warning", "danger",
             "light", "dark")
bs_colors <- bslib::bs_get_variables(bs_theme_used, bs_vars)
print(bs_colors)

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
    theme = bs_theme_used, # darkly (round)/ superhero(corners) / morph / slate / cyborg
    header = list(assets()),
    title = "Energy use in Swiss cities",
    id = "main-menu",
    tabPanel(
      "Latest use",
      shiny::h1("Recent energy use compared to the last 4 years"),
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
      p("In Zurich, the energy use data is also available split according to the supply voltage.
			  The lower voltage group are the households and small businesses; larger industrial
			  users, of which there are fewer, are supplied with a higher voltage. To keep the plots simple,
			  the first group is referred to as the households (though bear in mind that it includes more
			  than just households), and the second group as industry."),
      zh_detailsUI('zh_details')
    ),
    tabPanel(
      "Energy, power etc.",
      includeMarkdown(system.file("app/www/energy_etc.md", package = "capstonePrototype"))
    ),
    tabPanel(
      "Forecast",
      shiny::h1("Seasonal decomposition and forecast"),
      tagList(
        span("The data on energy usage can be decomposed into different temporal components:
		    a trend, seasonal components for variations within each year, week, day and hour, and
		    a remainder. This can then be used to forecast the energy usage in the future.
		    However, note that this is a very simple model which does not take into account
		    major factors known to affect energy usage such as the weather. For more sophisticated
		    predictions check out these links for "),
        a(
          "Zurich",
          href = "https://www.ewz.ch/de/ueber-ewz/newsroom/aus-aktuellem-anlass/strommangellage/energieverbrauch-stadt-zuerich.html",
          target = "_blank"),
        span(" and "),
        a(
          "Basel",
          href = "https://www.statistik.bs.ch/aktuell/stromverbrauch.html",
          target = "_blank"
        ),
        span(".")),
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
      shiny::h1("What does the energy use over the last years look like?"),
      p("The energy consumption time series is a rich data source. Can you spot
		  the seasonal changes with lower energy usage in summer? The lower energy use on the weekends
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
