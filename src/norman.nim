## Norman, a migration manager for Norm.

import strutils
import os, osproc
import parsecfg
import times

import cligen

import normanpkg/private/[consts, utils]


var pkgDir: string


proc init() =
  ## Init model structure.

  createDir(pkgDir)

  (pkgDir/mdlFile).writeFile mdlTmpl

  echo "Models file created in $#." % (pkgDir/mdlFile)

  createDir(pkgDir/mdlDir)

  echo "Models directory created in $#." % (pkgDir/mdlDir)

  cfgFile.writeFile(cfgTmpl)

  echo "Config file created in $#." % cfgFile

proc generate(message: string) =
  ## Generate a migration from the current model state.

  let
    timestamp = now().toTime().toUnix()
    slug = slugified message
    newMgrDir = mgrDir / "$#_$#" % [$timestamp, slug]
    lstMgr = findLatestMigration()
    lstMgrImpPath = if len(lstMgr) > 0: '"' & ["..", lstMgr, "models"].join("/") & '"' else: "models"

  createDir(mgrDir)

  createDir(newMgrDir)

  echo "New migration directory created in $#." % (newMgrDir)

  copyFile(pkgDir/mdlFile, newMgrDir/mdlFile)

  copyDir(pkgDir/mdlDir, newMgrDir/mdlDir)

  echo "Current models copied to $# and $#." % [newMgrDir/mdlFile, newMgrDir/mdlDir]

  (newMgrDir/mgrFile).writeFile(mgrTmpl % lstMgrImpPath)

  echo "New migration template created in $#." % (newMgrDir/mgrFile)

proc apply(verbose = false) =
  ## Apply migrations.

  createDir(mgrDir/binDir)

  for dir in walkDirs(mgrDir/"*"):
    if splitPath(dir).tail != binDir:
      echo dir / mgrFile
      echo dir / mdlFile
      echo dir / mdlDir

when isMainModule:
  let nimbleFile = findNimbleFile()

  if len(nimbleFile) == 0:
    quit(".nimble file not found. Please run Norman inside a package.")

  let
    cfg = loadConfig(nimbleFile)
    srcDir = cfg.getSectionValue("", "srcDir")
    pkgName = splitFile(nimbleFile).name

  pkgDir = srcDir / pkgName

  dispatchMulti([init], [generate], [apply])
