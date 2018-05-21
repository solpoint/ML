
#' # Linear models, parameter estimates, predictions, cross-validation
#'
#' ### Søren Højsgaard
#'
#' compile this file to html with knitr::spin("day1_estimates-prediction.R")


library(ggplot2)
library(broom)
library(magrittr)

source("multiplot.R")
options("device"="X11")

#' Stopping distance of cars related to speed
p <- qplot(speed, dist, data=cars)
p

#' Linear relationship? Quadratic relationship?

p1 = lm(dist ~ speed, data=cars)
p2 = lm(dist ~ speed + I(speed^2), data=cars)
pn = lm(dist ~ poly(speed, 5), data=cars)
p1
p2
pn

tidy(p1) ## from broom
tidy(p2) 
tidy(pn) 

glance(p1) ## from broom
glance(p2)
glance(pn)

p + geom_line(aes(speed, predict(p1)), col='blue') +
    geom_line(aes(speed, predict(p2)), col='red') +
    geom_line(aes(speed, predict(pn)), col='green') 


#' ## Std. error of parameter estimates:
#'
tidy(p2) ## from broom

#' What is a standard error of an estimate? Short answer: A measure of
#' how much parameter estimates vary if we redo the study many times.
#'
#' We can not redo the study many times but we can mimic doing so in many ways; here are two:
#'

#' ## Alternative 1:

i = sample(1:nrow(cars), replace=T)
cars2 = cars[i, ]
p22 = lm(dist ~ speed + I(speed^2), data=cars2)
coef(p22)

resample1 <- function(){
    i = sample(1:nrow(cars), replace=T)
    cars2 = cars[i, ]
    p22 = lm(dist ~ speed + I(speed^2), data=cars2)
    coef(p22)
}

#' Interesting to see how the estimates vary across (pseudo) replicates:
resample1(); resample1(); resample1()

#' Resample many times:
M = 10
mat1 <- replicate(M, resample1())
mat1 

#' Same as
# mat1 = matrix(0, nr=3, ncol=M)
# for (j in 1:M){
#   mat1[, j] <- resample1()
# }

#' std. error across replicates; not unlike std. errors from lm()
apply(mat1, 1, sd)
tidy(p2)

#' ## Alternative 2
#' Regard x's as fixed only resample y's ; do so via residuals:

r <- resid(p2); r
p <- predict(p2); p
cars2 <- cars

resample2 <- function(){
    r2 <- sample(r, replace=T)
    cars2$dist <- p + r2
    p22 = lm(dist ~ speed + I(speed^2), data=cars2)
    coef(p22)
}    

#' Interesting to see how the estimates vary across (pseudo) replicates:
resample2(); resample2(); resample2()

#' Resample many times:
mat2 <- replicate(M, resample2())
mat2

#' std. error across replicates; not unlike std. errors from
#' lm(). That is the practical interpretation of standard errors of
#' estimates:
apply(mat1, 1, sd)
apply(mat2, 1, sd)
tidy(p2)

#' Do many replicates:
#' 
M <- 1000
mat1 <- replicate(M, resample1())
mat2 <- replicate(M, resample2())

#' std. error across replicates; not unlike std. errors from lm()
apply(mat1, 1, sd)
apply(mat2, 1, sd)
tidy(p2)
confint(p2) # confidence intervals: estimate +/- 2 se

#' Look at sample across replicates:
multiplot(
    qplot(mat2[1,]),
    qplot(mat2[2,]),
    qplot(mat2[3,]))

#' The techiques used above are called bootstrap methods; can be done
#' using boot package: Approach above is useful in many contexts. For
#' example this: In the linear regression model what is the value of x
#' corresponding to y=10. Answer

m1 <- lm(dist ~ speed, data=cars)
b <- coef(m1)
b
(10 - b[1]) / b[2]

resample3 <- function(){
    i = sample(1:nrow(cars), replace=T)
    cars2 = cars[i, ]
    p22 = lm(dist ~ speed, data=cars2)
    coef(p22)
}


