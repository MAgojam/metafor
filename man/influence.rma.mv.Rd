\name{influence.rma.mv}
\alias{influence.rma.mv}
\alias{cooks.distance.rma.mv}
\alias{dfbetas.rma.mv}
\alias{hatvalues.rma.mv}
\title{Model Diagnostics for 'rma.mv' Objects}
\description{
   Functions to compute various outlier and influential study diagnostics (some of which indicate the influence of deleting one study at a time on the model fit or the fitted/residual values) for objects of class \code{"rma.mv"}. \loadmathjax
}
\usage{
\method{cooks.distance}{rma.mv}(model, progbar=FALSE, cluster,
               reestimate=TRUE, parallel="no", ncpus=1, cl, \dots)

\method{dfbetas}{rma.mv}(model, progbar=FALSE, cluster,
        reestimate=TRUE, parallel="no", ncpus=1, cl, \dots)

\method{hatvalues}{rma.mv}(model, type="diagonal", \dots)
}
\arguments{
   \item{model}{an object of class \code{"rma.mv"}.}
   \item{progbar}{logical to specify whether a progress bar should be shown (the default is \code{FALSE}).}
   \item{cluster}{optional vector to specify a clustering variable to use for computing the Cook's distances or DFBETAS values. If unspecified, these measures are computed for the individual observed effect sizes or outcomes.}
   \item{reestimate}{logical to specify whether variance/correlation components should be re-estimated after deletion of the \mjeqn{i\text{th}}{ith} case (the default is \code{TRUE}).}
   \item{parallel}{character string to specify whether parallel processing should be used (the default is \code{"no"}). For parallel processing, set to either \code{"snow"} or \code{"multicore"}. See \sQuote{Note}.}
   \item{ncpus}{integer to specify the number of processes to use in the parallel processing.}
   \item{cl}{optional cluster to use if \code{parallel="snow"}. If unspecified, a cluster on the local machine is created for the duration of the call.}
   \item{type}{character string to specify whether only the diagonal of the hat matrix (\code{"diagonal"}) or the entire hat matrix (\code{"matrix"}) should be returned.}
   \item{\dots}{other arguments.}
}
\details{
   The term \sQuote{case} below refers to a particular row from the dataset used in the model fitting (when argument \code{cluster} is not specified) or each level of the variable specified via \code{cluster}.

   Cook's distance for the \mjeqn{i\text{th}}{ith} case can be interpreted as the Mahalanobis distance between the entire set of predicted values once with the \mjeqn{i\text{th}}{ith} case included and once with the \mjeqn{i\text{th}}{ith} case excluded from the model fitting.

   The DFBETAS value(s) essentially indicate(s) how many standard deviations the estimated coefficient(s) change(s) after excluding the \mjeqn{i\text{th}}{ith} case from the model fitting.
}
\value{
   The \code{cooks.distance} function returns a vector. The \code{dfbetas} function returns a data frame. The \code{hatvalues} function returns either a vector with the diagonal elements of the hat matrix or the entire hat matrix.
}
\note{
   The variable specified via \code{cluster} is assumed to be of the same length as the data originally passed to the \code{rma.mv} function (and if the \code{data} argument was used in the original model fit, then the variable will be searched for within this data frame first). Any subsetting and removal of studies with missing values that was applied during the model fitting is also automatically applied to the variable specified via the \code{cluster} argument.

   Leave-one-out diagnostics are calculated by refitting the model \mjseqn{k} times (where \mjseqn{k} denotes the number of cases). Depending on how large \mjseqn{k} is, it may take a few moments to finish the calculations. For complex models fitted with \code{\link{rma.mv}}, this can become computationally expensive.

   On machines with multiple cores, one can try to speed things up by delegating the model fitting to separate worker processes, that is, by setting \code{parallel="snow"} or \code{parallel="multicore"} and \code{ncpus} to some value larger than 1. Parallel processing makes use of the \code{\link[parallel]{parallel}} package, using the \code{\link[parallel]{makePSOCKcluster}} and \code{\link[parallel]{parLapply}} functions when \code{parallel="snow"} or using \code{\link[parallel]{mclapply}} when \code{parallel="multicore"} (the latter only works on Unix/Linux-alikes).

   Alternatively (or in addition to using parallel processing), one can also set \code{reestimate=FALSE}, in which case any variance/correlation components in the model are not re-estimated after deleting the \mjeqn{i\text{th}}{ith} case from the dataset. Doing so only yields an approximation to the Cook's distances and DFBETAS values that ignores the influence of the \mjeqn{i\text{th}}{ith} case on the variance/correlation components, but is considerably faster (and often yields similar results).

   It may not be possible to fit the model after deletion of the \mjeqn{i\text{th}}{ith} case from the dataset. This will result in \code{NA} values for that case.
}
\author{
   Wolfgang Viechtbauer (\email{wvb@metafor-project.org}, \url{https://www.metafor-project.org}).
}
\references{
   Belsley, D. A., Kuh, E., & Welsch, R. E. (1980). \emph{Regression diagnostics}. New York: Wiley.

   Cook, R. D., & Weisberg, S. (1982). \emph{Residuals and influence in regression}. London: Chapman and Hall.

   Viechtbauer, W. (2010). Conducting meta-analyses in R with the metafor package. \emph{Journal of Statistical Software}, \bold{36}(3), 1--48. \verb{https://doi.org/10.18637/jss.v036.i03}

   Viechtbauer, W. (2021). Model checking in meta-analysis. In C. H. Schmid, T. Stijnen, & I. R. White (Eds.), \emph{Handbook of meta-analysis} (pp. 219--254). Boca Raton, FL: CRC Press. \verb{https://doi.org/10.1201/9781315119403}

   Viechtbauer, W., & Cheung, M. W.-L. (2010). Outlier and influence diagnostics for meta-analysis. \emph{Research Synthesis Methods}, \bold{1}(2), 112--125. \verb{https://doi.org/10.1002/jrsm.11}
}
\seealso{
   \code{\link[=rstudent.rma.mv]{rstudent}} for externally standardized residuals and \code{\link[=weights.rma.mv]{weights}} for model fitting weights.
}
\examples{
### copy data from Konstantopoulos (2011) into 'dat'
dat <- dat.konstantopoulos2011

### multilevel random-effects model
res <- rma.mv(yi, vi, random = ~ 1 | district/school, data=dat)
print(res, digits=3)

### Cook's distance for each observed outcome
x <- cooks.distance(res)
x
plot(x, type="o", pch=19, xlab="Observed Outcome", ylab="Cook's Distance")

### Cook's distance for each district
x <- cooks.distance(res, cluster=district)
x
plot(x, type="o", pch=19, xlab="District", ylab="Cook's Distance", xaxt="n")
axis(side=1, at=seq_along(x), labels=as.numeric(names(x)))

### hat values
hatvalues(res)
}
\keyword{models}
