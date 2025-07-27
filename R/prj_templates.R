#' List available project templates
#'
#' Shows all available templates that can be used with \code{rprj_init()}.
#' This includes both built-in templates and user-defined templates.
#'
#' @return A character vector of template names.
#'
#' @export
#'
#' @examples
#' # List all available templates
#' rprj_list_templates()
rprj_list_templates <- function() {
  templates <- character()
  
  # Get package templates
  pkg_template_dir <- system.file("templates", package = "banfa")
  if (pkg_template_dir != "" && fs::dir_exists(pkg_template_dir)) {
    pkg_templates <- fs::dir_ls(pkg_template_dir, glob = "*.Rproj")
    pkg_templates <- fs::path_ext_remove(fs::path_file(pkg_templates))
    templates <- c(templates, pkg_templates)
  }
  
  # Get user templates
  user_template_dir <- get_user_template_dir()
  if (fs::dir_exists(user_template_dir)) {
    user_templates <- fs::dir_ls(user_template_dir, glob = "*.Rproj")
    user_templates <- fs::path_ext_remove(fs::path_file(user_templates))
    templates <- c(templates, paste0(user_templates, " (user)"))
  }
  
  if (length(templates) == 0) {
    cli::cli_alert_info("No templates found. Use {.fn rprj_add_template} to add custom templates.")
    return(invisible(character()))
  }
  
  unique(templates)
}

#' Add a custom project template
#'
#' Adds a custom .Rproj template that can be used with \code{rprj_init()}.
#' Templates can include placeholders like \{\{project_name\}\} that will be
#' replaced when creating a new project.
#'
#' @param name Character string. Name for the template.
#' @param file Character string. Path to an existing .Rproj file to use as template.
#'   If NULL, creates a template interactively.
#' @param content Character vector. Content of the template. Used only if file is NULL.
#'
#' @return Invisibly returns the path to the created template file.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Add a template from an existing .Rproj file
#' rprj_add_template("my_template", file = "path/to/existing.Rproj")
#'
#' # Create a template with specific content
#' content <- c(
#'   "Version: 1.0",
#'   "",
#'   "RestoreWorkspace: No",
#'   "SaveWorkspace: No",
#'   "AlwaysSaveHistory: No",
#'   "",
#'   "EnableCodeIndexing: Yes"
#' )
#' rprj_add_template("minimal", content = content)
#' }
rprj_add_template <- function(name, file = NULL, content = NULL) {
  # Validate name
  if (!grepl("^[a-zA-Z0-9_-]+$", name)) {
    rlang::abort("Template name must contain only letters, numbers, underscores, and hyphens.")
  }
  
  # Ensure user template directory exists
  user_template_dir <- get_user_template_dir()
  if (!fs::dir_exists(user_template_dir)) {
    fs::dir_create(user_template_dir, recurse = TRUE)
  }
  
  # Get content
  if (!is.null(file)) {
    if (!fs::file_exists(file)) {
      rlang::abort(paste0("File not found: ", file))
    }
    template_content <- readLines(file)
  } else if (!is.null(content)) {
    template_content <- content
  } else {
    # Interactive mode
    cli::cli_alert_info("Creating template interactively...")
    template_content <- create_template_interactive()
  }
  
  # Save template
  template_file <- fs::path(user_template_dir, paste0(name, ".Rproj"))
  writeLines(template_content, template_file)
  
  cli::cli_alert_success("Template '{name}' saved successfully!")
  cli::cli_alert_info("Use it with: {.code rprj_init(template = \"{name}\")}")
  
  invisible(template_file)
}

#' Create template interactively
#'
#' @return Character vector with template content
#'
#' @keywords internal
create_template_interactive <- function() {
  cli::cli_h3("R Project Template Creator")
  
  # Basic template structure
  template <- c(
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
    "LaTeX: pdfLaTeX"
  )
  
  # Ask for common customizations
  if (interactive()) {
    cli::cli_alert_info("Customize your template (press Enter for defaults):")
    
    restore <- readline("RestoreWorkspace [Default/Yes/No]: ")
    if (restore != "") template[3] <- paste0("RestoreWorkspace: ", restore)
    
    save <- readline("SaveWorkspace [Default/Yes/No]: ")
    if (save != "") template[4] <- paste0("SaveWorkspace: ", save)
    
    history <- readline("AlwaysSaveHistory [Default/Yes/No]: ")
    if (history != "") template[5] <- paste0("AlwaysSaveHistory: ", history)
    
    spaces <- readline("Number of spaces for tab [2]: ")
    if (spaces != "" && !is.na(as.numeric(spaces))) {
      template[9] <- paste0("NumSpacesForTab: ", spaces)
    }
  }
  
  template
}