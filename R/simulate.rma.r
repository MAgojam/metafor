simulate.rma <- function(object, nsim=1, seed=NULL, olim, ...) {

   mstyle <- .get.mstyle()

   .chkclass(class(object), must="rma", notav=c("rma.gen", "rma.glmm", "rma.mh", "rma.peto", "rma.uni.selmodel"))

   if (is.null(object$X))
      stop(mstyle$stop("Information needed to simulate values is not available in the model object."))

   na.act <- getOption("na.action")

   if (!is.element(na.act, c("na.omit", "na.exclude", "na.fail", "na.pass")))
      stop(mstyle$stop("Unknown 'na.action' specified under options()."))

   ### as in stats:::simulate.lm
   if (!exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE))
      runif(1)
   if (is.null(seed)) {
      RNGstate <- get(".Random.seed", envir = .GlobalEnv)
   } else {
      R.seed <- get(".Random.seed", envir = .GlobalEnv)
      set.seed(seed)
      RNGstate <- structure(seed, kind = as.list(RNGkind()))
      on.exit(assign(".Random.seed", R.seed, envir = .GlobalEnv), add=TRUE)
   }

   nsim <- round(nsim)

   if (nsim <= 0)
      stop(mstyle$stop("Argument 'nsim' must be >= 1."))

   ddd <- list(...)

   #########################################################################

   ### fitted values

   pred <- c(object$X %*% object$beta)

   if (isTRUE(ddd$withvb)) {
      vcovpred <- symmpart(object$X %*% object$vb %*% t(object$X))
   } else {
      vcovpred <- matrix(0, nrow=nrow(object$X), ncol=nrow(object$X))
   }

   ### simulate for rma.uni (and rma.ls) objects

   if (inherits(object, "rma.uni"))
      val <- t(.mvrnorm(nsim, mu=pred, Sigma=vcovpred+object$M))
      #val <- replicate(nsim, rnorm(object$k, mean=pred, sd=sqrt(object$vi + object$tau2)))

   ### simulate for rma.mv objects

   if (inherits(object, "rma.mv"))
      val <- t(.mvrnorm(nsim, mu=pred, Sigma=vcovpred+object$M))

   ### apply observation/outcome limits if specified

   if (!missing(olim)) {
      if (length(olim) != 2L)
         stop(mstyle$stop("Argument 'olim' must be of length 2."))
      olim <- sort(olim)
      val <- .applyolim(val, olim)
   }

   #########################################################################

   res <- matrix(NA_real_, nrow=object$k.f, ncol=nsim)
   res[object$not.na,] <- val
   res <- as.data.frame(res)

   rownames(res) <- object$slab
   colnames(res) <- paste0("sim_", seq_len(nsim))

   if (na.act == "na.omit")
      res <- res[object$not.na,,drop=FALSE]

   attr(res, "seed") <- RNGstate

   return(res)

}
