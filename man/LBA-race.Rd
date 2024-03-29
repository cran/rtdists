% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lba_race.R
\name{LBA-race}
\alias{LBA-race}
\alias{n1PDF}
\alias{n1CDF}
\title{LBA race functions: Likelihood for first accumulator to win.}
\usage{
n1PDF(rt, A, b, t0, ..., st0 = 0, distribution = c("norm", "gamma",
  "frechet", "lnorm"), args.dist = list(), silent = FALSE)

n1CDF(rt, A, b, t0, ..., st0 = 0, distribution = c("norm", "gamma",
  "frechet", "lnorm"), args.dist = list(), silent = FALSE)
}
\arguments{
\item{rt}{a vector of RTs.}

\item{A, b, t0}{LBA parameters, see \code{\link{LBA}}. Can either be a single
numeric vector (which will be recycled to reach \code{length(rt)} for
trialwise parameters) \emph{or} a \code{list} of such vectors in which each
list element corresponds to the parameters for this accumulator (i.e., the
list needs to be of the same length as there are accumulators). Each list
will also be recycled to reach \code{length(rt)} for trialwise parameters
per accumulator.}

\item{...}{two \emph{named} drift rate parameters depending on
\code{distribution} (e.g., \code{mean_v} and \code{sd_v} for
\code{distribution=="norm"}). The parameters can either be given as a
numeric vector or a list. If a numeric vector is passed each element of the
vector corresponds to one accumulator. If a list is passed each list
element corresponds to one accumulator allowing again trialwise driftrates.
The shorter parameter will be recycled as necessary (and also the elements
of the list to match the length of \code{rt}). See examples.}

\item{st0}{parameter specifying the variability of \code{t0} (which varies
uniformly from \code{t0} to \code{t0} + \code{st0}). Can be trialwise, and
will be recycled to length of \code{rt}.}

\item{distribution}{character specifying the distribution of the drift rate.
Possible values are \code{c("norm", "gamma", "frechet", "lnorm")}, default
is \code{"norm"}.}

\item{args.dist}{list of optional further arguments to the distribution
functions (i.e., \code{posdrift} or \code{robust} for
\code{distribution=="norm"}).}

\item{silent}{logical. Should the number of accumulators used be suppressed?
Default is \code{FALSE} which prints the number of accumulators.}
}
\description{
n1PDF and n1CDF take RTs, the distribution functions of the \link{LBA}, and
corresponding parameter values and put them throughout the race equations and
return the likelihood for the first accumulator winning (hence n1) in a set
of accumulators.
}
\details{
For a set of \eqn{N} independent accumulators \eqn{i = 1...N}, the
  race likelihood for a given accumulator \eqn{i} is given by 
  \deqn{L(\mbox{unit }i \mbox{ wins}) = f_i(t) \times \prod_{j<>i} [ S_j(t)
  ]}{L(unit i wins) = f_i(t) * prod_j<>i [ S_j(t) ]} where \eqn{f(t)} is the
  PDF (\code{dlba_...}) and \eqn{S_j(t) = 1 - F_j(t)} is the survivor
  function, that is the complement of the CDF \eqn{F(t)} (\code{plba_...}) at
  time \eqn{t}.
  
  In other words, this is just the PDF/CDF for the winning accumulator at
  time \eqn{t} times the probability that no other accumulators have finished
  at time \eqn{t}.
}
\examples{


## check random generated values against race functions:

## 1. Without st0:
r_lba <- rLBA(1e4, A=0.5, b=1, t0 = 0.5, mean_v=c(1.2, 1), sd_v=0.2)
x <- seq(0.5, 4, length.out = 100) # for plotting
# PDF
y <- n1PDF(x, A=0.5, b=1, t0 = 0.5, mean_v=c(1.2, 1.0), sd_v=0.2) # PDF
hist(r_lba$rt[r_lba$response==1],probability = TRUE, breaks = "FD")
lines(x=x,y=y/mean(r_lba$response == 1))
# CDF
plot(ecdf(r_lba$rt[r_lba$response==1]))
y <- n1CDF(x, A=0.5, b=1, t0 = 0.5, st0 = 0, mean_v=c(1.2, 1.0), sd_v=0.2)
lines(x=x,y=y/mean(r_lba$response == 1), col = "red", lwd = 4.5, lty = 2)
# KS test
\dontrun{
normalised_n1CDF = function(rt,...) n1CDF(rt,...)/n1CDF(rt=Inf,...) 
ks.test(r_lba$rt[r_lba$response==1], normalised_n1CDF, A=0.5, b=1, t0 = 0.5, 
        mean_v=c(1.2, 1.0), sd_v=0.2)
}

\dontrun{
## Other examples (don't run to save time):
  
## 2. With st0 = 0.2:
r_lba <- rLBA(1e4, A=0.5, b=1, t0 = 0.5, st0 = 0.2, mean_v=c(1.2, 1), sd_v=0.2)
x <- seq(0.5, 4, length.out = 100) # for plotting
# PDF
y <- n1PDF(x, A=0.5, b=1, t0 = 0.5, st0 = 0.2, mean_v=c(1.2, 1.0), sd_v=0.2) # PDF
hist(r_lba$rt[r_lba$response==1],probability = TRUE, breaks = "FD")
lines(x=x,y=y/mean(r_lba$response == 1))
# CDF
plot(ecdf(r_lba$rt[r_lba$response==1]))
y <- n1CDF(x, A=0.5, b=1, t0 = 0.5, st0 = 0.2, mean_v=c(1.2, 1.0), sd_v=0.2)
lines(x=x,y=y/mean(r_lba$response == 1), col = "red", lwd = 4.5, lty = 2)
# KS test
normalised_n1CDF = function(rt,...) n1CDF(rt,...)/n1CDF(rt=Inf,...) 
ks.test(r_lba$rt[r_lba$response==1], normalised_n1CDF, A=0.5, b=1, t0 = 0.5, 
        st0 = 0.2, mean_v=c(1.2, 1.0), sd_v=0.2)


xx <- rLBA(10, A=0.5, b=1, t0 = 0.5, mean_v=1.2, sd_v=0.2)

# default uses normal distribution for drift rate:
n1PDF(xx$rt, A=0.5, b=1, t0 = 0.5, mean_v=c(1.2, 1.0), sd_v=0.2)

# other distributions:
n1PDF(xx$rt, A=0.5, b=1, t0 = 0.5, shape_v=c(1.2, 1), scale_v=c(0.2,0.3), distribution = "gamma")
n1PDF(xx$rt, A=0.5, b=1, t0 = 0.5, shape_v=c(1.2, 1), scale_v=c(0.2,0.3), distribution = "frechet")
n1PDF(xx$rt, A=0.5, b=1, t0 = 0.5, meanlog_v = c(0.5, 0.8), sdlog_v = 0.5, distribution = "lnorm")

# add st0:
n1PDF(xx$rt, A=0.5, b=1, t0 = 0.5, mean_v=c(1.2, 1.0), sd_v=0.2, st0 = 0.4)


# use different A parameters for each RT:
n1PDF(xx$rt, A=runif(10, 0.4, 0.6), 
      b=1, t0 = 0.5, mean_v=c(1.2, 1.0), sd_v=0.2)

# use different A parameters for each RT and each accumulator:
n1PDF(xx$rt, A=list(runif(10, 0.4, 0.6), runif(10, 0.2, 0.4)), 
      b=1, t0 = 0.5, mean_v=c(1.2, 1.0), sd_v=0.2)


### vectorize drift rates:

# vector versus list:
v1 <- n1PDF(xx$rt, A=0.5, b=1, t0 = 0.5, mean_v=c(1.2, 1.0), sd_v=0.2)
v2 <- n1PDF(xx$rt, A=0.5, b=1, t0 = 0.5, mean_v=list(1.2, 1.0), sd_v=0.2)
identical(v1, v2)  # TRUE

# drift rate per trial:
n1PDF(xx$rt, A=0.5, b=1, t0 = 0.5, mean_v=list(rnorm(10, 1.2), rnorm(10, 1)), sd_v=0.2)

# combine list with vector:
n1PDF(xx$rt, A=0.5, b=1, t0 = 0.5, mean_v=list(rnorm(10, 1.2), rnorm(10, 1)), sd_v=c(0.2, 0.1))

# t0 per trial and accumulator:
n1PDF(xx$rt, A=0.5, b=1, t0 = c(0.5), mean_v=c(1.2, 1.0), sd_v=0.2)
n1PDF(xx$rt, A=0.5, b=1, t0 = c(0.5, 0.6), mean_v=c(1.2, 1.0), sd_v=0.2) # per trial only
n1PDF(xx$rt, A=0.5, b=1, t0 = list(0.5, 0.6), mean_v=c(1.2, 1.0), sd_v=0.2) # per drift rate only
n1PDF(xx$rt, A=0.5, b=1, t0 = list(c(0.4, 0.5), c(0.5, 0.6)), mean_v=c(1.2, 1.0), sd_v=0.2)
}
}
\seealso{
For more user-friendly functions that return the PDF or CDF for the
  corresponding (and not first) accumulator winning see /code{/link{LBA}}.
}
