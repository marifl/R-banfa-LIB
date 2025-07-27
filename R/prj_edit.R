#' Edit an existing project template
#'
#' Opens an existing template for editing or updates it with new content.
#'
#' @param name Character string. Name of the template to edit.
#' @param content Character vector. New content for the template. If NULL,
#'   the function will print the current content.
#' @param edit Logical. If TRUE and content is NULL, opens the template
#'   in the default editor (if in interactive mode).
#'
#' @return Invisibly returns the path to the template file.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # View template content
#' rprj_edit_template("base")
#'
#' # Update template content
#' new_content <- c("Version: 1.0", "", "RestoreWorkspace: No")
#' rprj_edit_template("base", content = new_content)
#'
#' # Open in editor (interactive mode only)
#' rprj_edit_template("base", edit = TRUE)
#' }
rprj_edit_template <- function(name, content = NULL, edit = FALSE) {
  # Check if template exists
  template_dir <- get_user_template_dir()
  template_file <- fs::path(template_dir, paste0(name, ".Rproj"))
  
  if (!fs::file_exists(template_file)) {
    available <- rprj_list_templates()
    rlang::abort(c(
      paste0("Template '", name, "' not found."),
      i = "Available templates:",
      paste0("  - ", available)
    ))
  }
  
  # If content provided, update the template
  if (!is.null(content)) {
    writeLines(content, template_file)
    cli::cli_alert_success("Updated template: {.file {name}}")
    return(invisible(template_file))
  }
  
  # If edit mode and interactive, open in editor
  if (edit && interactive()) {
    if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
      rstudioapi::navigateToFile(template_file)
    } else {
      utils::file.edit(template_file)
    }
    return(invisible(template_file))
  }
  
  # Otherwise, display content
  current_content <- readLines(template_file)
  cli::cli_h3("Template: {name}")
  cli::cli_code(current_content)
  
  invisible(template_file)
}

#' Delete a project template
#'
#' Removes a template from the user's template directory.
#'
#' @param name Character string. Name of the template to delete.
#' @param confirm Logical. Ask for confirmation before deleting? Default is TRUE.
#'
#' @return Invisibly returns TRUE if deletion was successful.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Delete a template with confirmation
#' rprj_delete_template("old_template")
#'
#' # Delete without confirmation
#' rprj_delete_template("old_template", confirm = FALSE)
#' }
rprj_delete_template <- function(name, confirm = TRUE) {
  # Check if template exists
  template_dir <- get_user_template_dir()
  template_file <- fs::path(template_dir, paste0(name, ".Rproj"))
  
  if (!fs::file_exists(template_file)) {
    cli::cli_alert_danger("Template '{name}' not found")
    return(invisible(FALSE))
  }
  
  # Confirm deletion
  if (confirm && interactive()) {
    response <- utils::menu(
      c("Yes", "No"),
      title = paste0("Are you sure you want to delete template '", name, "'?")
    )
    if (response != 1) {
      cli::cli_alert_info("Deletion cancelled")
      return(invisible(FALSE))
    }
  }
  
  # Delete the template
  fs::file_delete(template_file)
  cli::cli_alert_success("Deleted template: {.file {name}}")
  
  invisible(TRUE)
}