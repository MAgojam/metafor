plot.vif.rma <- function(x,
   breaks="Scott", freq=FALSE, col, border, col.out, col.density,
   trim=0, adjust=1, lwd=c(2,0), ...) {

   #########################################################################

   mstyle <- .get.mstyle()

   .chkclass(class(x), must="vif.rma")

   .start.plot()

   if (missing(col))
      col <- .coladj(par("bg","fg"), dark=0.3, light=-0.3)

   if (missing(border))
      border <- .coladj(par("bg"), dark=0.1, light=-0.1)

   if (missing(col.out))
      col.out <- ifelse(.is.dark(), rgb(0.7,0.15,0.15,0.5), rgb(1,0,0,0.5))

   if (missing(col.density))
      col.density <- ifelse(.is.dark(), "dodgerblue", "blue")

   if (!is.null(x$alpha)) {

      if (is.null(x[[2]]$sim)) {
         plot(x[[1]], breaks=breaks, freq=freq, col=col, border=border, trim=trim, col.out=col.out,
              col.density=col.density, adjust=adjust, lwd=lwd, mainadd="Location ", ...)
         return(invisible())
      }

      if (is.null(x[[1]]$sim)) {
         plot(x[[2]], breaks=breaks, freq=freq, col=col, border=border, trim=trim, col.out=col.out,
              col.density=col.density, adjust=adjust, lwd=lwd, mainadd="Scale ", ...)
         return(invisible())
      }

      np <- length(x[[1]]$vifs) + length(x[[2]]$vifs)

      if (np > 1L) {
         # if no plotting device is open or mfrow is too small, set mfrow appropriately
         if (dev.cur() == 1L || prod(par("mfrow")) < np)
            par(mfrow=n2mfrow(np))
         on.exit(par(mfrow=c(1L,1L)), add=TRUE)
      }

      plot(x[[1]], breaks=breaks, freq=freq, col=col, border=border, trim=trim, col.out=col.out,
           col.density=col.density, adjust=adjust, lwd=lwd, mainadd="Location ", setmfrow=FALSE, ...)
      plot(x[[2]], breaks=breaks, freq=freq, col=col, border=border, trim=trim, col.out=col.out,
           col.density=col.density, adjust=adjust, lwd=lwd, mainadd="Scale ", setmfrow=FALSE, ...)
      return(invisible())

   }

   ddd <- list(...)

   tail     <- .chkddd(ddd$tail, "upper", match.arg(ddd$tail, c("lower", "upper")))
   setmfrow <- .chkddd(ddd$setmfrow, TRUE, FALSE)
   mainadd  <- .chkddd(ddd$mainadd, "")

   if (!is.null(ddd$layout))
      warning(mstyle$warning("Argument 'layout' has been deprecated."), call.=FALSE)

   ### check if 'sim' was actually used

   if (is.null(x$sim))
      stop(mstyle$stop("Can only plot 'vif.rma' objects when 'sim=TRUE' was used."))

   ### number of plots

   np <- length(x$vifs)

   if (setmfrow && np > 1L) {
      # if no plotting device is open or mfrow is too small, set mfrow appropriately
      if (dev.cur() == 1L || prod(par("mfrow")) < np)
         par(mfrow=n2mfrow(np))
      on.exit(par(mfrow=c(1L,1L)), add=TRUE)
   }

   ### 1st: obs stat, 2nd: density

   if (length(lwd) == 1L)
      lwd <- lwd[c(1,1)]

   ### cannot plot density when freq=TRUE

   if (freq)
      lwd[2] <- 0

   ### check trim

   if (trim >= 0.5)
      stop(mstyle$stop("The value of 'trim' must be < 0.5."))

   ### local plotting functions

   lhist     <- function(..., tail, setmfrow, mainadd, layout) hist(...)
   labline   <- function(..., tail, setmfrow, mainadd, layout) abline(...)
   lsegments <- function(..., tail, setmfrow, mainadd, layout) segments(...)
   llines    <- function(..., tail, setmfrow, mainadd, layout) lines(...)

   ############################################################################

   for (i in seq_len(np)) {

      pvif <- x$sim[,i]
      pvif <- pvif[is.finite(pvif)]

      den <- density(pvif, adjust=adjust)

      if (trim > 0) {
         bound <- quantile(pvif, probs=1-trim)
         pvif <- pvif[pvif <= bound]
      }

      tmp <- lhist(pvif, breaks=breaks, plot=FALSE)

      ylim <- c(0, max(ifelse(lwd[2] == 0, 0, max(den$y)), max(tmp$density)))

      tmp <- lhist(pvif, breaks=breaks, col=col, border=border,
                   main=paste0(mainadd, "Coefficient", ifelse(x$vif[[i]]$m > 1, "s", ""), ": ", names(x$vifs)[i]),
                   xlab="Value of VIF",
                   freq=freq, ylim=ylim, xaxt="n", ...)

      xat <- axTicks(side=1)
      xlabels <- xat

      axis(side=1, at=xat, labels=xlabels)

      .coltail(tmp, val=x$vifs[i], col=col.out, border=border, freq=freq, ...)

      usr <- par("usr")

      if (x$vifs[i] > usr[2] && lwd[1] > 0) {
         ya <- mean(par("yaxp")[1:2])
         arrows(usr[2] - 0.08*(usr[2]-usr[1]), ya, usr[2] - 0.01*(usr[2]-usr[1]), ya,
                length = 0.02*(grconvertY(usr[4], from="user", to="inches")-
                              (grconvertY(usr[3], from="user", to="inches"))))
      }

      x$vifs[i] <- min(x$vifs[i], usr[2])

      par(xpd = TRUE)
      if (lwd[1] > 0)
         lsegments(x$vifs[i], usr[3], x$vifs[i], usr[4], lwd=lwd[1], lty="dashed", ...)
      par(xpd = FALSE)

      #den$y <- den$y[den$x <= par("xaxp")[2]]
      #den$x <- den$x[den$x <= par("xaxp")[2]]
      if (lwd[2] > 0)
         llines(den, lwd=lwd[2], col=col.density, ...)

   }

   ############################################################################

   invisible()

}
