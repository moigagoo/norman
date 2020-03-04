## Norman, a migration manager for Norm.

import strutils
import os, osproc
import parsecfg
import times
import sugar
import algorithm

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
    lstMdlImpPath =
      if (let mgrs = getMgrs(); len(mgrs) > 0):
        '"' & "../$#/models" % mgrs[^1] & '"'
      else:
        "models"

  createDir(mgrDir)

  createDir(newMgrDir)

  echo "New migration directory created in $#." % (newMgrDir)

  copyFile(pkgDir/mdlFile, newMgrDir/mdlFile)

  copyDir(pkgDir/mdlDir, newMgrDir/mdlDir)

  echo "Current models copied to $# and $#." % [newMgrDir/mdlFile, newMgrDir/mdlDir]

  (newMgrDir/mgrFile).writeFile(mgrTmpl % lstMdlImpPath)

  echo "New migration template created in $#." % (newMgrDir/mgrFile)

proc apply(verbose = false) =
  ## Apply migrations.

  createDir(mgrDir/binDir)

  var binPaths: seq[string]

  let cmds = collect(newSeq):
    for mgr in getMgrs():
      let
        cacheDirPath = mgrDir / binDir / applyPfx & mgr & cacheSfx
        binPath = mgrDir / binDir / applyPfx & mgr

      binPaths.add binPath

      [cmplCmd % [cacheDirPath, binPath], (if verbose: verboseFlag else: ""), applyFlag, mgrDir/mgr/mgrFile].join(" ")

  echo cmds

  discard execProcesses cmds

  echo "Compiled $# migrations." % $len(cmds)

  for binPath in sorted binPaths:
    echo execProcess binPath

  echo "Applied $# migrations." % $len(binPaths)


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
