#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
ln -sfn "$DIR" ~/.dotfiles
sudo darwin-rebuild switch --flake ~/.dotfiles#mac

# Homebrew upgrades can remove a library that source-built R packages link to.
# Reinstall those packages, as the user, so site-library stays user-owned.
Rscript --vanilla - <<'EOF'
so <- Sys.glob(file.path(.libPaths()[1], "*", "libs", "*.so"))
missing_dylib <- function(f) {
  libs <- system2("otool", c("-L", f), stdout = TRUE)[-1]
  libs <- trimws(sub(" \\(.*", "", libs))
  any(startsWith(libs, "/opt/homebrew/") & !file.exists(libs))
}
broken <- unique(basename(dirname(dirname(so[vapply(so, missing_dylib, logical(1))]))))
if (length(broken) == 0) {
  message("R packages: all linked libraries present")
} else {
  message("R packages to reinstall: ", paste(broken, collapse = ", "))
  pak::pkg_install(paste0(broken, "?reinstall"), upgrade = FALSE, ask = FALSE)
}
EOF
