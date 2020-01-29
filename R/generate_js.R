# Function that generates the heyshiny.js JavaScript file
#
generate_js <- function() {
  dir.create("www/", showWarnings = FALSE)
  out_file <- paste0("www/heyshiny.js")
  cat(
    file = out_file,
    paste(
      "var initAnnyang = function() {",
      "  if (annyang) {",
      "    var commands = {",
      generate_inputs_command(elems$inputs),
      "    };",
      paste0('    annyang.setLanguage("', elems$language, '");'),
      "    annyang.addCommands(commands);",
      "    annyang.start();",
      "  }",
      "};",
      "",
      "$(function() {",
      # I dont know if 10*inputs has sense, but solves an issue
      paste0("  setTimeout(initAnnyang, ", 10 * length(elems$inputs), ");"),
      "});",
      "",
      sep = "\n"
    )
  )
}

generate_inputs_command <- function(inputs) {
  paste(lapply(inputs, generate_input_command), collapse = ",\n")
}

generate_input_command <- function(input) {
  paste(
    paste0(
      '      "',
      input$command,
      '": function(',
      (if (input$has_variable) "msg" else ""),
      ") {"
    ),
    paste0(
      '        Shiny.setInputValue("',
      input$id,
      '", ',
      (if (input$has_variable) "msg" else "Math.random()"),
      ', {priority: "event"}',
      ");"
    ),
    "      }",
    sep = "\n"
  )
}
