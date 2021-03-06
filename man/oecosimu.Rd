\encoding{UTF-8}
\name{oecosimu}
\alias{oecosimu}
\alias{commsimulator}
\alias{as.ts.oecosimu}
\alias{as.mcmc.oecosimu}
\alias{density.oecosimu}
\alias{densityplot.oecosimu}

\title{ Null Models for Biological Communities }

\description{
  Null models generate random communities with different criteria to
  study the significance of nestedness or other community patterns. The
  function only simulates binary (presence/absence) models with
  constraint for total number of presences, and optionally for numbers
  of species and/or species frequencies.
}

\usage{
oecosimu(comm, nestfun, method, nsimul = 99, burnin = 0, thin = 1,
   statistic = "statistic", alternative = c("two.sided", "less", "greater"),
   ...)
commsimulator(x, method, thin=1)
\method{as.ts}{oecosimu}(x, ...)
\method{as.mcmc}{oecosimu}(x)
\method{density}{oecosimu}(x, ...)
\method{densityplot}{oecosimu}(x, data, xlab = "Simulated", ...)
}

\arguments{
  \item{comm}{Community data.}
  \item{x}{Community data for \code{commsimulator}, or an \code{oecosimu}
    result object for \code{as.ts}, \code{as.mcmc}, \code{density} and 
    \code{densityplot}.}
  \item{nestfun}{Function to analyse nestedness. Some functions are
  provided in \pkg{vegan}, but any function can be used if it accepts the
  community as the first argument, and returns either a plain number or
  the result in list item with the name defined in argument
  \code{statistic}. See Examples for defining your own functions.}
  \item{method}{Null model method. See details.}
  \item{nsimul}{Number of simulated null communities.}
  \item{burnin}{Number of null communities discarded before proper
  analysis in sequential methods \code{"swap"} and \code{"tswap"}.}
  \item{thin}{Number of discarded null communities between two
  evaluations of nestedness statistic in sequential methods
  \code{"swap"} and \code{"tswap"}.}
  \item{statistic}{The name of the statistic returned by
    \code{nestedfun}} 
  \item{alternative}{a character string specifying the alternative
    hypothesis, must be one of \code{"two.sided"} (default), \code{"greater"}
    or \code{"less"}. Please note that the \eqn{p}-value of two-sided
    test is approximately two times higher than in the corresponding
    one-sided test (\code{"greater"} or \code{"less"} depending on the
    sign of the difference).}
  \item{data}{Ignored argument of the generic function.}
  \item{xlab}{Label of the x-axis.}
  \item{\dots}{Other arguments to functions.}
}

