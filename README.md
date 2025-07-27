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
rprj_setup()  # Creates only base template
rprj_setup(create_examples = TRUE)  # Creates base + example templates

# Or from command line:
rprj setup                  # Creates only base template
rprj setup --examples       # Creates base + example templates (shiny, package)
```

## Usage

### Command Line Interface (CLI)

#### Setup and Initialization

```bash
# First time setup (creates base template only)
rprj setup

# Setup with example templates (shiny, package)
rprj setup --examples

# Create a project in current directory
rprj init

# Create a project with a name
rprj init my_project

# Use a specific template
rprj init my_app --template shiny
rprj init my_app -t shiny  # short form

# Create in specific directory
rprj init my_app --path ~/projects --template package
rprj init my_app -p ~/projects -t package  # short form

# Open in RStudio after creation
rprj init my_app --open
rprj init my_app -o  # short form

# All options combined
rprj init my_awesome_app --template shiny --path ~/dev/R --open
```

#### Template Management (CRUD Operations)

```bash
# List all templates
rprj list-templates

# Add a custom template from existing .Rproj file
rprj add-template my_template --file ~/existing_project/.Rproj
rprj add-template my_template -f ~/existing_project/.Rproj  # short form

# View/Edit template content
rprj edit-template base      # shows content in terminal
rprj edit-template shiny     # opens in editor if in RStudio

# Delete a template
rprj delete-template old_template
rprj delete-template old_template --yes  # skip confirmation
rprj delete-template old_template -y     # short form
```

### R Functions

All CLI commands are also available as R functions with more flexibility:

```r
library(banfa)

# First time setup
rprj_setup()                          # base template only
rprj_setup(create_examples = TRUE)    # base + example templates (shiny, package)

# Create projects
rprj_init()                           # in current directory with base template
rprj_init(name = "my_analysis")       # with specific name
rprj_init(template = "shiny")         # with specific template
rprj_init(path = "~/projects/app")    # in specific directory
rprj_init(open = TRUE)                # open in RStudio after creation

# Full example with all parameters
rprj_init(
  path = "~/dev/R/new_app",
  name = "awesome_shiny_app", 
  template = "shiny",
  open = TRUE
)

# List available templates
rprj_list_templates()
```

### CLI vs R Function Comparison

| Feature | CLI | R Function |
|---------|-----|------------|
| **Project name** | `rprj init myproject` | `rprj_init(name = "myproject")` |
| **Template** | `--template shiny` or `-t shiny` | `template = "shiny"` |
| **Path** | `--path ~/dev` or `-p ~/dev` | `path = "~/dev"` |
| **Open in RStudio** | `--open` or `-o` | `open = TRUE` |
| **Setup with examples** | `--examples` or `-e` | `create_examples = TRUE` |
| **Skip confirmation** | `--yes` or `-y` | `confirm = FALSE` |
| **Tab completion** | ❌ No | ✅ Yes (in RStudio) |
| **Help** | `rprj --help` | `?rprj_init` |
| **Interactive mode** | Limited | Full support |

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