\name{plot.vif.rma}
\alias{plot.vif.rma}
\title{Plot Method for 'vif.rma' Objects}
\description{
   Plot method for objects of class \code{"vif.rma"}.
}
\usage{
\method{plot}{vif.rma}(x, breaks="Scott", freq=FALSE, col, border, col.out, col.density,
     trim=0, adjust=1, lwd=c(2,0), \dots)
}
\arguments{
   \item{x}{an object of class \code{"vif.rma"} obtained with \code{\link[=vif.rma]{vif}}.}
   \item{breaks}{argument to be passed on to the corresponding argument of \code{\link{hist}} to set (the method for determining) the (number of) breakpoints.}
   \item{freq}{logical to specify whether frequencies (if \code{TRUE}) or probability densities should be plotted (the default is \code{FALSE}).}
   \item{col}{optional character string to specify the color of the histogram bars.}
   \item{border}{optional character string to specify the color of the borders around the bars.}
   \item{col.out}{optional character string to specify the color of the bars that are more extreme than the observed (G)VIF value (the default is a semi-transparent shade of red).}
   \item{col.density}{optional character string to specify the color of the kernel density estimate of the distribution that is superimposed on top of the histogram (the default is blue).}
   \item{trim}{the fraction (up to 0.5) of observations to be trimmed from the upper tail of each distribution before its histogram is plotted.}
   \item{adjust}{numeric value to be passed on to the corresponding argument of \code{\link{density}} (for adjusting the bandwidth of the kernel density estimate).}
   \item{lwd}{numeric vector to specify the width of the vertical lines corresponding to the value of the observed (G)VIFs and of the density estimate (note: by default, the density estimate has a line width of 0 and is therefore not plotted).}
   \item{\dots}{other arguments.}
}
\details{
   The function plots the distribution of each (G)VIF as simulated under independence as a histogram.

   Arguments \code{breaks}, \code{freq}, \code{col}, and \code{border} are passed on to the \code{\link{hist}} function for the plotting.

   Argument \code{trim} can be used to trim away a certain fraction of observations from the upper tail of each distribution before its histogram is plotted. By setting this to a value above 0, one can quickly remove some of the extreme values that might lead to the bulk of the distribution getting squished together at the left (typically, a small value such as \code{trim=0.01} is sufficient for this purpose).

   The observed (G)VIF value is indicated as a vertical dashed line. If the observed exceeds the upper plot limit, then this is indicated by an arrow pointing to the line.

   Argument \code{col.out} is used to specify the color for the bars in the histogram that are more extreme than the observed (G)VIF value.

   A kernel density estimate of the distribution can be superimposed on top of the histogram (as a smoothed representation of the distribution). Note that the kernel density estimate of the distribution is only shown when setting the line width for this element greater than 0 via the \code{lwd} argument (e.g., \code{lwd=c(2,2)}).
}
\author{
   Wolfgang Viechtbauer (\email{wvb@metafor-project.org}, \url{https://www.metafor-project.org}).
}
\references{
   Viechtbauer, W. (2010). Conducting meta-analyses in R with the metafor package. \emph{Journal of Statistical Software}, \bold{36}(3), 1--48. \verb{https://doi.org/10.18637/jss.v036.i03}
}
\seealso{
   \code{\link[=vif.rma]{vif}} for the function to create \code{vif.rma} objects.
}
\examples{
### copy data from Bangert-Drowns et al. (2004) into 'dat'
dat <- dat.bangertdrowns2004

### fit mixed-effects meta-regression model
res <- rma(yi, vi, mods = ~ length + wic + feedback + info + pers + imag + meta, data=dat)

### use the simulation approach to analyze the size of the VIFs
\dontrun{
vifs <- vif(res, sim=TRUE, seed=1234)
vifs

### plot the simulated distributions of the VIFs
plot(vifs)

### add densities, trim away some extremes, and set break points
plot(vifs, lwd=c(2,2), trim=0.01, breaks=seq(1,2.2,by=0.05), adjust=1.5)
}
}
\keyword{hplot}
