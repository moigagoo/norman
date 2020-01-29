# Package

version       = "0.1.0"
author        = "Constantine Molchanov"
description   = "Migration manager for Norm."
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["norman"]



# Dependencies

requires "nim >= 1.0.6", "norm >= 1.1.0", "cligen"
