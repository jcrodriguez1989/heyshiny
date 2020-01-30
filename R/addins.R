#' @importFrom miniUI miniPage gadgetTitleBar miniContentPanel
#' @importFrom rstudioapi insertText
#' @importFrom shiny verbatimTextOutput renderText observeEvent stopApp runGadget
#'
audio_writer <- function(language = "en") {
  ui <- miniPage(
    heyshiny::useHeyshiny(language),
    gadgetTitleBar("Audio writer", left = NULL),
    miniContentPanel(
      heyshiny::speechInput(inputId = "type", "type *msg"),
      verbatimTextOutput("read_command")
    )
  )
  server <- function(input, output, session) {
    observeEvent(input$type, {
      output$read_command <- renderText(input$type)
      insertText(input$type)
    })

    # stop the app when 'Done' button clicked
    observeEvent(input$done, {
      stopApp()
    })
  }

  runGadget(ui, server)
}
