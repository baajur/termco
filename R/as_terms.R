#' Convert a Count Matrix to List of Term Vectors
#'
#' Convert a count matrix to a named list of term vectors.
#'
#' @param x A \code{\link[base]{data.frame}}/\code{\link[base]{matrix}} of counts.
#' @param names A character vector of names to assign to the list.
#' @param \ldots ignored.
#' @return Returns a list of term vectors.
#' @export
#' @examples
#' data(markers)
#' as_terms(markers)
as_terms <- function(x, names = NULL, ...) {

    val <- validate_term_count(x)

    terms <- ifelse(inherits(x, 'token_count'), "token.vars", "term.vars")
    nwords <- ifelse(inherits(x, 'token_count'), "n.tokens", "n.words")

    if (isTRUE(val)) {
        term.vars <- attributes(x)[[terms]]
        if (is.null(names)) names <- paste2(x[, attributes(x)[["group.vars"]], drop=FALSE], ...)
        x <- x[, attributes(x)[[terms]], drop=FALSE]
    } else {
         if (is.null(names)) names <- rownames(x)
         term.vars <- NULL
    }
    nms <- colnames(x)
	lst <- apply(x, 1, function(y) rep(nms, y))

    if (nrow(x) == 1) lst <- list(c(lst))
    if (!is.list(lst) & is.atomic(lst)) lst <- as.list(lst)
    if(!is.list(lst)) lst <- lapply(1:ncol(lst), function(i) lst[, i])
    out <- stats::setNames(lst, nm = names)

    class(out) <- c('as_terms', class(out))

    attributes(out)[["term.vars"]] <- term.vars
    out
}



#' Prints an as_terms Object
#'
#' Prints an as_terms object.
#'
#' @param x The as_terms object.
#' @param \ldots ignored
#' @method print as_terms
#' @export
print.as_terms <- function(x, ...) {
    x <- rm_class(x, "as_terms")
    attributes(x)[["term.vars"]] <- NULL
    print(x)
}

