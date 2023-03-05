#' city_info UI
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
city_infoUI <- function(id){
  ns <- NS(id)

  # links Winterthur
  link_winti_ogd <- a(href = "https://www.web.statistik.zh.ch/ogd/datenkatalog/standalone/?keywords=ogd",
                      "the OGD portal of the canton of Zurich",
                      target = "_blank")
  link_winti_wiki <- a(href = "https://en.wikipedia.org/wiki/Winterthur",
                       "Wikipedia article on Winterthur",
                       target = "_blank")

  # links Zurich
  link_zh_ogd <- a(href = "https://data.stadt-zuerich.ch/",
                   "its OGD portal.", target = "_blank")
  link_zh_wiki <- a(href = "https://en.wikipedia.org/wiki/Z%C3%BCrich",
                    "Wikipedia article on Zurich",
                    target = "_blank")

  # Basel links
  link_bs_ogd <- a(href = "https://data.bs.ch/pages/home/",
                   "its OGD portal",
                   target = "_blank")
  link_bs_wiki <- a(href = "https://en.wikipedia.org/wiki/Basel",
                    "Wikipedia article on Zurich",
                    target = "_blank")

  card1 <- bslib::card(
    bslib::card_header("Zurich"),
    bslib::card_body(
      HTML(paste0(
        "Zurich is Switzerlands largest city with ",
        tags$b("XXX inhabitants "),
        "at the end of 2022. You can find some more general information about it in the ",
        link_zh_wiki,
        " and more data in ",
        link_zh_ogd
      ))
    ))
  card2 <- bslib::card(
    bslib::card_header("Winterthur"),
    bslib::card_body(
      HTML(paste0(
        "Winterthr is the second large city in the canton of Zurich, and with ",
        tags$b("XXX inhabitants "),
        "at the end of 2022, Switzerland's sixth-largest city overall. It has a strong industrial heritage (think Sulzer and Rieter) . You can find some more general information about it in the ",
        link_winti_wiki,
        " and more data in ",
        link_winti_ogd,
        " (search for Winterthur)."
      ))
    ))
  card3 <- bslib::card(
    bslib::card_header("Basel"),
    bslib::card_body(
      HTML(paste0(
        "Basel is Switzerlands x-largest city with ",
        tags$b("XXX inhabitants "),
        "at the end of 2022. It is known for its strong pharmaceutical industry (Roche, Novartis). You can find some more general information about it in the ",
        link_bs_wiki,
        " and more data in ",
        link_bs_ogd
      ))
    ))

  fluidPage(
    h3("Some information about the cities presented here"),
    p(paste0(
      "If you are not local, you probably will not know the three cities - which have onlny been chosen on the basis of their data being available.",
      "The map provides some orientation of where the cities are located within Switzerland, and the cards below give you a ",
      "very minimal impression and further links."
    )),

    plotOutput(ns("map")) %>%
      shinycssloaders::withSpinner(),

    bslib::layout_column_wrap(
      width = "200px", height = 300,
      card1, card2, card3
    )
  )
}

#' city_info Server
#'
#' @param id Unique id for module instance.
#'
#' @keywords internal
city_info_server <- function(id, cantons, cities, bs_colors){
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
      output$map <- renderPlot({
        plot_cities(cantons, cities, bs_colors)
      })
    }
  )
}

# UI
# city_infoUI('id')

# server
# city_info_server('id')
