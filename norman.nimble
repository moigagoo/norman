# Package

version       = "1.0.2"
author        = "Constantine Molchanov"
description   = "Migration manager for Norm."
license       = "MIT"
srcDir        = "src"
installExt    = @["nim", "nims"]
binDir        = "bin"
bin           = @["norman"]


# Dependencies

requires "nim >= 1.1.0", "norm >= 1.1.2", "cligen"

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
