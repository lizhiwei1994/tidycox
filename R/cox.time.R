#' cox.time
#'
#'Calculating the survival time of patients
#'
#'
#' @param date date or numeric vector. The date of the follow-up visit, which can be year-month-day in date format. It can also be a year, month or day in separate numerical values.
#' @param outcome numeric vector. There are only two values, 0: no ending event has occurred; 1: an ending event has occurred.
#'
#' @return numeric vector with lengh = 1.
#' @export
#'
cox.time <- function(date,outcome) {
  if(1 %in% outcome) min(date[outcome==1]) - min(date)
  else max(date) -  min(date)
}
