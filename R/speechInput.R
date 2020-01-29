#' Create a speech recognition input control
#'
#' Create an input control for entry of speech recognition text values
#'
#' @param inputId	The input slot that will be used to access the value.
#' @param command The voice command that will activate the speechInput. The
#'   voice command must be exactly matched in order to send a value to the
#'   speechInput. To capture particular parts of the command, there are two
#'   symbols: "*" and ":". "*" captures any number of words, meanwhile ":"
#'   captures exactly one word. Moreover, to make words optional, they should be
#'   put between "(" and ")". \cr\cr
#'   For example:
#'   \itemize{
#'     \item "hello world" will trigger the input$inputId event, with no
#'           particular value, when it is said "hello world".
#'     \item "hello (my beatiful) world" will trigger the input$inputId event,
#'           with no particular value, when it is said "hello world" or "hello
#'           (my beatiful) world".
#'     \item "hello my *world" will trigger the input$inputId event, with all
#'           the words said after "hello my".
#'     \item "hello my :world" will trigger the input$inputId event, with the
#'           first word said after "hello my".
#'   }
#'
#' @export
#'
speechInput <- function(inputId, command = "hey shiny *message") {
  command <- trimws(command)
  elems$inputs <- append(
    elems$inputs,
    SpeechInput(
      id = inputId,
      command = command,
      has_variable = grepl("( \\*)|( :)", command)
    )
  )
  generate_js()
  invisible()
}

# Class that contains the information related to each speechInput
#
SpeechInput <- setRefClass(
  "SpeechInput",
  fields = list(
    id = "character",
    command = "character",
    has_variable = "logical"
  )
)
