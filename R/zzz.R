# Class and global object that contains all the inputs
#
#' @importFrom methods new
#'
Elems <- setRefClass(
  "Elems",
  fields = list(
    language = "character",
    inputs = "list"
  ),
  methods = list(
    initialize = function() {
      .self$language <- "en"
      .self$inputs <- list()
      .self
    }
  )
)
elems <- Elems$new()
