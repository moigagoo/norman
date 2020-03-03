## Norman, a migration manager for Norm.

import strformat
import os, osproc
import parsecfg

import cligen


const
  mgrDir = "migrations"
  binDir = "bin"
  cmplCmd = &"nim c --verbosity:0 --hints:off --outdir:{mgrDir/binDir}"
  mgrFile = "migration.nim"
  mdlDir = "models"
  mdlFile = "models.nim"
  cfgFile = "config.nims"
  tmplDir = "normanpkg" / "private"/ "templates"
  mdlTmpl = staticRead(tmplDir/mdlFile)
  cfgTmpl = staticRead(tmplDir/cfgFile)


proc findNimbleFile(): string =
  ## Find the .nimble file in the current directory and return the path to it.

  for path in walkFiles("*.nimble"):
    return path

proc init() =
  ## Init model structure.

  let nimbleFile = findNimbleFile()

  if len(nimbleFile) == 0:
    quit(".nimble file not found")

  let
    srcDir = loadConfig(nimbleFile).getSectionValue("", "srcDir")
    pkgDir = srcDir / splitFile(nimbleFile).name

  createDir(pkgDir)

  (pkgDir/mdlFile).writeFile mdlTmpl

  echo &"Models file created in {pkgDir/mdlFile}."

  createDir(pkgDir/mdlDir)

  echo &"Models directory created in {pkgDir/mdlDir}."

  cfgFile.writeFile cfgTmpl

  echo &"Config file created in {cfgFile}."

proc apply(verbose = false) =
  ## Apply migrations.

  for dir in walkDirs(mgrDir/"*"):
    if splitPath(dir).tail != binDir:
      echo dir / mgrFile
      echo dir / mdlFile
      echo dir / mdlDir

when isMainModule:
  dispatchMulti([init], [apply])
