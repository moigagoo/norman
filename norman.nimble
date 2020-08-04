# Package

version       = "2.1.3"
author        = "Constantine Molchanov"
description   = "Scaffolder and migration manager for Norm."
license       = "MIT"
srcDir        = "src"
installExt    = @["nim", "nims"]
binDir        = "bin"
bin           = @["norman"]


# Dependencies

requires "nim >= 1.2.6", "norm >= 2.1.1", "cligen >= 1.1.0", "dotenv >= 1.1.1"

task apidoc, "Generate API docs":
  --outdir:"htmldocs"
  --git.url: https://github.com/moigagoo/norman/
  --git.commit: develop
  --project
  --index:on

  setCommand "doc", "src/norman"

task idx, "Generate index":
  selfExec "buildIndex --out:htmldocs/theindex.html htmldocs"

task docs, "Generate docs":
  rmDir "htmldocs"
  exec "nimble apidoc"
  exec "nimble idx"
