\name{print.deltamethod}
\alias{print.deltamethod}
\title{Print Method for 'deltamethod' Objects}
\description{
   Functions to print objects of class \code{"deltamethod"}.
}
\usage{
\method{print}{deltamethod}(x, digits, signif.stars=getOption("show.signif.stars"),
      signif.legend=signif.stars, \dots)
}
\arguments{
   \item{x}{an object of class \code{"deltamethod"}.}
   \item{digits}{integer to specify the number of decimal places to which the printed results should be rounded. If unspecified, the default is to take the value from the object.}
   \item{signif.stars}{logical to specify whether p-values should be encoded visually with \sQuote{significance stars}. Defaults to the \code{show.signif.stars} slot of \code{\link{options}}.}
   \item{signif.legend}{logical to specify whether the legend for the \sQuote{significance stars} should be printed. Defaults to the value for \code{signif.stars}.}
   \item{\dots}{other arguments.}
}
\details{
   The output is a table with the estimated coefficients, corresponding standard errors, test statistics, p-values, and confidence interval bounds.
}
\value{
   The function does not return an object.
}
\author{
   Wolfgang Viechtbauer (\email{wvb@metafor-project.org}, \url{https://www.metafor-project.org}).
}
\seealso{
   \code{\link{deltamethod}} for the function to create \code{deltamethod} objects.
}
\keyword{print}
