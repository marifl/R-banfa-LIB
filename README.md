# banfa

Simple R Project Creation and Management

## Installation

You can install the development version of banfa from GitHub:

```r
# install.packages("devtools")
devtools::install_github("marifl/R-banfa-LIB")
```

### Installing the CLI

After installing the package, you can make the `rprj` command available system-wide:

```bash
# Find where the CLI is installed
R -e "cat(system.file('bin/rprj', package='banfa'))"

# Add to your PATH (example for bash/zsh)
echo 'export PATH="$PATH:$(R -e "cat(system.file(\"bin\", package=\"banfa\"))" -s)"' >> ~/.bashrc
# or for zsh
echo 'export PATH="$PATH:$(R -e "cat(system.file(\"bin\", package=\"banfa\"))" -s)"' >> ~/.zshrc

# Reload your shell configuration
source ~/.bashrc  # or source ~/.zshrc
```

## Getting Started

After installation, you need to set up banfa with an initial template:

```r
# In R:
rprj_setup()

# Or from command line:
rprj setup
```

## Usage

### Command Line Interface (CLI)

```bash
# First time setup
rprj setup

# Create a project in current directory
rprj init

# Create a project with a name
rprj init my_project

# Use a specific template
rprj init my_app --template my_template

# Create in specific directory
rprj init --path ~/projects/new_project

# Template management (CRUD operations)
rprj list-templates                          # List all templates
rprj add-template my_template --file existing.Rproj  # Create
rprj edit-template my_template               # Read/Edit
rprj delete-template my_template             # Delete
```

### R Functions

The main function is `rprj_init()` which creates a new R project with a `.Rproj` file:

```r
library(banfa)

# First time setup (creates base template)
rprj_setup()

# Create a project in the current directory
rprj_init()

# Create a project with a specific name
rprj_init(name = "my_analysis")

# Create a project in a specific directory
rprj_init(path = "~/projects/new_project", name = "awesome_project")

# Use a different template
rprj_init(template = "my_template")

# List available templates
rprj_list_templates()
```

## Template Management

banfa uses a flexible template system. After setup, you'll have a base template that you can customize:

```r
# Add a template from an existing .Rproj file
rprj_add_template("my_template", file = "path/to/existing.Rproj")

# Create a template with specific content
content <- c(
  "Version: 1.0",
  "",
  "RestoreWorkspace: No",
  "SaveWorkspace: No",
  "AlwaysSaveHistory: No",
  "",
  "EnableCodeIndexing: Yes"
)
rprj_add_template("minimal", content = content)

# Edit an existing template
rprj_edit_template("base")  # Shows content
rprj_edit_template("base", edit = TRUE)  # Opens in editor

# Delete a template
rprj_delete_template("old_template")
```

## License

MIT

## contributions welcome

This is my first "real" project and it is mainly ai generated. So - if you find any bugs or have any suggestions, please let me know.

Made with 🤖 claude & ganz viel Verzweiflung.