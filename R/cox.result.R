#' cox.result
#'
#' Get the results of the independent variables of interest in the cox model
#'
#' @param fit An object with class is `coxph` or `coxme`.
#'
#' @return A tibble.
#' @details
#' `x.vars`: character vector. Name of the independent variable of interest.
#' `term`: character vector. When the independent variable of interest is numeric, term and x.vars are consistent.
#'       When the independent variable of interest is a factor, x.vars will be merged with the factor level in term.
#' `HR.POS`: character vector. "positive" means HR >= 1; "negetive" means HR <1.
#' `p.sig`: character vector. "yes" means p.value <=0.05; "no" means p.sig > 0.05.
#' `estimate`: numeric vector. The coefficient in cox model of x.vars.
#' `std.error`: numeric vector. The standard error in cox model of x.vars.
#' `HR`: numeric vector. The hazard ratio in cox model of x.vars. HR = exp(estimate)
#' `HR.LOW`: numeric vector. Lower limit of 95% confidence interval.
#' `HR.UP`: numeric vector. Upper limit of 95% confidence interval.
#' `p.value`: numeric vector. P value of x.vars.
#' @importFrom stringr str_split str_extract
#' @importFrom dplyr filter select mutate as_tibble
#' @importFrom coxme fixef
#' @importFrom broom tidy
#' @importFrom bdsmatrix diag
#' @export
cox.result <- function(fit){


  if(!class(fit) %in% c('coxph', 'coxme'))
    stop('class(fit) is not a coxph or coxme ')

  formula.terms =

    if(class(fit) == 'coxph'){

      as.character(fit$formula)

    } else {

      as.character(fit$formula)[1] %>%
        str_split(pattern = '(?<=~)\\s|\\s(?=~)') %>%
        unlist() %>%
        `[`(c(2,1,3))
    }

  air.pollution = formula.terms[3] %>% stringr::str_extract('[\\w\\.]+')

  model.result0 =

    if(class(fit) == 'coxph'){

      tidy(fit)

    } else {


      estimate <- coxme::fixef(fit)
      nvar <- base::length(estimate)
      nfrail <- base::nrow(fit$var) - nvar
      std.error <- base::sqrt(bdsmatrix::diag(fit$var)[nfrail + 1:nvar])
      statistic<- base::round(estimate/std.error, 2)
      p.value<- base::signif(1 - stats::pchisq((estimate/std.error)^2, 1), 2)
      table=base::data.frame(base::cbind(estimate,std.error,statistic,p.value))
      term = base::rownames(table)
      table=base::cbind(term, table)

    }

  model.result1 = model.result0 %>%
    mutate(
      HR = exp(estimate),
      HR.LOW = exp(estimate - 1.96*std.error),
      HR.UP  = exp(estimate + 1.96*std.error),
      HR.POS = ifelse(HR >= 1, 'positive', 'negative'),
      p.sig = ifelse(p.value <= 0.05, 'yes', 'no'),
      x.vars = air.pollution) %>%
    filter(grepl(air.pollution, term)) %>%
    select(x.vars, term, HR.POS, p.sig, estimate, std.error, HR:HR.UP, p.value) %>%
    as_tibble()

  model.result1

}