\details{
  
  Function \code{oecosimu} is a wrapper that evaluates a nestedness
  statistic using function given by \code{nestfun}, and then simulates
  a series of null models using \code{commsimulator} or other
  functions (depending on method argument), and evaluates the
  statistic on these null models. The \pkg{vegan} packages contains
  some nestedness functions that are described separately
  (\code{\link{nestedchecker}}, \code{\link{nesteddisc}},
  \code{\link{nestedn0}}, \code{\link{nestedtemp}}), but many other
  functions can be used as long as they are meaningful with binary or
  quantitative community models.  An applicable function must return
  either the statistic as a plain number, or as a list element
  \code{"statistic"} (like \code{\link{chisq.test}}), or in an item
  whose name is given in the argument \code{statistic}.  The statistic
  can be a single number (like typical for a nestedness index), or it
  can be a vector. The vector indices can be used to analyse site
  (row) or species (column) properties, see \code{\link{treedive}} for
  an example. Raup-Crick index (\code{\link{raupcrick}}) gives an
  example of using a dissimilarities index.

  Function \code{commsimulator} implements binary (presence/absence) 
  null models for community composition.
  The implemented models are \code{r00} which maintains the
  number of presences but fills these anywhere so that neither species
  (column) nor site (row) totals are preserved. Methods \code{r0},
  \code{r1} and \code{r2} maintain the site (row) frequencies. Method \code{r0}
  fills presences anywhere on the row with no respect to species (column)
  frequencies, \code{r1} uses column marginal 
  frequencies as probabilities, and \code{r2} uses squared column
  sums. Methods \code{r1} and \code{r2} try to simulate original species
  frequencies, but they are not strictly constrained. All these methods
  are reviewed by Wright et al. (1998). Method \code{c0} maintains
  species frequencies, but does not honour site (row) frequencies (Jonsson
  2001).

  The other methods maintain both row and column frequencies.
  Methods \code{swap} and \code{tswap} implement sequential methods,
  where the matrix is changed only little in one step, but the changed
  matrix is used as an input if the next step.
  Methods \code{swap} and \code{tswap} inspect random 2x2 submatrices
  and if they are checkerboard units, the order of columns is
  swapped. This changes the matrix structure, but does not influence
  marginal sums (Gotelli & Entsminger
  2003). Method \code{swap} inspects submatrices so long that a swap
  can be done. \enc{Miklós}{Miklos} & Podani (2004) suggest that this may lead into
  biased sequences, since some columns or rows may be more easily
  swapped, and they suggest trying a fixed number of times and
  doing zero to many swaps at one step. This method is implemented by
  method \code{tswap} or trial swap. Function \code{commsimulator} makes
  only one trial swap in time (which probably does nothing),
  but \code{oecosimu} estimates how many
  submatrices are expected before finding a swappable checkerboard,
  and uses that ratio to thin the results, so that on average one swap
  will be found per step of \code{tswap}.  However, the checkerboard
  frequency probably changes during swaps, but this is not taken into
  account in estimating the \code{thin}.  One swap still changes the
  matrix only little, and it may be useful to 
  thin the results so that the statistic is only evaluated after
  \code{burnin} steps (and \code{thin}ned). 

  Methods \code{quasiswap} and \code{backtracking} are not sequential,
  but each call produces a matrix that is independent of previous
  matrices, and has the same marginal totals as the original data. The
  recommended method is \code{quasiswap} which is much faster because
  it is implemented in C. Method \code{backtracking} is provided for
  comparison, but it is so slow that it may be dropped from future
  releases of \pkg{vegan} (or also implemented in C).
  Method \code{quasiswap} (\enc{Miklós}{Miklos} & Podani 2004)
  implements a method where matrix is first filled 
  honouring row and column totals, but with integers that may be larger than
  one. Then the method inspects random 2x2 matrices and performs a
  quasiswap on them. Quasiswap is similar to ordinary swap, but it also
  can reduce numbers above one to ones maintaining marginal
  totals.
  Method \code{backtracking}
  implements a filling method with constraints both for row and column
  frequencies (Gotelli & Entsminger 2001). The matrix is first filled
  randomly using row and column frequencies as probabilities. Typically
  row and column sums are reached before all incidences are filled in.
  After that begins \dQuote{backtracking}, where some of the
  points are removed, and then filling is started again, and this
  backtracking is done so may times that all incidences will be filled
  into matrix. The \code{quasiswap} method is not sequential, but it produces
  a random incidence matrix with given marginal totals. 

  Function \code{as.ts} transforms the simulated results of sequential
  methods into a time series or a \code{\link{ts}} object. This allows
  using analytic tools for time series in studying the sequences (see
  examples). Function \code{as.mcmc} transforms the simulated results
  of sequential methods into an \code{\link[coda]{mcmc}} object of the
  \pkg{coda} package. The \pkg{coda} package provides functions for
  the analysis of stationarity, adequacy of sample size,
  autocorrelation, need of burn-in and much more for sequential
  methods. Please consult the documentation of \pkg{coda} package.

  Function \code{density} provides an interface to the
  standard \code{\link{density}} function for the simulated
  values. Function \code{densityplot} is an interface to the
  \code{\link[lattice]{densityplot}} function of the \pkg{lattice}
  package. The \code{density} can be used meaningfully only for single
  statistics and must be plotted separately. The \code{densityplot}
  function can handle multiple statistics, and it plots the results
  directly. In addition to the density, the \code{densityplot} also
  shows the observed value of the statistic (provided it is within the
  graph limits). The \code{densityplot} function is defined as a
  generic function in the \pkg{lattice} package and you must either
  load the \pkg{lattice} library before calling \code{densityplot}, or
  use the longer form \code{densityplot.oecosimu} when you first time
  call the function.

  As a result of \code{method = "r2dtable"} in \code{oecosimu}, quantitative
  community null models are used to evaluate the statistic. This setting uses
  the \code{\link{r2dtable}} function to generate random matrices with fixed
  row and column totals (hypergeometric distribution). This null model is
  used in diversity partitioning function (see \code{\link{adipart}}).

  The \code{method} argument can be a function with first argument taking the 
  community matrix, and optionally with \code{burnin} and \code{thin} argument.
  The function must return a matrix-like object with same dimensions.
  But be careful, blindly applying permuted matrices for null model testing
  can be dangerous.
}

