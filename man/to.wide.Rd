\name{to.wide}
\alias{to.wide}
\title{Convert Data from a Long to a Wide Format}
\description{
   Function to convert data given in long format to a wide format.
}
\usage{
to.wide(data, study, grp, ref, grpvars, postfix=c(".1",".2"),
        addid=TRUE, addcomp=TRUE, adddesign=TRUE, minlen=2,
        var.names=c("id","comp","design"))
}
\arguments{
   \item{data}{a data frame in long format.}
   \item{study}{either the name (given as a character string) or the position (given as a single number) of the study variable in the data frame.}
   \item{grp}{either the name (given as a character string) or the position (given as a single number) of the group variable in the data frame.}
   \item{ref}{optional character string to specify the reference group (must be one of the groups in the group variable). If not given, the most frequently occurring group is used as the reference group.}
   \item{grpvars}{either the names (given as a character vector) or the positions (given as a numeric vector) of the group-level variables.}
   \item{postfix}{a character string of length 2 giving the affix that is placed after the names of the group-level variables for the first and second group.}
   \item{addid}{logical to specify whether a row id variable should be added to the data frame (the default is \code{TRUE}).}
   \item{addcomp}{logical to specify whether a comparison id variable should be added to the data frame (the default is \code{TRUE}).}
   \item{adddesign}{logical to specify whether a design id variable should be added to the data frame (the default is \code{TRUE}).}
   \item{minlen}{integer to specify the minimum length of the shortened group names for the comparison and design id variables (the default is 2).}
   \item{var.names}{character vector with three elements to specify the name of the id, comparison, and design variables (the defaults are \code{"id"}, \code{"comp"}, and \code{"design"}, respectively).}
}
\details{
   A meta-analytic dataset may be structured in a \sQuote{long} format, where each row in the dataset corresponds to a particular study group (e.g., treatment arm). Using this function, such a dataset can be restructured into a \sQuote{wide} format, where each group within a study is contrasted against a particular reference group.

   The \code{study} and \code{group} arguments are used to specify the study and group variables in the dataset (either as character strings or as numbers indicating the column positions of these variables in the dataset). Optional argument \code{ref} is used to specify the reference group (this must be one of the groups in the \code{group} variable). Argument \code{grpvars} is used to specify (either as a character vector or by giving the column positions) of those variables in the dataset that correspond to group-level outcomes (the remaining variables are treated as study-level outcomes).

   The dataset is restructured so that a two-group study will yield a single row in the restructured dataset, contrasting the first group against the second/reference group. For studies with more than two groups (often called \sQuote{multiarm} or \sQuote{multitreatment} studies in the medical literature), the reference group is repeated as many times as needed (so a three-group study would yield two rows in the restructured dataset, contrasting two groups against a common reference group).

   If a study does not include the reference group, then another group from the study will be used as the reference group. This group is chosen based on the factor levels of the \code{grp} variable (i.e., the last level that occurs in the study becomes the reference group).

   To distinguish the names of the group-level outcome variables for the two first and second group in the restructured dataset, the strings given for the \code{postfix} argument are placed after the respective variable names.

   If requested, row id, comparison id, and design id variables are added to the restructured dataset. The row id is simply a unique number for each row in the dataset. The comparison id variable indicates which two groups have been compared against each other). The design id variable indicates which groups were included in a particular study. The group names are shortened for the comparison and design variables (to at least \code{minlen}; the actual length might be longer to ensure uniqueness of the group names).

   The examples below illustrate the use of this function.
}
\value{
   A data frame with rows contrasting groups against a reference group and an appropriate number of columns (depending on the number of group-level outcome variables).
}
\author{
   Wolfgang Viechtbauer (\email{wvb@metafor-project.org}, \url{https://www.metafor-project.org}).
}
\references{
   Viechtbauer, W. (2010). Conducting meta-analyses in R with the metafor package. \emph{Journal of Statistical Software}, \bold{36}(3), 1--48. \verb{https://doi.org/10.18637/jss.v036.i03}
}
\seealso{
   \code{\link{contrmat}} for a function to construct a contrast matrix based on a dataset in wide format.

   \code{\link[metadat]{dat.hasselblad1998}}, \code{\link[metadat]{dat.lopez2019}}, \code{\link[metadat]{dat.obrien2003}}, \code{\link[metadat]{dat.pagliaro1992}}, \code{\link[metadat]{dat.senn2013}} for illustrative examples.
}
\examples{
### data in long format
dat <- dat.senn2013
dat <- dat[c(1,4,3,2,5,6)]
dat

### restructure to wide format
dat <- to.wide(dat, study="study", grp="treatment", ref="placebo", grpvars=4:6)
dat

### data in long format
dat <- dat.hasselblad1998
dat

### restructure to wide format
dat <- to.wide(dat, study="study", grp="trt", ref="no_contact", grpvars=6:7)
dat
}
\keyword{manip}
