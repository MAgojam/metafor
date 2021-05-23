### library(metafor); library(testthat); Sys.setenv(NOT_CRAN="true")

### see also: https://www.metafor-project.org/doku.php/analyses:viechtbauer2007a

context("Checking analysis example: viechtbauer2007a")

source("tolerances.r") # read in tolerances

### load data
data(dat.collins1985b, package="metafor")
dat <- dat.collins1985b[,1:7]
dat <- escalc(measure="OR", ai=pre.xti, n1i=pre.nti, ci=pre.xci, n2i=pre.nci, data=dat)

### note: results are compared with those in Table II on page 44 (but without rounding)

test_that("the heterogeneity estimates are correct.", {

   ### fit model with different tau^2 estimators
   res.DL   <- rma(yi, vi, data=dat, method="DL")
   res.ML   <- rma(yi, vi, data=dat, method="ML")
   res.REML <- rma(yi, vi, data=dat, method="REML")
   res.SJ   <- rma(yi, vi, data=dat, method="SJ")

   sav <- c(DL=res.DL$tau2, ML=res.ML$tau2, REML=res.REML$tau2, SJ=res.SJ$tau2)
   expect_equivalent(sav, c(.2297, .2386, .3008, .4563), tolerance=.tol[["var"]])

})

test_that("CI is correct for the Q-profile method.", {

   res.DL <- rma(yi, vi, data=dat, method="DL")
   sav <- confint(res.DL)
   sav <- c(sav$random["tau^2","ci.lb"], sav$random["tau^2","ci.ub"])
   expect_equivalent(sav, c(.0723, 2.2027), tolerance=.tol[["var"]])

})

test_that("CI is correct for the Biggerstaff–Tweedie method.", {

   res.DL <- rma(yi, vi, data=dat, method="DL")

   CI.D.func <- function(tau2val, s1, s2, Q, k, lower.tail) {
      expQ  <- (k-1) + s1*tau2val
      varQ  <- 2*(k-1) + 4*s1*tau2val + 2*s2*tau2val^2
      shape <- expQ^2/varQ
      scale <- varQ/expQ
      qtry  <- Q/scale
      pgamma(qtry, shape = shape, scale = 1, lower.tail = lower.tail) - .025
   }

   wi <- 1/dat$vi
   s1 <- sum(wi) - sum(wi^2)/sum(wi)
   s2 <- sum(wi^2) - 2*sum(wi^3)/sum(wi) + sum(wi^2)^2/sum(wi)^2

   ci.lb <- uniroot(CI.D.func, interval=c(0,10), s1=s1, s2=s2, Q=res.DL$QE, k=res.DL$k, lower.tail=FALSE)$root
   ci.ub <- uniroot(CI.D.func, interval=c(0,10), s1=s1, s2=s2, Q=res.DL$QE, k=res.DL$k, lower.tail=TRUE)$root
   sav <- c(ci.lb=ci.lb, ci.ub=ci.ub)
   expect_equivalent(sav, c(.0481, 2.3551), tolerance=.tol[["var"]])

})

test_that("CI is correct for the profile likelihood method.", {

   res.ML <- rma.mv(yi, vi, random = ~ 1 | id, data=dat, method="ML")
   res.REML <- rma.mv(yi, vi, random = ~ 1 | id, data=dat, method="REML")

   sav <- confint(res.ML)
   sav <- c(sav$random["sigma^2","ci.lb"], sav$random["sigma^2","ci.ub"])
   expect_equivalent(sav, c(.0266, 1.1308), tolerance=.tol[["var"]])

   sav <- confint(res.REML)
   sav <- c(sav$random["sigma^2","ci.lb"], sav$random["sigma^2","ci.ub"])
   expect_equivalent(sav, c(.0427, 1.4747), tolerance=.tol[["var"]])

   skip_on_cran()

   profile(res.ML, xlim=c(0,1.2), steps=50, progbar=FALSE)
   abline(h=logLik(res.ML) - qchisq(.95,1)/2, lty="dotted")
   abline(v=c(0.027, 1.131), lty="dotted")

   profile(res.REML, xlim=c(0,1.2), steps=50, progbar=FALSE)
   abline(h=logLik(res.REML) - qchisq(.95,1)/2, lty="dotted")
   abline(v=c(0.043, 1.475), lty="dotted")

})

test_that("CI is correct for the Wald-type method.", {

   res.ML   <- rma(yi, vi, data=dat, method="ML")
   res.REML <- rma(yi, vi, data=dat, method="REML")

   sav <- c(ci.lb=res.ML$tau2 - 1.96*res.ML$se.tau2, ci.ub=res.ML$tau2 + 1.96*res.ML$se.tau2)
   expect_equivalent(sav, c(-.1011, .5782), tolerance=.tol[["var"]])

   sav <- c(ci.lb=res.REML$tau2 - 1.96*res.REML$se.tau2, ci.ub=res.REML$tau2 + 1.96*res.REML$se.tau2)
   expect_equivalent(sav, c(-.1306, .7322), tolerance=.tol[["var"]])

})

test_that("CI is correct for the Sidik-Jonkman method.", {

   res.SJ <- rma(yi, vi, data=dat, method="SJ")

   sav <- c(ci.lb=(res.SJ$k-1) * res.SJ$tau2 / qchisq(.975, df=res.SJ$k-1),
            ci.ub=(res.SJ$k-1) * res.SJ$tau2 / qchisq(.025, df=res.SJ$k-1))
   expect_equivalent(sav, c(.2082, 1.6748), tolerance=.tol[["var"]])

})

test_that("CI is correct for the parametric bootstrap method.", {

   skip_on_cran()

   maj <- as.numeric(R.Version()$major)
   min <- as.numeric(R.Version()$minor)

   ### run test only on R versions 3.6.x (due to change in sampler)

   if (maj >= 3 && min >= 6) {

      library(boot)

      boot.func <- function(data.boot) {
         res <- rma(yi, vi, data=data.boot, method="DL")
         c(res$tau2, res$se.tau2^2)
      }

      data.gen <- function(dat, mle) {
         data.frame(yi=rnorm(nrow(dat), mle$mu, sqrt(mle$tau2 + dat$vi)), vi=dat$vi)
      }

      res.DL <- rma(yi, vi, data=dat, method="DL")

      set.seed(12345)
      sav <- boot(dat, boot.func, R=1000, sim="parametric", ran.gen=data.gen, mle=list(mu=coef(res.DL), tau2=res.DL$tau2))
      sav <- boot.ci(sav, type=c("norm", "basic", "stud", "perc"))
      sav <- sav$percent[4:5]
      expect_equivalent(sav, c(0, .7171), tolerance=.tol[["var"]])

   } else {

      expect_true(TRUE)

   }

})

test_that("CI is correct for the non-parametric bootstrap method.", {

   skip_on_cran()

   maj <- as.numeric(R.Version()$major)
   min <- as.numeric(R.Version()$minor)

   ### run test only on R versions 3.6.x (due to change in sampler)

   if (maj >= 3 && min >= 6) {

      library(boot)

      boot.func <- function(dat, indices) {
         res <- rma(yi, vi, data=dat, subset=indices, method="DL")
         c(res$tau2, res$se.tau2^2)
      }

      set.seed(12345)
      sav <- boot(dat, boot.func, R=1000)
      sav <- boot.ci(sav)
      sav <- sav$percent[4:5]
      expect_equivalent(sav, c(.0218, .5143), tolerance=.tol[["var"]])

   } else {

      expect_true(TRUE)

   }

})
