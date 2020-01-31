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

## Frequently Asked Questions

For a FAQ with respect to the Speech Recognition tool, annyang, please
refer to its [FAQ
page](https://github.com/TalAter/annyang/blob/master/docs/FAQ.md), where
you can find:

  - [What languages are
    supported?](https://github.com/TalAter/annyang/blob/master/docs/FAQ.md#what-languages-are-supported)
  - [Why does the browser repeatedly ask for permission to use the
    microphone?](https://github.com/TalAter/annyang/blob/master/docs/FAQ.md#why-does-the-browser-repeatedly-ask-for-permission-to-use-the-microphone)
  - [What can I do to make speech recognition results return
    faster?](https://github.com/TalAter/annyang/blob/master/docs/FAQ.md#what-can-i-do-to-make-speech-recognition-results-return-faster)
  - [How can I contribute to annyang’s
    development?](https://github.com/TalAter/annyang/blob/master/docs/FAQ.md#how-can-i-contribute-to-annyangs-development)
  - [Why does Speech Recognition repeatedly starts and
    stops?](https://github.com/TalAter/annyang/blob/master/docs/FAQ.md#why-does-speech-recognition-repeatedly-starts-and-stops)
  - [Can annyang work
    offline?](https://github.com/TalAter/annyang/blob/master/docs/FAQ.md#can-annyang-work-offline)
  - [Which browsers are
    supported?](https://github.com/TalAter/annyang/blob/master/docs/FAQ.md#which-browsers-are-supported)
  - [Can annyang be used to capture the full text spoken by the
    user?](https://github.com/TalAter/annyang/blob/master/docs/FAQ.md#can-annyang-be-used-to-capture-the-full-text-spoken-by-the-user)
  - [Can I detect when the user starts and stops
    speaking?](https://github.com/TalAter/annyang/blob/master/docs/FAQ.md#can-i-detect-when-the-user-starts-and-stops-speaking)
  - [Can annyang be used in Chromium or
    Electron?](https://github.com/TalAter/annyang/blob/master/docs/FAQ.md#can-annyang-be-used-in-chromium-or-electron)
  - [Can annyang be used in
    Cordova?](https://github.com/TalAter/annyang/blob/master/docs/FAQ.md#can-annyang-be-used-in-cordova)

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
