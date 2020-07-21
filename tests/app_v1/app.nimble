# Package

version       = "0.1.0"
author        = "Constantine Molchanov"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
bin           = @["app"]



# Dependencies

requires "nim >= 1.2.4", "jester#head", "norm >= 2.1.1", "dotenv >= 1.1.1"
