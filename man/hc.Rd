\name{hc}
\alias{hc}
\alias{hc.rma.uni}
\title{Meta-Analysis based on the Method by Henmi and Copas (2010)}
\description{
   Function to obtain an estimate of the average true outcome and corresponding confidence interval under a random-effects model using the method described by Henmi and Copas (2010).
}
\usage{
hc(object, \dots)

\method{hc}{rma.uni}(object, digits, transf, targs, control, \dots)
}
\arguments{
   \item{object}{an object of class \code{"rma.uni"}.}
   \item{digits}{optional integer to specify the number of decimal places to which the printed results should be rounded. If unspecified, the default is to take the value from the object.}
   \item{transf}{optional argument to specify a function to transform the estimate and the corresponding interval bounds (e.g., \code{transf=exp}; see also \link{transf}). If unspecified, no transformation is used.}
   \item{targs}{optional arguments needed by the function specified under \code{transf}.}
   \item{control}{list of control values for the iterative algorithm. If unspecified, default values are used. See \sQuote{Note}.}
   \item{\dots}{other arguments.}
}
\details{
   The model specified via \code{object} must be a model without moderators (i.e., either an equal- or a random-effects model).

   When using the usual method for fitting a random-effects model (i.e., weighted estimation with inverse-variance weights), the weights assigned to smaller and larger studies become more uniform as the amount of heterogeneity increases. As a consequence, the estimated average outcome could become increasingly biased under certain forms of publication bias (where smaller studies on one side of the funnel plot are missing). The method by Henmi and Copas (2010) counteracts this problem by providing an estimate of the average true outcome that is based on inverse-variance weights as used under an equal-effects model, which are not affected by the amount of heterogeneity. The amount of heterogeneity is still estimated (with the DerSimonian-Laird estimator) and incorporated into the standard error of the estimated average outcome and the corresponding confidence interval.

   Currently, there is only a method for handling objects of class \code{"rma.uni"} with the \code{hc} function. It therefore provides a method for conducting a sensitivity analysis after the model has been fitted with the \code{\link{rma.uni}} function.
}
\value{
   An object of class \code{"hc.rma.uni"}. The object is a list containing the following components:
   \item{beta}{estimated average true outcome.}
   \item{se}{corresponding standard error.}
   \item{ci.lb}{lower bound of the confidence intervals for the average true outcome.}
   \item{ci.ub}{upper bound of the confidence intervals for the average true outcome.}
   \item{\dots}{some additional elements/values.}

   The results are formatted and printed with the \code{\link[=print.hc.rma.uni]{print}} function.
}
\note{
   The method makes use of the \code{\link{uniroot}} function. By default, the desired accuracy is set equal to \code{.Machine$double.eps^0.25} and the maximum number of iterations to \code{1000}. The desired accuracy (\code{tol}) and the maximum number of iterations (\code{maxiter}) can be adjusted with the \code{control} argument (i.e., \code{control=list(tol=value, maxiter=value)}).
}
\author{
   Original code by Henmi and Copas (2010). Corrected for typos by Michael Dewey (\email{lists@dewey.myzen.co.uk}). Incorporated into the package with some small adjustments for consistency with the other functions in the package by Wolfgang Viechtbauer (\email{wvb@metafor-project.org}, \url{https://www.metafor-project.org}).
}
\references{
   Henmi, M., & Copas, J. B. (2010). Confidence intervals for random effects meta-analysis and robustness to publication bias. \emph{Statistics in Medicine}, \bold{29}(29), 2969--2983. \verb{https://doi.org/10.1002/sim.4029}

   Viechtbauer, W. (2010). Conducting meta-analyses in R with the metafor package. \emph{Journal of Statistical Software}, \bold{36}(3), 1--48. \verb{https://doi.org/10.18637/jss.v036.i03}
}
\seealso{
   \code{\link{rma.uni}} for the function to fit \code{rma.uni} models.
}
\examples{
### calculate log odds ratios and corresponding sampling variances
dat <- escalc(measure="OR", ai=ai, n1i=n1i, ci=ci, n2i=n2i, data=dat.lee2004)
dat

### meta-analysis based on log odds ratios
res <- rma(yi, vi, data=dat)
res

### funnel plot as in Henmi and Copas (2010)
funnel(res, yaxis="seinv", refline=0, xlim=c(-3,3), ylim=c(.5,3.5), steps=7, digits=1, back="white")

### use method by Henmi and Copas (2010) as a sensitivity analysis
hc(res)

### back-transform results to odds ratio scale
hc(res, transf=exp)
}
\keyword{htest}
