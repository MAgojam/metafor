### library(metafor); library(testthat); Sys.setenv(NOT_CRAN="true")

context("Checking misc: plot() function")

source("settings.r")

test_that("plot can be drawn for rma().", {

   expect_equivalent(TRUE, TRUE) # avoid 'Empty test' message

   dat <- escalc(measure="RR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
   res <- rma(yi, vi, data=dat)
   plot(res)

   res <- rma(yi ~ ablat, vi, data=dat)
   plot(res)

})

test_that("plot can be drawn for rma.mh().", {

   expect_equivalent(TRUE, TRUE) # avoid 'Empty test' message

   res <- rma.mh(measure="RR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
   plot(res)

})

test_that("plot can be drawn for rma.peto().", {

   expect_equivalent(TRUE, TRUE) # avoid 'Empty test' message

   res <- rma.peto(ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
   plot(res)

})

rm(list=ls())
