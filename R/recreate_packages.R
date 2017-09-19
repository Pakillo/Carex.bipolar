
#' Recreate packages
#'
#' Recreate dependencies (packages) used in the project as they were in a specified date.
#'
#' @param date character. Date ("YYYY-MM-DD" format). This will be used by \code{checkpoint} to download the corresponding package versions from CRAN for that date. Packages will be downloaded to a local folder ("~/.checkpoint) and these specific versions will be used for the session (Note that restarting the session will reset to the normal user library).
#'
#' @export
#' @importFrom checkpoint checkpoint

recreate_packages <- function(date = "2017-09-19") {

  ## Load CRAN packages: versions for the specified date
  checkpoint::checkpoint(snapshotDate = date, use.knitr = TRUE)

  ## Now install other external packages (not on CRAN)
  ## NB. pkgs installed to .libPaths() = "~/.checkpoint"
  ## so this doesn't mess with local user library
  install.packages("dependencies/rSDM_0.3.7.tar.gz", repos = NULL, type = "source")


}



#' Delete packages library
#'
#' Delete special packages library created by \code{\link{recreate_packages}}: "~/.checkpoint".
#'
#' @export
#'
delete_packages <- function() {

  unlink("~/.checkpoint", recursive = FALSE)

}
