% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/token_count.R
\name{token_count}
\alias{token_count}
\title{Count Fixed Tokens}
\usage{
token_count(
  text.var,
  grouping.var = NULL,
  token.list,
  stem = FALSE,
  keep.punctuation = TRUE,
  pretty = ifelse(isTRUE(grouping.var), FALSE, TRUE),
  group.names,
  meta.sep = "__",
  meta.names = c("meta"),
  ...
)
}
\arguments{
\item{text.var}{The text string variable.}

\item{grouping.var}{The grouping variable(s).  Default \code{NULL} generates
one word list for all text.  Also takes a single grouping variable or a list
of 1 or more grouping variables.  If \code{TRUE} an \code{id} variable is
used with a \code{seq_along} the \code{text.var}.}

\item{token.list}{A list of named character vectors of tokens.  Search will
combine the counts for tokens supplied that are in the same vector.  Tokens
are defined as  \code{"^([a-z' ]+|[0-9.]+|[[:punct:]]+)$"} and should
conform to this standard.  `code{token_count} can be used in a hierarchical
fashion as well; that is a list of tokens that can be passed and counted and
then a second (or more) pass can be taken with a new set of tokens on only
those rows/text elements that were left untagged (count
\code{\link[base]{rowSums}} is zero).  This is accomplished by passing
a \code{\link[base]{list}} of \code{\link[base]{list}}s of search tokens.
See \bold{Examples} for the \strong{hierarchical tokens} section for a
demonstration.}

\item{stem}{logical.  If \code{TRUE} the search is done after the terms have
been stemmed.}

\item{keep.punctuation}{logical.  If \code{TRUE} the punctuation marks are
considered as tokens.}

\item{pretty}{logical.  If \code{TRUE} pretty printing is used.  Pretty
printing can be turned off globally by setting
\code{options(termco_pretty = FALSE)}.}

\item{group.names}{A vector of names that corresponds to group.  Generally
for internal use.}

\item{meta.sep}{A character separator (or character vector of separators) to
break up the term list names (tags) into that will generate an merge table
attribute on the output that has the supplied tags and meta + sub tags as
dictated by the separator breaks.}

\item{meta.names}{A vector of names corresponding to the meta tags generated
by \code{meta.sep}.}

\item{\ldots}{Other arguments passed to \code{\link[gofastr]{q_dtm}}.}
}
\value{
Returns a \code{\link[dplyr]{tbl_df}} object of term counts by
grouping variable.  Has all of the same features as a \code{term_count}
object, meaning functions that work on a \code{term_count} object will
operate on a a \code{token_count} object as well.
}
\description{
Count the occurrence of tokens within a vector of strings.  This function
differs from \code{\link[termco]{term_count}} in that \code{term_count} is
regex based, allowing for fuzzy matching.  This function only searches for
lower cased tokens (words, number sequences, or punctuation).  This counting
function is faster but less flexible.
}
\examples{
token_list <- list(
    person = c('sam', 'i'),
    place = c('here', 'house'),
    thing = c('boat', 'fox', 'rain', 'mouse', 'box', 'eggs', 'ham'),
    no_like = c('not like')
)

token_count(sam_i_am, grouping.var = TRUE, token.list = token_list)
token_count(sam_i_am, grouping.var = NULL, token.list = token_list)

\dontrun{
x <- presidential_debates_2012[["dialogue"]]

bigrams <- frequent_ngrams(x, gram.length = 2)$collocation
bigram_model <- token_count(x, TRUE, token.list = as_term_list(bigrams))
as_dtm(bigram_model)

if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, lexicon, textshape)

token_list <- lexicon::nrc_emotions \%>\%
    textshape::column_to_rownames() \%>\%
    t() \%>\%
    textshape::as_list()

presidential_debates_2012 \%>\%
     with(token_count(dialogue, TRUE, token_list))

presidential_debates_2012 \%>\%
     with(token_count(dialogue, list(person, time), token_list))

presidential_debates_2012 \%>\%
     with(token_count(dialogue, list(person, time), token_list)) \%>\%
     plot()
}

## hierarchical tokens
token_list <- list(
    list(
        person = c('sam', 'i')
    ),
    list(
        place = c('here', 'house'),
        thing = c('boat', 'fox', 'rain', 'mouse', 'box', 'eggs', 'ham')
    ),
    list(
        no_like = c('not like'),
        thing = c('train', 'goat')
    )
)

(x <- token_count(sam_i_am, grouping.var = TRUE, token.list = token_list))
attributes(x)[['pre_collapse_coverage']]

## External Dictionaries
\dontrun{
## dictionary from quanteda
require(quanteda); require(stringi); require(textreadr)

## Nadra Pencle and Irina Malaescu (2016) What's in the Words? Development and Validation of a
##   Multidimensional Dictionary for CSR and Application Using Prospectuses. Journal of Emerging
##   Technologies in Accounting: Fall 2016, Vol. 13, No. 2, pp. 109-127.

dict_corporate_social_responsibility <- "https://provalisresearch.com/Download/CSR.zip" \%>\%
    textreadr::download() \%>\%
    unzip(exdir = tempdir()) \%>\%
    `[`(1) \%>\%
    dictionary(file = .)

csr <- dict_corporate_social_responsibility \%>\%
    as_term_list() \%>\%
    lapply(function(x){
        x \%>\%
            stringi::stri_replace_all_fixed('_', ' ') \%>\%
            stringi::stri_replace_all_regex('\\\\s*\\\\(.+?\\\\)', '') \%>\%
            stringi::stri_replace_all_regex('[^ -~]', "'")
    })

presidential_debates_2012 \%>\%
     with(token_count(dialogue, list(time, person), csr)) \%>\%
     plot()

}
}
