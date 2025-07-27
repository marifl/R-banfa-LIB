test_that("rprj_add_template creates template file", {
  # Create temporary template directory
  temp_dir <- tempdir()
  old_home <- Sys.getenv("HOME")
  Sys.setenv(HOME = temp_dir)
  
  tryCatch({
    # Create template content
    content <- c(
      "Version: 1.0",
      "",
      "RestoreWorkspace: No",
      "SaveWorkspace: No"
    )
    
    # Add template
    result <- rprj_add_template("test_template", content = content)
    
    # Check that template file was created
    expect_true(file.exists(result))
    
    # Check content
    saved_content <- readLines(result)
    expect_equal(saved_content, content)
    
    # List templates should include the new one
    templates <- rprj_list_templates()
    expect_true(any(grepl("test_template", templates)))
    
    # Clean up
    unlink(dirname(result), recursive = TRUE)
  }, finally = {
    Sys.setenv(HOME = old_home)
  })
})

test_that("rprj_edit_template modifies templates", {
  # Create temporary home
  temp_home <- tempdir()
  old_home <- Sys.getenv("HOME")
  Sys.setenv(HOME = temp_home)
  
  tryCatch({
    # Setup and add a template
    rprj_setup(verbose = FALSE)
    rprj_add_template("test", content = c("Version: 1.0", "Test: Yes"))
    
    # Edit the template
    new_content <- c("Version: 2.0", "Test: No")
    rprj_edit_template("test", content = new_content)
    
    # Verify changes
    template_file <- file.path(get_user_template_dir(), "test.Rproj")
    actual_content <- readLines(template_file)
    expect_equal(actual_content, new_content)
  }, finally = {
    Sys.setenv(HOME = old_home)
  })
})

test_that("rprj_delete_template removes templates", {
  # Create temporary home
  temp_home <- tempdir()
  old_home <- Sys.getenv("HOME")
  Sys.setenv(HOME = temp_home)
  
  tryCatch({
    # Setup and add a template
    rprj_setup(verbose = FALSE)
    rprj_add_template("to_delete", content = c("Version: 1.0"))
    
    # Verify it exists
    expect_true(any(grepl("to_delete", rprj_list_templates())))
    
    # Delete it
    rprj_delete_template("to_delete", confirm = FALSE)
    
    # Verify it's gone
    expect_false(any(grepl("to_delete", rprj_list_templates())))
  }, finally = {
    Sys.setenv(HOME = old_home)
  })
})