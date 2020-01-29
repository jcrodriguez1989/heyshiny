#' @importFrom miniUI miniPage gadgetTitleBar miniContentPanel
#' @importFrom rstudioapi insertText
#' @importFrom shiny verbatimTextOutput renderText observeEvent stopApp runGadget
#'
audio_writer <- function() {
  ann_js <- paste(
    "var initAnnyang = function() {",
    "  if (annyang) {",
    "    var commands = {",
    '      "type *msg": function(msg) {',
    '        Shiny.setInputValue("type", msg, {priority: "event"});',
    "      }",
    "    };",
    '    annyang.setLanguage("en");',
    "    annyang.addCommands(commands);",
    "    annyang.start();",
    "  }",
    "};",
    "",
    "$(function() {",
    "  setTimeout(initAnnyang, 10);",
    "});",
    sep = "\n"
  )

  ui <- miniPage(
    heyshiny::useHeyshiny(),
    tags$script(ann_js),
    gadgetTitleBar("Audio writer", left = NULL),
    miniContentPanel(
      heyshiny::speechInput(inputId = "type", "type *msg"),
      verbatimTextOutput("foo")
    )
  )
  server <- function(input, output, session) {
    output$foo <- renderText(input$type)
    # stop the app when 'Done' button clicked
    observeEvent(input$done, {
      stopApp()
    })
  }

  runGadget(ui, server)
}
