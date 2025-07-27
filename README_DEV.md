# banfa Developer Documentation

Welcome to the banfa development guide! This document contains everything you need to know to contribute to the banfa R package.

## Table of Contents

1. [Development Setup](#development-setup)
2. [Project Structure](#project-structure)
3. [File Documentation](#file-documentation)
4. [Development Workflow](#development-workflow)
5. [Testing](#testing)
6. [Contributing Guidelines](#contributing-guidelines)
7. [Release Process](#release-process)

## Development Setup

### Required R Packages

Install all development dependencies:

```r
# Core development tools
install.packages(c(
  "devtools",     # Package development utilities
  "roxygen2",     # Documentation generation
  "testthat",     # Unit testing framework
  "usethis",      # Development helpers
  "pkgdown"       # Package website generation
))

# Package dependencies
install.packages(c(
  "cli",          # Beautiful command line interfaces
  "fs",           # File system operations
  "glue",         # String interpolation
  "rappdirs",     # User directories
  "rlang",        # Programming tools
  "optparse"      # CLI argument parsing
))

# Additional tools for CRAN submission
install.packages(c(
  "spelling",     # Spell checking
  "rhub",         # Cross-platform testing
  "available"     # Check package name availability
))
```

### System Requirements

- R >= 3.5.0
- RStudio (recommended)
- Git
- A terminal with bash support

### Initial Setup

1. Clone the repository:
```bash
git clone https://github.com/marifl/R-banfa-LIB.git
cd R-banfa-LIB/banfa
```

2. Install the package locally:
```r
devtools::install()
```

3. Load the package for development:
```r
devtools::load_all()
```

## Project Structure

```
banfa/
├── .github/
│   └── workflows/
│       └── R-CMD-check.yaml    # GitHub Actions CI/CD configuration
├── R/                           # R source code
│   ├── prj_init.R              # Main project initialization function
│   ├── prj_setup.R             # Setup and template creation
│   ├── prj_templates.R         # Template management functions
│   ├── prj_edit.R              # Template CRUD operations
│   └── zzz.R                   # Package startup hooks
├── inst/                        # Installed files
│   ├── bin/
│   │   └── rprj                # CLI executable script
│   └── WORDLIST                # Custom words for spell check
├── man/                         # Generated documentation (DO NOT EDIT)
│   └── *.Rd                    # roxygen2 generated help files
├── tests/                       # Test suite
│   ├── testthat.R              # Test runner
│   └── testthat/
│       ├── test-prj_init.R     # Tests for initialization
│       └── test-templates.R     # Tests for template management
├── DESCRIPTION                  # Package metadata
├── NAMESPACE                    # Export declarations
├── LICENSE                      # MIT license
├── NEWS.md                      # Version history
├── README.md                    # User documentation
├── README_DEV.md               # This file
├── .Rbuildignore               # Files to exclude from package
└── cran-comments.md            # Notes for CRAN submission
```

## File Documentation

### Core R Files

#### `R/prj_init.R`
**Purpose**: Main entry point for creating R projects  
**Key Functions**:
- `rprj_init()`: Creates a new R project with specified template
- `load_template()`: Internal function to load template files
- `get_user_template_dir()`: Gets user's template directory

**Modification Guidelines**:
- Keep backward compatibility when changing function signatures
- Update roxygen2 documentation for any parameter changes
- Ensure template placeholders (e.g., `{{project_name}}`) work correctly

#### `R/prj_setup.R`
**Purpose**: Initial setup and template creation  
**Key Functions**:
- `rprj_setup()`: Creates initial templates after installation
- `is_banfa_setup()`: Checks if banfa is configured

**Modification Guidelines**:
- Default templates should match RStudio conventions
- Keep setup process simple and user-friendly
- Consider adding new template types in `create_examples` parameter

#### `R/prj_templates.R`
**Purpose**: Template listing and creation  
**Key Functions**:
- `rprj_list_templates()`: Lists all available templates
- `rprj_add_template()`: Adds new custom templates
- `create_template_interactive()`: Interactive template creation

**Modification Guidelines**:
- Maintain clear separation between user and package templates
- Validate template names (alphanumeric, underscores, hyphens only)
- Keep template format compatible with RStudio

#### `R/prj_edit.R`
**Purpose**: Template CRUD operations  
**Key Functions**:
- `rprj_edit_template()`: View/edit existing templates
- `rprj_delete_template()`: Remove templates

**Modification Guidelines**:
- Always ask for confirmation on destructive operations
- Provide clear error messages when templates don't exist
- Support both programmatic and interactive usage

#### `R/zzz.R`
**Purpose**: Package startup configuration  
**Key Functions**:
- `.onAttach()`: Shows setup message for new users

**Modification Guidelines**:
- Keep startup messages brief and helpful
- Only show messages when action is needed

### CLI Script

#### `inst/bin/rprj`
**Purpose**: Command-line interface for banfa  
**Commands**:
- `setup`: Initialize banfa with templates
- `init`: Create new R project
- `list-templates`: Show available templates
- `add-template`: Add custom template
- `edit-template`: View/modify template
- `delete-template`: Remove template

**CLI to R Function Mapping**:
```
CLI Command                          → R Function Call
rprj setup                          → rprj_setup()
rprj setup --examples               → rprj_setup(create_examples = TRUE)
rprj init                           → rprj_init()
rprj init name                      → rprj_init(name = "name")
rprj init -t template               → rprj_init(template = "template")
rprj init -p path                   → rprj_init(path = "path")
rprj init -o                        → rprj_init(open = TRUE)
rprj list-templates                 → rprj_list_templates()
rprj add-template name -f file      → rprj_add_template("name", file = "file")
rprj edit-template name             → rprj_edit_template("name", edit = interactive())
rprj delete-template name -y        → rprj_delete_template("name", confirm = FALSE)
```

**Adding New Commands**:
1. Add the command to the help text in the beginning
2. Add a new `} else if (command == "your-command") {` block
3. Parse options using `optparse::OptionParser`
4. Call the corresponding R function with mapped parameters
5. Handle errors with informative messages

**Modification Guidelines**:
- Use optparse for consistent argument parsing
- Provide helpful error messages
- Keep CLI commands intuitive and Unix-like
- Always use the R function names with `rprj_` prefix when calling from CLI
- Support both long (`--option`) and short (`-o`) forms for common options
- Positional arguments (like project name) should come before options

### Configuration Files

#### `DESCRIPTION`
**Purpose**: Package metadata and dependencies  
**Modification Guidelines**:
- Update version number for releases (use semantic versioning)
- Keep dependencies minimal
- Update Authors@R when adding contributors
- Ensure all imported packages have version requirements

#### `NAMESPACE`
**Purpose**: Function exports and imports  
**Modification Guidelines**:
- Never edit manually - use `devtools::document()`
- Mark internal functions with `@keywords internal`
- Export only user-facing functions

## Development Workflow

### Quick Reference - After Every Change

```r
# The essential workflow (run these in order):
devtools::document()  # Update docs (if functions changed)
devtools::test()      # Run tests (quick)
devtools::check()     # Full check (do this before committing)
devtools::install()   # Install locally to test

# Git workflow
git add .
git commit -m "type: description"  # feat/fix/docs/test/refactor
git push
```

### 1. Making Changes (Detailed)

```r
# 1. Create a new branch
git checkout -b feature/your-feature-name

# 2. Make your changes
# Edit files as needed

# 3. Document your changes
devtools::document()

# 4. Run tests
devtools::test()

# 5. Check the package
devtools::check()

# 6. Install and test locally
devtools::install()
```

### Building and Using the Package Locally

#### Method 1: Direct Installation from Source (Recommended for Development)

```r
# From the banfa directory
devtools::install()

# Or from any directory, pointing to the package
devtools::install("/path/to/banfa")

# Now you can use it in any R project
library(banfa)
rprj_init()
```

#### Method 2: Build and Install Manually

```r
# Build the package tarball
devtools::build()
# This creates banfa_0.1.0.tar.gz in the parent directory

# Install from the tarball
install.packages("../banfa_0.1.0.tar.gz", repos = NULL, type = "source")
```

#### Method 3: Load Without Installing (Quick Testing)

```r
# From the banfa directory - loads all functions without installing
devtools::load_all()

# Test your changes immediately
rprj_init()
```

#### Method 4: Install from GitHub (Your Fork)

```r
# Install from your GitHub fork
devtools::install_github("yourusername/R-banfa-LIB", subdir = "banfa")
```

### Using the CLI During Development

After installing the package, the CLI needs to be in your PATH:

```bash
# Find where it's installed
R -e "cat(system.file('bin', package='banfa'))"

# Add to PATH temporarily (current session only)
export PATH="$PATH:$(R -e "cat(system.file('bin', package='banfa'))" -s)"

# Now you can use
rprj init my_test_project
```

For permanent CLI access, add the export line to your `~/.bashrc` or `~/.zshrc`.

### Testing Your Changes in a Real Project

1. **Create a test project**:
```bash
mkdir ~/test-banfa
cd ~/test-banfa
```

2. **Test the R functions**:
```r
library(banfa)
rprj_setup()  # First time only
rprj_init(name = "test_project")
```

3. **Test the CLI**:
```bash
rprj setup
rprj init test_cli_project
rprj list-templates
```

### Rapid Development Cycle

For quick iterations:

```r
# Make changes to R files
# Then in R console (from package directory):
devtools::load_all(); devtools::test_file("tests/testthat/test-prj_init.R")

# If tests pass, install and test in real scenario
devtools::install(); library(banfa); rprj_init("~/Desktop/quick_test")
```

### 2. Code Style Guidelines

- Use tidyverse style guide
- Function names: lowercase with underscores (e.g., `rprj_init`)
- Internal functions: don't export, add `@keywords internal`
- Use meaningful variable names
- Add roxygen2 documentation for all exported functions
- Keep lines under 80 characters when possible

### 3. Documentation Standards

All exported functions must have:
```r
#' Title (brief description)
#'
#' Detailed description of what the function does.
#'
#' @param param1 Description of parameter
#' @param param2 Description of parameter
#'
#' @return Description of return value
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Example usage
#' rprj_init()
#' }
```

## Testing

### Running Tests

```r
# Run all tests
devtools::test()

# Run specific test file
devtools::test_file("tests/testthat/test-prj_init.R")

# Check test coverage
covr::package_coverage()
```

### Writing Tests

Tests are located in `tests/testthat/`. Follow these patterns:

```r
test_that("function does what it should", {
  # Setup
  temp_home <- tempdir()
  old_home <- Sys.getenv("HOME")
  Sys.setenv(HOME = temp_home)
  
  tryCatch({
    # Test code
    expect_true(rprj_setup(verbose = FALSE))
    expect_equal(result, expected)
  }, finally = {
    # Cleanup
    Sys.setenv(HOME = old_home)
  })
})
```

Key testing principles:
- Isolate tests using temporary directories
- Clean up after tests
- Test both success and failure cases
- Use `skip_if_not_installed()` for optional dependencies

## Contributing Guidelines

### Before Submitting a PR

1. **Check your code**:
```r
# Full package check
devtools::check()

# Spell check
devtools::spell_check()

# Check on Windows
devtools::check_win_devel()

# For additional platform checks:
# Option 1: Use GitHub Actions (already configured in .github/workflows/)
# Option 2: Use the new rhub (requires GitHub): rhub::rhub_check()
# Option 3: Manual submission to win-builder.r-project.org
```

2. **Update documentation**:
- Update NEWS.md with your changes
- Update README.md if adding new features
- Ensure all functions have proper documentation

3. **Follow commit conventions**:
```
feat: Add new template type
fix: Correct template path handling
docs: Update README with examples
test: Add tests for edge cases
refactor: Simplify template loading
```

### PR Process

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Update documentation
6. Submit PR with clear description

## Release Process

### Pre-Release Checklist

```r
# 1. Ensure all changes are committed
git status  # Should be clean

# 2. Run full check suite
devtools::check()                    # Must pass with 0 errors, 0 warnings
devtools::check_win_devel()          # Windows check

# For multi-platform checks (rhub v2 uses GitHub Actions):
# Option 1: Use rhub with GitHub
rhub::rhub_check()                   # Requires GitHub repo

# Option 2: Use R-universe
# Submit your package to win-builder manually:
# https://win-builder.r-project.org/

# 3. Update version
usethis::use_version("patch")        # 0.1.0 -> 0.1.1
# or
usethis::use_version("minor")        # 0.1.0 -> 0.2.0
# or  
usethis::use_version("major")        # 0.1.0 -> 1.0.0

# 4. Update NEWS.md with changes
# Add a new section with version and date

# 5. Final check after version bump
devtools::check()

# 6. Commit version changes
git add -A
git commit -m "chore: bump version to X.Y.Z"
git push

# 7. Submit to CRAN (optional)
devtools::release()
```

### Version Numbering

We use semantic versioning (MAJOR.MINOR.PATCH):
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes

## Troubleshooting

### Common Issues

**roxygen2 not updating documentation**:
```r
# Force recreation
devtools::document(roclets = c('rd', 'collate', 'namespace'))
```

**Test failures in CI but not locally**:
- Check for platform-specific code
- Ensure no hardcoded paths
- Use `skip_on_cran()` for tests requiring special setup

**CRAN submission rejections**:
- Check spelling in DESCRIPTION and documentation
- Ensure examples run in < 5 seconds
- Use `\dontrun{}` for interactive examples
- Check that LICENSE file is properly formatted

## Getting Help

- Open an issue on GitHub for bugs
- Start a discussion for feature requests
- Check existing issues before creating new ones
- Join our discussions in the Issues section

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers and help them get started
- Focus on constructive criticism
- Follow the [Contributor Covenant](https://www.contributor-covenant.org/)

---

Thank you for contributing to banfa! Your help makes R project management better for everyone. 🚀