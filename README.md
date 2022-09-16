
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TidyCox: Make building cox models easier in R <img src="man/figures/logo.png" alt="logo" align="right" height="140" width="120"/>

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-%23fd8008.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![install with
devtools](https://img.shields.io/badge/install%20with-devtools-brightgreen.svg)](https://cran.r-project.org/web/packages/devtools/index.html)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Flizhiwei1994%2Ftidycox&count_bg=%2379C83D&title_bg=%23555555&icon=sourceforge.svg&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)
[![issues](https://img.shields.io/github/issues/lizhiwei1994/tidycox)](https://github.com/lizhiwei1994/tidycox/issues)

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
  as_tibble()
df
#> # A tibble: 16 × 3
#>       id date       outcome
#>    <dbl> <date>       <dbl>
#>  1     1 2013-01-01       0
#>  2     1 2014-01-01       0
#>  3     1 2015-01-01       1
#>  4     1 2016-01-01       1
#>  5     2 2013-01-01       0
#>  6     2 2014-01-01       1
#>  7     2 2015-01-01       0
#>  8     2 2016-01-01       0
#>  9     3 2013-01-01       1
#> 10     3 2014-01-01       1
#> 11     3 2015-01-01       0
#> 12     3 2016-01-01       0
#> 13     4 2013-01-01       0
#> 14     4 2014-01-01       0
#> 15     4 2015-01-01       0
#> 16     4 2016-01-01       0
```
