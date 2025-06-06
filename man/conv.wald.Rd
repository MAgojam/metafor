\name{conv.wald}
\alias{conv.wald}
\title{Convert Wald-Type Confidence Intervals and Tests to Sampling Variances}
\description{
   Function to convert Wald-type confidence intervals (CIs) and test statistics (or the corresponding p-values) to sampling variances. \loadmathjax
}
\usage{
conv.wald(out, ci.lb, ci.ub, zval, pval, n, data, include,
          level=95, transf, check=TRUE, var.names, append=TRUE, replace="ifna", \dots)
}
\arguments{
   \item{out}{vector with the observed effect sizes or outcomes.}
   \item{ci.lb}{vector with the lower bounds of the corresponding Wald-type CIs.}
   \item{ci.ub}{vector with the upper bounds of the corresponding Wald-type CIs.}
   \item{zval}{vector with the Wald-type test statistics.}
   \item{pval}{vector with the p-values of the Wald-type tests.}
   \item{n}{vector with the total sample sizes of the studies.}
   \item{data}{optional data frame containing the variables given to the arguments above.}
   \item{include}{optional (logical or numeric) vector to specify the subset of studies for which the conversion should be carried out.}
   \item{level}{numeric value (or vector) to specify the confidence interval level(s) (the default is 95; see \link[=misc-options]{here} for details).}
   \item{transf}{optional argument to specify a function to transform \code{out}, \code{ci.lb}, and \code{ci.ub} (e.g., \code{transf=log}). If unspecified, no transformation is used.}
   \item{check}{logical to specify whether the function should carry out a check to examine if the point estimates fall (approximately) halfway between the CI bounds (the default is \code{TRUE}).}
   \item{var.names}{character vector with two elements to specify the name of the variable for the observed effect sizes or outcomes and the name of the variable for the corresponding sampling variances (if \code{data} is an object of class \code{"escalc"}, the \code{var.names} are taken from the object; otherwise the defaults are \code{"yi"} and \code{"vi"}).}
   \item{append}{logical to specify whether the data frame provided via the \code{data} argument should be returned together with the estimated values (the default is \code{TRUE}).}
   \item{replace}{character string or logical to specify how values in \code{var.names} should be replaced (only relevant when using the \code{data} argument and if variables in \code{var.names} already exist in the data frame). See the \sQuote{Value} section for more details.}
   \item{\dots}{other arguments.}
}
\details{
   The \code{\link{escalc}} function can be used to compute a wide variety of effect sizes or \sQuote{outcome measures}. However, the inputs required to compute certain measures with this function may not be reported for all of the studies. Under certain circumstances, other information (such as point estimates and corresponding confidence intervals and/or test statistics) may be available that can be converted into the appropriate format needed for a meta-analysis. The purpose of the present function is to facilitate this process.

   The function typically takes a data frame created with the \code{\link{escalc}} function as input via the \code{data} argument. This object should contain variables \code{yi} and \code{vi} (unless argument \code{var.names} was used to adjust these variable names when the \code{"escalc"} object was created) for the observed effect sizes or outcomes and the corresponding sampling variances, respectively. For some studies, the values for these variables may be missing.

   \subsection{Converting Point Estimates and Confidence Intervals}{

      In some studies, the effect size estimate or observed outcome may already be reported. If so, such values can be supplied via the \code{out} argument and are then substituted for missing \code{yi} values. At times, it may be necessary to transform the reported values (e.g., reported odds ratios to log odds ratios). Via argument \code{transf}, an appropriate transformation function can be specified (e.g., \code{transf=log}), in which case \mjseqn{y_i = f(\text{out})} where \mjeqn{f(\cdot)}{f(.)} is the function specified via \code{transf}.

      Moreover, a confidence interval (CI) may have been reported together with the estimate. The bounds of the CI can be supplied via arguments \code{ci.lb} and \code{ci.ub}, which are also transformed if a function is specified via \code{transf}. Assume that the bounds were obtained from a Wald-type CI of the form \mjeqn{y_i \pm z_{crit} \sqrt{v_i}}{y_i ± z_crit \sqrt{v_i}} (on the transformed scale if \code{transf} is specified), where \mjseqn{v_i} is the sampling variance corresponding to the effect size estimate or observed outcome (so that \mjseqn{\sqrt{v_i}} is the corresponding standard error) and \mjeqn{z_{crit}}{z_crit} is the appropriate critical value from a standard normal distribution (e.g., \mjseqn{1.96} for a 95\% CI). Then \mjdeqn{v_i = \left(\frac{\text{ci.ub} - \text{ci.lb}}{2 \times z_{crit}}\right)^2}{v_i = ((ci.ub - ci.lb) / (2*z_crit))^2} is used to back-calculate the sampling variances of the (transformed) effect size estimates or observed outcomes and these values are then substituted for missing \code{vi} values in the dataset.

      For example, consider the following dataset of three RCTs used as input for a meta-analysis of log odds ratios:

\preformatted{
dat <- data.frame(study = 1:3,
                  cases.trt = c(23, NA, 4), n.trt = c(194, 183, 46),
                  cases.plc = c(38, NA, 7), n.plc = c(201, 188, 44),
                  oddsratio = c(NA, 0.64, NA), lower = c(NA, 0.33, NA), upper = c(NA, 1.22, NA))
dat <- escalc(measure="OR", ai=cases.trt, n1i=n.trt, ci=cases.plc, n2i=n.plc, data=dat)
dat

#   study cases.trt n.trt cases.plc n.plc oddsratio lower upper      yi     vi
# 1     1        23   194        38   201        NA    NA    NA -0.5500 0.0818
# 2     2        NA   183        NA   188      0.64  0.33  1.22      NA     NA
# 3     3         4    46         7    44        NA    NA    NA -0.6864 0.4437}

      where variable \code{yi} contains the log odds ratios and \code{vi} the corresponding sampling variances as computed from the counts and group sizes by \code{escalc()}.

      Study 2 does not report the counts (or sufficient information to reconstruct them), but the odds ratio and a corresponding 95\% confidence interval (CI) directly, as given by variables \code{oddsratio}, \code{lower}, and \code{upper}. The CI is a standard Wald-type CI that was computed on the log scale (and whose bounds were then exponentiated). Then the present function can be used as follows:

\preformatted{
dat <- conv.wald(out=oddsratio, ci.lb=lower, ci.ub=upper, data=dat, transf=log)
dat

#   study cases.trt n.trt cases.plc n.plc oddsratio lower upper      yi     vi
# 1     1        23   194        38   201        NA    NA    NA -0.5500 0.0818
# 2     2        NA   183        NA   188      0.64  0.33  1.22 -0.4463 0.1113
# 3     3         4    46         7    44        NA    NA    NA -0.6864 0.4437}

      Now variables \code{yi} and \code{vi} in the dataset are complete.

      If the CI was not a 95\% CI, then one can specify the appropriate level via the \code{level} argument. This can also be an entire vector in case different studies used different levels.

      By default (i.e., when \code{check=TRUE}), the function carries out a rough check to examine if the point estimate falls (approximately) halfway between the CI bounds (on the transformed scale) for each study for which the conversion was carried out. A warning is issued if there are studies where this is not the case. This may indicate that a particular CI was not a Wald-type CI or was computed on a different scale (in which case the back-calculation above would be inappropriate), but can also arise due to rounding of the reported values (in which case the back-calculation would still be appropriate, albeit possibly a bit inaccurate). Care should be taken when using such back-calculated values in a meta-analysis.

   }

   \subsection{Converting Test Statistics and P-Values}{

      Similarly, study authors may report the test statistic and/or p-value from a Wald-type test of the form \mjseqn{\text{zval} = y_i / \sqrt{v_i}} (on the transformed scale if \code{transf} is specified), with the corresponding two-sided p-value given by \mjseqn{\text{pval} = 2(1 - \Phi(\text{|zval|}))}, where \mjeqn{\Phi(\cdot)}{Phi(.)} denotes the cumulative distribution function of a standard normal distribution (i.e., \code{\link{pnorm}}). Test statistics and/or corresponding p-values of this form can be supplied via arguments \code{zval} and \code{pval}.

      A given p-value can be back-transformed into the corresponding test statistic (if it is not already available) with \mjseqn{\text{zval} = \Phi^{-1}(1 - \text{pval}/2)}, where \mjeqn{\Phi^{-1}(\cdot)}{Phi^{-1}(.)} denotes the quantile function (i.e., the inverse of the cumulative distribution function) of a standard normal distribution (i.e., \code{\link{qnorm}}). Then \mjdeqn{v_i = \left(\frac{y_i}{\text{zval}}\right)^2}{v_i = (yi / zval)^2} is used to back-calculate a missing \code{vi} value in the dataset.

      Note that the conversion of a p-value to the corresponding test statistic (which is then converted into sampling variance) as shown above assumes that the exact p-value is reported. If authors only report that the p-value fell below a certain threshold (e.g., \mjseqn{p < .01} or if authors only state that the test was significant -- which typically implies \mjseqn{p < .05}), then a common approach is to use the value of the cutoff reported (e.g., if \mjseqn{p < .01} is reported, then assume \mjseqn{p = .01}), which is conservative (since the actual p-value was below that assumed value by some unknown amount). The conversion will therefore tend to be much less accurate.

      Using the earlier example, suppose that only the odds ratio and the corresponding two-sided p-value from a Wald-type test (whether the log odds ratio differs significantly from zero) is reported for study 2.

\preformatted{
dat <- data.frame(study = 1:3,
                  cases.trt = c(23, NA, 4), n.trt = c(194, 183, 46),
                  cases.plc = c(38, NA, 7), n.plc = c(201, 188, 44),
                  oddsratio = c(NA, 0.64, NA), pval = c(NA, 0.17, NA))
dat <- escalc(measure="OR", ai=cases.trt, n1i=n.trt, ci=cases.plc, n2i=n.plc, data=dat)
dat

  study cases.trt n.trt cases.plc n.plc oddsratio pval      yi     vi
1     1        23   194        38   201        NA   NA -0.5500 0.0818
2     2        NA   183        NA   188      0.64 0.17      NA     NA
3     3         4    46         7    44        NA   NA -0.6864 0.4437}

      Then the function can be used as follows:

\preformatted{
dat <- conv.wald(out=oddsratio, pval=pval, data=dat, transf=log)
dat

#   study cases.trt n.trt cases.plc n.plc oddsratio pval      yi     vi
# 1     1        23   194        38   201        NA   NA -0.5500 0.0818
# 2     2        NA   183        NA   188      0.64 0.17 -0.4463 0.1058
# 3     3         4    46         7    44        NA   NA -0.6864 0.4437}

      Note that the back-calculated sampling variance for study 2 is not identical in these two examples, because the CI bounds and p-value are rounded to two decimal places, which introduces some inaccuracies. Also, if both (\code{ci.lb}, \code{ci.ub}) and either \code{zval} or \code{pval} is available for a study, then the back-calculation of \mjseqn{v_i} via the confidence interval is preferred.

   }

   Optionally, one can use the \code{n} argument to supply the total sample sizes of the studies. This has no relevance for the calculations done by the present function, but some other functions may use this information (e.g., when drawing a funnel plot with the \code{\link{funnel}} function and one adjusts the \code{yaxis} argument to one of the options that puts the sample sizes or some transformation thereof on the y-axis).
}
\value{
   If the \code{data} argument was not specified or \code{append=FALSE}, a data frame of class \code{c("escalc","data.frame")} with two variables called \code{var.names[1]} (by default \code{"yi"}) and \code{var.names[2]} (by default \code{"vi"}) with the (transformed) observed effect sizes or outcomes and the corresponding sampling variances (computed as described above).

   If \code{data} was specified and \code{append=TRUE}, then the original data frame is returned. If \code{var.names[1]} is a variable in \code{data} and \code{replace="ifna"} (or \code{replace=FALSE}), then only missing values in this variable are replaced with the (possibly transformed) observed effect sizes or outcomes from \code{out} (where possible) and otherwise a new variable called \code{var.names[1]} is added to the data frame. Similarly, if \code{var.names[2]} is a variable in \code{data} and \code{replace="ifna"} (or \code{replace=FALSE}), then only missing values in this variable are replaced with the sampling variances back-calculated as described above (where possible) and otherwise a new variable called \code{var.names[2]} is added to the data frame.

   If \code{replace="all"} (or \code{replace=TRUE}), then all values in \code{var.names[1]} and \code{var.names[2]} are replaced, even for cases where the value in \code{var.names[1]} and \code{var.names[2]} is not missing.
}
\note{
   \bold{A word of caution}: Except for the check on the CI bounds, there is no possibility to determine if the back-calculations done by the function are appropriate in a given context. They are only appropriate when the CI bounds and tests statistics (or p-values) arose from Wald-type CIs / tests as described above. Using the same back-calculations for other purposes is likely to yield nonsensical values.
}
\author{
   Wolfgang Viechtbauer (\email{wvb@metafor-project.org}, \url{https://www.metafor-project.org}).
}
\references{
   Viechtbauer, W. (2010). Conducting meta-analyses in R with the metafor package. \emph{Journal of Statistical Software}, \bold{36}(3), 1--48. \verb{https://doi.org/10.18637/jss.v036.i03}
}
\seealso{
   \code{\link{escalc}} for a function to compute various effect size measures.
}
\examples{
### a very simple example
dat <- data.frame(or=c(1.37,1.89), or.lb=c(1.03,1.60), or.ub=c(1.82,2.23))
dat

### convert the odds ratios and CIs into log odds ratios with corresponding sampling variances
dat <- conv.wald(out=or, ci.lb=or.lb, ci.ub=or.ub, data=dat, transf=log)
dat

############################################################################

### a more elaborate example based on the BCG vaccine dataset
dat <- dat.bcg[,c(2:7)]
dat

### with complete data, we can use escalc() in the usual way
dat1 <- escalc(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat)
dat1

### random-effects model fitted to these data
res1 <- rma(yi, vi, data=dat1)
res1

### now suppose that the 2x2 table data are not reported in all studies, but that the
### following dataset could be assembled based on information reported in the studies
dat2 <- data.frame(summary(dat1))
dat2[c("yi", "ci.lb", "ci.ub")] <- data.frame(summary(dat1, transf=exp))[c("yi", "ci.lb", "ci.ub")]
names(dat2)[which(names(dat2) == "yi")] <- "or"
dat2[,c("or","ci.lb","ci.ub","pval")] <- round(dat2[,c("or","ci.lb","ci.ub","pval")], digits=2)
dat2$vi <- dat2$sei <- dat2$zi <- NULL
dat2$ntot <- with(dat2, tpos + tneg + cpos + cneg)
dat2[c(1,12),c(3:6,9:10)] <- NA
dat2[c(4,9), c(3:6,8)] <- NA
dat2[c(2:3,5:8,10:11,13),c(7:10)] <- NA
dat2$ntot[!is.na(dat2$tpos)] <- NA
dat2

### in studies 1 and 12, authors reported only the odds ratio and the corresponding p-value
### in studies 4 and 9, authors reported only the odds ratio and the corresponding 95\% CI

### use escalc() first
dat2 <- escalc(measure="OR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat2)
dat2

### fill in the missing log odds ratios and sampling variances
dat2 <- conv.wald(out=or, ci.lb=ci.lb, ci.ub=ci.ub, pval=pval, n=ntot, data=dat2, transf=log)
dat2

### random-effects model fitted to these data
res2 <- rma(yi, vi, data=dat2)
res2

### any differences between res1 and res2 are a result of or, ci.lb, ci.ub, and pval being
### rounded in dat2 to two decimal places; without rounding, the results would be identical
}
\keyword{manip}