\value{ 
  Function \code{oecosimu} returns the result of \code{nestfun} added
  with a component called \code{oecosimu}. The \code{oecosimu}
  component contains the simulated values of the statistic (item
  \code{simulated}), the name of the \code{method}, \eqn{P} value
  (with given \code{alternative}), \eqn{z}-value of the statistic
  based on simulation (also known as standardized effect size), and
  the mean of simulations.  
}

\references{
  Gotelli, N.J. & Entsminger, N.J. (2001). Swap and fill algorithms in
  null model analysis: rethinking the knight's tour. \emph{Oecologia}
  129, 281--291.

  Gotelli, N.J. & Entsminger, N.J. (2003). Swap algorithms in null model
  analysis. \emph{Ecology} 84, 532--535.

  Jonsson, B.G. (2001) A null model for randomization tests of
  nestedness in species assemblages. \emph{Oecologia} 127, 309--313.

  \enc{Miklós}{Miklos}, I. & Podani, J. (2004). Randomization of presence-absence
  matrices: comments and new algorithms. \emph{Ecology} 85, 86--92.

  Wright, D.H., Patterson, B.D., Mikkelson, G.M., Cutler, A. & Atmar,
  W. (1998). A comparative analysis of nested subset patterns of species
  composition. \emph{Oecologia} 113, 1--20.
  }
\author{ Jari Oksanen }
\note{
  Functions \code{commsimulator} and \code{oecosimu} do not have
  default \code{nestfun} nor default \code{method}, because there is
  no clear natural choice. If you use these methods, you must be able
  to choose your own strategy. The choice of nestedness index is
  difficult because the functions seem to imply very different
  concepts of structure and randomness. The choice of swapping method
  is also problematic. Method \code{r00} has some heuristic value of
  being really random. However, it produces null models which are
  different from observed communities in most respects, and a
  \dQuote{significant} result may simply mean that not all species are
  equally common (\code{r0} is similar with this respect). It is also
  difficult to find justification for \code{r2}. The methods
  maintaining both row and column totals only study the community
  relations, but they can be very slow. Moreover, they regard marginal
  totals as constraints instead of results of occurrence patterns. You
  should evaluate timings in small trials (one cycle) before launching
  an extensive simulation. One swap is fast, but it changes data only
  little, and you may need long \code{burnin} and strong
  \code{thin}ning in large matrices. You should plot the simulated
  values to see that they are more or less stationary and there is no
  trend. Method \code{quasiswap} is implemented
  in C and it is much faster than \code{backtrack}.  Method
  \code{backtrack} may be removed from later releases of \pkg{vegan}
  because it is slow, but it is still included for comparison.

  If you wonder about the name of \code{oecosimu}, look at journal
  names in the References (and more in \code{\link{nestedtemp}}).  }

\seealso{ \code{\link{r2dtable}} generates table with given marginals but
  with entries above one. Functions \code{\link{permatfull}} and
  \code{\link{permatswap}} generate Null models for count data.
  Function \code{\link[labdsv]{rndtaxa}}
  (\pkg{labdsv} package) randomizes a community table. See also
  \code{\link{nestedtemp}} (that also discusses other nestedness
  functions) and \code{\link{treedive}} for another application. }
\examples{
## Use the first eigenvalue of correspondence analysis as an index
## of structure: a model for making your own functions.
data(sipoo)
## Traditional nestedness statistics (number of checkerboard units)
oecosimu(sipoo, nestedchecker, "r0")
## sequential model, one-sided test, a vector statistic
out <- oecosimu(sipoo, decorana, "swap", burnin=100, thin=10, 
   statistic="evals", alt = "greater")
out
## Inspect the swap sequence as a time series object
plot(as.ts(out))
lag.plot(as.ts(out))
acf(as.ts(out))
## Density plot
densityplot(out, as.table = TRUE)
## Use quantitative null models to compare
## mean Bray-Curtis dissimilarities
data(dune)
meandist <- function(x) mean(vegdist(x, "bray"))
mbc1 <- oecosimu(dune, meandist, "r2dtable")
mbc1
## Define a custom function that shuffles
## cells in each rows
f <- function(x) {
    apply(x, 2, function(z) sample(z, length(z)))
}
mbc2 <- oecosimu(as.matrix(dune), meandist, f)
mbc2
}
\keyword{ multivariate }
\keyword{ datagen }


