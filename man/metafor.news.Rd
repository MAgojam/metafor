\name{metafor.news}
\alias{metafor.news}
\title{Read News File of the Metafor Package}
\description{
   Function to read the \file{NEWS} file of the \pkg{\link{metafor-package}}.
}
\usage{
metafor.news()
}
\details{
   The function is simply a wrapper for \code{news(package="metafor")} which parses and displays the \file{NEWS} file of the package.
}
\author{
   Wolfgang Viechtbauer (\email{wvb@metafor-project.org}, \url{https://www.metafor-project.org}).
}
\references{
   Viechtbauer, W. (2010). Conducting meta-analyses in R with the metafor package. \emph{Journal of Statistical Software}, \bold{36}(3), 1--48. \verb{https://doi.org/10.18637/jss.v036.i03}
}
\examples{
\dontrun{
metafor.news()
}
}
\keyword{utilities}
