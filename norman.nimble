# Package

version       = "0.1.0"
author        = "Constantine Molchanov"
description   = "Migration manager for Norm."
license       = "MIT"
srcDir        = "src"
installExt    = @["nim", "nims"]
binDir        = "bin"
bin           = @["norman"]


# Dependencies

requires "nim >= 1.1.0", "norm#head", "cligen"
