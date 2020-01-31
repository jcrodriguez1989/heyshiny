#' Stop the SpeechRecognition
#'
#' Stop the browser's SpeechRecognition task. This is useful to be called when
#' the Shiny app is going to be exited. If not, the browser's tab will keep
#' trying to perfom speech recognition.
#'
#' @param session Session object to send notification to.
#'
#' @importFrom shiny getDefaultReactiveDomain
#'
#' @export
#'
stopHeyshiny <- function(session = getDefaultReactiveDomain()) {
  session$sendCustomMessage("stopHS", "")
}
