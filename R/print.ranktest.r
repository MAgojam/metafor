print.ranktest <- function(x, digits=x$digits, ...) {

   mstyle <- .get.mstyle("crayon" %in% .packages())

   .chkclass(class(x), must="ranktest")

   digits <- .get.digits(digits=digits, xdigits=x$digits, dmiss=FALSE)

   if (!exists(".rmspace"))
      cat("\n")

   cat(mstyle$section("Rank Correlation Test for Funnel Plot Asymmetry"))
   cat("\n\n")
   cat(mstyle$result(paste0("Kendall's tau = ", .fcf(x$tau, digits[["est"]]), ", p ", .pval(x$pval, digits[["pval"]], showeq=TRUE, sep=" "))))
   cat("\n")
   #cat("H0: true tau is equal to 0\n\n")

   if (!exists(".rmspace"))
      cat("\n")

   invisible()

}
