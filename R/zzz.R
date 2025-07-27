.onAttach <- function(libname, pkgname) {
  if (!is_banfa_setup()) {
    packageStartupMessage(
      "Welcome to banfa!\n",
      "Please run rprj_setup() to create your first template.\n",
      "Or use: rprj setup"
    )
  }
}