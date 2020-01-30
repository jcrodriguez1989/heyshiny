#' @importFrom beepr beep
#' @importFrom miniUI miniPage gadgetTitleBar miniContentPanel
#' @importFrom rstudioapi insertText
#' @importFrom shiny verbatimTextOutput renderText observeEvent stopApp runGadget
#'
audio_writer <- function(language = "en") {
  ui <- miniPage(
    heyshiny::useHeyshiny(language),
    gadgetTitleBar("Audio writer", left = NULL),
    miniContentPanel(
      h2("Voice commands, say:"),
      heyshiny::speechInput(
        inputId = "sound", "sound", "Sound - toggle sound"
      ),
      heyshiny::speechInput(
        inputId = "stop", "stop", "Stop - quit the app"
      ),
      heyshiny::speechInput(
        inputId = "new_file", "new (file)", "New file - open new file"
      ),
      heyshiny::speechInput(
        inputId = "next_line", "next (line)", "Next line - enter a new line"
      ),
      heyshiny::speechInput(
        inputId = "write", "write *msg", "Write 'code' - write the code"
      )
    )
  )

  process_text <- function(text) {
    message(text)
    text <- tolower(text)
    text <- gsub(" assignation ", " <- ", text)
    text <- gsub(" equal.* ", " = ", text)
    text <- gsub(" greater.* ", " > ", text)
    text <- sub(".*conditional (.*)", "if (\\1) {", text)
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
    observeEvent(
      {
        input$done
        input$stop
      },
      {
        sound_finnish(sound())
        stopApp()
      }
    )

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