#' Interesting to see how the estimates vary across (pseudo) replicates:
resample3(); resample3(); resample3()

#' Resample many times:
M <- 10
mat3 <- replicate(M, resample3())
mat3

x.10 <- (10 - mat3[1,]) / mat3[2,]

summary(x.10)

M <- 1000
mat3 <- replicate(M, resample3())
x.10 <- (10 - mat3[1,]) / mat3[2,]

summary(x.10)
sd(x.10)

qplot(x.10)


## The boot package does this

library(boot)

bs <- function(formula, data, indices) {
  d <- data[indices,] # allows boot to select sample
  fit <- lm(formula, data=d)
  b <- coef(fit)
  (10 - b[1]) / b[2]
}

bs(dist~speed, cars, 1:30)

results <- boot(data=cars, statistic=bs,
                R=1000, formula=dist~speed)
results



#' ## How good are models?
#'
#' ### Predictions
#'
#' Correlate observed and predicted values

cor(cars$dist, predict(p1, newdata=cars))

cor2 <- function(d, m){
    cor(d[["dist"]], predict(m, newdata = d))
}
cor2(cars, p1)
cor2(cars, p2)
cor2(cars, pn)

#' Misleading; instead consider out of sample predictions
#' 

N = nrow(cars)
i = sample(N, size=20)
train1 = cars[i,]  ## Fit on training data
valid1 = cars[-i,] ## Validate on external data

pt1 = lm(dist ~ speed, data=train1)
pt2 = lm(dist ~ speed + I(speed^2), data=train1)
##pt2 = lm(dist ~ poly(speed, 2), data=train1) ## same same
ptn = lm(dist ~ poly(speed, 5), data=train1)

glance(pt1)
glance(pt2)
glance(ptn)

multiplot(
    qplot(dist, predict(pt2), data=train1) + geom_abline(),
    qplot(dist, predict(ptn), data=train1) + geom_abline())

#' ## More complex model fits better to data
#' 
cor2(train1, pt1)
cor2(train1, pt2)
cor2(train1, ptn) ## More complex model fits better to data

cor2(valid1, pt1)
cor2(valid1, pt2)
cor2(valid1, ptn) ## But out-of-sample predictions are poor...

rmsep <- function(d, m){
    pe <- d$dist - predict(m, newdata=d)
    sqrt(sum(pe**2) / length(pe))
}

rmsep(train1, pt1)
rmsep(train1, pt2)
rmsep(train1, ptn) ## More complex model fits better to data

rmsep(valid1, pt1)
rmsep(valid1, pt2)
rmsep(valid1, ptn) ## But out-of-sample predictions are poor...


#' R-squared
corval <- function(formula, data, indices) {
  d <- data[indices,] # allows boot to select sample
  fit <- lm(formula, data=d)
  out <- cor(d[["dist"]], predict(fit))
  return(out)
}

rsq(dist~speed+I(speed^2), cars, 1:10)
corval(dist~speed+I(speed^2), cars, 1:10)

# bootstrapping with 1000 replications
results <- boot(data=cars, statistic=corval,
   R=1000, formula=dist~speed+I(speed^2))

results
plot(results)
boot.ci(results, type="bca")


#' ### Out-of-range predictions
#' 
i = cars$speed < 15
train2=cars[i,]   ## Fit on low speeds
valid2=cars[!i,]  ## Validate on high speeds
pt22 = lm(dist~speed+I(speed^2), data=train2)
## pt22 = update(pt2, data=train2)

predict(pt22, newdata=valid2)

p = qplot(speed, dist, data=cars)
p

p + geom_line(aes(speed, predict(p2)), col='red') +
    geom_line(aes(speed, predict(pt2)),
              data=train1, col='purple') +
    geom_line(aes(x=speed, y=predict(pt22, newdata=train2)),
               data=train2, col='green') +
    geom_line(aes(x=speed, y=predict(pt22, newdata=valid2)),
               data=valid2, col='blue')


