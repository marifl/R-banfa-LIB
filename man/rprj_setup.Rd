% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prj_setup.R
\name{rprj_setup}
\alias{rprj_setup}
\title{Set up banfa with initial templates}
\usage{
rprj_setup(verbose = TRUE, create_examples = FALSE)
}
\arguments{
\item{verbose}{Logical. Should setup messages be displayed? Default is TRUE.}

\item{create_examples}{Logical. Should example templates (shiny, package) be created? Default is FALSE.}
}
\value{
Invisibly returns TRUE if setup was successful.
}
\description{
Creates the initial base template for banfa after installation.
This function should be run once after installing the package.
}
\examples{
\dontrun{
# Run after installing banfa (base template only)
rprj_setup()

# Create with example templates
rprj_setup(create_examples = TRUE)
}
}
