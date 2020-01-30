heyshiny - Speech to Shiny Text Input
================

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

Add Speech Recognition to your Shiny app\! The `heyshiny` package
provides a new Shiny input, the `speechInput()`. This new input allows
your Shiny app to listen to the microphone, recognize the speech, and
return it as text.

So, make you Shiny app voice-interactive with `heyshiny`\!

`heyshiny` is possible thanks to the
[annyang](https://www.talater.com/annyang/) javascript library.

## Installation

`heyshiny` is currently only available as a GitHub package.

To install it run the following from an R console:

``` r
if (!require("remotes")) {
  install.packages("remotes")
}
remotes::install_github("jcrodriguez1989/heyshiny", dependencies = TRUE)
```

## Important\!

annyang, and thus `heyshiny`, depends on that the used browser supports
speech recognition. The RStudio viewer pane does not support `heyshiny`,
so addins created with `heyshiny` should be opened in a new window
(which opens a supported browser).

`heyshiny` works nicely with Google Chrome.

## Example

``` r
library("shiny")
library("heyshiny")

ui <- fluidPage(
  useHeyshiny(language = "en-US"), # configure the heyshiny package
  titlePanel("Hey Shiny!"),
  speechInput(inputId = "hey_cmd", command = "hey *msg"), # set the input
  verbatimTextOutput("shiny_response")
)

server <- function(input, output, session) {
   # read the speech input
  observeEvent(input$hey_cmd, {
    speech <- input$hey_cmd
    message(speech)
    res <- "Sorry, I don't know how to help with that yet"
    if (grepl("^random number", tolower(speech))) {
      res <- paste0("Here is your random number: ", round(runif(1, 0, 8818)))
    } else if (grepl("^repeat", tolower(speech))) {
      res <- sub("repeat ", "", speech)
    }
    output$shiny_response <- renderText(res)
  })
}

shinyApp(ui, server)
```
