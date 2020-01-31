#' @importFrom beepr beep
#' @importFrom miniUI miniPage gadgetTitleBar miniContentPanel
#' @importFrom rstudioapi insertText
#' @import shiny
#'
audio_writer <- function(language = "en") {
  ui <- fluidPage(
    heyshiny::useHeyshiny("en"),
    titlePanel("Audio writer"),
    wellPanel(
      h2("Voice commands, say:"),
      heyshiny::speechInput(
        inputId = "sound", "sound", "Sound - toggle sound"
      ),
      heyshiny::speechInput(
        inputId = "stop", "stop", "Stop - quit the app"
      ),
      heyshiny::speechInput(
        inputId = "new_file", "create (file)", "Create file - open new file"
      ),
      heyshiny::speechInput(
        inputId = "next_line", "next (line)", "Next line - enter a new line"
      ),
      heyshiny::speechInput(
        inputId = "write", "write *msg", "Write 'code' - write the code"
      ),
      HTML(
        '&ensp; "t1 assignation t2" ~> "t1 <- t2" <br/>',
        '&ensp; "t1 equal t2" ~> "t1 = t2" <br/>',
        '&ensp; "t1 greater t2" ~> "t1 > t2" <br/>',
        '&ensp; "minus t" ~> "- t" <br/>',
        '&ensp; "conditional c" ~> "if (c) {" <br/>'
      )
    )
  )

  process_text <- function(text) {
    text <- tolower(text)
    text <- gsub(" assignation ", " <- ", text)
    text <- gsub(" equal.*? ", " = ", text)
    text <- gsub(" greater.*? ", " \\> ", text)
    text <- gsub(" minus ", " - ", text)
    text <- gsub(">( )+=", " >= ", text)
    text <- gsub("close.*? conditional", "}", text)
    text <- sub(".*?conditional (.*)", "if (\\1) {", text)
    text
  }

  server <- function(input, output, session) {
    # toggle if has to play a sound once each command ends
    sound <- reactiveVal(TRUE)
    sound_finnish <- function(do) {
      if (do) beep(1)
    }
    observeEvent(input$sound, {
      sound(!sound())
      sound_finnish(TRUE)
    })

    # stop the app when done
    observeEvent(input$stop, {
      sound_finnish(sound())
      stopHeyshiny()
      stopApp()
    })

    # open a new file
    observeEvent(input$new_file, {
      rstudioapi::documentNew("")
      sound_finnish(sound())
    })

    # enter code
    observeEvent(input$write, {
      rstudioapi::insertText(process_text(input$write))
      sound_finnish(sound())
    })

    # enter new line
    observeEvent(input$next_line, {
      rstudioapi::insertText("\n")
      sound_finnish(sound())
    })
  }

  shinyApp(ui, server)
}
