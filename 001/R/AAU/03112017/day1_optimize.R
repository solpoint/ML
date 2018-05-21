#' # Computing parameter estimates in linear models
#'
#' ### Søren Højsgaard
#'
#' Compile to html with knitr::spin("day1_optimize.R")

library(ggplot2)
source("multiplot.R")

y <- cars$dist
x <- cars$speed

#' `lm()` function minimizes residual sums of squares in closed form:
m1 <- lm(y ~ x)
m1
m3 <- lm(y ~ x + I(x^2))
m3

multiplot(
    qplot(fitted(m1), y) + geom_abline(intercept = 0, slope = 1),
    qplot(fitted(m3), y) + geom_abline(intercept = 0, slope = 1),
    cols=2)

#' Alternative - just for illustration: minimize by using standard
#' optimizer in R:

#' linear
rss1 <- function(b){
    sum((y - (b[1] + b[2] * x))^2)/(length(x) - 2)
}

#' quadratic
rss3 <- function(b){
    sum((y - (b[1] + b[2] * x + b[3] * x^2))^2)/(length(x) - 3)
}


rss1(c(1, 4))
rss3(c(1, 4, 4))

#' Minimize
#' 
#' Results same as above:
optim(c(1, 1), rss1)
optim(c(3, 1), rss1)

#' Results depend on starting value: Often the case in iterative
#' methods
optim(c(1, 1, 1),  rss3)
optim(c(3, 1, .1), rss3)


