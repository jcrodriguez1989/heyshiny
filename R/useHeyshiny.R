#' Set up a Shiny app to use heyshiny
#'
#' This function must be called from a Shiny app's UI in order for all other
#' heyshiny functions to work. \cr\cr
#' You can call useHeyshiny() from anywhere inside the UI, as long as the final
#' app UI contains the result of useHeyshiny().
#'
#' @param language The language the user will speak in. Check posibilites at:
#'   https://github.com/TalAter/annyang/blob/master/docs/FAQ.md#what-languages-are-supported
#'
#' @importFrom shiny tags includeScript
#'
#' @export
#'
useHeyshiny <- function(language = "en") {
  elems$initialize()
  elems$language <- language
  tags$head(
    tags$script(
      src = "//cdnjs.cloudflare.com/ajax/libs/annyang/2.6.0/annyang.min.js"
    ),
    tags$script(src = "heyshiny.js")
  )
}
