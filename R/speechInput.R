#' Create a speech recognition input control
#'
#' Create an input control for entry of speech recognition text values.
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
#' @param label Display label, or NULL for no label.
#'
#' @export
#'
speechInput <- function(inputId, command = "hey shiny *message", label = NULL) {
  command <- trimws(command)
  tagList(
    tags$script(generate_input_js(inputId, command)),
    h3(label)
  )
}

generate_input_js <- function(id, command) {
  paste(
    paste0("var init", id, " = function() {"),
    "  if (annyang) {",
    "    var commands = {",
    generate_input_command(id, command),
    "    };",
    "    annyang.addCommands(commands);",
    "    annyang.start();",
    "  }",
    "};",
    "",
    "$(function() {",
    paste0("  setTimeout(init", id, ", 1);"),
    "});",
    sep = "\n"
  )
}

generate_input_command <- function(id, command) {
  has_variable <- grepl("( \\*)|( :)", command)
  paste(
    paste0(
      '      "',
      command,
      '": function(',
      (if (has_variable) "msg" else ""),
      ") {"
    ),
    paste0(
      '        Shiny.setInputValue("',
      id,
      '", ',
      (if (has_variable) "msg" else "Math.random()"),
      ', {priority: "event"}',
      ");"
    ),
    "      }",
    sep = "\n"
  )
}
