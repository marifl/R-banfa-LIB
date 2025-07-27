test_that("rprj_init requires setup", {
  # Create temporary home to isolate test
  temp_home <- tempdir()
  old_home <- Sys.getenv("HOME")
  Sys.setenv(HOME = temp_home)
  
  tryCatch({
    # Try to init without setup
    expect_null(rprj_init(path = file.path(temp_home, "test")))
    
    # Now run setup
    expect_true(rprj_setup(verbose = FALSE))
    
    # Now init should work
    test_proj <- file.path(temp_home, "test_project")
    result <- rprj_init(path = test_proj, name = "test_proj")
    
    # Check that .Rproj file was created
    expect_true(file.exists(result))
    expect_equal(basename(result), "test_proj.Rproj")
    
    # Clean up
    unlink(test_proj, recursive = TRUE)
  }, finally = {
    Sys.setenv(HOME = old_home)
  })
})

test_that("rprj_setup creates base template", {
  # Create temporary home
  temp_home <- tempdir()
  old_home <- Sys.getenv("HOME")
  Sys.setenv(HOME = temp_home)
  
  tryCatch({
    # Run setup
    expect_true(rprj_setup(verbose = FALSE))
    
    # Check that base template exists
    templates <- rprj_list_templates()
    expect_type(templates, "character")
    expect_true(any(grepl("base", templates)))
  }, finally = {
    Sys.setenv(HOME = old_home)
  })
})