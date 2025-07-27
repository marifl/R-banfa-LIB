#' Initialize a new R project
#'
#' Creates a new R project with a .Rproj file based on a template.
#'
#' @param path Character string. Path where the project should be created.
#'   If NULL (default), uses the current directory.
#' @param name Character string. Name of the project. If NULL (default),
#'   uses the directory name.
#' @param template Character string. Name of the template to use.
#'   Default is "default". Use \code{rprj_list_templates()} to see available templates.
#' @param open Logical. Should the project be opened in RStudio after creation?
#'   Default is FALSE.
#'
#' @return Invisibly returns the path to the created .Rproj file.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Create a project in the current directory
#' rprj_init()
#'
#' # Create a project with a specific name
#' rprj_init(name = "my_analysis")
#'
#' # Create a project in a specific directory
#' rprj_init(path = "~/projects/new_project", name = "awesome_project")
#'
#' # Use a custom template
#' rprj_init(template = "shiny_app")
#' }
rprj_init <- function(path = NULL, name = NULL, template = "base", open = FALSE) {
  # Check if banfa is set up
  if (!is_banfa_setup()) {
    cli::cli_alert_danger("No templates found. Please run {.fn rprj_setup} first.")
    cli::cli_alert_info("Or create a template with {.fn rprj_add_template}")
    return(invisible(NULL))
  }
  # Use current directory if path not specified
  if (is.null(path)) {
    path <- getwd()
  }
  
  # Create directory if it doesn't exist
  if (!fs::dir_exists(path)) {
    fs::dir_create(path, recurse = TRUE)
    cli::cli_alert_success("Created directory: {.path {path}}")
  }
  
  # Determine project name
  if (is.null(name)) {
    name <- basename(path)
  }
  
  # Load template
  template_content <- load_template(template)
  
  # Replace placeholders in template
  # Join content, replace placeholders, then split again
  template_text <- paste(template_content, collapse = "\n")
  template_text <- glue::glue(template_text, 
                              project_name = name,
                              .open = "{{", 
                              .close = "}}")
  template_content <- strsplit(as.character(template_text), "\n")[[1]]
  
  # Create .Rproj file
  rproj_file <- fs::path(path, paste0(name, ".Rproj"))
  writeLines(template_content, rproj_file)
  
  cli::cli_alert_success("Created R project: {.file {rproj_file}}")
  
  # Open in RStudio if requested
  if (open && requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
    rstudioapi::openProject(path)
  }
  
  invisible(rproj_file)
}

#' Load a project template
#'
#' @param template_name Character string. Name of the template to load.
#'
#' @return Character vector containing the template content.
#'
#' @keywords internal
load_template <- function(template_name) {
  # First check user templates
  user_template_dir <- get_user_template_dir()
  user_template_file <- fs::path(user_template_dir, paste0(template_name, ".Rproj"))
  
  if (fs::file_exists(user_template_file)) {
    return(readLines(user_template_file))
  }
  
  # Then check package templates
  pkg_template_file <- system.file(
    "templates",
    paste0(template_name, ".Rproj"),
    package = "banfa"
  )
  
  if (pkg_template_file != "" && fs::file_exists(pkg_template_file)) {
    return(readLines(pkg_template_file))
  }
  
  # If template not found, show available templates and error
  available <- rprj_list_templates()
  rlang::abort(c(
    paste0("Template '", template_name, "' not found."),
    i = "Available templates:",
    paste0("  - ", available)
  ))
}

#' Get user template directory
#'
#' @return Path to user template directory
#'
#' @keywords internal
get_user_template_dir <- function() {
  fs::path(rappdirs::user_data_dir("banfa"), "templates")
}