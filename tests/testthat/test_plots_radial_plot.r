### library(metafor); library(testthat); Sys.setenv(NOT_CRAN="true")

### see also: https://www.metafor-project.org/doku.php/plots:radial_plot

context("Checking plots example: radial (Galbraith) plot")

test_that("plot can be drawn.", {

   expect_equivalent(TRUE, TRUE) # avoid 'Empty test' message

   skip_on_cran()

   opar <- par(no.readonly=TRUE)

   ### adjust margins so the space is better used
   par(mar=c(5,4,0,2))

   ### load ETS data
   data(dat.hackshaw1998, package="metafor")

   ### fit fixed-effects model
   res <- rma(yi, vi, data=dat.hackshaw1998, method="FE")

   ### draw radial plot
   radial(res)

   par(opar)

})
