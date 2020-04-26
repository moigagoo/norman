import unittest
import os

import norman


suite "Norman commands":
  setup:
    discard

  teardown:
    discard

  test "init":
    check true

  test "get pkg dir from nimble file srcDir":
    const contents = @["installExt    = @[\"nim\", \"nims\"]", "srcDir = \"src\""]
    let nf = open("test.nimble", fmWrite)
    nf.writeLine(contents)
    nf.close()

    let pkgDir = getPkgDirFromNimble("test.nimble")

    removeFile("test.nimble")
    check pkgDir == "src/test"

  test "get pkg dir from nimble file normanBaseDir":
    const contents = @["srcDir = \"src\"", "normanBaseDir = \"src/api\""]
    let nf = open("test.nimble", fmWrite)
    for line in contents:
      nf.writeLine(line)
    nf.close()

    let pkgDir = getPkgDirFromNimble("test.nimble")

    removeFile("test.nimble")
    check pkgDir == "src/api"
