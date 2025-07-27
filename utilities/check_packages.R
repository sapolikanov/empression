## check_packages.R

# Run this script to check for packages that the other R scripts will use. If missing, try to install.
# code borrowed from here:
# http://www.vikram-baliga.com/blog/2015/7/19/a-hassle-free-way-to-verify-that-r-packages-are-installed-and-loaded

# add new packages to the chain here
packages = c(
  # general management
  "here", "renv", "conflicted", 
  # reading and writing data
  "writexl", "readxl", "haven", 
  # spatial
  "sf", 
  # processing
  "tidyverse",
  # modelling
  "MASS",  "car",
  # presentation
  "knitr", "kableExtra", "modelsummary", "marginaleffects", "patchwork"
)

package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    renv::install(x, dependencies = "strong")
    library(x, character.only = TRUE)
  }
})

