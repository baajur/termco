% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tidy_counts.R
\name{tidy_counts}
\alias{tidy_counts}
\title{Convert `term_count` & `token_count` to Tidy Form}
\usage{
tidy_counts(x, ...)
}
\arguments{
\item{x}{A `term_count` object.}

\item{\ldots}{ignored.}
}
\value{
Returns a tibble with tags and counts in long form (retains all other
variables in the `term_count` object.
}
\description{
Converts a wide matrix of counts to tidy form (tags are stretched long-wise
with corresponding counts of tags).
}
\note{
\code{n.words} or \code{n.tokens} will be repeated for each row element
id (\code{element_id}) and thus are nested.
}
\examples{
## On term counts
discoure_markers <- list(
    AA__response_cries = c("\\\\boh", "\\\\bah", "\\\\baha", "\\\\bouch", "yuk"),
    AA__back_channels = c("uh[- ]huh", "uhuh", "yeah"),
    BB__summons = "\\\\bhey",
    CC__justification = "because"
)

terms1 <- with(presidential_debates_2012,
    term_count(dialogue, TRUE, discoure_markers)
)

tidy_counts(terms1)


terms2 <- with(presidential_debates_2012,
    term_count(dialogue, list(person, time), discoure_markers)
)

tidy_counts(terms2)


## On token count
library(dplyr)
token_list <- lexicon::nrc_emotions \%>\%
    textshape::column_to_rownames() \%>\%
    t() \%>\%
    textshape::as_list()

token1 <- presidential_debates_2012 \%>\%
     with(token_count(dialogue, TRUE, token_list))

tidy_counts(token1)


token2 <- presidential_debates_2012 \%>\%
     with(token_count(dialogue, list(person, time), token_list))

tidy_counts(token2)
}
\keyword{tidy}
