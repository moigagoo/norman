# Package

version       = "2.1.6"
author        = "Constantine Molchanov"
description   = "Scaffolder and migration manager for Norm."
license       = "MIT"
srcDir        = "src"
installExt    = @["nim", "nims"]
binDir        = "bin"
bin           = @["norman"]


# Dependencies

requires "nim >= 1.2.6", "norm >= 2.1.4", "cligen >= 1.1.0", "dotenv >= 1.1.1"

task docs, "Generate docs":
  rmDir "htmldocs"
  exec "nimble doc --outdir:htmldocs --project --index:on src/norm"
  exec "nim rst2html -o:htmldocs/index.html README.rst"
  exec "testament html"
  mvFile("testresults.html", "htmldocs/testresults.html")
  cpFile("CNAME", "htmldocs/CNAME")
