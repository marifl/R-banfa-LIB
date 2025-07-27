#' Set up banfa with initial templates
#'
#' Creates the initial base template for banfa after installation.
#' This function should be run once after installing the package.
#'
#' @param verbose Logical. Should setup messages be displayed? Default is TRUE.
#'
#' @return Invisibly returns TRUE if setup was successful.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Run after installing banfa
#' rprj_setup()
#' }
rprj_setup <- function(verbose = TRUE) {
  # Ensure user template directory exists
  template_dir <- get_user_template_dir()
  if (!fs::dir_exists(template_dir)) {
    fs::dir_create(template_dir, recurse = TRUE)
    if (verbose) {
      cli::cli_alert_success("Created template directory: {.path {template_dir}}")
    }
  }
  
  # Check if base template already exists
  base_template <- fs::path(template_dir, "base.Rproj")
  
  if (fs::file_exists(base_template)) {
    if (verbose) {
      cli::cli_alert_info("Base template already exists. Use {.fn rprj_edit_template} to modify it.")
    }
    return(invisible(TRUE))
  }
  
  # Create base template
  base_content <- c(
    "Version: 1.0",
    "",
    "RestoreWorkspace: Default",
    "SaveWorkspace: Default",
    "AlwaysSaveHistory: Default",
    "",
    "EnableCodeIndexing: Yes",
    "UseSpacesForTab: Yes",
    "NumSpacesForTab: 2",
    "Encoding: UTF-8",
    "",
    "RnwWeave: Sweave",
    "LaTeX: pdfLaTeX",
    "",
    "AutoAppendNewline: Yes",
    "StripTrailingWhitespace: Yes"
  )
  
  writeLines(base_content, base_template)
  
  if (verbose) {
    cli::cli_alert_success("Created base template: {.file {base_template}}")
    cli::cli_alert_info("You can now use {.code rprj_init()} to create projects")
    cli::cli_alert_info("Add more templates with {.fn rprj_add_template}")
  }
  
  invisible(TRUE)
}

#' Check if banfa is set up
#'
#' @return Logical. TRUE if at least one template exists.
#'
#' @keywords internal
is_banfa_setup <- function() {
  template_dir <- get_user_template_dir()
  if (!fs::dir_exists(template_dir)) {
    return(FALSE)
  }
  
  templates <- fs::dir_ls(template_dir, glob = "*.Rproj", fail = FALSE)
  length(templates) > 0
}