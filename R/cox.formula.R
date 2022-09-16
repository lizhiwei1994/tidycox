#' cox.formula
#' Generate a cox formula.
#' @param y `character vector` with `length = 1`. Dependent variables including survival time and ending events.
#' @param x `character vector` with `length = 1`. Independent variables of interest.
#' @param x.covars `character vector`. Covariates other than the independent variable.
#' @param frailty `character vector` with `length = 1`. The default is NULL. you can set it if you are fitting a frailty cox model.
#'
#' @return a `formula`
#' @importFrom stats as.formula
#' @export
#'
cox.formula <- function(y, x, x.covars, frailty = NULL){

  x.covars = unlist(x.covars)

  x2 = paste0(c(x, x.covars, frailty), collapse = '+')

  f = paste0(y, '~', x2) %>% as.formula()
  f
}
