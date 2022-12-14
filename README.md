
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TidyCox: Make building cox models easier in R <img src="man/figures/logo.png" alt="logo" align="right" height="140" width="120"/>

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-%23fd8008.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![install with
devtools](https://img.shields.io/badge/install%20with-devtools-brightgreen.svg)](https://cran.r-project.org/web/packages/devtools/index.html)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Flizhiwei1994%2Ftidycox&count_bg=%2379C83D&title_bg=%23555555&icon=sourceforge.svg&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
[![issues](https://img.shields.io/github/issues/lizhiwei1994/tidycox.svg)](https://github.com/lizhiwei1994/tidycox/issues)

## :bar_chart: Overview

The
[tidymodel](https://cran.r-project.org/web/packages/tidymodels/index.html)
and
[survival](https://cran.r-project.org/web/packages/survival/index.html)
packages are good enough to do most of the work of fitting cox models
and extracting model results.
[TidyCox](https://github.com/lizhiwei1994/tidycox) package provides some
tiny functions to make fitting cox models and extracting model results
more easy.

## :arrow_double_down: Installation

You can install the development version of **tidycox** from Github with:

``` r
devtools::install_github('lizhiwei1994/tidycox')
```

## :beginner: Usage

There are 3 functions in tidycox, `cox.time()`, `cox.formula()` and
`cox.result()`. Next I will introduce the usage of these 3 functions one
by one.

## `cox.time()`

`cox.time()` can calculate the survival time for each patient in **long
data format**. It has two parameters `date` and `outcome`, which
represent the follow-up date, and the outcome at the time of follow-up,
respectively.

First we create a data frame `df` in long data format containing three
variables: `id`, `date` and `outcome.` `id` is the unique patient
identification code. `date` is the date of the follow-up visit.
`outcome` is the outcome at the time of the follow-up visit, where `1`
and `0` represent the occurrence and non-occurrence of the event of
interest, respectively.

``` r
library(dplyr)
df = data.frame(
  id = c(1,1,1,1, 2,2,2,2, 3,3,3,3, 4,4,4,4),
  date = c('2013-01-01', '2014-01-01', '2015-01-01', '2016-01-01',
           '2013-01-01', '2014-01-01', '2015-01-01', '2016-01-01',
           '2013-01-01', '2014-01-01', '2015-01-01', '2016-01-01',
           '2013-01-01', '2014-01-01', '2015-01-01', '2016-01-01'),
  outcome = c(0,0,1,1, 0,1,0,0, 1,1,0,0, 0,0,0,0)
) %>% 
  mutate(date = as.Date(date)) %>% 
  group_by(id) %>% 
  mutate(follow_up = row_number()) %>% 
  ungroup() %>% 
  as_tibble()
df
#> # A tibble: 16 ?? 4
#>       id date       outcome follow_up
#>    <dbl> <date>       <dbl>     <int>
#>  1     1 2013-01-01       0         1
#>  2     1 2014-01-01       0         2
#>  3     1 2015-01-01       1         3
#>  4     1 2016-01-01       1         4
#>  5     2 2013-01-01       0         1
#>  6     2 2014-01-01       1         2
#>  7     2 2015-01-01       0         3
#>  8     2 2016-01-01       0         4
#>  9     3 2013-01-01       1         1
#> 10     3 2014-01-01       1         2
#> 11     3 2015-01-01       0         3
#> 12     3 2016-01-01       0         4
#> 13     4 2013-01-01       0         1
#> 14     4 2014-01-01       0         2
#> 15     4 2015-01-01       0         3
#> 16     4 2016-01-01       0         4
```

Since we are using a long data format, we need to use the `group_by()`
function in the `dplyr` package to group the `id`s and also combine it
with the `mutate()` function to calculate the survival time `time`. The
survival time of the same `id` is the same.

``` r
library(tidycox)

df %>% group_by(id) %>% 
  mutate(time = cox.time(date = date, outcome = outcome))
#> # A tibble: 16 ?? 5
#> # Groups:   id [4]
#>       id date       outcome follow_up time     
#>    <dbl> <date>       <dbl>     <int> <drtn>   
#>  1     1 2013-01-01       0         1  730 days
#>  2     1 2014-01-01       0         2  730 days
#>  3     1 2015-01-01       1         3  730 days
#>  4     1 2016-01-01       1         4  730 days
#>  5     2 2013-01-01       0         1  365 days
#>  6     2 2014-01-01       1         2  365 days
#>  7     2 2015-01-01       0         3  365 days
#>  8     2 2016-01-01       0         4  365 days
#>  9     3 2013-01-01       1         1    0 days
#> 10     3 2014-01-01       1         2    0 days
#> 11     3 2015-01-01       0         3    0 days
#> 12     3 2016-01-01       0         4    0 days
#> 13     4 2013-01-01       0         1 1095 days
#> 14     4 2014-01-01       0         2 1095 days
#> 15     4 2015-01-01       0         3 1095 days
#> 16     4 2016-01-01       0         4 1095 days
```

The parameter `date` in `cox.time()` can also accept numeric variables.

``` r
df %>% group_by(id) %>% 
  mutate(time = cox.time(date = follow_up, outcome = outcome))
#> # A tibble: 16 ?? 5
#> # Groups:   id [4]
#>       id date       outcome follow_up  time
#>    <dbl> <date>       <dbl>     <int> <int>
#>  1     1 2013-01-01       0         1     2
#>  2     1 2014-01-01       0         2     2
#>  3     1 2015-01-01       1         3     2
#>  4     1 2016-01-01       1         4     2
#>  5     2 2013-01-01       0         1     1
#>  6     2 2014-01-01       1         2     1
#>  7     2 2015-01-01       0         3     1
#>  8     2 2016-01-01       0         4     1
#>  9     3 2013-01-01       1         1     0
#> 10     3 2014-01-01       1         2     0
#> 11     3 2015-01-01       0         3     0
#> 12     3 2016-01-01       0         4     0
#> 13     4 2013-01-01       0         1     3
#> 14     4 2014-01-01       0         2     3
#> 15     4 2015-01-01       0         3     3
#> 16     4 2016-01-01       0         4     3
```

## `cox.formula()`

`cox.formula()` returns a `formula` by passing in the dependent
variable, the independent variable of interest, and other covariates,
respectively. All arguments in `cox.formula()` are **character**
vectors.

``` r
y = 'Surv(time, status)'
x = 'x_interest'
x.covars = c('covars_1', 'covars_2', 'covars_3')

cox.formula(y = y, x = x, x.covars = x.covars)
#> Surv(time, status) ~ x_interest + covars_1 + covars_2 + covars_3
#> <environment: 0x0000027808d8b430>
```

Note that the dependent variable `y` needs to be formulated using the
cox model expression, similar to `'Surv(time, status)'`. `time` is the
survival time and `status` is the ending event. `surv` is the name of
the function that creates a survival object. Since
`'Surv(time, status)'` is a character vector, it is not executed.

`cox.formula()` can also generate formulas for the [frailty cox
model](https://data.princeton.edu/pop509/frailtyr). You need to specify
the `frailty` parameter in `cox.formula()` (`frailty` is `NULL` by
default).

``` r
frailty = '(1|random_intercept_var)'

cox.formula(y = y, x = x, x.covars = x.covars, frailty = frailty)
#> Surv(time, status) ~ x_interest + covars_1 + covars_2 + covars_3 + 
#>     (1 | random_intercept_var)
#> <environment: 0x000002780aa3ad18>
```

## `cox.result()`

The function `cox.result()` is somewhat similar to the
[`tidy()`](https://rdrr.io/cran/generics/man/tidy.html) function in the
`generics` package, but returns more content than it does and is more
compatible.

`cox.result()` will only return the result of **the first independent
variable** in the formula, which allows us to quickly obtain the result
of the independent variable of interest.

First create a simple dataset.

``` r
test1 <- list(time=c(4,3,1,1,2,2,3), 
              status=c(1,1,1,0,1,1,0), 
              x1=c(0,2,1,1,1,0,0), 
              x2=c(1,2,1,2,1,0,0),
              sex=c(0,0,0,0,1,1,1)) 
```

Then we fit a cox model of class `coxph` and extract the results with
`cox.result()`. This will return the result of the independent variable
`x1`.

> Note that the order of the independent variables is `x1+x2`.

``` r
library(survival)
model_1 = coxph(Surv(time, status) ~ x1+x2, test1) 
cox.result(model_1)
#> # A tibble: 1 ?? 10
#>   x.vars term  HR.POS   p.sig estimate std.error         HR HR.LOW HR.UP p.value
#>   <chr>  <chr> <chr>    <chr>    <dbl>     <dbl>      <dbl>  <dbl> <dbl>   <dbl>
#> 1 x1     x1    positive no        20.6    23841. 878395377.      0   Inf   0.999
```

If we turn `x1+x2` into `x2+x1`, we will return the result of `x2`.

``` r
model_1 = coxph(Surv(time, status) ~ x2+x1, test1) 
cox.result(model_1)
#> # A tibble: 1 ?? 10
#>   x.vars term  HR.POS   p.sig estimate std.error         HR HR.LOW HR.UP p.value
#>   <chr>  <chr> <chr>    <chr>    <dbl>     <dbl>      <dbl>  <dbl> <dbl>   <dbl>
#> 1 x2     x2    negative no       -20.4    23841.    1.39e-9      0   Inf   0.999
```

`cox.result()` returns a `tibble` which contains `10` variables
respectively.

> **x.vars**: `character` vector. Name of the independent variable of
> interest. **term**: `character` vector. When the independent variable
> of interest is numeric, `term` and `x.vars` are consistent. When the
> independent variable of interest is a factor, `x.vars` will be merged
> with the factor level in `term`. **HR.POS**: `character` vector.
> `"positive"` means `HR` \>= 1; `"negetive"` means `HR` \<1. **p.sig**:
> `character` vector. `"yes"` means `p.value` \<=0.05; `"no"` means
> `p.value` \> 0.05. **estimate**: `numeric` vector. The coefficient in
> cox model of `x.vars.` **std.error**: `numeric` vector. The standard
> error in cox model of `x.vars`. **HR**: `numeric` vector. The hazard
> ratio in cox model of `x.vars`. HR = exp(estimate) **HR.LOW**:
> `numeric` vector. Lower limit of 95% confidence interval. **HR.UP**:
> `numeric` vector. Upper limit of 95% confidence interval. **p.value**:
> `numeric` vector. P value of `x.vars`.

`cox.result()` can also extract results with object class `coxme`, which
cannot be done in the
[`tidy()`](https://rdrr.io/cran/generics/man/tidy.html) function. If you
use the
[coxme](https://cran.r-project.org/web/packages/coxme/index.html)
package to build a frailty cox model will return a `coxme` object.

First we fit a frailty cox model using the `coxme` package.

``` r
library(coxme)
model_2 <- coxme(Surv(time, status) ~ ph.ecog + age + (1|inst), lung)
```

If you try to extract the result of `model_2` with `tidy()` it will give
an error. Because the `tidy()` function can be used for `coxph` objects
but not for `coxme` objects.

``` r
broom::tidy(model_2) 
```

The results of `model_2` can be successfully extracted using
`cox.result()`.

``` r
cox.result(model_2)
#> # A tibble: 1 ?? 10
#>   x.vars  term    HR.POS   p.sig estimate std.error    HR HR.LOW HR.UP  p.value
#>   <chr>   <chr>   <chr>    <chr>    <dbl>     <dbl> <dbl>  <dbl> <dbl>    <dbl>
#> 1 ph.ecog ph.ecog positive yes      0.473     0.119  1.61   1.27  2.03 0.000072
```

## :page_with_curl: About Author

Zhiwei Li (<lizhiwei@ccmu.edu.cn>)

Department of Epidemiology and Health Statistics

School of Public Health, Capital Medical University

No.10 Xitoutiao, Youanmen Wai Street

Beijing, 100069

## :page_with_curl: Citation

If my R package is useful to you, please cite it.

Li Z (2022). *tidycox: A package that makes building cox models easier.*
R package version 0.1.0.

``` r
@Manual{,
  title = {tidycox: A package that makes building cox models easier},
  author = {Zhiwei Li},
  year = {2022},
  note = {R package version 0.1.0},
}
```

## :page_with_curl: Acknowledgements

The hex logo of the `tidycox` package is made by
[`hexSticker`](https://github.com/GuangchuangYu/hexSticker). the
`Readme` file format is referenced from the
[`sigminer`](https://github.com/ShixiangWang/sigminer) package. Thanks
to the above authors for their help in building the `tidycox` package.
