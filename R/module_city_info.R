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
                    "Wikipedia article on Basel",
                    target = "_blank")

  card_zh <- bslib::card(
    bslib::card_header(HTML("<div style='color:#3498db';>Zurich</div>")),
    bslib::card_body(
      div(class = "p-3 text-center",
          img(src='img/zh_hell.png', align = "center", width = "20%", height = "20%")
      ),
      HTML(paste0(
        "Zurich is Switzerland's largest city with ",
        tags$b("443'037 inhabitants "),
        "at the end of 2022. It is known for its  finance and insurance industries, and hosts well-known universities. You can find some more general information about it in the ",
        link_zh_wiki,
        " and more data in ",
        link_zh_ogd
      )),
      div(class = "p-3 text-center",
          img(src='img/zurich1.png', align = "center", width = "70%", height = "70%")
      )
    ))

  card_wi <- bslib::card(
    bslib::card_header(HTML("<div style='color:#00bc8c';>Winterthur</div>")),
    bslib::card_body(
      div(class = "p-3 text-center",
          img(src='img/winterthur.png', align = "center", width = "20%", height = "20%")
      ),
      HTML(paste0(
        "Winterthur is the second large city in the canton of Zurich, and with ",
        tags$b("120'222 inhabitants "),
        "at the end of 2022, Switzerland's sixth-largest city overall. It has a strong industrial heritage (e.g. Sulzer and Rieter) . You can find some more general information about it in the ",
        link_winti_wiki,
        " and more data in ",
        link_winti_ogd,
        " (search for Winterthur)."
      )),
      div(class = "p-3 text-center",
          img(src='img/winti1.png', align = "center", width = "70%", height = "70%")
      )
    ))

  card_bs <- bslib::card(
    bslib::card_header(HTML("<div style='color:#e74c3c';>Basel</div>")),
    bslib::card_body(
      div(class = "p-3 text-center",
          img(src='img/basel.png', align = "center", width = "20%", height = "20%")
      ),
      HTML(paste0(

        "Basel is Switzerland's third-largest city, but as we're looking at the energy use from the canton of Basel-Stadt, which also includes Riehen and Bettingen, we look at their total number of inhabitants, which is ",
        tags$b("204'550 inhabitants "),
        "at the end of 2022. It is known for its strong pharmaceutical industry (Roche, Novartis). You can find some more general information about it in the ",
        link_bs_wiki,
        " and more data in ",
        link_bs_ogd
      )),
      div(class = "p-3 text-center",
          img(src='img/basel1.png', align = "center", width = "70%", height = "70%")
      )
    ))

  fluidPage(
    h3("Some information about the cities"),
    p(paste0(
      "If you are not local, you might not know the three cities presented here - which have only been chosen on the basis of their data being available. ",
      "The map provides some orientation of where the cities are located within Switzerland, and the cards below give you a minimal impression, further links ",
      "and a pseudocolored map."
    )),

    plotOutput(ns("map")) |> 
      shinycssloaders::withSpinner(),

    bslib::layout_column_wrap(
      width = "200px", height = 680,
      card_bs, card_zh, card_wi
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
